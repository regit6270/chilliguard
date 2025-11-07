"""
API Endpoints
=============
All REST API endpoint blueprints.
"""

from app.api.v1.endpoints import (
    sensors,
    feasibility,
    disease_detection,
    recommendations,
    batches,
    reports,
    knowledge_base,
    users,
    fields,
    alerts
)

__all__ = [
    'sensors',
    'feasibility',
    'disease_detection',
    'recommendations',
    'batches',
    'reports',
    'knowledge_base',
    'users',
    'fields',
    'alerts',
]
