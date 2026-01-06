import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppliedJobsPage extends StatelessWidget {
  const AppliedJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser!.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Applied Jobs')),
      body: FutureBuilder(
        future: supabase
            .from('applications')
            .select('''
              id,
              status,
              applied_at,
              jobs (
                id,
                title,
                company_name,
                location,
                job_type
              )
            ''')
            .eq('applicant_id', userId)
            .order('applied_at', ascending: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return const Center(
              child: Text(
                'No applications yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final applications = snapshot.data as List;

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final app = applications[index];
              final job = app['jobs'];

              Color statusColor = Colors.grey;
              switch (app['status']) {
                case 'Pending':
                  statusColor = Colors.orange;
                  break;
                case 'Reviewed':
                  statusColor = Colors.blue;
                  break;
                case 'Accepted':
                  statusColor = Colors.green;
                  break;
                case 'Rejected':
                  statusColor = Colors.red;
                  break;
              }

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: statusColor.withOpacity(0.2),
                    child: Icon(
                      _getStatusIcon(app['status']),
                      color: statusColor,
                    ),
                  ),
                  title: Text(job['title'] ?? 'No Title'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job['company_name'] ?? 'Unknown Company'),
                      Text('${job['location'] ?? 'Remote'} • ${job['job_type'] ?? 'Full-time'}'),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              app['status'],
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Text(
                    _formatDate(app['applied_at']),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pending':
        return Icons.hourglass_empty;
      case 'Reviewed':
        return Icons.remove_red_eye;
      case 'Accepted':
        return Icons.check_circle;
      case 'Rejected':
        return Icons.cancel;
      default:
        return Icons.question_mark;
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.tryParse(dateString);
    if (date == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return 'Just now';
    }
  }
}