import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  _initApp();
}

Future<void> _initApp() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}
Future<String?> getPackageNameFromProc() async {
  try {
    File file = File("/proc/self/cmdline");
    String content = await file.readAsString();
    List<String> parts = content.split('\0');
    if(parts.isNotEmpty && parts.first.isNotEmpty){
      return parts.first;
    }
    return null;
  } catch (e) {
    return "读取失败：$e";
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proc读取测试',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ReadPage(),
    );
  }
}
class ReadPage extends StatefulWidget {
  const ReadPage({super.key});

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  String result = "等待读取...";

  @override
  void initState() {
    super.initState();
    _readProcInfo();
  }
  Future<void> _readProcInfo() async {
    String? pkg = await getPackageNameFromProc();
    setState(() {
      result = pkg ?? "获取包名失败";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("/proc 读取测试")),
      body: Center(
        child: Text(
          result,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
