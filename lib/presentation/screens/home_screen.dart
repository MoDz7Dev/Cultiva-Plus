//import 'package:cultiva_plus/presentation/screens/scan_screen.dart';
import 'package:cultiva_plus/presentation/screens/scan_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Utilizado para conocer las dimensiones del dispositivo
    final size = MediaQuery.sizeOf(context);
    
    return Scaffold(
      backgroundColor: Color(0xFFebf2f2),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            /*Positioned(
              top: 0,
              left: -50,
              child: Transform.rotate(
                angle: 0.9,
                child: Image.asset('assets/images/plantita_gris.png', width: 250),
              )
            ),
            Positioned(
              top: 100,
              left: 230,
              child: Transform.rotate(
                angle: -0.4,
                child: Image.asset('assets/images/plantita_gris.png', width: 250,),
              )
            ),
            Positioned(
              top: 300,
              left: -50,
              child: Transform.rotate(
                angle: 0.3,
                child: Image.asset('assets/images/plantita_gris.png', width: 250),
              )
            ),*/
            Positioned(
              top: 20,
              left: 30,
              child: Image.asset(
                'assets/images/cultiva_+.png',
                width: size.width * 0.85,
              )
            ),
            Positioned(
              bottom: size.height * 0.20,
              left: -14,
              child: Transform.rotate(
                angle: 0.25,
                child: Image.asset('assets/images/plantita_verde.png', width: size.width * 1, color: Colors.white,),
              ),
            ),
            //?==== TARJETA INFERIOR ====
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: size.height * 0.36,
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Cuidar ¡Nunca fue tan fácil!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      'Olvídate de adivinar cuándo regar o abonar. Analiza las necesidades de cada una de tus plantas para cuidarlas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16
                        ,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 20,),
                    //Boton Escanea
                    SizedBox(
                      width: size.width * 0.42,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ScanScreen())
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                          backgroundColor: Color(0xFF21955D)
                        ),
                        child: Row(
                          spacing: 18,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            /*Image.asset(
                              'assets/images/plantita_icono.png',
                              color: Colors.white,
                              width: 27,
                            ),*/
                            Icon(Icons.photo_camera, size: 25, color: Colors.white,),
                            Text('Escanea', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 28),
                  ],
                ),
              ),
            ),
            Positioned(
              left: -size.width * 0.16,
              bottom: size.height * 0.22,
              child: Image.asset(
                'assets/images/plantita.png',
                height: size.width * 1.30,
                fit: BoxFit.contain,
              )
            )
          ],
        ),
      )
    );
  }
}