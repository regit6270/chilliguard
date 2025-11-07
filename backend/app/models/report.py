"""Report data model"""
from __future__ import annotations

from datetime import datetime
from typing import Any, Dict, Optional


class Report:
    """Report model for end-cycle and analytical reports"""

    def __init__(
        self,
        report_id: str,
        batch_id: str,
        user_id: str,
        report_type: str,  # end_cycle, comparison, analytics
        title: str = '',
        pdf_url: Optional[str] = None,
        data: Optional[Dict[str, Any]] = None,
        generated_at: Optional[datetime] = None,
        **kwargs: Any,
    ) -> None:
        self.report_id = report_id
        self.batch_id = batch_id
        self.user_id = user_id
        self.report_type = report_type
        self.title = title
        self.pdf_url = pdf_url
        self.data = data or {}
        self.generated_at = generated_at or datetime.utcnow()

        for key, value in kwargs.items():
            setattr(self, key, value)

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for Firestore"""
        return {
            'report_id': self.report_id,
            'batch_id': self.batch_id,
            'user_id': self.user_id,
            'report_type': self.report_type,
            'title': self.title,
            'pdf_url': self.pdf_url,
            'data': self.data,
            'generated_at': self.generated_at
        }

    @staticmethod
    def from_dict(data: Dict[str, Any]) -> 'Report':
        """Create Report from Firestore document"""
        return Report(**data)

    def __repr__(self) -> str:
        return f"<Report {self.report_id} - {self.report_type}>"
