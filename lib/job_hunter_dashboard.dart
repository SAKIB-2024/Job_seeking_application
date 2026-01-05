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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // This extends the background behind app bar
      appBar: AppBar(
        title: const Text(
          "Job Hunter Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove shadow
        iconTheme: const IconThemeData(
          color: Colors.white, // White icons for better visibility
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pic05.jpeg'), // Same background image
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Welcome Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.work_outline,
                        size: 70,
                        color: Color.fromARGB(255, 49, 67, 49),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Welcome, Job Seeker!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 49, 67, 49),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Find your dream job today",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Dashboard Cards Container
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _dashboardCard(
                              context,
                              "Search Jobs",
                              Icons.search,
                              const SearchJobsPage(),
                              "Browse and apply for new opportunities",
                            ),
                            const Divider(height: 0),
                            _dashboardCard(
                              context,
                              "Applied Jobs",
                              Icons.work,
                              const AppliedJobsPage(),
                              "Track your job applications",
                            ),
                            const Divider(height: 0),
                            _dashboardCard(
                              context,
                              "Profile",
                              Icons.person,
                              const JobProfilePage(),
                              "View and update your profile",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Quick Stats or Motivation Section (Optional)
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 49, 67, 49).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.yellow[300],
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Tip: Tailor your resume for each job application",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dashboardCard(BuildContext context, String title, IconData icon, Widget page, String subtitle) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 49, 67, 49).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color.fromARGB(255, 49, 67, 49),
            size: 28,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 49, 67, 49),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color.fromARGB(255, 49, 67, 49),
          size: 16,
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}