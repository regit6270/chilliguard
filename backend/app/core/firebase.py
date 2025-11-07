from typing import Any
import logging
import os
import firebase_admin
from firebase_admin import credentials, firestore, storage, auth, db
from app.core.config import Config


logger = logging.getLogger(__name__)

_initialized: bool = False


def initialize_firebase() -> None:
    """Initialize Firebase Admin SDK with Firestore and Realtime Database"""
    global _initialized

    if _initialized:
        return

    try:
        cred = credentials.Certificate(Config.FIREBASE_CREDENTIALS_PATH)

        # Get RTDB URL from environment or use default
        rtdb_url = os.getenv(
            'FIREBASE_RTDB_URL',
            'https://soilmonitoringapp-76262-default-rtdb.firebaseio.com/'
        )

        firebase_admin.initialize_app(cred, {
            'storageBucket': Config.FIREBASE_STORAGE_BUCKET,
            'databaseURL': rtdb_url  # ← Added for Realtime Database access
        })
        _initialized = True
        logger.info('Firebase initialized successfully (Firestore + RTDB)')
    except Exception as e:
        logger.error(f'Failed to initialize Firebase: {str(e)}')
        raise


def get_firestore_client() -> firestore.client:
    """Get Firestore client instance"""
    if not _initialized:
        initialize_firebase()
    return firestore.client()


def get_storage_bucket() -> storage.bucket:
    """Get Cloud Storage bucket instance"""
    if not _initialized:
        initialize_firebase()
    return storage.bucket()


def verify_firebase_token(id_token: str) -> Any:
    """Verify Firebase ID token"""
    try:
        decoded_token = auth.verify_id_token(id_token)
        return decoded_token
    except Exception as e:
        logger.error(f'Token verification failed: {str(e)}')
        return None


def get_user_by_uid(uid: str) -> Any:
    """Get user by Firebase UID"""
    try:
        user = auth.get_user(uid)
        return user
    except Exception as e:
        logger.error(f'Failed to get user: {str(e)}')
        return None
