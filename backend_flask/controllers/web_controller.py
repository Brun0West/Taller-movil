# controllers/web_controller.py - Controlador de rutas web
from flask import Blueprint, request, render_template, redirect, session, url_for
from models.user_model import UserModel
from models.product_model import ProductModel


web_bp = Blueprint('web_bp', __name__)


@web_bp.route('/', methods=['GET', 'POST'])
def web_login():
    """Vista web de login."""
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        password = request.form.get('password', '')

        usuario = UserModel.validate_login(username, password)

        if usuario:
            session['usuario_id'] = usuario['id']
            session['username'] = usuario['username']
            return redirect(url_for('web_bp.web_principal'))

        return render_template(
            'login.html',
            error='Credenciales incorrectas'
        )

    return render_template('login.html')


@web_bp.route('/principal')
def web_principal():
    """Vista principal después del login."""
    if 'usuario_id' not in session:
        return redirect(url_for('web_bp.web_login'))

    return render_template(
        'principal.html',
        username=session.get('username')
    )


@web_bp.route('/productos-web', methods=['GET', 'POST'])
def web_productos():
    """Vista web para mantenimiento básico de productos."""
    if 'usuario_id' not in session:
        return redirect(url_for('web_bp.web_login'))

    mensaje = None

    if request.method == 'POST':
        accion = request.form.get('accion')

        if accion == 'agregar':
            data = {
                'codigo': request.form.get('codigo', '').strip(),
                'nombre': request.form.get('nombre', '').strip(),
                'categoria': request.form.get('categoria', '').strip(),
                'precio': request.form.get('precio', 0),
                'stock': request.form.get('stock', 0),
                'descripcion': request.form.get('descripcion', '')
            }

            if not all([data['codigo'], data['nombre'], data['categoria'], data['precio']]):
                mensaje = 'Error: complete los campos obligatorios.'
            else:
                resultado = ProductModel.create(data)
                mensaje = (
                    'Producto agregado exitosamente.'
                    if resultado['ok']
                    else 'Error: El código del producto ya existe.'
                )

        elif accion == 'eliminar':
            prod_id = request.form.get('prod_id')
            if prod_id:
                ProductModel.delete(int(prod_id))
                mensaje = 'Producto eliminado.'

    productos = ProductModel.list_all()
    return render_template(
        'productos.html',
        productos=productos,
        mensaje=mensaje
    )


@web_bp.route('/salir')
def web_salir():
    """Cierra la sesión web."""
    session.clear()
    return redirect(url_for('web_bp.web_login'))
