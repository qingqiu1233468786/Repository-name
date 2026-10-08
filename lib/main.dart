import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 🔒 游戏固定横屏，只允许左右横向
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  // 🎮 沉浸式全屏，隐藏状态栏、导航栏
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
    _videoCtrl.setLooping(true); // 启动页视频循环播放
    await _videoCtrl.play();
    if (mounted) setState(() => videoReady = true);
  }

  @override
  void dispose() {
    _videoCtrl.dispose();
    super.dispose();
  }

  void gotoHome() {
    _videoCtrl.pause(); // 跳转前暂停，节省性能
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
          // 背景视频（自适应铺满全屏）
          videoReady
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoCtrl.value.size.width,
                      height: _videoCtrl.value.size.height,
                      child: VideoPlayer(_videoCtrl),
                    ),
                  ),
                )
              : Container(color: Colors.black),

          // 居中的“进入”按钮
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.white, width: 2),
                ),
                elevation: 10,
              ),
              onPressed: videoReady ? gotoHome : null, // 视频加载好才能点，防闪退
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

  @override
  void initState() {
    super.initState();
    _videoCtrl = VideoPlayerController.asset("assets/bg.mp4");
    _initVideo();
  }

  Future<void> _initVideo() async {
    await _videoCtrl.initialize();
    _videoCtrl.setLooping(true); // 🎯 核心：主界面视频无限循环播放
    await _videoCtrl.play();
    if (mounted) setState(() => videoReady = true);
  }

  void showMsg(String text) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.75),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 底层视频背景（自适应铺满）
          videoReady
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoCtrl.value.size.width,
                      height: _videoCtrl.value.size.height,
                      child: VideoPlayer(_videoCtrl),
                    ),
                  ),
                )
              : Container(color: Colors.black),

          // 半透明侧边菜单
          Row(
            children: [
              SizedBox(
                width: 180,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.32),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: const Color(0xff2040aa).withValues(alpha: 0.4),
                        child: const Text(
                          "三清",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                      ListTile(
                        title: const Text("功能1", style: TextStyle(color: Colors.white)),
                        selected: selectedIndex == 0,
                        onTap: () {
                          setState(() => selectedIndex = 0);
                          showMsg("已选择功能1");
                        },
                      ),
                      ListTile(
                        title: const Text("功能2", style: TextStyle(color: Colors.white)),
                        selected: selectedIndex == 1,
                        onTap: () {
                          setState(() => selectedIndex = 1);
                          showMsg("已选择功能2");
                        },
                      ),
                      ListTile(
                        title: const Text("功能3", style: TextStyle(color: Colors.white)),
                        selected: selectedIndex == 2,
                        onTap: () {
                          setState(() => selectedIndex = 2);
                          showMsg("已选择功能3");
                        },
                      ),
                      ListTile(
                        title: const Text("功能4", style: TextStyle(color: Colors.white)),
                        selected: selectedIndex == 3,
                        onTap: () {
                          setState(() => selectedIndex = 3);
                          showMsg("已选择功能4");
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.25),
                    ),
                    child: const Text(
                      "主内容区",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
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
