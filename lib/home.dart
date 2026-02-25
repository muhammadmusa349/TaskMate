import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskmate/UIhelper.dart';
import 'package:taskmate/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showCompletedOnly = false;

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    Query taskQuery = FirebaseFirestore.instance
        .collection("tasks")
        .where("uid", isEqualTo: uid);

    if (showCompletedOnly) {
      taskQuery = taskQuery.where("isCompleted", isEqualTo: true);
    }

    return Scaffold(
      backgroundColor: Colors.blue.shade50,

      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Profile()));
            },
            icon: const Icon(Icons.person_pin, color: Colors.white, size: 35),
          )
        ],
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                filterCard(
                  title: "ALL",
                  isSelected: !showCompletedOnly,
                  onTap: () {
                    setState(() => showCompletedOnly = false);
                  },
                ),
                const SizedBox(width: 12),
                filterCard(
                  title: "COMPLETED",
                  isSelected: showCompletedOnly,
                  onTap: () {
                    setState(() => showCompletedOnly = true);
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: taskQuery.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No tasks found",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  );
                }

                final tasks = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return taskCard(tasks[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade400,
        foregroundColor: Colors.white,
        onPressed: () {
          showAddTaskBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget filterCard({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: isSelected ? 4 : 1,
          color: isSelected ? Colors.blue : Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget taskCard(QueryDocumentSnapshot task) {
    Color priorityColor = task["priority"] == "High"
        ? Colors.red
        : task["priority"] == "Medium"
            ? Colors.orange
            : Colors.green;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [

            Checkbox(
              value: task["isCompleted"],
              onChanged: (value) {
                FirebaseFirestore.instance
                    .collection("tasks")
                    .doc(task.id)
                    .update({"isCompleted": value});
              },
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task["title"],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: task["isCompleted"]
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task["desc"],
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${task["priority"]} Priority",
                      style: TextStyle(
                        fontSize: 12,
                        color: priorityColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("tasks")
                    .doc(task.id)
                    .delete();
              },
            ),
          ],
        ),
      ),
    );
  }

  void showAddTaskBottomSheet(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String selectedPriority = "Low";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const Text(
                    "Add New Task",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Task Title",
                      prefixIcon: const Icon(Icons.task_alt),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: descController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Description",
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: selectedPriority,
                    items: const [
                      DropdownMenuItem(value: "Low", child: Text("Low Priority")),
                      DropdownMenuItem(
                          value: "Medium", child: Text("Medium Priority")),
                      DropdownMenuItem(
                          value: "High", child: Text("High Priority")),
                    ],
                    onChanged: (value) {
                      setModalState(() => selectedPriority = value!);
                    },
                    decoration: InputDecoration(
                      labelText: "Priority",
                      prefixIcon: const Icon(Icons.flag),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  UIhelper.custombutton(() async {
                    final String title = titleController.text.trim();
                    if (title.isEmpty) return;

                    final String taskId =
                        "${title}_${DateTime.now().millisecondsSinceEpoch}";

                    await FirebaseFirestore.instance
                        .collection("tasks")
                        .doc(taskId)
                        .set({
                      "uid": uid,
                      "title": title,
                      "desc": descController.text.trim(),
                      "priority": selectedPriority,
                      "isCompleted": false,
                      "createdAt": Timestamp.now(),
                    });

                    Navigator.pop(context);
                  }, "Add Task"),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
