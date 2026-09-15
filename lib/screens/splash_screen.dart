import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../widgets/brain_rush_title.dart';
import 'home_screen.dart';

/// Màn khởi động (Splash):
/// - Hiện logo + tên game
/// - Thanh loading chạy một lúc
/// - Xong thì chuyển sang Home (màn Play)
///
/// Học: StatefulWidget = màn hình có "trạng thái đổi theo thời gian"
/// (ở đây là thanh loading đầy dần).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // AnimationController = "đồng hồ" chạy từ 0.0 → 1.0 trong [duration].
  late final AnimationController _controller;

  // Màu theo mockup xanh — gom 1 chỗ cho dễ chỉnh.
  static const _bgBlue = Color(0xFF0B3D91);
  static const _bgBlueDeep = Color(0xFF072E6E);
  static const _yellow = Color(0xFFFFC107);
  static const _barTrack = Color(0xFF0A2F70);

  @override
  void initState() {
    // initState chỉ chạy 1 lần khi màn được tạo.
    // Sửa duration xong phải Hot Restart (R), Hot Reload (r) không đủ.
    super.initState();

    _controller = AnimationController(
      // vsync gắn animation với màn hình (cần SingleTickerProviderStateMixin).
      vsync: this,
      // Thời gian loading. Đổi số này = đổi tốc độ thanh vàng.
      duration: const Duration(seconds: 3),
    )..forward(); // Bắt đầu chạy ngay từ 0 → 1.

    // Khi animation xong → chuyển màn.
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        // pushReplacement: thay Splash bằng Home (không quay lại Splash bằng nút Back).
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    // Học: luôn hủy controller khi rời màn → tránh rò bộ nhớ.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // build() vẽ UI. Flutter gọi lại khi cần rebuild.
    return Scaffold(
      // Nền gradient xanh (thay vì 1 màu phẳng).
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.2),
            radius: 1.1,
            colors: [_bgBlue, _bgBlueDeep],
          ),
        ),
        // Stack: lớp dưới = ngôi sao trang trí, lớp trên = nội dung splash.
        // Học: Positioned đặt widget theo cạnh left/right/top.
        child: Stack(
          children: [
            // --- SAO TRÁI (3) ---
            const Positioned(left: 28, top: 110, child: _BgStar(size: 18)),
            const Positioned(left: 48, top: 260, child: _BgStar(size: 12)),
            const Positioned(left: 22, top: 420, child: _BgStar(size: 16)),

            // --- SAO PHẢI (3) ---
            const Positioned(right: 30, top: 130, child: _BgStar(size: 14)),
            const Positioned(right: 44, top: 290, child: _BgStar(size: 20)),
            const Positioned(right: 24, top: 450, child: _BgStar(size: 12)),

            // SafeArea: tránh đè notch / thanh status bar.
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    // Spacer đẩy nội dung ra giữa / xuống dưới theo tỉ lệ flex.
                    const Spacer(flex: 2),

                    // --- LOGO + TITLE ---
                    // Transform.translate(offset âm Y): kéo chữ lên đè nhẹ chân ảnh.
                    // Học: offset.dy < 0 = dịch lên trên (không cần Stack).
                    Column(
                      children: [
                        ShaderMask(
                          blendMode: BlendMode.dstIn,
                          shaderCallback: (bounds) {
                            return RadialGradient(
                              colors: [
                                Colors.white,
                                Colors.white,
                                Colors.white.withValues(alpha: 0),
                              ],
                              stops: const [0.0, 0.72, 1.0],
                            ).createShader(bounds);
                          },
                          child: Image.asset(
                            'assets/images/brain_rush_mascot.png',
                            width: 300,
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -36),
                          child: const BrainRushTitle(
                            fontSize: 52,
                            arcDegrees: 36,
                            height: 160,
                          ),
                        ),
                      ],
                    ),
                    // Transform kéo chữ lên nhưng layout vẫn giữ chỗ cũ → subtitle sát hơn một chút.
                    const SizedBox(height: 4),

                    // --- SUBTITLE ---
                    Text(
                      AppLocalizations.of(context)!.splashSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const Spacer(flex: 2),

                    // --- LOADING BAR ---
                    // AnimatedBuilder lắng nghe _controller → mỗi frame value đổi là vẽ lại thanh.
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        return Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: LinearProgressIndicator(
                                // value từ 0.0 → 1.0 theo thời gian duration ở trên.
                                value: _controller.value,
                                minHeight: 12,
                                backgroundColor: _barTrack,
                                color: _yellow,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              AppLocalizations.of(context)!.loading,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ngôi sao trang trí nền.
/// Học: tách widget nhỏ riêng cho dễ đọc / tái sử dụng.
class _BgStar extends StatelessWidget {
  const _BgStar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.star_rounded,
      size: size,
      color: const Color(0xFFFFC107).withValues(alpha: 0.85),
    );
  }
}
