from functools import wraps
from flask import request, jsonify
from app.core.firebase import verify_firebase_token
import logging

logger = logging.getLogger(__name__)

def require_auth(f):
    """Decorator to require Firebase authentication"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        auth_header = request.headers.get('Authorization')

        if not auth_header:
            return jsonify({'error': 'No authorization header'}), 401

        try:
            # Extract token from "Bearer <token>"
            token = auth_header.split(' ')[1] if ' ' in auth_header else auth_header

            # Verify token
            decoded_token = verify_firebase_token(token)
            if not decoded_token:
                return jsonify({'error': 'Invalid token'}), 401

            # Add user info to request context
            request.user = decoded_token

        except Exception as e:
            logger.error(f'Authentication error: {str(e)}')
            return jsonify({'error': 'Authentication failed'}), 401

        return f(*args, **kwargs)

    return decorated_function

def get_current_user():
    """Get current authenticated user from request context"""
    return getattr(request, 'user', None)

def get_user_id():
    """Get current user ID"""
    user = get_current_user()
    return user['uid'] if user else None
