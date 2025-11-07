"""
ChilliGuard Backend Server Entry Point
"""
import logging
from app import create_app


# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)

# Create Flask app
app = create_app()

if __name__ == '__main__':
    logger.info('Starting ChilliGuard Backend Server...')
    logger.info('Server running on http://localhost:5000')
    logger.info('Health check: http://localhost:5000/health')
    logger.info('Press CTRL+C to quit')

    app.run(
        host='0.0.0.0',
        port=5000,
        debug=True,
        use_reloader=True
    )
