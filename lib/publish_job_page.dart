import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PublishJobPage extends StatefulWidget {
  const PublishJobPage({super.key});

  @override
  State<PublishJobPage> createState() => _PublishJobPageState();
}

class _PublishJobPageState extends State<PublishJobPage> {
  final supabase = Supabase.instance.client;
  final _company = TextEditingController();
  final _title = TextEditingController();
  final _desc = TextEditingController();

  Future<void> publish() async {
    final employerId = supabase.auth.currentUser?.id;

    if (employerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You are not logged in")),
      );
      return;
    }

    // if employer exists in profiles
    final profile = await supabase
        .from('profiles')
        .select('id')
        .eq('id', employerId)
        .maybeSingle();

    if (profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your profile is missing!")),
      );
      return;
    }

    // Insertion of job 
    final title = _title.text.trim();
    final company = _company.text.trim();
    final desc = _desc.text.trim();

    if (title.isEmpty || company.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    await supabase.from('jobs').insert({
      'employer_id': employerId,
      'company_name': company,
      'title': title,
      'description': desc,
    });

    Navigator.pop(context); // back to employer dashboard
  }

  @override
  Widget build(BuildContext context) {
    print("Current user ID: ${Supabase.instance.client.auth.currentUser?.id}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Publish Job"),
        backgroundColor: const Color.fromARGB(255, 38, 49, 36),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _company,
              decoration: const InputDecoration(labelText: "Company Name"),
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: "Job Title"),
            ),
            TextField(
              controller: _desc,
              decoration: const InputDecoration(labelText: "Job Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: publish,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 49, 67, 49),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Publish"),
            ),
          ],
        ),
      ),
    );
  }
}
