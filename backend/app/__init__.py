"""
ChilliGuard Backend Application
================================
Main Flask application factory and initialization.
"""

import os
import logging
from typing import Dict, Tuple

from flask import Flask
from flask_cors import CORS
from dotenv import load_dotenv

from app.core.firebase import initialize_firebase
from app.core.database import init_db  # ← CORRECT IMPORT (from database.py, not firestore_db.py)
from app.api.v1.routes import register_routes

# Load environment variables
load_dotenv()

# Configure logging


def setup_logging(app: Flask) -> None:
    """Configure application logging."""
    log_level = logging.DEBUG if app.config.get('DEBUG', False) else logging.INFO
    logging.basicConfig(
        level=log_level,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.StreamHandler(),
            logging.FileHandler('app.log')
        ]
    )
    app.logger.setLevel(log_level)


def create_app(config_name: str = 'development') -> Flask:
    """
    Application factory pattern.
    Args:
        config_name (str): Configuration name in {'development', 'production', 'testing'}
    Returns:
        Flask: Configured Flask application instance
    """
    app = Flask(__name__)

    # Load configuration from environment
    app.config['DEBUG'] = True
    app.config['ALLOWED_ORIGINS'] = ['*']

    # Setup logging
    setup_logging(app)

    app.logger.info(f"🚀 Creating ChilliGuard Backend with config: {config_name}")

    # Initialize CORS
    CORS(app, resources={
        r"/api/*": {
            "origins": app.config.get('ALLOWED_ORIGINS', ['*']),
            "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
            "allow_headers": ["Content-Type", "Authorization"]
        }
    })
    app.logger.info("✅ CORS initialized")

    # Initialize Firebase
    initialize_firebase()
    app.logger.info("✅ Firebase initialized")

    # ⭐ CRITICAL: Initialize Firestore Database
    init_db(app)  # ← THIS WAS MISSING! NOW ADDED!
    app.logger.info("✅ Firestore database initialized")

    # Register API routes
    register_routes(app)
    app.logger.info("✅ API routes registered")

    # ============================================
    # HEALTH CHECK ENDPOINTS
    # ============================================

    @app.route('/')
    def health_check() -> Tuple[Dict[str, str], int]:
        """Root endpoint - API info"""
        return {
            'status': 'healthy',
            'service': 'ChilliGuard Backend API',
            'version': 'v1'
        }, 200

    @app.route('/health')
    def health() -> Tuple[Dict[str, str], int]:
        """Health check endpoint for monitoring"""
        from datetime import datetime
        return {
            'status': 'healthy',
            'timestamp': datetime.now().isoformat()
        }, 200

    # ============================================
    # ERROR HANDLERS
    # ============================================

    @app.errorhandler(400)
    def bad_request(error: Exception) -> Tuple[Dict[str, str], int]:
        return {'error': 'Bad Request', 'message': str(error)}, 400

    @app.errorhandler(401)
    def unauthorized(error: Exception) -> Tuple[Dict[str, str], int]:
        return {'error': 'Unauthorized', 'message': 'Authentication required'}, 401

    @app.errorhandler(403)
    def forbidden(error: Exception) -> Tuple[Dict[str, str], int]:
        return {'error': 'Forbidden', 'message': 'Access denied'}, 403

    @app.errorhandler(404)
    def not_found(error: Exception) -> Tuple[Dict[str, str], int]:
        return {'error': 'Resource not found', 'message': str(error)}, 404

    @app.errorhandler(500)
    def internal_error(error: Exception) -> Tuple[Dict[str, str], int]:
        app.logger.error(f'Internal Server Error: {str(error)}')
        return {'error': 'Internal server error'}, 500

    app.logger.info("✅ Application factory setup complete!")
    return app
