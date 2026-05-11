import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../features/notes/presentation/notes_controller.dart';
import '../home/home_shell.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sigilScale;
  late Animation<double> _sigilOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _glowIntensity;
  late Animation<double> _breathAnimation;

  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // 1. Impatto: Scale down leggero (da 1.15 a 1.0) e fade in
    _sigilScale = Tween<double>(begin: 1.15, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );
    _sigilOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // 2. Attivazione: Glow e testo
    _glowIntensity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
      ),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
      ),
    );

    // 3. Respiro: Pulsazione infinita dopo il secondo 0.8
    _breathAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Avvio dell'animazione
    _controller.forward();

    // Ascolta lo stato dell'animazione per far partire il respiro
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat(reverse: true, period: const Duration(milliseconds: 1000));
      }
    });

    // Controllo periodico per la navigazione
    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    // Aspetta almeno 1.5 secondi per l'effetto wow
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (!mounted) return;

    // Controlla se i dati sono stati caricati
    final notesController = Provider.of<NotesController>(context, listen: false);
    
    if (!notesController.isLoading) {
      _navigateToHome();
    } else {
      // Se sta ancora caricando, riprova tra 200ms
      _waitForLoading(notesController);
    }
  }

  void _waitForLoading(NotesController controller) {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      if (!controller.isLoading) {
        _navigateToHome();
      } else {
        _waitForLoading(controller);
      }
    });
  }

  void _navigateToHome() {
    if (_isNavigating) return;
    _isNavigating = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeShell(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sigillo e Icona
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Se l'animazione è completata e sta ripetendo (respiro),
                // usiamo il valore di respiro, altrimenti il valore di ingresso.
                final glowVal = _controller.status == AnimationStatus.reverse || 
                                (_controller.status == AnimationStatus.forward && _controller.value > 0.8)
                    ? 0.7 + (0.3 * (1.0 - (_controller.value - 0.8) / 0.2)) // Simulo un respiro se non uso una seconda animation
                    : _glowIntensity.value;

                return Opacity(
                  opacity: _sigilOpacity.value,
                  child: Transform.scale(
                    scale: _sigilScale.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.magicAccent.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.magicAccent.withValues(alpha: glowVal * 0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          color: AppColors.magicAccent,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            // Testo D&D Companion
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final tracking = 4.0 + (1.0 - _textOpacity.value) * 10;
                return Opacity(
                  opacity: _textOpacity.value,
                  child: Text(
                    'D&D COMPANION',
                    style: AppTypography.h2.copyWith(
                      letterSpacing: tracking,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
