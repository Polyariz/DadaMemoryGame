import 'package:firebase_core/firebase_core.dart';

/// Конфигурация Firebase для проекта Dada Memory Game
class FirebaseConfig {
  static const FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyDqNdqQqu6uv5X3KZvikFMxE5zNQfLx1ps",
    authDomain: "dadamemorygame.firebaseapp.com",
    projectId: "dadamemorygame",
    storageBucket: "dadamemorygame.appspot.com",
    messagingSenderId: "508896497562",
    appId: "1:508896497562:web:68838b3708de0faa793423",
    databaseURL: "https://dadamemorygame-default-rtdb.firebaseio.com",
  );

  /// Инициализация Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: firebaseOptions,
    );
  }
}
