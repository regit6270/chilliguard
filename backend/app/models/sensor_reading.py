"""Sensor reading data model"""
from __future__ import annotations

from datetime import datetime
from typing import Any, Dict, Optional


class SensorReading:
    """Sensor reading model for IoT data"""

    def __init__(
        self,
        reading_id: str,
        field_id: str,
        device_id: str,
        ph: Optional[float] = None,
        nitrogen: Optional[float] = None,
        phosphorus: Optional[float] = None,
        potassium: Optional[float] = None,
        moisture: Optional[float] = None,
        temperature: Optional[float] = None,
        humidity: Optional[float] = None,
        timestamp: Optional[datetime] = None,
        **kwargs: Any,
    ) -> None:
        self.reading_id = reading_id
        self.field_id = field_id
        self.device_id = device_id
        self.ph = ph
        self.nitrogen = nitrogen
        self.phosphorus = phosphorus
        self.potassium = potassium

        self.moisture = moisture
        self.temperature = temperature
        self.humidity = humidity
        self.timestamp = timestamp or datetime.utcnow()

        for key, value in kwargs.items():
            setattr(self, key, value)

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for Firestore"""
        return {
            'reading_id': self.reading_id,
            'field_id': self.field_id,
            'device_id': self.device_id,
            'ph': self.ph,
            'nitrogen': self.nitrogen,
            'phosphorus': self.phosphorus,
            'potassium': self.potassium,
            'moisture': self.moisture,
            'temperature': self.temperature,
            'humidity': self.humidity,
            'timestamp': self.timestamp
        }

    @staticmethod
    def from_dict(data: Dict[str, Any]) -> 'SensorReading':
        """Create SensorReading from Firestore document"""
        return SensorReading(**data)

    def __repr__(self) -> str:
        return f"<SensorReading {self.reading_id} - Field: {self.field_id}>"
