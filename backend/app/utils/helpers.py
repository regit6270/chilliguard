"""Helper utility functions"""
from __future__ import annotations

import logging
import re
import uuid
from datetime import date, datetime
from typing import Any, Optional

logger = logging.getLogger(__name__)


def format_date(date_obj: Any) -> Optional[str]:
    """Format date object to ISO string"""
    if isinstance(date_obj, datetime):
        return date_obj.isoformat()
    if isinstance(date_obj, date):
        return date_obj.isoformat()
    if isinstance(date_obj, str):
        return date_obj
    return None


def parse_date(date_str: Any) -> Optional[date]:
    """Parse ISO date string to date object"""
    try:
        if isinstance(date_str, date):
            return date_str
        if isinstance(date_str, datetime):
            return date_str.date()
        if isinstance(date_str, str):
            return datetime.fromisoformat(date_str).date()
        return None
    except Exception as e:  # pylint: disable=broad-except
        logger.error(f'Error parsing date: {str(e)}')
        return None


def calculate_percentage(
    value: float,
    min_val: float,
    max_val: float,
) -> float:
    """Calculate percentage within range"""
    if value < min_val:
        return max(0, 100 - ((min_val - value) / (max_val - min_val) * 100))
    elif value > max_val:
        return max(0, 100 - ((value - max_val) / (max_val - min_val) * 100))
    else:
        return 100.0


def validate_phone_number(phone: str) -> bool:
    """Validate Indian phone number"""
    pattern = r'^[6-9]\d{9}$'
    return bool(re.match(pattern, phone.replace('+91', '').replace(' ', '')))


def sanitize_input(text: str) -> str:
    """Sanitize user input"""
    if not text:
        return ''
    # Remove potentially harmful characters
    return re.sub(r'[<>{}]', '', text.strip())


def generate_id(prefix: str = '') -> str:
    """Generate unique ID with optional prefix"""
    unique_id = str(uuid.uuid4())
    return f'{prefix}_{unique_id}' if prefix else unique_id
