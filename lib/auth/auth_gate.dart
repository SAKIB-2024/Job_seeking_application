import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home_page.dart';
import '../employer_dashboard.dart';
import '../job_hunter_dashboard.dart';
import '../admin_dashboard.dart';
import 'login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data?.session;
        
        if (session != null) {
          final user = session.user;
          final role = user.userMetadata?['role'] as String?;

          // If role not in metadata, fetch from profiles table
          if (role == null) {
            return FutureBuilder(
              future: _fetchUserRole(user.id),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                
                final fetchedRole = roleSnapshot.data as String? ?? 'Job Seeker';
                
                return _getDashboardForRole(fetchedRole);
              },
            );
          }
          
          return _getDashboardForRole(role);
        } else {
          return const LoginPage();
        }
      },
    );
  }

  Future<String?> _fetchUserRole(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .single();
      
      return response['role'] as String?;
    } catch (e) {
      return null;
    }
  }

  Widget _getDashboardForRole(String role) {
    switch (role) {
      case 'Job Seeker':
        return const JobHunterDashboard();
      case 'Employer':
        return const EmployerDashboard();
      case 'Admin':
        return const AdminDashboard();
      default:
        return const HomePage();
    }
  }
}