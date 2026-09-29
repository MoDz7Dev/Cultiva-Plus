import 'package:camera/camera.dart';
//import 'package:cultiva_plus/presentation/screens/info_plant.dart';
import 'package:cultiva_plus/presentation/widgets/button_common.dart';
import 'package:cultiva_plus/presentation/widgets/button_selection.dart';
import 'package:cultiva_plus/presentation/widgets/cristal_card.dart';
import 'package:cultiva_plus/presentation/widgets/dialog_emergent.dart';
import 'package:flutter/material.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  // ─── Campos de estado ───────────────────────────────────────────
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  bool _cargando = true;
  String? _error;
  bool _capturando = false;
  CameraDescription? _camaraActual;
  bool _pausado = false;
  int _opcionSeleccionada = 0;   // 0 = "Identificar Planta" por defecto


  // ─── Ciclo de vida ──────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _inicializarCamara();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _liberarController();        // ya hace null + dispose
    super.dispose();
  }

  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached: 
        // La app pierde el foco: liberamos la cámara para no bloquear
        // el recurso mientras MIUI/Android nos suspende.
        if (_camaraActual != null && !_pausado) {
          _pausado = true;
          _liberarController();
          if (mounted) setState(() {});
        }
        break;

      case AppLifecycleState.resumed:
        // Recuperamos el foco: reabrimos con la MISMA cámara.
        if (_pausado && _camaraActual != null) {
          _pausado = false;
          _reanudarCamara();
        }
        break;
    }
  }

  /// Suelta el controller sin tocar la UI. Se usa desde el ciclo de vida,
  /// donde no podemos esperar ni reconstruir el árbol.
  void _liberarController() {
    final controller = _controller;
    _controller = null;
    controller?.dispose();
  }



  // ─── Lógica de cámara ──────────────────────────────────────────
  Future<void> _inicializarCamara() async {
    try {
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        if (!mounted) return;
        setState(() {
          _error = 'No se encontró ninguna cámara en este dispositivo.';
          _cargando = false;
        });
        return;
      }

      // Preferimos la cámara trasera; si no hay, la primera disponible.
      final camaraTrasera = _cameras.firstWhere(
        (camara) => camara.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      await _abrirCamara(camaraTrasera);
    } on CameraException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = _traducirError(error);
        _cargando = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'Ocurrió un error inesperado al abrir la cámara.';
        _cargando = false;
      });
    }
  }

  Future<void> _cerrarCamara() async {
    _camaraActual = null;        // ← limpia la intención: no reabrir
    _pausado = false;
    _liberarController();
  }

  Future<void> _abrirCamara(CameraDescription descripcion) async {
    // Si ya había un controller vivo, lo liberamos antes de crear otro.
    if (!mounted) return;

    final anterior = _controller;
    if (anterior != null) {
      anterior.dispose();
      _controller = null;
    }

    final nuevoController = CameraController(
      descripcion,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await nuevoController.initialize();
      if (!mounted) {
        nuevoController.dispose();
        return;
      }
      setState(() {
        _controller = nuevoController;
        _camaraActual = descripcion; 
        _cargando = false;
        _error = null;
      });
    } on CameraException catch (error) {
      nuevoController.dispose();
      if (!mounted) return;
      setState(() {
        _error = _traducirError(error);
        _cargando = false;
      });
    }
  }

  Future<void> _reanudarCamara() async {
    final descripcion = _camaraActual;
    if (descripcion == null || !mounted) return;

    setState(() => _cargando = true);   // ← muestra el spinner durante los ~330ms

    try {
      final nuevoController = CameraController(
        descripcion,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await nuevoController.initialize();
      if (!mounted) {
        nuevoController.dispose();
        return;
      }
      setState(() {
        _controller = nuevoController;
        _cargando = false;
        _error = null;
      });
    } on CameraException catch (error) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _error = _traducirError(error);
      });
    } catch (error) {
      // Red de seguridad: si initialize() falla por algo que no sea
      // CameraException, no queremos quedarnos en negro sin mensaje.
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _error = 'No se pudo reabrir la cámara. Intenta de nuevo.';
      });
    }
  }

  



  String _traducirError(CameraException error) {
    switch (error.code) {
      case 'CameraAccessDenied':
        return 'Necesitamos tu permiso para usar la cámara.';
      case 'CameraAccessDeniedWithoutPrompt':
        return 'El permiso de cámara está bloqueado. Actívalo en los ajustes del sistema.';
      case 'CameraAccessRestricted':
        return 'El acceso a la cámara está restringido en este dispositivo.';
      case 'AudioAccessDenied':
      case 'AudioAccessDeniedWithoutPrompt':
        return 'Necesitamos tu permiso para usar el micrófono.';
      case 'AudioAccessRestricted':
        return 'El acceso al micrófono está restringido en este dispositivo.';
      default:
        return 'No se pudo iniciar la cámara: ${error.description ?? error.code}';
    }
  }

  Future<void> _tomarFoto() async {
    final controller = _controller;
    if (!mounted || controller == null || !controller.value.isInitialized || _capturando) {
      return;
    }

    setState(() => _capturando = true);

    try {
      final XFile foto = await controller.takePicture();
      if (!mounted) return;
      setState(() => _capturando = false);

      // TODO: enviar `foto` al análisis (IA/API) cuando esté listo.
      debugPrint('Foto capturada en: ${foto.path}');
    } on CameraException catch (error) {
      if (!mounted) return;
      setState(() {
        _capturando = false;
        _error = _traducirError(error);
      });
    }
  }

  // ─── UI ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Vista de la cámara ocupando toda la pantalla.
          if (controller != null && controller.value.isInitialized)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.previewSize!.height,
                  height: controller.value.previewSize!.width,
                  child: CameraPreview(controller),
                ),
              ),
            )
          else
            const Positioned.fill(
              child: Center(
                child: Icon(Icons.photo_camera, size: 70, color: Colors.white24),
              ),
            ),

          // Estado de carga / error.
          if (_cargando || _error != null)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: _cargando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.no_photography,
                                  size: 70, color: Colors.white),
                              const SizedBox(height: 16),
                              Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              const SizedBox(height: 24),
                              FilledButton.icon(
                                onPressed: _reintentar,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Reintentar'),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          
          Positioned(
            bottom: size.height * 0.3,
            left: size.width * 0.06,
            child: SafeArea(
              child: Image.asset('assets/images/capturador_delgado.png', width: size.width * 0.88,),
            )
          ),
          
          Positioned(
            bottom: 0,
            left: -30,
            right: -30,
            child: TarjetaCristal(
              child:Container(
                height: size.height * 0.17,
              )
            )
          ),
          // Botón de volver, flotando sobre el preview.
          Positioned(
            top: 15,
            left: 10,
            child: SafeArea(
              child: CustomButton(
                icon: Icons.arrow_back_ios_new,
                backgroundColor: Colors.transparent,
                sizeIcon: 25,
                sizeButton: 55,
                onPressed: () async {
                  final navigator = Navigator.of(context);   // ← capturado ANTES del await
                  // Cerramos la cámara explícitamente ANTES de navegar
                  await _cerrarCamara();
                  // Ahora sí salimos
                  navigator.maybePop(); 
                },
              ),
            ),
          ),
          Positioned(
            top: 15,
            left: size.width * 0.85,
            child: SafeArea(
              child: CustomButton(
                icon: Icons.info,
                backgroundColor: Colors.transparent,
                sizeIcon: 30,
                sizeButton: 55,
                onPressed: () async {
                  ConsejosScanDialog.show(context);
                },
              ),
            ),
          ),
          // CULTIVA +
          Positioned(
            top: 12,
            left: size.width * 0.34,
            child: SafeArea(
              child: Image.asset('assets/images/cultiva_+_blanco.png', width: size.width * 0.35,)
            ),
          ),

          // Barra inferior con el disparador.
          if (controller != null && controller.value.isInitialized)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Encuadra tu planta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 1),
                      // -----FILA DE OPCIONES ----
                      SizedBox(
                        height: 50,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(), // Rebote estilo IOS
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            spacing: 5,
                            children: [
                              CustomButtonText(text: 'Identificar Planta', isSelected: _opcionSeleccionada == 0,onPressed: () => setState(() => _opcionSeleccionada = 0),),
                              CustomButtonText(text: 'Hierba', isSelected: _opcionSeleccionada == 1,onPressed: () => setState(() => _opcionSeleccionada = 1),),
                              CustomButtonText(text: 'Arbol', isSelected: _opcionSeleccionada == 2,onPressed: () => setState(() => _opcionSeleccionada = 2),),
                              CustomButtonText(text: 'Seta', isSelected: _opcionSeleccionada == 3,onPressed: () => setState(() => _opcionSeleccionada = 3),),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 55,
                        children: [
                          Column(
                            children: [
                              CustomButton(
                                icon: Icons.photo_library,
                                onPressed: () {},
                                sizeIcon: 34,
                                sizeButton: 50,
                                backgroundColor: Colors.transparent,
                                iconColor: Colors.white,
                              ),
                              Text(
                                'Fotos',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13
                                ),
                              )
                            ],
                          ),
                          IconButton(
                            onPressed: _capturando ? null : _tomarFoto,
                            iconSize: 72,
                            icon: _capturando
                                ? const SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: CircularProgressIndicator(color: Colors.white),
                                )
                                : Image.asset('assets/images/photo_lens.png', height: 70,),
                          ),
                          Column(
                            children: [
                              CustomButton(
                                icon: Icons.flash_on,
                                onPressed: () {},
                                sizeIcon: 34,
                                sizeButton: 50,
                                backgroundColor: Colors.transparent,
                                iconColor: Colors.white,
                              ),
                              Text(
                                'Flash',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      
                    ],
                  ),
                ),
              ),
            ),
          

        ],
      ),
    );
  }

  Future<void> _reintentar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    await _inicializarCamara();
  }

}
