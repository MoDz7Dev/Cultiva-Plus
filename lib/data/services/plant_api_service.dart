import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cultiva_plus/config/api_config.dart';
import 'package:cultiva_plus/data/models/plant_identification.dart';
import 'package:http/http.dart' as http;

/// Error de negocio del backend, con un mensaje ya listo para el usuario.
class PlantApiException implements Exception {
  final String mensaje;
  final int? statusCode;

  const PlantApiException(this.mensaje, {this.statusCode});

  @override
  String toString() => mensaje;
}

/// Cliente HTTP del backend Cultiva+ (Pl@ntNet + Trefle).
class PlantApiService {
  PlantApiService({http.Client? cliente}) : _cliente = cliente ?? http.Client();

  final http.Client _cliente;

  /// Comprueba rápido que el backend está encendido y accesible.
  ///
  /// Lanza [PlantApiException] con instrucciones concretas si no se llega
  /// a él (así no hay que esperar 90 s para saber que el servidor está apagado).
  Future<void> verificarConexion() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/health');

    try {
      final respuesta = await _cliente.get(uri).timeout(ApiConfig.timeoutSalud);
      if (respuesta.statusCode != 200) {
        throw PlantApiException(
          'El backend respondió con un error (${respuesta.statusCode}).',
          statusCode: respuesta.statusCode,
        );
      }

      // Si el backend está encendido pero sin claves, avisamos antes de gastar
      // una foto en una llamada que va a fallar.
      try {
        final json = jsonDecode(utf8.decode(respuesta.bodyBytes));
        if (json is Map && json['plantnetConfigurado'] == false) {
          throw const PlantApiException(
            'El backend está encendido, pero le falta la clave de Pl@ntNet.\n\n'
            'Edita backend/.env y coloca PLANTNET_API_KEY '
            '(y TREFLE_TOKEN para la ficha).',
          );
        }
      } on FormatException {
        // Respuesta no JSON: no es crítico, continuamos.
      }
    } on TimeoutException {
      throw const PlantApiException(
        'No se pudo conectar con el backend.\n\n'
        'Revisa que:\n'
        '• El servidor esté encendido:  uvicorn app.main:app --host 0.0.0.0 --port 8000\n'
        '• ApiConfig.baseUrl tenga la IP de tu PC (${ApiConfig.baseUrl}).\n'
        '• El teléfono y la PC estén en la misma red Wi-Fi.\n'
        '• El firewall de Windows permita el puerto 8000.',
      );
    } on SocketException {
      throw const PlantApiException(
        'No se pudo conectar con el backend.\n\n'
        'Revisa que el servidor esté encendido, la IP en ApiConfig.baseUrl '
        'y el firewall de Windows (puerto 8000).',
      );
    }
  }

  /// Envía la foto a `POST /identify` y devuelve las especies probables.
  Future<IdentificacionPlanta> identificar(
    File foto, {
    String organo = 'auto',
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/identify');
    final peticion = http.MultipartRequest('POST', uri)
      ..fields['organ'] = organo
      ..files.add(await http.MultipartFile.fromPath('image', foto.path));

    try {
      final respuesta = await http.Response.fromStream(
        await _cliente.send(peticion).timeout(ApiConfig.timeoutIdentificar),
      );
      return IdentificacionPlanta.fromJson(_decodificar(respuesta));
    } on TimeoutException {
      throw const PlantApiException(
        'El análisis tardó demasiado. Intenta de nuevo con otra foto.',
      );
    } on SocketException {
      throw const PlantApiException(
        'Se perdió la conexión con el backend durante el análisis.',
      );
    } on HttpException {
      throw const PlantApiException('No se pudo leer la foto capturada.');
    } on FormatException {
      throw const PlantApiException('El servidor devolvió una respuesta inválida.');
    }
  }

  /// Pide la ficha botánica a `GET /plants/{nombre}`.
  /// Devuelve `null` si Trefle no conoce la especie (no es un error).
  Future<DetallePlanta?> detalle(String nombreCientifico) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/plants/${Uri.encodeComponent(nombreCientifico)}',
    );

    try {
      final respuesta = await _cliente.get(uri).timeout(ApiConfig.timeoutDetalle);
      if (respuesta.statusCode == 404) return null;
      return DetallePlanta.fromJson(_decodificar(respuesta));
    } on TimeoutException {
      throw const PlantApiException(
        'La ficha de la planta tardó demasiado en llegar.',
      );
    } on SocketException {
      throw const PlantApiException(
        'Se perdió la conexión con el backend.',
      );
    } on FormatException {
      throw const PlantApiException('El servidor devolvió una respuesta inválida.');
    }
  }

  /// Decodifica el cuerpo o lanza [PlantApiException] con el `detail` de FastAPI.
  Map<String, dynamic> _decodificar(http.Response respuesta) {
    final cuerpo = utf8.decode(respuesta.bodyBytes);

    if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
      return jsonDecode(cuerpo) as Map<String, dynamic>;
    }

    String mensaje = 'Ocurrió un error en el servidor (${respuesta.statusCode}).';
    try {
      final json = jsonDecode(cuerpo);
      if (json is Map && json['detail'] is String) {
        mensaje = json['detail'] as String;
      }
    } catch (_) {
      // El cuerpo no era JSON; nos quedamos con el mensaje genérico.
    }
    throw PlantApiException(mensaje, statusCode: respuesta.statusCode);
  }

  /// Libera el cliente HTTP.
  void dispose() => _cliente.close();
}
