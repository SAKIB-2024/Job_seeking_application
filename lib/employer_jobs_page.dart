import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'publish_job_page.dart';

class EmployerJobsPage extends StatelessWidget {
  const EmployerJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser!.id;

    return Scaffold(
      appBar: AppBar(title: const Text("Your Jobs")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PublishJobPage()),
        ),
      ),
      body: FutureBuilder(
        future: supabase
            .from('jobs')
            .select()
            .eq('employer_id', userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final jobs = snapshot.data as List;

          if (jobs.isEmpty) {
            return const Center(child: Text("No jobs posted"));
          }

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (_, i) {
              final job = jobs[i];
              return Card(
                child: ListTile(
                  title: Text(job['title']),
                  subtitle: Text(job['company_name']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
