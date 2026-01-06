import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchJobsPage extends StatefulWidget {
  const SearchJobsPage({super.key});

  @override
  State<SearchJobsPage> createState() => _SearchJobsPageState();
}

class _SearchJobsPageState extends State<SearchJobsPage> {
  final supabase = Supabase.instance.client;
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Jobs")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search job title / company",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => query = value);
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: supabase
                  .from('jobs')
                  .select()
                  .ilike('title', '%$query%'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final jobs = snapshot.data as List;

                if (jobs.isEmpty) {
                  return const Center(child: Text("No jobs found"));
                }

                return ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(job['title']),
                        subtitle: Text(job['company_name']),
                        trailing: ElevatedButton(
                          child: const Text("Apply"),
                          onPressed: () async {
                            try {
                              await supabase.from('applications').insert({
                                'job_id': job['id'],
                                'applicant_id':
                                    supabase.auth.currentUser!.id,
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Applied successfully")),
                              );
                            } catch (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Already applied for this job")),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
