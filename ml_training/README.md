```markdown
# ChilliGuard Disease Detection Model Training

## Overview
This directory contains scripts for training the chilli disease detection model using transfer learning.

## Dataset Requirements

### Data Structure
```
datasets/
├── raw/
│   ├── healthy/
│   ├── anthracnose_leaf_spot/
│   ├── bacterial_spot/
│   ├── powdery_mildew/
│   ├── fusarium_wilt/
│   ├── fruit_rot/
│   ├── pepper_weevil_damage/
│   ├── nitrogen_deficiency/
│   └── phosphorus_deficiency/
└── processed/
    ├── train/
    │   ├── healthy/
    │   ├── anthracnose_leaf_spot/
    │   └── ...
    ├── val/
    └── test/
```

### Dataset Sources

1. **PlantVillage Dataset**
   - URL: https://github.com/spMohanty/PlantVillage-Dataset
   - Contains various plant disease images including peppers

2. **Kaggle Agricultural Datasets**
   - Search for: "chilli disease", "pepper disease", "plant pathology"
   - Recommended: Combine multiple datasets

3. **Custom Data Collection**
   - Use smartphone to capture chilli leaf images
   - Ensure diverse conditions (lighting, angles, backgrounds)
   - Minimum 500 images per class for good performance
   - Target: 1000-2000 images per class for production

### Data Augmentation
- Handled automatically in training script
- Includes: rotation, flipping, color jitter, scaling

## Training Instructions

### 1. Prepare Dataset
```bash
# Split dataset into train/val/test
python scripts/data_preprocessing.py \\
    --input-dir datasets/raw \\
    --output-dir datasets/processed \\
    --train-ratio 0.7 \\
    --val-ratio 0.15 \\
    --test-ratio 0.15
```

### 2. Train Model
```bash
# Train MobileNetV3-Small (for mobile)
python scripts/train_model.py \\
    --data-dir datasets/processed \\
    --output-dir models/checkpoints \\
    --model-name mobilenet_v3_small \\
    --batch-size 32 \\
    --num-epochs 50 \\
    --learning-rate 0.001

# Train ResNet50 (for cloud, higher accuracy)
python scripts/train_model.py \\
    --data-dir datasets/processed \\
    --output-dir models/checkpoints \\
    --model-name resnet50 \\
    --batch-size 16 \\
    --num-epochs 50 \\
    --learning-rate 0.0001
```

### 3. Evaluate Model
```bash
python scripts/evaluate_model.py \\
    --model-path models/checkpoints/best_model.pt \\
    --test-dir datasets/processed/test
```

### 4. Convert to TFLite (for mobile deployment)
```bash
python scripts/convert_to_tflite.py \\
    --pytorch-model models/checkpoints/best_model.pt \\
    --output-dir models/exported \\
    --model-name disease_detection_v1 \\
    --quantize
```

### 5. Deploy Model
```bash
# Copy TFLite model to mobile app
cp models/exported/disease_detection_v1.tflite \\
   ../mobile_app/assets/ml_models/

# Upload PyTorch model to Cloud Storage for cloud inference
gsutil cp models/checkpoints/best_model.pt \\
   gs://chilliguard-models/disease_detection_v1.pt
```

## Model Performance Targets

- **On-Device Model (TFLite)**
  - Accuracy: ≥ 85%
  - Size: < 50 MB
  - Inference time: < 500ms on mid-range Android

- **Cloud Model (PyTorch)**
  - Accuracy: ≥ 92%
  - Inference time: < 2s

## Transfer Learning Strategy

Using **pre-trained models** (ImageNet weights) + fine-tuning:

1. **Freeze** early layers (feature extractors)
2. **Train** only final classification layers initially
3. **Unfreeze** and fine-tune all layers with lower learning rate
4. Use **data augmentation** to prevent overfitting

## Tips for Improvement

1. **More Data**: Collect more diverse images
2. **Class Balance**: Ensure similar number of images per class
3. **Hard Negative Mining**: Add challenging negative samples
4. **Ensemble Models**: Combine predictions from multiple models
5. **Active Learning**: Continuously improve with user feedback
```
