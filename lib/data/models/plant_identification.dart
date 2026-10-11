// Modelos de la respuesta del backend Cultiva+ (Pl@ntNet + Trefle).

/// Imagen de referencia de una especie (la devuelve Pl@ntNet).
class ImagenReferencia {
  final String? organo;
  final String? url;
  final String? autor;
  final String? licencia;

  const ImagenReferencia({this.organo, this.url, this.autor, this.licencia});

  factory ImagenReferencia.fromJson(Map<String, dynamic> json) {
    return ImagenReferencia(
      organo: json['organo'] as String?,
      url: json['url'] as String?,
      autor: json['autor'] as String?,
      licencia: json['licencia'] as String?,
    );
  }
}

/// Una posible especie identificada.
class CandidatoPlanta {
  final String? nombreComun;
  final String nombreCientifico;
  final String? familia;
  final String? genero;
  final double score;
  final List<ImagenReferencia> imagenes;
  final String? gbifId;

  const CandidatoPlanta({
    this.nombreComun,
    required this.nombreCientifico,
    this.familia,
    this.genero,
    this.score = 0,
    this.imagenes = const [],
    this.gbifId,
  });

  factory CandidatoPlanta.fromJson(Map<String, dynamic> json) {
    final crudas = (json['imagenes'] as List?) ?? const [];
    return CandidatoPlanta(
      nombreComun: json['nombreComun'] as String?,
      nombreCientifico: (json['nombreCientifico'] as String?) ?? '—',
      familia: json['familia'] as String?,
      genero: json['genero'] as String?,
      score: (json['score'] as num?)?.toDouble() ?? 0,
      imagenes: crudas
          .whereType<Map>()
          .map((e) => ImagenReferencia.fromJson(e.cast<String, dynamic>()))
          .toList(),
      gbifId: json['gbifId'] as String?,
    );
  }

  /// Porcentaje de coincidencia listo para mostrar (ej. 87).
  int get porcentaje => (score * 100).round();
}

/// Resultado completo de `POST /identify`.
class IdentificacionPlanta {
  final CandidatoPlanta? mejor;
  final List<CandidatoPlanta> candidatos;
  final int? restantes;
  final String? version;
  final String fuente;

  const IdentificacionPlanta({
    this.mejor,
    this.candidatos = const [],
    this.restantes,
    this.version,
    this.fuente = 'Pl@ntNet',
  });

  factory IdentificacionPlanta.fromJson(Map<String, dynamic> json) {
    final lista = (json['candidatos'] as List?) ?? const [];
    final mejorJson = json['mejor'];
    return IdentificacionPlanta(
      mejor: mejorJson is Map
          ? CandidatoPlanta.fromJson(mejorJson.cast<String, dynamic>())
          : null,
      candidatos: lista
          .whereType<Map>()
          .map((e) => CandidatoPlanta.fromJson(e.cast<String, dynamic>()))
          .toList(),
      restantes: (json['restantes'] as num?)?.toInt(),
      version: json['version'] as String?,
      fuente: (json['fuente'] as String?) ?? 'Pl@ntNet',
    );
  }

  /// Candidatos alternativos (todos menos el primero).
  List<CandidatoPlanta> get alternativas =>
      candidatos.length > 1 ? candidatos.sublist(1) : const [];
}

/// Ficha botánica de `GET /plants/{nombre}`.
class DetallePlanta {
  final String nombreCientifico;
  final String? nombreComun;
  final String? familia;
  final String? genero;
  final int? anio;
  final String? imagen;
  final String? resumen;
  final String? luz;
  final String? humedad;
  final String fuente;

  const DetallePlanta({
    required this.nombreCientifico,
    this.nombreComun,
    this.familia,
    this.genero,
    this.anio,
    this.imagen,
    this.resumen,
    this.luz,
    this.humedad,
    this.fuente = 'Trefle (CC-BY-4.0)',
  });

  factory DetallePlanta.fromJson(Map<String, dynamic> json) {
    return DetallePlanta(
      nombreCientifico: (json['nombreCientifico'] as String?) ?? '—',
      nombreComun: json['nombreComun'] as String?,
      familia: json['familia'] as String?,
      genero: json['genero'] as String?,
      anio: (json['anio'] as num?)?.toInt(),
      imagen: json['imagen'] as String?,
      resumen: json['resumen'] as String?,
      luz: json['luz'] as String?,
      humedad: json['humedad'] as String?,
      fuente: (json['fuente'] as String?) ?? 'Trefle (CC-BY-4.0)',
    );
  }
}
