"""Input validation utilities"""
from typing import Dict, Any, List
import logging

logger = logging.getLogger(__name__)


def validate_sensor_reading(data: Dict[str, Any]) -> tuple[bool, str]:
    """Validate sensor reading data"""
    required_fields = ['field_id', 'device_id']

    # Check required fields
    for field in required_fields:
        if field not in data:
            return False, f'Missing required field: {field}'

    # Validate numeric ranges
    validations = {
        'ph': (0, 14),
        'nitrogen': (0, 500),
        'phosphorus': (0, 300),
        'potassium': (0, 300),
        'moisture': (0, 100),
        'temperature': (-10, 60),
        'humidity': (0, 100)
    }

    for field, (min_val, max_val) in validations.items():
        if field in data and data[field] is not None:
            try:
                value = float(data[field])
                if not (min_val <= value <= max_val):
                    return False, f'{
                        field} out of valid range ({min_val}-{max_val})'
            except (ValueError, TypeError):
                return False, f'{field} must be a number'

    return True, 'Valid'


def validate_batch_data(data: Dict[str, Any]) -> tuple[bool, str]:
    """Validate batch creation data"""
    required_fields = ['field_id', 'crop_type', 'planting_date', 'area']

    for field in required_fields:
        if field not in data:
            return False, f'Missing required field: {field}'

    # Validate area
    try:
        area = float(data['area'])
        if area <= 0:
            return False, 'Area must be positive'
    except (ValueError, TypeError):
        return False, 'Area must be a number'

    # Validate crop type
    allowed_crops = ['chilli', 'tomato', 'potato']  # Extensible
    if data['crop_type'].lower() not in allowed_crops:
        return False, f'Invalid crop type. Allowed: {", ".join(allowed_crops)}'

    return True, 'Valid'


def validate_field_data(data: Dict[str, Any]) -> tuple[bool, str]:
    """Validate field creation data"""
    required_fields = ['field_name', 'area']

    for field in required_fields:
        if field not in data:
            return False, f'Missing required field: {field}'

    # Validate area
    try:
        area = float(data['area'])
        if area <= 0 or area > 1000:  # Max 1000 hectares
            return False, 'Area must be between 0 and 1000 hectares'
    except (ValueError, TypeError):
        return False, 'Area must be a number'

    # Validate field name
    if len(data['field_name'].strip()) < 3:
        return False, 'Field name must be at least 3 characters'

    return True, 'Valid'
