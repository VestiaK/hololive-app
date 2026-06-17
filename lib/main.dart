import 'package:first/data/notifiers.dart';
import 'package:first/views/pages/welcome_pages.dart';
// 1. Pastikan import halaman Home kamu (sesuaikan path-nya jika beda)
import 'package:first/views/widget_tree.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// 2. Import shared_preferences
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");

  // 3. Cek status login sebelum aplikasi merender UI
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // 4. Kirim status login ke class Home
  runApp(Home(isLoggedIn: isLoggedIn));
}

class Home extends StatefulWidget {
  // 5. Tangkap variabel status login dari main()
  final bool isLoggedIn;
  
  const Home({super.key, required this.isLoggedIn});

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
          // 6. Logika penentuan halaman: 
          // Jika true -> langsung ke HomePages (misal: MyHome)
          // Jika false -> pergi ke WelcomePages (nanti dari Welcome baru diarahkan ke Login)
          home: widget.isLoggedIn ? WidgetTree() : WelcomePages(),
        );
      },
    );
  }
}