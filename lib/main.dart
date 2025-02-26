import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
import 'package:window_size/window_size.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  Intl.defaultLocale = 'es';

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Reloj App');
    setWindowMinSize(const Size(600, 600));
    setWindowMaxSize(const Size(600, 600));
    setWindowFrame(const Rect.fromLTWH(0, 0, 600, 600));
  }

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  late String _timeString;
  late String _dateString;
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _animation = IntTween(begin: 0, end: 3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss a').format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    return "${DateFormat('EEEE').format(dateTime).capitalize()}, ${DateFormat('dd').format(dateTime)} de ${DateFormat('MMMM').format(dateTime).capitalize()}";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('es'), // Set the locale for the MaterialApp
      home: Scaffold(
        body: Container(
          color: const Color(0xFFC4EEF2),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _dateString,
                  style: const TextStyle(
                    fontSize: 48,
                    fontFamily: 'Comic Sans MS',
                    color: Color(0xFF1C1C1C),
                  ),
                ),
                Text(
                  _timeString,
                  style: const TextStyle(
                    fontSize: 48,
                    fontFamily: 'Comic Sans MS',
                    color: Color(0xFF1C1C1C),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Image.asset('assets/sprite_${_animation.value + 1}.png');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension StringExtensions on String { 
  String capitalize() { 
    return "${this[0].toUpperCase()}${this.substring(1)}"; 
  } 
}
