import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFFD9D7),
            Color(0xFFFFF0EC),
            Color(0xFFDDE8F5),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -32,
            child: _MountainArtwork(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'स्वागत छ, Sitaram!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppConstants.primaryRed,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              const SizedBox(
                width: 430,
                child: Text(
                  'आध्यात्मिक, सांस्कृतिक, शैक्षिक र सामाजिक हितका लागि '
                  'हाम्रो अभियानमा तपाईंको योगदान महत्वपूर्ण छ।',
                  style: TextStyle(
                    color: Color(0xFF5D5960),
                    height: 1.45,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MountainArtwork extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 520,
      height: 170,
      child: CustomPaint(
        painter: _MountainPainter(),
      ),
    );
  }
}

class _MountainPainter extends CustomPainter {
  const _MountainPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final back = Paint()..color = const Color(0xFFB8C6D8);
    final mid = Paint()..color = const Color(0xFF8FA2B8);
    final front = Paint()..color = const Color(0xFF6D7F91);

    Path mountain(List<Offset> points) {
      return Path()
        ..moveTo(0, size.height)
        ..lineTo(points.first.dx, points.first.dy)
        ..addPolygon(points, false)
        ..lineTo(size.width, size.height)
        ..close();
    }

    canvas.drawPath(
      mountain([
        Offset(size.width * .05, size.height * .65),
        Offset(size.width * .22, size.height * .18),
        Offset(size.width * .38, size.height * .57),
        Offset(size.width * .52, size.height * .05),
        Offset(size.width * .70, size.height * .55),
        Offset(size.width * .84, size.height * .22),
        Offset(size.width, size.height * .60),
      ]),
      back,
    );

    canvas.drawPath(
      mountain([
        Offset(0, size.height * .76),
        Offset(size.width * .17, size.height * .32),
        Offset(size.width * .31, size.height * .70),
        Offset(size.width * .49, size.height * .28),
        Offset(size.width * .64, size.height * .70),
        Offset(size.width * .80, size.height * .37),
        Offset(size.width, size.height * .72),
      ]),
      mid,
    );

    canvas.drawPath(
      mountain([
        Offset(0, size.height * .85),
        Offset(size.width * .22, size.height * .47),
        Offset(size.width * .39, size.height * .82),
        Offset(size.width * .58, size.height * .45),
        Offset(size.width * .77, size.height * .82),
        Offset(size.width, size.height * .55),
      ]),
      front,
    );

    final roof = Paint()..color = const Color(0xFF7D2C1F);
    final wall = Paint()..color = const Color(0xFFB85E3E);

    final x = size.width * .32;
    final y = size.height * .62;
    canvas.drawRect(Rect.fromLTWH(x, y, 72, 42), wall);
    canvas.drawPath(
      Path()
        ..moveTo(x - 9, y)
        ..lineTo(x + 36, y - 26)
        ..lineTo(x + 81, y)
        ..close(),
      roof,
    );
    canvas.drawRect(Rect.fromLTWH(x + 28, y - 30, 16, 72), roof);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
