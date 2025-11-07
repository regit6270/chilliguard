"""User data model"""
from __future__ import annotations

from datetime import datetime
from typing import Any, Dict, Optional


class User:
    """User model representing a farmer/landowner"""

    def __init__(
        self,
        user_id: str,
        name: str,
        phone: str,
        email: Optional[str] = None,
        location: Optional[Dict[str, str]] = None,
        created_at: Optional[datetime] = None,
        updated_at: Optional[datetime] = None,
        **kwargs: Any,
    ) -> None:
        self.user_id = user_id
        self.name = name
        self.phone = phone
        self.email = email
        self.location = location or {}
        self.created_at = created_at or datetime.utcnow()
        self.updated_at = updated_at or datetime.utcnow()

        # Additional fields
        for key, value in kwargs.items():
            setattr(self, key, value)

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for Firestore"""
        return {
            'user_id': self.user_id,
            'name': self.name,
            'phone': self.phone,
            'email': self.email,
            'location': self.location,
            'created_at': self.created_at,
            'updated_at': self.updated_at
        }

    @staticmethod
    def from_dict(data: Dict[str, Any]) -> 'User':
        """Create User from Firestore document"""
        return User(**data)

    def __repr__(self) -> str:
        return f"<User {self.user_id} - {self.name}>"
