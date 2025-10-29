"""
Disease Detection Model Training Script
Uses Transfer Learning with MobileNetV3/ResNet50
"""

import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader, Dataset
from torchvision import transforms, models
from PIL import Image
import os
import json
from pathlib import Path
import logging
from tqdm import tqdm
import argparse

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Disease classes for chilli crop
DISEASE_CLASSES = [
    'healthy',
    'anthracnose_leaf_spot',
    'bacterial_spot',
    'powdery_mildew',
    'fusarium_wilt',
    'fruit_rot',
    'pepper_weevil_damage',
    'nitrogen_deficiency',
    'phosphorus_deficiency'
]

class ChilliDiseaseDataset(Dataset):
    """Custom dataset for chilli disease images"""

    def __init__(self, root_dir, transform=None):
        self.root_dir = Path(root_dir)
        self.transform = transform
        self.images = []
        self.labels = []

        # Load images and labels
        for class_idx, class_name in enumerate(DISEASE_CLASSES):
            class_dir = self.root_dir / class_name
            if not class_dir.exists():
                logger.warning(f'Class directory not found: {class_dir}')
                continue

            for img_path in class_dir.glob('*.jpg'):
                self.images.append(str(img_path))
                self.labels.append(class_idx)

        logger.info(f'Loaded {len(self.images)} images from {len(DISEASE_CLASSES)} classes')

    def __len__(self):
        return len(self.images)

    def __getitem__(self, idx):
        img_path = self.images[idx]
        label = self.labels[idx]

        image = Image.open(img_path).convert('RGB')

        if self.transform:
            image = self.transform(image)

        return image, label

