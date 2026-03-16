import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate/firebase_provider.dart';
import 'package:taskmate/login.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Container(
                width: 140, height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: surfaceColor,
                  border: Border.all(color: surfaceColor, width: 4),
                  boxShadow: [
                    BoxShadow(color: Colors.blue.withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 10)),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset("assets/images/person.jpg", fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 30),

              Consumer<FirebaseProvider>(
                builder: (context, value, child) {
                  if (value.isLoading) return const CircularProgressIndicator();

                  return Column(
                    children: [
                      Text(
                        value.name ?? "TaskMate User",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        value.email ?? "No email provided",
                        style: TextStyle(fontSize: 15, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),

              if (uid != null)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('tasks').where('uid', isEqualTo: uid).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox(height: 80);

                    int completed = 0;
                    int pending = 0;

                    for (var doc in snapshot.data!.docs) {
                      if (doc['isCompleted'] == true) {
                        completed++;
                      } else {
                        pending++;
                      }
                    }

                    return Row(
                      children: [
                        _buildStatCard("Pending", pending, Colors.orange.shade400, surfaceColor, context),
                        const SizedBox(width: 16),
                        _buildStatCard("Completed", completed, Colors.green.shade500, surfaceColor, context),
                      ],
                    );
                  },
                ),

              const SizedBox(height: 40),

              _buildActionTile(
                title: "Sign Out",
                icon: Icons.logout_rounded,
                isDestructive: true,
                surfaceColor: surfaceColor,
                context: context,
                onTap: () {
                  FirebaseAuth.instance.signOut().then((_) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                      (Route<dynamic> route) => false,
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color, Color surfaceColor, BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black87 : Colors.grey.shade300,
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String title, required IconData icon, required VoidCallback onTap,
    required Color surfaceColor, required BuildContext context, bool isDestructive = false,
  }) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red.withOpacity(0.05) : surfaceColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDestructive 
                  ? Colors.red.withOpacity(0.3) 
                  : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDestructive ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: isDestructive ? Colors.red : Colors.blue.shade700, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDestructive ? Colors.red : Colors.grey.shade500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}