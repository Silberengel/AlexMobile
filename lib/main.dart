import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/loading_screen_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for cross-platform storage
  await Hive.initFlutter();
  
  runApp(const ProviderScope(child: AlexandriaApp()));
}

class AlexandriaApp extends ConsumerStatefulWidget {
  const AlexandriaApp({super.key});

  @override
  ConsumerState<AlexandriaApp> createState() => _AlexandriaAppState();
}

class _AlexandriaAppState extends ConsumerState<AlexandriaApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate initialization time for better UX
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    
    if (!_isInitialized) {
      return MaterialApp(
        title: 'GitCitadel Alexandria',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: const LoadingScreenWidget(
          message: 'Loading Alexandria Mobile...',
          showLogo: true,
          showProgress: true,
        ),
        debugShowCheckedModeBanner: false,
      );
    }
    
    return MaterialApp(
      title: 'GitCitadel Alexandria',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
