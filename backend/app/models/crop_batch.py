"""Crop batch data model"""
from __future__ import annotations

from datetime import date, datetime
from typing import Any, Dict, Optional


class CropBatch:
    """Crop batch model for tracking cultivation cycles"""

    def __init__(
        self,
        batch_id: str,
        user_id: str,
        field_id: str,
        crop_type: str,  # "chilli"
        planting_date: date,
        estimated_harvest_date: Optional[date] = None,
        actual_harvest_date: Optional[date] = None,
        area: float = 0.0,  # hectares
        seed_variety: Optional[str] = None,
        status: str = 'active',  # active, harvested, failed
        health_score: float = 100.0,
        created_at: Optional[datetime] = None,
        updated_at: Optional[datetime] = None,
        **kwargs: Any,
    ) -> None:
        self.batch_id = batch_id
        self.user_id = user_id
        self.field_id = field_id
        self.crop_type = crop_type
        self.planting_date = planting_date
        self.estimated_harvest_date = estimated_harvest_date
        self.actual_harvest_date = actual_harvest_date
        self.area = area
        self.seed_variety = seed_variety
        self.status = status
        self.health_score = health_score
        self.created_at = created_at or datetime.utcnow()
        self.updated_at = updated_at or datetime.utcnow()

        for key, value in kwargs.items():
            setattr(self, key, value)

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for Firestore"""
        return {
            'batch_id': self.batch_id,
            'user_id': self.user_id,
            'field_id': self.field_id,
            'crop_type': self.crop_type,
            'planting_date': self.planting_date.isoformat() if isinstance(
                self.planting_date,
                date) else self.planting_date,
            'estimated_harvest_date': self.estimated_harvest_date.isoformat() if self.estimated_harvest_date else None,
            'actual_harvest_date': self.actual_harvest_date.isoformat() if self.actual_harvest_date else None,
            'area': self.area,
            'seed_variety': self.seed_variety,
            'status': self.status,
            'health_score': self.health_score,
            'created_at': self.created_at,
            'updated_at': self.updated_at}

    @staticmethod
    def from_dict(data: Dict[str, Any]) -> 'CropBatch':
        """Create CropBatch from Firestore document"""
        # Convert ISO date strings back to date objects
        if 'planting_date' in data and isinstance(data['planting_date'], str):
            data['planting_date'] = date.fromisoformat(data['planting_date'])
        if 'estimated_harvest_date' in data and isinstance(
                data['estimated_harvest_date'], str):
            data['estimated_harvest_date'] = date.fromisoformat(
                data['estimated_harvest_date'])
        if 'actual_harvest_date' in data and isinstance(
                data['actual_harvest_date'], str):
            data['actual_harvest_date'] = date.fromisoformat(
                data['actual_harvest_date'])
        return CropBatch(**data)

    def __repr__(self) -> str:
        return f"<CropBatch {self.batch_id} - {self.crop_type} ({self.status})>"
