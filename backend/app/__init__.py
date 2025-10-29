from flask import Flask
from flask_cors import CORS
from app.config import Config
from app.core.firebase import initialize_firebase
from app.core.database import init_db
from app.api.v1.routes import register_routes
import logging

def create_app(config_class=Config):
    """Application factory pattern"""
    app = Flask(__name__)
    app.config.from_object(config_class)

    # Setup CORS
    CORS(app, resources={
        r"/api/*": {
            "origins": app.config['ALLOWED_ORIGINS'],
            "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
            "allow_headers": ["Content-Type", "Authorization"]
        }
    })

    # Setup logging
    setup_logging(app)

    # Initialize Firebase
    initialize_firebase()

    # Initialize Database
    init_db(app)

    # Register API routes
    register_routes(app)

    # Register error handlers
    register_error_handlers(app)

    # Health check endpoint
    @app.route('/health', methods=['GET'])
    def health_check():
        return {'status': 'healthy', 'version': '1.0.0'}, 200

    return app

def setup_logging(app):
    """Configure application logging"""
    log_level = logging.DEBUG if app.config['DEBUG'] else logging.INFO

    logging.basicConfig(
        level=log_level,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.StreamHandler(),
            logging.FileHandler('app.log')
        ]
    )

    app.logger.setLevel(log_level)

def register_error_handlers(app):
    """Register global error handlers"""

    @app.errorhandler(400)
    def bad_request(error):
        return {'error': 'Bad Request', 'message': str(error)}, 400

    @app.errorhandler(401)
    def unauthorized(error):
        return {'error': 'Unauthorized', 'message': 'Authentication required'}, 401

    @app.errorhandler(403)
    def forbidden(error):
        return {'error': 'Forbidden', 'message': 'Access denied'}, 403

    @app.errorhandler(404)
    def not_found(error):
        return {'error': 'Not Found', 'message': 'Resource not found'}, 404

    @app.errorhandler(500)
    def internal_error(error):
        app.logger.error(f'Internal Server Error: {str(error)}')
        return {'error': 'Internal Server Error', 'message': 'An unexpected error occurred'}, 500
