# app.py - Backend TechStore S.A.C. con Arquitectura MVC
from flask import Flask
from flask_cors import CORS

from config import Config
from models.db import init_db
from controllers.auth_controller import auth_bp
from controllers.product_controller import product_bp
from controllers.web_controller import web_bp


def create_app():
    """Crea y configura la aplicación Flask."""
    app = Flask(
        __name__,
        template_folder='views/templates',
        static_folder='static'
    )
    app.config.from_object(Config)

    # Habilitar CORS para permitir peticiones desde Flutter
    CORS(app)

    # Registrar controladores mediante Blueprints
    app.register_blueprint(auth_bp)
    app.register_blueprint(product_bp)
    app.register_blueprint(web_bp)

    return app


app = create_app()


if __name__ == '__main__':
    init_db()
    app.run(debug=True, host='0.0.0.0', port=5000)
