// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'constants/app_constants.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'ui/screens/auth/login_screen.dart';
import 'ui/screens/auth/register_screen.dart';
import 'ui/screens/customer/home_screen.dart';
import 'ui/screens/admin/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ApiService().initialize();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppConstants.backgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const RedCapApp());
}

class RedCapApp extends StatelessWidget {
  const RedCapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/admin': (context) => const AdminDashboardScreen(),
        },
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: Colors.red,
      primaryColor: AppConstants.primaryColor,
      scaffoldBackgroundColor: AppConstants.backgroundColor,
      fontFamily: 'Poppins',

      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: AppConstants.secondaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.secondaryColor,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppConstants.secondaryColor,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: AppConstants.textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // ✅ Fixed: CardTheme → CardThemeData
      cardTheme: CardThemeData(
        color: AppConstants.secondaryColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: AppConstants.margin,
          vertical: AppConstants.smallMargin,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: AppConstants.secondaryColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          side: const BorderSide(color: AppConstants.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.secondaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(
            color: AppConstants.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide(color: AppConstants.errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.padding,
          vertical: AppConstants.smallPadding,
        ),
        hintStyle: const TextStyle(color: AppConstants.textSecondaryColor),
      ),

      textTheme: const TextTheme(
        displayLarge: AppConstants.headingStyle,
        displayMedium: AppConstants.subheadingStyle,
        bodyLarge: AppConstants.bodyStyle,
        bodyMedium: AppConstants.captionStyle,
      ),

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppConstants.primaryColor,
        secondary: AppConstants.accentColor,
        surface: AppConstants.secondaryColor,
        error: AppConstants.errorColor,
        onPrimary: AppConstants.secondaryColor,
        onSecondary: AppConstants.secondaryColor,
        onSurface: AppConstants.textPrimaryColor,
        onError: AppConstants.secondaryColor,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: AppConstants.secondaryColor,
        elevation: 4,
      ),

      dividerTheme: const DividerThemeData(
        color: Colors.grey,
        thickness: 1,
        space: 1,
      ),

      // ✅ Fixed: ChipTheme → ChipThemeData
      chipTheme: ChipThemeData(
        backgroundColor: AppConstants.secondaryColor,
        selectedColor: AppConstants.primaryColor,
        labelStyle: const TextStyle(color: AppConstants.textPrimaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
        ),
      ),

      // ✅ Fixed: DialogTheme → DialogThemeData
      dialogTheme: DialogThemeData(
        backgroundColor: AppConstants.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        titleTextStyle: AppConstants.headingStyle,
        contentTextStyle: AppConstants.bodyStyle,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppConstants.textPrimaryColor,
        contentTextStyle: const TextStyle(color: AppConstants.secondaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppConstants.primaryColor,
        linearTrackColor: Colors.grey,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    await Future.delayed(const Duration(seconds: 3));

    await authService.initialize();

    if (mounted) {
      if (authService.isAuthenticated) {
        if (authService.isAdmin) {
          Navigator.of(context).pushReplacementNamed('/admin');
        } else {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  AppConstants.appLogo,
                  width: 200,
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/redcap_logo.png',
                      width: 200,
                      height: 80,
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.secondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.appDescription,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppConstants.secondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppConstants.secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}