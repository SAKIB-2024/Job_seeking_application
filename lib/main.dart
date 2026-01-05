import 'package:flutter/material.dart';
import 'package:job_seeking_application/auth/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Supabase.initialize(
      url: 'https://zwqpxngbesmdmkreymla.supabase.co',
      anonKey:'sb_publishable_1zpu1DbADYdHJv-0DQzPag_RX58YZEI',
    );

    runApp(const MyApp());
}
class MyApp extends StatelessWidget {
    const MyApp({super.key});
    @override
    Widget build(BuildContext context) {
        return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: AuthGate(),
        );
    }
}
