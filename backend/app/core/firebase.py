import firebase_admin
from firebase_admin import credentials, firestore, storage, auth
from app.config import Config
import logging

logger = logging.getLogger(__name__)

_initialized = False

def initialize_firebase():
    """Initialize Firebase Admin SDK"""
    global _initialized

    if _initialized:
        return

    try:
        cred = credentials.Certificate(Config.FIREBASE_CREDENTIALS_PATH)
        firebase_admin.initialize_app(cred, {
            'storageBucket': Config.FIREBASE_STORAGE_BUCKET
        })
        _initialized = True
        logger.info('Firebase initialized successfully')
    except Exception as e:
        logger.error(f'Failed to initialize Firebase: {str(e)}')
        raise

def get_firestore_client():
    """Get Firestore client instance"""
    if not _initialized:
        initialize_firebase()
    return firestore.client()

def get_storage_bucket():
    """Get Cloud Storage bucket instance"""
    if not _initialized:
        initialize_firebase()
    return storage.bucket()

def verify_firebase_token(id_token):
    """Verify Firebase ID token"""
    try:
        decoded_token = auth.verify_id_token(id_token)
        return decoded_token
    except Exception as e:
        logger.error(f'Token verification failed: {str(e)}')
        return None

def get_user_by_uid(uid):
    """Get user by Firebase UID"""
    try:
        user = auth.get_user(uid)
        return user
    except Exception as e:
        logger.error(f'Failed to get user: {str(e)}')
        return None
