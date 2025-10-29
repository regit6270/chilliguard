"""
Convert PyTorch model to TensorFlow Lite for mobile deployment
"""

import torch
import torch.onnx
import onnx
import tensorflow as tf
from onnx_tf.backend import prepare
import argparse
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def pytorch_to_onnx(pytorch_model_path, onnx_model_path, input_size=224):
    """Convert PyTorch model to ONNX format"""

    logger.info('Loading PyTorch model...')
    checkpoint = torch.load(pytorch_model_path, map_location='cpu')

    # Recreate model architecture (adjust based on your model)
    from torchvision import models
    model = models.mobilenet_v3_small(pretrained=False)
    num_classes = len(checkpoint['classes'])
    model.classifier[3] = torch.nn.Linear(model.classifier[3].in_features, num_classes)
    model.load_state_dict(checkpoint['model_state_dict'])
    model.eval()

    # Create dummy input
    dummy_input = torch.randn(1, 3, input_size, input_size)

    # Export to ONNX
    logger.info('Exporting to ONNX...')
    torch.onnx.export(
        model,
        dummy_input,
        onnx_model_path,
        export_params=True,
        opset_version=11,
        do_constant_folding=True,
        input_names=['input'],
        output_names=['output'],
        dynamic_axes={
            'input': {0: 'batch_size'},
            'output': {0: 'batch_size'}
        }
    )

    logger.info(f'ONNX model saved to: {onnx_model_path}')

    # Verify ONNX model
    onnx_model = onnx.load(onnx_model_path)
    onnx.checker.check_model(onnx_model)
    logger.info('ONNX model verified successfully')

    return onnx_model

def onnx_to_tensorflow(onnx_model_path, tf_model_path):
    """Convert ONNX model to TensorFlow SavedModel format"""

    logger.info('Loading ONNX model...')
    onnx_model = onnx.load(onnx_model_path)

    logger.info('Converting to TensorFlow...')
    tf_rep = prepare(onnx_model)

    tf_rep.export_graph(tf_model_path)
    logger.info(f'TensorFlow model saved to: {tf_model_path}')

def tensorflow_to_tflite(tf_model_path, tflite_model_path, quantize=True):
    """Convert TensorFlow SavedModel to TFLite"""

    logger.info('Loading TensorFlow model...')
    converter = tf.lite.TFLiteConverter.from_saved_model(tf_model_path)

    # Apply optimizations
    if quantize:
        logger.info('Applying quantization...')
        converter.optimizations = [tf.lite.Optimize.DEFAULT]
        converter.target_spec.supported_types = [tf.float16]

    # Convert
    logger.info('Converting to TFLite...')
    tflite_model = converter.convert()

    # Save
    with open(tflite_model_path, 'wb') as f:
        f.write(tflite_model)

    logger.info(f'TFLite model saved to: {tflite_model_path}')

    # Print model size
    import os
    size_mb = os.path.getsize(tflite_model_path) / (1024 * 1024)
    logger.info(f'Model size: {size_mb:.2f} MB')

def main():
    parser = argparse.ArgumentParser(description='Convert PyTorch model to TFLite')
    parser.add_argument('--pytorch-model', type=str, required=True,
                        help='Path to PyTorch model (.pt file)')
    parser.add_argument('--output-dir', type=str, default='models/exported',
                        help='Output directory')
    parser.add_argument('--model-name', type=str, default='disease_detection_v1',
                        help='Output model name')
    parser.add_argument('--input-size', type=int, default=224,
                        help='Input image size')
    parser.add_argument('--quantize', action='store_true',
                        help='Apply quantization for smaller model size')

    args = parser.parse_args()

    import os
    os.makedirs(args.output_dir, exist_ok=True)

    # Define paths
    onnx_path = os.path.join(args.output_dir, f'{args.model_name}.onnx')
    tf_path = os.path.join(args.output_dir, f'{args.model_name}_tf')
    tflite_path = os.path.join(args.output_dir, f'{args.model_name}.tflite')

    # Conversion pipeline
    logger.info('Starting conversion pipeline...')

    # PyTorch -> ONNX
    pytorch_to_onnx(args.pytorch_model, onnx_path, args.input_size)

    # ONNX -> TensorFlow
    onnx_to_tensorflow(onnx_path, tf_path)

    # TensorFlow -> TFLite
    tensorflow_to_tflite(tf_path, tflite_path, args.quantize)

    logger.info('Conversion completed successfully!')
    logger.info(f'\\nTo use in mobile app, copy {tflite_path} to:')
    logger.info('  mobile_app/assets/ml_models/')

if __name__ == '__main__':
    main()
