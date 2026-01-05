import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'employer_dashboard.dart';
import 'job_hunter_dashboard.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("JobConnect")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: const Text("Job Hunter"),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const JobHunterDashboard())),
          ),
          ElevatedButton(
            child: const Text("Employer"),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const EmployerDashboard())),
          ),
          ElevatedButton(
            child: const Text("Admin"),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AdminDashboard())),
          ),
        ],
      ),
    );
  }
}
