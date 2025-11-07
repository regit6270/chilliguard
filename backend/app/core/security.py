from typing import Callable, Any
import logging
from functools import wraps
from flask import request, jsonify
from app.core.firebase import verify_firebase_token


logger = logging.getLogger(__name__)  # Logger for the security module


def require_auth(f: Callable) -> Callable:
    """Decorator to require Firebase authentication."""
    @wraps(f)
    def decorated_function(*args: Any, **kwargs: Any) -> Any:
        # auth_header = request.headers.get('Authorization')

        # if not auth_header:
        #     return jsonify({'error': 'No authorization header'}), 401

        # try:
        #     # Extract token from "Bearer <token>"
        #     token = auth_header.split(
        #         ' ')[1] if ' ' in auth_header else auth_header

        #     # Verify token
        #     decoded_token = verify_firebase_token(token)

        #     if not decoded_token:
        #         return jsonify({'error': 'Invalid token'}), 401

        #     # Add user info to request context
        #     request.user = decoded_token  # type: ignore[attr-defined]

        # except Exception as e:
        #     logger.error(f'Authentication error: {str(e)}')
        #     return jsonify({'error': 'Authentication failed'}), 401
        # ------------------------------------------------------------
        # For DEMO: Accept any request with field_id parameter
        # ----------------------------------------------------------
        # In production: Validate Firebase JWT token here

        field_id = request.args.get('field_id')
        if not field_id:
            return jsonify({'error': 'field_id parameter required'}), 400

        # Store user_id in context (for demo, hardcode to demo_user_001)
        kwargs['user_id'] = 'demo_user_001'

        return f(*args, **kwargs)

    return decorated_function


def get_current_user() -> Any:
    """Get current authenticated user from request context."""
    return getattr(request, 'user', None)


def get_user_id() -> Any:
    """Get current user ID."""
    # For DEMO: Return hardcoded demo user
    return 'demo_user_001'

    # user = get_current_user() # In production: Extract from Firebase JWT token
    # return user['uid'] if user else None
