"""Disease data model"""
from __future__ import annotations

from datetime import datetime
from typing import Any, Dict, List, Optional


class Disease:
    """Disease model for plant disease information"""

    def __init__(
        self,
        disease_id: str,
        disease_name: str,
        scientific_name: Optional[str] = None,
        description: Optional[str] = None,
        symptoms: Optional[List[str]] = None,
        causes: Optional[List[str]] = None,
        prevention: Optional[List[str]] = None,
        severity_levels: Optional[Dict[str, str]] = None,
        created_at: Optional[datetime] = None,
        updated_at: Optional[datetime] = None,
        **kwargs: Any,
    ) -> None:
        self.disease_id = disease_id
        self.disease_name = disease_name
        self.scientific_name = scientific_name
        self.description = description
        self.symptoms = symptoms or []
        self.causes = causes or []
        self.prevention = prevention or []
        self.severity_levels = severity_levels or {}
        self.created_at = created_at or datetime.utcnow()
        self.updated_at = updated_at or datetime.utcnow()

        for key, value in kwargs.items():
            setattr(self, key, value)

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for Firestore"""
        return {
            'disease_id': self.disease_id,
            'disease_name': self.disease_name,
            'scientific_name': self.scientific_name,
            'description': self.description,
            'symptoms': self.symptoms,
            'causes': self.causes,
            'prevention': self.prevention,
            'severity_levels': self.severity_levels,
            'created_at': self.created_at,
            'updated_at': self.updated_at
        }

    @staticmethod
    def from_dict(data: Dict[str, Any]) -> 'Disease':
        """Create Disease from Firestore document"""
        return Disease(**data)

    def __repr__(self) -> str:
        return f"<Disease {self.disease_id} - {self.disease_name}>"


class DiseaseDetection:
    """Disease detection model for storing detection results"""

    def __init__(
        self,
        detection_id: str,
        user_id: str,
        field_id: Optional[str] = None,
        batch_id: Optional[str] = None,
        disease_name: str = 'unknown',
        confidence: float = 0.0,
        severity: str = 'unknown',  # mild, moderate, severe
        affected_area_percent: float = 0.0,
        image_url: Optional[str] = None,
        model_type: str = 'device',  # device or cloud
        timestamp: Optional[datetime] = None,
        **kwargs: Any,
    ) -> None:
        self.detection_id = detection_id
        self.user_id = user_id
        self.field_id = field_id
        self.batch_id = batch_id
        self.disease_name = disease_name
        self.confidence = confidence
        self.severity = severity
        self.affected_area_percent = affected_area_percent
        self.image_url = image_url
        self.model_type = model_type
        self.timestamp = timestamp or datetime.utcnow()

        for key, value in kwargs.items():
            setattr(self, key, value)

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for Firestore"""
        return {
            'detection_id': self.detection_id,
            'user_id': self.user_id,
            'field_id': self.field_id,
            'batch_id': self.batch_id,
            'disease_name': self.disease_name,
            'confidence': self.confidence,
            'severity': self.severity,
            'affected_area_percent': self.affected_area_percent,
            'image_url': self.image_url,
            'model_type': self.model_type,
            'timestamp': self.timestamp
        }

    @staticmethod
    def from_dict(data: Dict[str, Any]) -> 'DiseaseDetection':
        """Create DiseaseDetection from Firestore document"""
        return DiseaseDetection(**data)

    def __repr__(self) -> str:
        return (
            f"<DiseaseDetection {self.detection_id} - {self.disease_name} "
            f"({self.confidence:.2%})>"
        )