def get_data_transforms(input_size=224):
    """Get data augmentation transforms"""

    train_transforms = transforms.Compose([
        transforms.Resize((input_size, input_size)),
        transforms.RandomHorizontalFlip(p=0.5),
        transforms.RandomVerticalFlip(p=0.3),
        transforms.RandomRotation(30),
        transforms.ColorJitter(brightness=0.2, contrast=0.2, saturation=0.2),
        transforms.RandomAffine(degrees=0, translate=(0.1, 0.1), scale=(0.9, 1.1)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
    ])

    val_transforms = transforms.Compose([
        transforms.Resize((input_size, input_size)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
    ])

    return train_transforms, val_transforms

def create_model(model_name='mobilenet_v3_small', num_classes=9, pretrained=True):
    """
    Create model with pretrained weights for transfer learning

    Supported models:
    - mobilenet_v3_small (lightweight, for mobile deployment)
    - mobilenet_v3_large
    - resnet50 (higher accuracy, cloud deployment)
    """

    if model_name == 'mobilenet_v3_small':
        model = models.mobilenet_v3_small(pretrained=pretrained)
        num_features = model.classifier[3].in_features
        model.classifier[3] = nn.Linear(num_features, num_classes)

    elif model_name == 'mobilenet_v3_large':
        model = models.mobilenet_v3_large(pretrained=pretrained)
        num_features = model.classifier[3].in_features
        model.classifier[3] = nn.Linear(num_features, num_classes)

    elif model_name == 'resnet50':
        model = models.resnet50(pretrained=pretrained)
        num_features = model.fc.in_features
        model.fc = nn.Linear(num_features, num_classes)

    else:
        raise ValueError(f'Unsupported model: {model_name}')

    logger.info(f'Created {model_name} model with {num_classes} classes')
    return model

def train_epoch(model, dataloader, criterion, optimizer, device):
    """Train for one epoch"""

    model.train()
    running_loss = 0.0
    correct = 0
    total = 0

    pbar = tqdm(dataloader, desc='Training')
    for images, labels in pbar:
        images, labels = images.to(device), labels.to(device)

        # Forward pass
        optimizer.zero_grad()
        outputs = model(images)
        loss = criterion(outputs, labels)

        # Backward pass
        loss.backward()
        optimizer.step()

        # Statistics
        running_loss += loss.item()
        _, predicted = outputs.max(1)
        total += labels.size(0)
        correct += predicted.eq(labels).sum().item()

        # Update progress bar
        pbar.set_postfix({
            'loss': f'{running_loss/total:.4f}',
            'acc': f'{100.*correct/total:.2f}%'
        })

    epoch_loss = running_loss / len(dataloader)
    epoch_acc = 100. * correct / total

    return epoch_loss, epoch_acc

def validate(model, dataloader, criterion, device):
    """Validate model"""

    model.eval()
    running_loss = 0.0
    correct = 0
    total = 0

    with torch.no_grad():
        pbar = tqdm(dataloader, desc='Validation')
        for images, labels in pbar:
            images, labels = images.to(device), labels.to(device)

            outputs = model(images)
            loss = criterion(outputs, labels)

            running_loss += loss.item()
            _, predicted = outputs.max(1)
            total += labels.size(0)
            correct += predicted.eq(labels).sum().item()

            pbar.set_postfix({
                'loss': f'{running_loss/total:.4f}',
                'acc': f'{100.*correct/total:.2f}%'
            })

    epoch_loss = running_loss / len(dataloader)
    epoch_acc = 100. * correct / total

    return epoch_loss, epoch_acc

def train_model(args):
    """Main training function"""

    # Setup device
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    logger.info(f'Using device: {device}')

    # Create datasets
    train_transforms, val_transforms = get_data_transforms(args.input_size)

    train_dataset = ChilliDiseaseDataset(
        os.path.join(args.data_dir, 'train'),
        transform=train_transforms
    )

    val_dataset = ChilliDiseaseDataset(
        os.path.join(args.data_dir, 'val'),
        transform=val_transforms
    )

    # Create dataloaders
    train_loader = DataLoader(
        train_dataset,
        batch_size=args.batch_size,
        shuffle=True,
        num_workers=args.num_workers,
        pin_memory=True
    )

    val_loader = DataLoader(
        val_dataset,
        batch_size=args.batch_size,
        shuffle=False,
        num_workers=args.num_workers,
        pin_memory=True
    )

    # Create model
    model = create_model(
        model_name=args.model_name,
        num_classes=len(DISEASE_CLASSES),
        pretrained=True
    )
    model = model.to(device)

    # Loss and optimizer
    criterion = nn.CrossEntropyLoss()
    optimizer = optim.Adam(model.parameters(), lr=args.learning_rate)
    scheduler = optim.lr_scheduler.ReduceLROnPlateau(
        optimizer,
        mode='min',
        factor=0.5,
        patience=3,
        verbose=True
    )

    # Training loop
    best_val_acc = 0.0
    history = {
        'train_loss': [],
        'train_acc': [],
        'val_loss': [],
        'val_acc': []
    }

    for epoch in range(args.num_epochs):
        logger.info(f'\\nEpoch {epoch+1}/{args.num_epochs}')

        # Train
        train_loss, train_acc = train_epoch(
            model, train_loader, criterion, optimizer, device
        )

        # Validate
        val_loss, val_acc = validate(
            model, val_loader, criterion, device
        )

        # Update learning rate
        scheduler.step(val_loss)

        # Save history
        history['train_loss'].append(train_loss)
        history['train_acc'].append(train_acc)
        history['val_loss'].append(val_loss)
        history['val_acc'].append(val_acc)

        logger.info(f'Train Loss: {train_loss:.4f}, Train Acc: {train_acc:.2f}%')
        logger.info(f'Val Loss: {val_loss:.4f}, Val Acc: {val_acc:.2f}%')

        # Save best model
        if val_acc > best_val_acc:
            best_val_acc = val_acc
            torch.save({
                'epoch': epoch,
                'model_state_dict': model.state_dict(),
                'optimizer_state_dict': optimizer.state_dict(),
                'val_acc': val_acc,
                'classes': DISEASE_CLASSES
            }, os.path.join(args.output_dir, 'best_model.pt'))
            logger.info(f'Saved best model with accuracy: {val_acc:.2f}%')

    # Save final model
    torch.save({
        'model_state_dict': model.state_dict(),
        'classes': DISEASE_CLASSES
    }, os.path.join(args.output_dir, 'final_model.pt'))

    # Save training history
    with open(os.path.join(args.output_dir, 'training_history.json'), 'w') as f:
        json.dump(history, f, indent=2)

    logger.info(f'Training completed! Best validation accuracy: {best_val_acc:.2f}%')

def main():
    parser = argparse.ArgumentParser(description='Train Chilli Disease Detection Model')

    # Data
    parser.add_argument('--data-dir', type=str, required=True,
                        help='Path to dataset directory')
    parser.add_argument('--output-dir', type=str, default='models/checkpoints',
                        help='Output directory for models')

    # Model
    parser.add_argument('--model-name', type=str, default='mobilenet_v3_small',
                        choices=['mobilenet_v3_small', 'mobilenet_v3_large', 'resnet50'],
                        help='Model architecture')
    parser.add_argument('--input-size', type=int, default=224,
                        help='Input image size')

    # Training
    parser.add_argument('--batch-size', type=int, default=32,
                        help='Batch size')
    parser.add_argument('--num-epochs', type=int, default=50,
                        help='Number of epochs')
    parser.add_argument('--learning-rate', type=float, default=0.001,
                        help='Learning rate')
    parser.add_argument('--num-workers', type=int, default=4,
                        help='Number of data loading workers')

    args = parser.parse_args()

    # Create output directory
    os.makedirs(args.output_dir, exist_ok=True)

    # Train
    train_model(args)

if __name__ == '__main__':
    main()
