"""Custom logging configuration"""
import logging
import sys
from logging.handlers import RotatingFileHandler
from pathlib import Path

def setup_logger(name: str, log_file: str = 'app.log', level=logging.INFO):
    """Setup logger with file and console handlers"""

    # Create logger
    logger = logging.getLogger(name)
    logger.setLevel(level)

    # Create formatters
    file_formatter = logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )

    console_formatter = logging.Formatter(
        '%(levelname)s - %(message)s'
    )

    # File handler
    log_dir = Path('logs')
    log_dir.mkdir(exist_ok=True)

    file_handler = RotatingFileHandler(
        log_dir / log_file,
        maxBytes=10485760,  # 10MB
        backupCount=5
    )
    file_handler.setLevel(level)
    file_handler.setFormatter(file_formatter)

    # Console handler
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(level)
    console_handler.setFormatter(console_formatter)

    # Add handlers
    logger.addHandler(file_handler)
    logger.addHandler(console_handler)

    return logger


class AppLogger:
    """Application logger wrapper"""

    @staticmethod
    def info(message: str):
        logging.info(message)

    @staticmethod
    def debug(message: str):
        logging.debug(message)

    @staticmethod
    def warning(message: str):
        logging.warning(message)

    @staticmethod
    def error(message: str, error: Exception = None):
        if error:
            logging.error(f'{message}: {str(error)}', exc_info=True)
        else:
            logging.error(message)
