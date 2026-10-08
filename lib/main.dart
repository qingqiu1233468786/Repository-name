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
// ================= 主界面 =================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _videoCtrl;
  bool videoReady = false;
  int selectedIndex = 0;
  bool showAuxWindow = false;

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

  void showMsg(String text) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        title: Text(text, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("关闭"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoCtrl.dispose();
    super.dispose();
  }

  Widget _buildCapsuleItem(String title, int index, {bool isTitle = false}) {
    bool isSelected = selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: GestureDetector(
        onTap: () {
          if (!isTitle) {
            setState(() {
              selectedIndex = index;
              if (index == 1) {
                showAuxWindow = !showAuxWindow;
              }
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6),
              width: isSelected ? 2.0 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTitle ? 22 : 18,
              fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
              letterSpacing: isTitle ? 4 : 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuxiliaryWindow() {
    return Positioned(
      right: 100,
      top: 50,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("辅助配置", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => setState(() => showAuxWindow = false),
                    child: const Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ],
              ),
              const Divider(color: Colors.white30),
              const Text("地面目标配置:", style: TextStyle(color: Colors.cyan, fontSize: 12)),
              _buildSliderRow("左右偏移 (X)", 0.0),
              _buildSliderRow("前后偏移 (Y)", 0.0),
              _buildSliderRow("高度偏移 (Z)", 1.684),
              _buildSliderRow("水平预判", 0.144),
              _buildSliderRow("垂直预判", 0.100),
              _buildSliderRow("平滑系数", 0.500),
              const SizedBox(height: 10),
              const Text("空中目标配置:", style: TextStyle(color: Colors.cyan, fontSize: 12)),
              _buildSliderRow("左右偏移 (X)", 0.0),
              _buildSliderRow("前后偏移 (Y)", 0.0),
              _buildSliderRow("高度偏移 (Z)", 1.763),
              _buildSliderRow("水平预判", 0.144),
              _buildSliderRow("垂直预判", 0.263),
              _buildSliderRow("平滑系数", 0.500),
              const SizedBox(height: 10),
              const Text("通用配置:", style: TextStyle(color: Colors.cyan, fontSize: 12)),
              _buildCheckbox("启用平滑", true),
              _buildCheckbox("持枪时触发", true),
              _buildCheckbox("过滤队友", true),
              _buildCheckbox("显示自瞄圈圈", true),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text("自瞄圈半径:", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Expanded(
                    child: Slider(value: 245, min: 0, max: 500, activeColor: Colors.blueAccent, onChanged: (v) {}),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("最大自瞄距离(米):", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Expanded(
                    child: Slider(value: 85, min: 0, max: 200, activeColor: Colors.blueAccent, onChanged: (v) {}),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.withValues(alpha: 0.8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    ),
                    child: const Text("保存配置", style: TextStyle(fontSize: 12)),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.withValues(alpha: 0.8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    ),
                    child: const Text("加载配置", style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildSliderRow(String label, double value) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ),
        Expanded(
          child: Slider(
            value: value, min: 0.0, max: 2.0,
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.white24,
            onChanged: (v) {},
          ),
        ),
        SizedBox(
          width: 30,
          child: Text(value.toStringAsFixed(3), style: const TextStyle(color: Colors.white, fontSize: 10)),
        ),
      ],
    );
  }

  Widget _buildCheckbox(String label, bool value) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (v) {},
          activeColor: Colors.blueAccent,
          checkColor: Colors.white,
          side: const BorderSide(color: Colors.white54),
        ),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
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

          Row(
            children: [
              SizedBox(
                width: 180,
                child: ListView(
                  padding: const EdgeInsets.only(top: 40),
                  children: [
                    _buildCapsuleItem("三清", 0, isTitle: true),
                    const SizedBox(height: 10),
                    _buildCapsuleItem("辅助", 1),
                    _buildCapsuleItem("功能2", 2),
                    _buildCapsuleItem("功能3", 3),
                    _buildCapsuleItem("功能4", 4),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      "主内容区",
                      style: TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),

          if (showAuxWindow) _buildAuxiliaryWindow(),
        ],
      ),
    );
  }
}