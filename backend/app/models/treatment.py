"""Treatment data model"""
from datetime import datetime, date
from typing import Optional, Dict, Any

class Treatment:
    """Treatment model for disease treatment tracking"""

    def __init__(
        self,
        treatment_id: str,
        user_id: str,
        batch_id: str,
        detection_id: Optional[str] = None,
        treatment_name: str = '',
        treatment_type: str = 'chemical',  # chemical, organic, biological
        dosage: Optional[str] = None,
        application_method: Optional[str] = None,
        application_date: Optional[date] = None,
        next_application_date: Optional[date] = None,
        frequency: Optional[str] = None,
        notes: Optional[str] = None,
        effectiveness_rating: Optional[float] = None,  # 0-5 stars
        cost: Optional[float] = None,
        created_at: Optional[datetime] = None,
        updated_at: Optional[datetime] = None,
        **kwargs
    ):
        self.treatment_id = treatment_id
        self.user_id = user_id
        self.batch_id = batch_id
        self.detection_id = detection_id
        self.treatment_name = treatment_name
        self.treatment_type = treatment_type
        self.dosage = dosage
        self.application_method = application_method
        self.application_date = application_date
        self.next_application_date = next_application_date
        self.frequency = frequency
        self.notes = notes
        self.effectiveness_rating = effectiveness_rating
        self.cost = cost
        self.created_at = created_at or datetime.utcnow()
        self.updated_at = updated_at or datetime.utcnow()

        for key, value in kwargs.items():
            setattr(self, key, value)

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for Firestore"""
        return {
            'treatment_id': self.treatment_id,
            'user_id': self.user_id,
            'batch_id': self.batch_id,
            'detection_id': self.detection_id,
            'treatment_name': self.treatment_name,
            'treatment_type': self.treatment_type,
            'dosage': self.dosage,
            'application_method': self.application_method,
            'application_date': self.application_date.isoformat() if self.application_date else None,
            'next_application_date': self.next_application_date.isoformat() if self.next_application_date else None,
            'frequency': self.frequency,
            'notes': self.notes,
            'effectiveness_rating': self.effectiveness_rating,
            'cost': self.cost,
            'created_at': self.created_at,
            'updated_at': self.updated_at
        }

    @staticmethod
    def from_dict(data: Dict[str, Any]) -> 'Treatment':
        """Create Treatment from Firestore document"""
        if 'application_date' in data and isinstance(data['application_date'], str):
            data['application_date'] = date.fromisoformat(data['application_date'])
        if 'next_application_date' in data and isinstance(data['next_application_date'], str):
            data['next_application_date'] = date.fromisoformat(data['next_application_date'])
        return Treatment(**data)

    def __repr__(self):
        return f"<Treatment {self.treatment_id} - {self.treatment_name}>"
