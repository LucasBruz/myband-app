import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../metronome_engine.dart';

class MetronomeScreen extends StatefulWidget {
  final String songTitle;
  final int initialBpm;

  const MetronomeScreen({
    super.key,
    this.songTitle = 'Metrónomo libre',
    this.initialBpm = 120,
  });

  @override
  State<MetronomeScreen> createState() => _MetronomeScreenState();
}

class _MetronomeScreenState extends State<MetronomeScreen> {
  late final MetronomeEngine _engine;
  int _currentBeat = 0;
  bool _isPlaying = false;
  int _timeSignatureIndex = 0;
  static const timeSignatures = [4, 3, 6]; // simplificado: 4/4, 3/4, 6/8

  @override
  void initState() {
    super.initState();
    _engine = MetronomeEngine(
      config: MetronomeConfig(bpm: widget.initialBpm, beatsPerBar: 4),
    );
    _engine.onTick = (tickIndex, isAccent) {
      if (!mounted) return;
      setState(() => _currentBeat = tickIndex % _engine.config.beatsPerBar);
    };
    // TODO: await _engine.loadSounds() con los assets reales antes de
    // permitir play, y manejar el estado de carga.
  }

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying ? _engine.start() : _engine.stop();
    });
  }

  void _changeBpm(int delta) {
    setState(() => _engine.updateBpm(_engine.config.bpm + delta));
  }

  void _onTap() {
    final bpm = _engine.registerTap();
    if (bpm != null) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bpm = _engine.config.bpm;
    return Scaffold(
      backgroundColor: const Color(0xFF101012),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.chevron_left, color: AppColors.text),
                  ),
                  Text(
                    widget.songTitle.toUpperCase(),
                    style: const TextStyle(color: AppColors.muted, fontSize: 11),
                  ),
                  IconButton(
                    onPressed: () => setState(
                        () => _engine.updateBpm(widget.initialBpm)),
                    icon: const Icon(Icons.restart_alt,
                        color: AppColors.muted, size: 18),
                  ),
                ],
              ),

              // Indicador visual de pulso — se resalta en tiempo real con
              // cada tick que emite el engine (onTick callback).
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_engine.config.beatsPerBar, (i) {
                  final active = _isPlaying && _currentBeat == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 80),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: active ? AppColors.lime : const Color(0xFF3A3B40),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),

              Column(
                children: [
                  Text(
                    '$bpm',
                    style: const TextStyle(
                        fontFamily: 'Anton',
                        fontSize: 72,
                        height: 1,
                        color: AppColors.text),
                  ),
                  const Text('BPM',
                      style: TextStyle(color: AppColors.muted, fontSize: 12)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _RoundIconButton(
                          icon: Icons.remove, onTap: () => _changeBpm(-1)),
                      SizedBox(
                        width: 140,
                        child: Slider(
                          value: bpm.toDouble(),
                          min: 20,
                          max: 300,
                          activeColor: AppColors.lime,
                          inactiveColor: AppColors.border,
                          onChanged: (v) =>
                              setState(() => _engine.updateBpm(v.round())),
                        ),
                      ),
                      _RoundIconButton(
                          icon: Icons.add, onTap: () => _changeBpm(1)),
                    ],
                  ),
                ],
              ),

              // Compás — cambia beatsPerBar del engine.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(timeSignatures.length, (i) {
                  final active = i == _timeSignatureIndex;
                  final label = ['4/4', '3/4', '6/8'][i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: active,
                      onSelected: (_) {
                        setState(() {
                          _timeSignatureIndex = i;
                          _engine.config = _engine.config
                              .copyWith(beatsPerBar: timeSignatures[i]);
                        });
                      },
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: active ? AppColors.onLime : AppColors.muted,
                      ),
                      selectedColor: AppColors.lime,
                      backgroundColor: Colors.transparent,
                      side: BorderSide(
                          color: active ? AppColors.lime : AppColors.border),
                    ),
                  );
                }),
              ),

              // Play + accesos a sonido/vibración (TODO: hookear a settings).
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      _RoundIconButton(icon: Icons.volume_up_outlined, onTap: () {}),
                      const SizedBox(height: 4),
                      const Text('SONIDO',
                          style: TextStyle(color: AppColors.muted, fontSize: 9)),
                    ],
                  ),
                  const SizedBox(width: 24),
                  GestureDetector(
                    onTap: _toggle,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                          color: AppColors.lime, shape: BoxShape.circle),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppColors.onLime,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Column(
                    children: [
                      _RoundIconButton(icon: Icons.vibration, onTap: () {}),
                      const SizedBox(height: 4),
                      const Text('VIBRAR',
                          style: TextStyle(color: AppColors.muted, fontSize: 9)),
                    ],
                  ),
                ],
              ),

              TextButton(
                onPressed: _onTap,
                child: const Text('TAP TEMPO',
                    style: TextStyle(color: AppColors.lime, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.card,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.text, size: 18),
      ),
    );
  }
}
