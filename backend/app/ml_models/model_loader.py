"""
Singleton TFLite model loader - loads model ONCE at startup
Uses TensorFlow Lite for inference (faster + smaller)
"""
import os
import logging
import numpy as np
from pathlib import Path
import json

logger = logging.getLogger(__name__)

# Try TFLite import
try:
    import tensorflow as tf
    TFLITE_AVAILABLE = True
except ImportError:
    logger.warning("TensorFlow not available")
    TFLITE_AVAILABLE = False

class TFLiteModelLoader:
    _instance = None
    _interpreter = None
    _input_details = None
    _output_details = None
    _class_names = []

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(TFLiteModelLoader, cls).__new__(cls)
            cls._instance._load_model()
        return cls._instance

    def _load_model(self):
        """Load TFLite model and model info (runs ONCE)"""
        try:
            model_path = Path(__file__).parent / 'chili_disease_model.tflite'
            info_path = Path(__file__).parent / 'model_info.json'

            if not model_path.exists():
                raise FileNotFoundError(f"Model not found at {model_path}")

            if not info_path.exists():
                raise FileNotFoundError(f"Model info not found at {info_path}")

            # Load model info
            with open(info_path, 'r') as f:
                model_info = json.load(f)
                self._class_names = model_info.get('class_names', [])

            logger.info(f"📋 Loaded class names: {self._class_names}")
            logger.info(f"Loading TFLite model from {model_path}...")

            # Load TFLite model
            self._interpreter = tf.lite.Interpreter(model_path=str(model_path))
            self._interpreter.allocate_tensors()

            # Get input and output details
            self._input_details = self._interpreter.get_input_details()
            self._output_details = self._interpreter.get_output_details()

            logger.info(f"✅ TFLite model loaded successfully")
            logger.info(f"   Input shape: {self._input_details[0]['shape']}")
            logger.info(f"   Output shape: {self._output_details[0]['shape']}")

        except Exception as e:
            logger.error(f"❌ Failed to load TFLite model: {e}")
            raise

    def predict(self, image_array: np.ndarray) -> np.ndarray:
        """
        Run inference on preprocessed image
        Args:
            image_array: Preprocessed image (1, 224, 224, 3) with values [0, 1]
        Returns:
            predictions: Softmax probabilities (1, 6)
        """
        if self._interpreter is None:
            raise RuntimeError("Model not loaded")

        # Ensure correct dtype
        input_dtype = self._input_details[0]['dtype']
        image_array = image_array.astype(input_dtype)

        # Set input tensor
        self._interpreter.set_tensor(
            self._input_details[0]['index'],
            image_array
        )

        # Run inference
        self._interpreter.invoke()

        # Get output tensor
        predictions = self._interpreter.get_tensor(
            self._output_details[0]['index']
        )

        return predictions

    def get_class_names(self):
        """Get list of class names"""
        return self._class_names

# Singleton instance
model_loader = TFLiteModelLoader()

def get_disease_model():
    """Helper function to get model loader"""
    return model_loader

def predict_disease(image_array: np.ndarray) -> np.ndarray:
    """Helper function to run prediction"""
    return model_loader.predict(image_array)

def get_class_names():
    """Helper function to get class names"""
    return model_loader.get_class_names()
