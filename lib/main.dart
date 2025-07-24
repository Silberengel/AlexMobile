import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/loading_screen_widget.dart';
import 'services/database_service.dart';
import 'services/network_service.dart';
import 'services/auth_service.dart';
import 'services/error_service.dart';

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
  String _initializationMessage = 'Initializing Alexandria Mobile...';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize database service
      _updateMessage('Initializing database...');
      final databaseService = DatabaseService();
      await databaseService.initialize();
      
      // Initialize network service
      _updateMessage('Initializing network monitoring...');
      final networkService = NetworkService();
      await networkService.initialize();
      
      // Initialize auth service
      _updateMessage('Initializing authentication...');
      final authService = AuthService();
      await authService.initialize();
      
      // Initialize error service
      _updateMessage('Initializing error handling...');
      final errorService = ErrorService();
      
      // Simulate additional initialization time for better UX
      _updateMessage('Loading Alexandria Mobile...');
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      // Handle initialization errors
      if (mounted) {
        setState(() {
          _initializationMessage = 'Initialization failed: $e';
        });
      }
    }
  }

  void _updateMessage(String message) {
    if (mounted) {
      setState(() {
        _initializationMessage = message;
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
        home: LoadingScreenWidget(
          message: _initializationMessage,
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
