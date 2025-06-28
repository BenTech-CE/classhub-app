import 'package:flutter/material.dart';

/// Um widget que desenha um triângulo retângulo com o ângulo de 90 graus
/// posicionado no canto superior direito.
class TopRightTriangle extends StatelessWidget {
  /// O tamanho do widget do triângulo.
  final Size size;

  /// A cor de preenchimento do triângulo.
  final Color color;

  /// Arredondamento do triângulo
  final double borderRadius;

  /// Cria um widget de triângulo retângulo.
  ///
  /// O [size] é obrigatório para definir as dimensões do triângulo.
  /// A [color] tem um padrão de `Colors.blue` se não for fornecida.
  const TopRightTriangle({
    super.key,
    required this.size,
    this.borderRadius = 4,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: CustomPaint(
        painter: _TrianglePainter(color, borderRadius),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  final double borderRadius;

  _TrianglePainter(this.color, this.borderRadius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    // Começa do canto superior direito
    path.moveTo(size.width, 0);

    // Linha até antes da ponta superior esquerda (deixando espaço para a curva)
    path.lineTo(borderRadius, 0);

    // Faz o arco (bordarredondada) até descer o lado esquerdo
    path.arcToPoint(
      Offset(0, borderRadius),
      radius: Radius.circular(borderRadius),
      clockwise: false,
    );

    // Linha até o canto inferior direito
    path.lineTo(size.width, size.height);

    // Fecha o triângulo
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // We can set this to false since the painter's properties are immutable.
    // If color or other properties could change, we'd need to compare them here.
    return false;
  }
}