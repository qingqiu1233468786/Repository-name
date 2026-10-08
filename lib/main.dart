import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '三清',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}

// ================= 启动页 =================
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late VideoPlayerController _videoCtrl;
  bool videoReady = false;

  @override
  void initState() {
    super.initState();
    _videoCtrl = VideoPlayerController.asset("assets/bg.mp4");
    _initVideo();
  }

  Future<void> _initVideo() async {
    await _videoCtrl.initialize();
    _videoCtrl.setLooping(true);
    await _videoCtrl.play();
    if (mounted) setState(() => videoReady = true);
  }

  @override
  void dispose() {
    _videoCtrl.dispose();
    super.dispose();
  }

  void gotoHome() {
    _videoCtrl.pause();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (ctx) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          videoReady
              ? SizedBox.expand(
                  child: ClipRect(
                    child: Transform.scale(
                      scale: 1.08,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _videoCtrl.value.size.width,
                          height: _videoCtrl.value.size.height,
                          child: VideoPlayer(_videoCtrl),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(color: Colors.black),

          Align(
            alignment: const Alignment(0, 0.6),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.white, width: 2),
                ),
                elevation: 10,
              ),
              onPressed: videoReady ? gotoHome : null,
              child: const Text(
                "进 入",
                style: TextStyle(fontSize: 22, letterSpacing: 6, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}