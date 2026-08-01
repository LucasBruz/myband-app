import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';

class JoinBandScreen extends StatefulWidget {
  const JoinBandScreen({super.key});

  @override
  State<JoinBandScreen> createState() => _JoinBandScreenState();
}

class _JoinBandScreenState extends State<JoinBandScreen> {
  static const _codeLength = 6;
  final List<TextEditingController> _controllers =
      List.generate(_codeLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(_codeLength, (_) => FocusNode());
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code =>
      _controllers.map((c) => c.text.trim().toUpperCase()).join();

  Future<void> _joinBand() async {
    if (_code.length < _codeLength) {
      setState(() => _errorMessage = 'Completá el código de 6 caracteres');
      return;
    }
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final query = await FirebaseFirestore.instance
          .collection('bands')
          .where('inviteCode', isEqualTo: _code)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        setState(() => _errorMessage = 'No encontramos ninguna banda con ese código');
        return;
      }

      final bandRef = query.docs.first.reference;
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await bandRef.collection('members').doc(uid).set({
        'role': 'musician',
        'joinedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      setState(() => _errorMessage = 'Ocurrió un error. Probá de nuevo.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ScreenHeadline('Código de', highlight: 'invitación'),
              const SizedBox(height: 8),
              const Text(
                'Pedíselo al administrador de tu banda',
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_codeLength, (i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 40,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(color: AppColors.text, fontSize: 16),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && i < _codeLength - 1) {
                          _focusNodes[i + 1].requestFocus();
                        } else if (value.isEmpty && i > 0) {
                          _focusNodes[i - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Color(0xFFE24B4A), fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loading ? null : _joinBand,
                child: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.onLime),
                      )
                    : const Text('UNIRME'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
