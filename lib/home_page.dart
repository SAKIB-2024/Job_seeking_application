import 'package:flutter/material.dart';
import 'package:job_seeking_application/dashboard.dart';
import 'package:job_seeking_application/auth/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Color.fromARGB(255, 49, 67, 49),),
            onPressed: () {
              Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_)=>const LoginPage())
              );
            },
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/quote01.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 40, 
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const Dashboard()
                      )
                    );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  backgroundColor: const Color.fromARGB(255, 38, 49, 36),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
