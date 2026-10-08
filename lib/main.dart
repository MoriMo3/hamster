import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const OmikujiApp());

class OmikujiApp extends StatelessWidget {
  const OmikujiApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'おみくじ',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB3261E)),
      useMaterial3: true,
    ),
    home: const OmikujiPage(),
  );
}

class OmikujiPage extends StatefulWidget {
  const OmikujiPage({super.key});

  @override
  State<OmikujiPage> createState() => _OmikujiPageState();
}

class _OmikujiPageState extends State<OmikujiPage> {
  int n = 0, e = 0, colorIndex = 0;
  bool loading = false;
  final emojis = ['⛩️', '👼', '🙏', '✨'];
  final backgroundColors = [
    const Color(0xFF0000FF),
    const Color(0xFF00FFFF),
    const Color(0xFFFF0000),
    const Color(0xFF00FF00),
    const Color(0xFFFFFF00),
  ];

  // web/images に置いたおみくじ画像を表示します。
  final images = [
    'images/omikuji-daikichi.png',
    'images/omikuji-chukichi.png',
    'images/omikuji-kichi.png',
    'images/omikuji-shokichi.png',
    'images/omikuji-kyo.png',
    'images/omikuji-daikyo.png',
    'images/omikuji-suekyo.png',
  ];

  Future<void> drawOmikuji() async {
    setState(() {
      loading = true;
      e = 0;
      colorIndex = 0;
    });

    for (int i = 0; i < 14; i++) {
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return;
      setState(() {
        e = (e + 1) % emojis.length;
        colorIndex = (colorIndex + 1) % backgroundColors.length;
      });
    }

    if (!mounted) return;
    setState(() {
      n = Random().nextInt(images.length);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('⛩️ おみくじ'),
      centerTitle: true,
      backgroundColor: const Color(0xFFB3261E),
      foregroundColor: Colors.white,
    ),
    body: AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeInOut,
      color: loading ? backgroundColors[colorIndex] : const Color(0xFFFFF8EE),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                loading ? '運勢を占っています…' : '今日の運勢は？',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF6F1D1B),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: 300,
                height: 480,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFB3261E), width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: loading
                    ? Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 100),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(
                                scale: animation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              ),
                          child: Text(
                            emojis[e],
                            key: ValueKey(e),
                            style: const TextStyle(fontSize: 108),
                          ),
                        ),
                      )
                    : Image.network(
                        images[n],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Text(
                                '🌸',
                                style: TextStyle(fontSize: 100),
                              ),
                            ),
                      ),
              ),
              const SizedBox(height: 24),
              const Text(' ⛩️ ', style: TextStyle(fontSize: 42)),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: loading ? null : drawOmikuji,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFB3261E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 18,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: const Text('🔔', style: TextStyle(fontSize: 22)),
                label: Text(loading ? '占い中…' : 'おみくじを引く'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
