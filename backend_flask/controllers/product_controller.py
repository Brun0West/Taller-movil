# controllers/product_controller.py - Controlador REST de productos
from flask import Blueprint, request, jsonify
from models.product_model import ProductModel


product_bp = Blueprint('product_bp', __name__)


@product_bp.route('/api/productos', methods=['GET'])
def listar_productos():
    """Lista todos los productos."""
    productos = ProductModel.list_all()
    return jsonify(productos), 200


@product_bp.route('/api/productos/buscar', methods=['GET'])
def buscar_productos():
    """Busca productos por código, nombre o categoría."""
    q = request.args.get('q', '').strip()
    productos = ProductModel.search(q)
    return jsonify(productos), 200


@product_bp.route('/api/productos', methods=['POST'])
def registrar_producto():
    """Registra un nuevo producto."""
    datos = request.get_json()

    if not datos:
        return jsonify({'ok': False, 'mensaje': 'No se recibió JSON'}), 400

    campos = ['codigo', 'nombre', 'categoria', 'precio']
    if not all(k in datos for k in campos):
        return jsonify({'ok': False, 'mensaje': 'Campos incompletos'}), 400

    resultado = ProductModel.create(datos)

    if not resultado['ok']:
        return jsonify({'ok': False, 'mensaje': 'El código ya existe'}), 409

    return jsonify({
        'ok': True,
        'mensaje': 'Producto registrado',
        'id': resultado['id']
    }), 201


@product_bp.route('/api/productos/<int:prod_id>', methods=['PUT'])
def actualizar_producto(prod_id):
    """Actualiza un producto existente."""
    datos = request.get_json()

    if not datos:
        return jsonify({'ok': False, 'mensaje': 'No se recibió JSON'}), 400

    actualizado = ProductModel.update(prod_id, datos)

    if not actualizado:
        return jsonify({'ok': False, 'mensaje': 'Producto no encontrado'}), 404

    return jsonify({'ok': True, 'mensaje': 'Producto actualizado'}), 200


@product_bp.route('/api/productos/<int:prod_id>', methods=['DELETE'])
def eliminar_producto(prod_id):
    """Elimina un producto."""
    eliminado = ProductModel.delete(prod_id)

    if not eliminado:
        return jsonify({'ok': False, 'mensaje': 'Producto no encontrado'}), 404

    return jsonify({'ok': True, 'mensaje': 'Producto eliminado'}), 200
