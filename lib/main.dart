import 'package:cultiva_plus/config/theme/app_theme.dart';
import 'package:cultiva_plus/presentation/screens/home_screen.dart';
import 'package:cultiva_plus/presentation/widgets/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Bloquea la rotación: solo vertical
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,  // descomenta si quieres permitir boca abajo
  ]);
  
  // Hace que la app dibuje detrás de las barras superior e inferior
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // Configura los colores de las barras del sistema
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // Barra de estado superior (batería, hora, wifi)
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // Íconos oscuros (negro)

      // Barra de navegación inferior (botones o barra de gestos)
      systemNavigationBarColor: Colors.white, // transparente
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark, 
      systemNavigationBarContrastEnforced: false,
    ),
    
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSystemBars(
        child: MaterialApp(
        theme: AppTheme().theme(),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}