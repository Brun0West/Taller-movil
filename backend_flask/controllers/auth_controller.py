# controllers/auth_controller.py - Controlador REST de autenticación
from flask import Blueprint, request, jsonify
from models.user_model import UserModel


auth_bp = Blueprint('auth_bp', __name__)


@auth_bp.route('/api/login', methods=['POST'])
def api_login():
    """Endpoint REST para login consumido desde Flutter."""
    datos = request.get_json()

    if not datos or 'username' not in datos or 'password' not in datos:
        return jsonify({'ok': False, 'mensaje': 'Datos incompletos'}), 400

    usuario = UserModel.validate_login(
        datos['username'],
        datos['password']
    )

    if usuario:
        return jsonify({
            'ok': True,
            'mensaje': 'Acceso exitoso',
            'usuario': usuario
        }), 200

    return jsonify({
        'ok': False,
        'mensaje': 'Credenciales incorrectas'
    }), 401
