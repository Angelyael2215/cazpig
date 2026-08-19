import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/views/screens/splash_screen.dart';
import 'src/services/notification_service.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización defensiva de Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 3));

    // Inicializar FCM solo si Firebase encendió correctamente
    try {
      await NotificationService.initialize();
    } catch (e) {
      debugPrint("Notificaciones no soportadas en este entorno: $e");
    }
  } catch (e) {
    debugPrint("Firebase omitido o no compatible en esta plataforma: $e");
  }

  runApp(const CazadoresApp());
}

class CazadoresApp extends StatelessWidget {
  const CazadoresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cazadores de Pigmentos',
      home: SplashScreen(), 
    );
  }
}