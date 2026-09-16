import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
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
      // Nền splash full màn. Ảnh đã gồm mascot + sao, nên không chồng thêm.
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bacground_splash.png'),
            fit: BoxFit.cover,
            // Âm trục Y = lấy phần trên ảnh, não xích xuống để không bị cắt tia sét.
            alignment: Alignment(0, -0.45),
          ),
        ),
        // SafeArea: tránh đè notch / thanh status bar.
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                // Spacer trên chừa chỗ mascot đã vẽ sẵn trong ảnh nền.
                const Spacer(flex: 5),

                const BrainRushTitle(fontSize: 52, arcDegrees: 36, height: 160),
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
                            backgroundColor: AppColors.cardBg,
                            color: AppColors.yellow,
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
      ),
    );
  }
}
