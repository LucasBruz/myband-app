import 'dart:async';
import 'package:just_audio/just_audio.dart';

/// Configuración de un compás/subdivisión del metrónomo.
class MetronomeConfig {
  final int bpm; // 20-300
  final int beatsPerBar; // ej. 4 en 4/4
  final int subdivision; // 1 = negras, 2 = corcheas, 3 = tresillos, 4 = semicorcheas
  final double swing; // 0.0 - 0.5
  final List<int> accentedBeats; // índices de pulso acentuados (0-based)

  const MetronomeConfig({
    this.bpm = 120,
    this.beatsPerBar = 4,
    this.subdivision = 1,
    this.swing = 0.0,
    this.accentedBeats = const [0],
  });

  MetronomeConfig copyWith({
    int? bpm,
    int? beatsPerBar,
    int? subdivision,
    double? swing,
    List<int>? accentedBeats,
  }) {
    return MetronomeConfig(
      bpm: bpm ?? this.bpm,
      beatsPerBar: beatsPerBar ?? this.beatsPerBar,
      subdivision: subdivision ?? this.subdivision,
      swing: swing ?? this.swing,
      accentedBeats: accentedBeats ?? this.accentedBeats,
    );
  }

  /// Duración de un pulso base (negra) en segundos.
  double get beatDurationSeconds => 60.0 / bpm;

  /// Duración de cada "tick" considerando subdivisión.
  double get tickDurationSeconds => beatDurationSeconds / subdivision;
}

/// Motor de metrónomo basado en look-ahead scheduling: en vez de confiar
/// en un Timer periódico (que deriva por jitter del sistema operativo),
/// programa los próximos ticks con anticipación consultando el reloj
/// real, que es la técnica estándar para metrónomos de precisión.
class MetronomeEngine {
  MetronomeConfig config;
  final AudioPlayer _normalClick = AudioPlayer();
  final AudioPlayer _accentClick = AudioPlayer();

  static const double _scheduleAheadTime = 0.1; // segundos
  static const double _lookaheadInterval = 25; // ms

  Timer? _schedulerTimer;
  double _nextTickTime = 0;
  int _currentTickInBar = 0;
  bool _isPlaying = false;
  final _stopwatch = Stopwatch();

  /// Callback opcional para UI (flash visual, resaltar pulso actual).
  void Function(int tickIndex, bool isAccent)? onTick;

  MetronomeEngine({this.config = const MetronomeConfig()});

  Future<void> loadSounds({
    String normalAsset = 'assets/sounds/click_normal.wav',
    String accentAsset = 'assets/sounds/click_accent.wav',
  }) async {
    await _normalClick.setAsset(normalAsset);
    await _accentClick.setAsset(accentAsset);
  }

  bool get isPlaying => _isPlaying;

  void start() {
    if (_isPlaying) return;
    _isPlaying = true;
    _currentTickInBar = 0;
    _stopwatch
      ..reset()
      ..start();
    _nextTickTime = 0;
    _schedulerTimer = Timer.periodic(
      Duration(milliseconds: _lookaheadInterval.toInt()),
      (_) => _scheduler(),
    );
  }

  void stop() {
    _isPlaying = false;
    _schedulerTimer?.cancel();
    _stopwatch.stop();
  }

  void updateBpm(int bpm) {
    config = config.copyWith(bpm: bpm.clamp(20, 300));
  }

  void _scheduler() {
    final now = _stopwatch.elapsedMicroseconds / 1e6;
    while (_nextTickTime < now + _scheduleAheadTime) {
      _playTick(_currentTickInBar, _nextTickTime);
      _advanceTick();
    }
  }

  void _advanceTick() {
    final ticksPerBar = config.beatsPerBar * config.subdivision;

    // Swing: retrasa levemente los ticks "off-beat" en subdivisiones pares.
    double interval = config.tickDurationSeconds;
    final isOffBeatTick =
        config.subdivision > 1 && (_currentTickInBar % 2 == 1);
    if (isOffBeatTick && config.swing > 0) {
      interval *= (1 + config.swing);
    }

    _nextTickTime += interval;
    _currentTickInBar = (_currentTickInBar + 1) % ticksPerBar;
  }

  Future<void> _playTick(int tickIndex, double scheduledTime) async {
    final beatIndex = tickIndex ~/ config.subdivision;
    final isBeatStart = tickIndex % config.subdivision == 0;
    final isAccent = isBeatStart && config.accentedBeats.contains(beatIndex);

    // Nota: para timing sample-accurate en producción, reemplazar por
    // reproducción vía buffer de audio de bajo nivel (ej. SoLoud/FFI)
    // en vez de just_audio, que tiene latencia de plataforma variable.
    final player = isAccent ? _accentClick : _normalClick;
    unawaited(player.seek(Duration.zero).then((_) => player.play()));

    onTick?.call(tickIndex, isAccent);
  }

  /// Tap Tempo: alimentar con timestamps de cada tap del usuario,
  /// devuelve el BPM promedio de los últimos taps (ventana de 4).
  final List<DateTime> _taps = [];
  int? registerTap() {
    final now = DateTime.now();
    _taps.add(now);
    if (_taps.length > 4) _taps.removeAt(0);
    if (_taps.length < 2) return null;

    final intervals = <int>[];
    for (var i = 1; i < _taps.length; i++) {
      intervals.add(_taps[i].difference(_taps[i - 1]).inMilliseconds);
    }
    final avgMs = intervals.reduce((a, b) => a + b) / intervals.length;
    final bpm = (60000 / avgMs).round().clamp(20, 300);
    updateBpm(bpm);
    return bpm;
  }

  void dispose() {
    stop();
    _normalClick.dispose();
    _accentClick.dispose();
  }
}
