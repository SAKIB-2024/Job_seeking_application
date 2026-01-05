import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase import
import 'employer_jobs_page.dart';
import 'employer_applicants_page.dart';
import 'publish_job_page.dart';
import 'auth/login_page.dart'; // make sure you have your login page

class EmployerDashboard extends StatelessWidget {
  const EmployerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employer Dashboard"),
        backgroundColor: const Color.fromARGB(255, 38, 49, 36),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                // Supabase logout
                await Supabase.instance.client.auth.signOut();

                // Navigate to login screen and remove all previous routes
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dashboardCard(context, "Your Jobs", Icons.work, const EmployerJobsPage()),
            _dashboardCard(context, "Applicants", Icons.people, const EmployerApplicantsPage()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 49, 67, 49),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PublishJobPage()),
          );
        },
      ),
    );
  }

  Widget _dashboardCard(BuildContext context, String title, IconData icon, Widget page) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 49, 67, 49), size: 28),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}
