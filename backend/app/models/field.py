"""Field data model"""
from __future__ import annotations

from datetime import datetime
from typing import Any, Dict, Optional, Tuple


class Field:
    """Field model representing a farm plot"""

    def __init__(
        self,
        field_id: str,
        user_id: str,
        field_name: str,
        area: float,  # hectares
        soil_type: Optional[str] = None,
        location: Optional[Tuple[float, float]] = None,  # (lat, lon)
        created_at: Optional[datetime] = None,
        updated_at: Optional[datetime] = None,
        **kwargs: Any,
    ) -> None:
        self.field_id = field_id
        self.user_id = user_id
        self.field_name = field_name
        self.area = area
        self.soil_type = soil_type
        self.location = location
        self.created_at = created_at or datetime.utcnow()
        self.updated_at = updated_at or datetime.utcnow()

        for key, value in kwargs.items():
            setattr(self, key, value)

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for Firestore"""
        data = {
            'field_id': self.field_id,
            'user_id': self.user_id,
            'field_name': self.field_name,
            'area': self.area,
            'soil_type': self.soil_type,
            'created_at': self.created_at,
            'updated_at': self.updated_at
        }

        if self.location:
            data['location'] = {
                'lat': self.location[0],
                'lon': self.location[1]}

        return data

    @staticmethod
    def from_dict(data: Dict[str, Any]) -> 'Field':
        """Create Field from Firestore document"""
        if 'location' in data and isinstance(data['location'], dict):
            data['location'] = (
                data['location'].get('lat'),
                data['location'].get('lon'))
        return Field(**data)

    def __repr__(self) -> str:
        return f"<Field {self.field_id} - {self.field_name}>"
