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
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _videoCtrl;
  bool videoReady = false;

  int selectedMenu = 0;
  final List<String> menuItems = [
    "程序主页",
    "内存功能",
    "虚体传送",
    "绘制参数",
    "自瞄参数",
    "隐藏窗口",
    "退出程序",
  ];

  double groundX = 0.000;
  double groundY = 0.000;
  double groundZ = 1.420;
  double groundH = 0.144;
  double groundV = 0.100;
  double groundS = 0.500;

  double airX = 0.000;
  double airY = 0.000;
  double airZ = 1.420;
  double airH = 0.144;
  double airV = 0.100;
  double airS = 0.500;

  bool enableSmooth = true;

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

          Positioned(
            top: 10,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                "自瞄调试参数",
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        Positioned.fill(
          top: 50,
          left: 10,
          right: 10,
          bottom: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white24),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedMenu == index;
                    return GestureDetector(
                      onTap: () => setState(() => selectedMenu = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue.withValues(alpha: 0.5)
                              : Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Text(
                            menuItems[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          children: [
                            _buildTopButton("保存配置"),
                            const SizedBox(width: 6),
                            _buildTopButton("加载配置"),
                          ],
                        ),
                      ),
                      const Divider(color: Colors.white24, height: 1),
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          thickness: 4,
                          radius: const Radius.circular(4),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle("地面目标配置:"),
                                _buildParamRow("左右偏移 (X)", groundX, (v) => setState(() => groundX = v)),
                                _buildParamRow("前后偏移 (Y)", groundY, (v) => setState(() => groundY = v)),
                                _buildParamRow("高度偏移 (Z)", groundZ, (v) => setState(() => groundZ = v)),
                                _buildParamRow("水平预判系数", groundH, (v) => setState(() => groundH = v)),
                                _buildParamRow("垂直预判系数", groundV, (v) => setState(() => groundV = v)),
                                _buildParamRow("平滑系数", groundS, (v) => setState(() => groundS = v)),

                                const SizedBox(height: 8),
                                _buildSectionTitle("空中目标配置:"),
                                _buildParamRow("左右偏移 (X)", airX, (v) => setState(() => airX = v)),
                                _buildParamRow("前后偏移 (Y)", airY, (v) => setState(() => airY = v)),
                                _buildParamRow("高度偏移 (Z)", airZ, (v) => setState(() => airZ = v)),
                                _buildParamRow("水平预判系数", airH, (v) => setState(() => airH = v)),
                                _buildParamRow("垂直预判系数", airV, (v) => setState(() => airV = v)),
                                _buildParamRow("平滑系数", airS, (v) => setState(() => airS = v)),

                                const SizedBox(height: 8),
                                _buildSectionTitle("通用配置:"),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: enableSmooth,
                                      onChanged: (v) => setState(() => enableSmooth = v ?? false),
                                      activeColor: Colors.blueAccent,
                                      side: const BorderSide(color: Colors.white54),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    const Text("启用平滑", style: TextStyle(color: Colors.white, fontSize: 13)),
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
  Widget _buildTopButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        title,
        style: const TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildParamRow(String label, double value, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          _buildMiniBtn(Icons.remove, () => onChanged((value - 0.001).clamp(0.0, 3.0))),
          Container(
            width: 48,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Center(
              child: Text(
                value.toStringAsFixed(3),
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ),
          _buildMiniBtn(Icons.add, () => onChanged((value + 0.001).clamp(0.0, 3.0))),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          SizedBox(
            width: 100,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              ),
              child: Slider(
                value: value.clamp(0.0, 3.0),
                min: 0.0,
                max: 3.0,
                activeColor: Colors.blueAccent,
                inactiveColor: Colors.white24,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.8)),
        ),
        child: Icon(icon, color: Colors.white, size: 14),
      ),
    );
  }
}