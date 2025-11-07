"""
Core Module
===========
Core functionality including config, security, Firebase, and database.
"""

from app.core.config import Config, DevelopmentConfig, ProductionConfig, TestingConfig, config
from app.core.security import require_auth, get_current_user, get_user_id
from app.core.firebase import initialize_firebase, verify_firebase_token, get_firestore_client

__all__ = [
    'Config',
    'DevelopmentConfig',
    'ProductionConfig',
    'TestingConfig',
    'config',
    'require_auth',
    'get_current_user',
    'get_user_id',
    'initialize_firebase',
    'verify_firebase_token',
    'get_firestore_client',
]
