# 3rd parth dependencies
from flask import Flask
from flask_cors import CORS

# project dependencies
from deepface import DeepFace
from modules.core.routes import blueprint
from deepface.commons.logger import Logger

logger = Logger()


def create_app():
    app = Flask(__name__)
    CORS(app)
    app.register_blueprint(blueprint)
    
    blueprint_routes = [rule.rule for rule in app.url_map.iter_rules()]
    logger.info(f"Available routes: {blueprint_routes}")

    logger.info(f"Welcome to DeepFace API v{DeepFace.__version__}!")
    return app
