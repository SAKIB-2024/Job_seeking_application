import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'search_jobs_page.dart';
import 'applied_jobs_page.dart';
import 'job_profile_page.dart';
import 'auth/login_page.dart';

class JobHunterDashboard extends StatelessWidget {
  const JobHunterDashboard({super.key});

  Future<void> _logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Job Hunter Dashboard"), backgroundColor: const Color.fromARGB(255, 49, 67, 49)),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dashboardCard(context, "Search Jobs", Icons.search, const SearchJobsPage()),
                  _dashboardCard(context, "Applied Jobs", Icons.work, const AppliedJobsPage()),
                  _dashboardCard(context, "Profile", Icons.person, const JobProfilePage()),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout, color: Color.fromARGB(255, 232, 240, 232)),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 49, 67, 49),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashboardCard(BuildContext context, String title, IconData icon, Widget page) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        leading: Icon(icon, size: 28, color: const Color.fromARGB(255, 49, 67, 49)),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}
