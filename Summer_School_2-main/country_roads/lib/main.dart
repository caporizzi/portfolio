import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/geoloc_provider.dart';
import 'package:task_manager/providers/transport_data_provider.dart';
import 'package:task_manager/providers/user_profile_provider.dart';
import 'package:task_manager/providers/weather_provider.dart';
import 'package:task_manager/utils/theme.dart';
import 'package:task_manager/views/welcome_page.dart';
import 'providers/auth_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<UserProfileProvider>(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider<GeolocProvider>(create: (_) => GeolocProvider()),
        ChangeNotifierProvider<WeatherProvider>(create: (_) => WeatherProvider()),
        ChangeNotifierProvider<TransportDataProvider>(create: (_) => TransportDataProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'Country Roads',
            theme: buildThemeData(),
            home: WelcomePage(),
          );
        },
      ),
    );
  }
}
