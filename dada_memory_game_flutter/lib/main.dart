import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/game_provider.dart';
import 'screens/game_screen.dart';
import 'services/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase
  try {
    await FirebaseConfig.initialize();
  } catch (e) {
    print('Ошибка инициализации Firebase: $e');
  }

  runApp(const DadaMemoryGameApp());
}

class DadaMemoryGameApp extends StatelessWidget {
  const DadaMemoryGameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        title: 'Dada Memory Game',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Используем шрифт Ubuntu как в оригинале
          textTheme: GoogleFonts.ubuntuTextTheme(),
          primaryColor: const Color(0xFFBA68C8),
          scaffoldBackgroundColor: const Color(0xFFE6CEFF).withOpacity(0.7),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFFBA68C8),
            secondary: const Color(0xFFBA68C8),
          ),
        ),
        home: const GameScreen(),
      ),
    );
  }
}
