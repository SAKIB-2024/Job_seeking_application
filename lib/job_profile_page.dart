import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JobProfilePage extends StatefulWidget {
  const JobProfilePage({super.key});

  @override
  State<JobProfilePage> createState() => _JobProfilePageState();
}

class _JobProfilePageState extends State<JobProfilePage> {
  final supabase = Supabase.instance.client;

  final _bio = TextEditingController();
  final _skills = TextEditingController();
  final _portfolio = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userId = supabase.auth.currentUser!.id;

    final data = await supabase
        .from('job_profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (data != null) {
      _bio.text = data['bio'] ?? '';
      _skills.text = data['skills'] ?? '';
      _portfolio.text = data['portfolio_url'] ?? '';
    }

    setState(() => loading = false);
  }

  Future<void> saveProfile() async {
    final userId = supabase.auth.currentUser!.id;

    await supabase.from('job_profiles').upsert({
      'user_id': userId,
      'bio': _bio.text.trim(),
      'skills': _skills.text.trim(),
      'portfolio_url': _portfolio.text.trim(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated")),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Your Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _bio,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Bio",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _skills,
              decoration: const InputDecoration(
                labelText: "Skills (comma separated)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _portfolio,
              decoration: const InputDecoration(
                labelText: "Portfolio URL",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveProfile,
              child: const Text("Save Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
