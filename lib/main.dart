import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 锁定横屏
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
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

// ========== 启动页：分两段动画 ==========
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _lineOpacity;
  late Animation<double> _colorOpacity;
  bool stage1 = true; // true=转圈加载阶段；false=图片渐变阶段

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // 图片渐变时长
    );

    _lineOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.6, 1, curve: Curves.easeOut)),
    );
    _colorOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.6, 1, curve: Curves.easeOut)),
    );

    // 【第一阶段：等待3秒转圈加载】
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        stage1 = false; // 切换到第二阶段图片渐变
      });
      _ctrl.forward(); // 启动图片渐变动画
    });

    // 图片渐变动画完成，跳转主页
    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const HomePage()));
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // 任意点击直接跳过所有动画，进入主界面
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const HomePage()));
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [Color(0xff2040aa), Color(0xffbb6020), Colors.black],
              center: Alignment.bottomLeft,
              radius: 1.4,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 第二阶段才显示两张图片
              if (!stage1) ...[
                FadeTransition(
                  opacity: _colorOpacity,
                  child: Image.asset(
                    "assets/original.png",
                    fit: BoxFit.cover,
                  ),
                ),
                FadeTransition(
                  opacity: _lineOpacity,
                  child: Image.asset(
                    "assets/line.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],

              // 第一阶段：转圈加载UI
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "三清",
                      style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if(stage1)
                    const Column(
                      children: [
                        Text(
                          "加载中",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        SizedBox(height:4),
                        Text(
                          "作者：三清",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========== 主界面：左侧侧边栏 ==========
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  void showMsg(String text) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(text, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("关闭"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 左侧侧边栏
          SizedBox(
            width: 180,
            child: Drawer(
              elevation: 2,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Color(0xff2040aa)),
                    child: Text("三清", style: TextStyle(color: Colors.white, fontSize: 22)),
                  ),
                  ListTile(
                    title: const Text("功能1"),
                    selected: selectedIndex == 0,
                    onTap: () {
                      setState(() => selectedIndex = 0);
                      showMsg("已选择功能1");
                    },
                  ),
                  ListTile(
                    title: const Text("功能2"),
                    selected: selectedIndex == 1,
                    onTap: () {
                      setState(() => selectedIndex = 1);
                      showMsg("已选择功能2");
                    },
                  ),
                  ListTile(
                    title: const Text("功能3"),
                    selected: selectedIndex == 2,
                    onTap: () {
                      setState(() => selectedIndex = 2);
                      showMsg("已选择功能3");
                    },
                  ),
                  ListTile(
                    title: const Text("功能4"),
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
          // 右侧主内容区域
           const Expanded(
             child: Center(
               child: Text(
                 "主内容区",
                 style: TextStyle(color: Colors.white, fontSize: 24),
               ),
             ),
           )
         ],
       ),
     );
   }
 }