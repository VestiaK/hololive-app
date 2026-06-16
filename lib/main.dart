import 'package:first/data/notifiers.dart';
import 'package:first/views/pages/welcome_pages.dart';
import 'package:flutter/material.dart';
// 1. Tambahkan import dotenv di sini
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 2. Ubah void main() menjadi Future<void> main() async
Future<void> main() async {
  // 3. Wajib tambahkan ini agar engine Flutter siap
  WidgetsFlutterBinding.ensureInitialized();
  
  // 4. Perintah untuk me-load file .env sebelum aplikasi berjalan
  await dotenv.load(fileName: "assets/.env");

  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: darkmode,
      builder: (context, dark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.greenAccent,
              brightness: dark ? Brightness.light : Brightness.dark,
            ),
          ),
          home: WelcomePages(),
        );
      },
    );
  }
}