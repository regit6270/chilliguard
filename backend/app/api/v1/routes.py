from flask import Blueprint, Flask
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


def register_routes(app: Flask) -> None:
    """Register all API v1 routes"""
    api_v1: Blueprint = Blueprint('api_v1', __name__, url_prefix='/api/v1')

    # Register endpoint blueprints
    api_v1.register_blueprint(sensors.bp)
    api_v1.register_blueprint(feasibility.bp)
    api_v1.register_blueprint(disease_detection.bp)
    api_v1.register_blueprint(recommendations.bp)
    api_v1.register_blueprint(batches.bp)
    api_v1.register_blueprint(reports.bp)
    api_v1.register_blueprint(knowledge_base.knowledge_base_bp)
    api_v1.register_blueprint(users.bp)
    api_v1.register_blueprint(fields.bp)
    api_v1.register_blueprint(alerts.bp)

    app.register_blueprint(api_v1)
