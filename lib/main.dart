import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:path_provider/path_provider.dart';
import 'models/nostr_event.dart';
import 'providers/app_providers.dart';
import 'screens/home_screen.dart';
import 'theme/zapchat_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Isar
  final dir = await getApplicationDocumentsDirectory();
  await Isar.open(
    [NostrEventSchema],
    directory: dir.path,
  );
  
  runApp(const ProviderScope(child: AlexReaderApp()));
}

class AlexReaderApp extends ConsumerWidget {
  const AlexReaderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInitializer = ref.watch(appInitializerProvider);
    
    return MaterialApp(
      title: 'Alex Reader',
      theme: ZapchatTheme.lightTheme,
      darkTheme: ZapchatTheme.darkTheme,
      home: appInitializer.when(
        data: (_) => const HomeScreen(),
        loading: () => const SplashScreen(),
        error: (error, stack) => ErrorScreen(error: error.toString()),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon with Zapchat design
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ZapchatTheme.primaryPurple,
                    ZapchatTheme.secondaryPurple,
                  ],
                ),
                borderRadius: BorderRadius.circular(ZapchatTheme.radius24),
                boxShadow: ZapchatTheme.shadowLarge,
              ),
              child: const Icon(
                Icons.library_books,
                size: 50,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: ZapchatTheme.spacing32),
            
            // App title
            Text(
              'Alex Reader',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: ZapchatTheme.primaryPurple,
              ),
            ),
            
            const SizedBox(height: ZapchatTheme.spacing8),
            
            Text(
              'Nostr E-Reader',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ZapchatTheme.textSecondary,
              ),
            ),
            
            const SizedBox(height: ZapchatTheme.spacing48),
            
            // Loading indicator with Zapchat colors
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(
                  ZapchatTheme.primaryPurple,
                ),
                strokeWidth: 3,
              ),
            ),
            
            const SizedBox(height: ZapchatTheme.spacing24),
            
            Text(
              'Initializing...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ZapchatTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String error;
  
  const ErrorScreen({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Failed to initialize app',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              Text(
                error,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: () {
                  // Restart app
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 