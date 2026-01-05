import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployerApplicantsPage extends StatelessWidget {
  const EmployerApplicantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final employerId = supabase.auth.currentUser!.id;

    return Scaffold(
      appBar: AppBar(title: const Text("Applicants")),
      body: FutureBuilder(
        future: supabase
            .from('applications')
            .select('''
              id,
              applied_at,
              jobs!inner (
                id,
                title,
                employer_id
              ),
              profiles!inner (
                id,
                name,
                email
              )
            ''')
            .eq('jobs.employer_id', employerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return const Center(child: Text("No applicants yet"));
          }

          final applications = snapshot.data as List;

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final app = applications[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(app['profiles']['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: ${app['profiles']['email']}"),
                      Text("Job: ${app['jobs']['title']}"),
                      Text("Application ID: ${app['id']}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
