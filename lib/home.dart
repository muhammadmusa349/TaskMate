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

    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "My Tasks",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: textColor,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const Profile()));
              },
              icon: Icon(Icons.account_circle, color: Colors.blue.shade600, size: 36),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                filterCard(
                  title: "All Tasks",
                  isSelected: !showCompletedOnly,
                  onTap: () => setState(() => showCompletedOnly = false),
                ),
                const SizedBox(width: 12),
                filterCard(
                  title: "Completed",
                  isSelected: showCompletedOnly,
                  onTap: () => setState(() => showCompletedOnly = true),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: taskQuery.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const SizedBox();
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          "No tasks yet",
                          style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }

                final tasks = snapshot.data!.docs;

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return taskCard(tasks[index], context);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => showTaskBottomSheet(context),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget filterCard({required String title, required bool isSelected, required VoidCallback onTap}) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade600 : surfaceColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? Colors.transparent : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget taskCard(QueryDocumentSnapshot task, BuildContext context) {
    Color priorityColor = task["priority"] == "High"
        ? Colors.red.shade400
        : task["priority"] == "Medium" ? Colors.orange.shade400 : Colors.green.shade400;

    final surfaceColor = Theme.of(context).colorScheme.surface;
    final textColor = Theme.of(context).colorScheme.onSurface;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    String? dueDateStr;
    if ((task.data() as Map).containsKey('dueDate') && task['dueDate'] != null) {
      DateTime date = (task['dueDate'] as Timestamp).toDate();
      dueDateStr = "${date.day}/${date.month}/${date.year}";
    }

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 32),
      ),
      onDismissed: (direction) {
        FirebaseFirestore.instance.collection("tasks").doc(task.id).delete();
      },
      child: GestureDetector(
        onTap: () => showTaskBottomSheet(context, existingTask: task),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(15), // Clear rounded corners
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300, // Visible border
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black87 : Colors.grey.shade300, // Strong shadow
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Transform.scale(
                  scale: 1.1,
                  child: Checkbox(
                    value: task["isCompleted"],
                    activeColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    side: BorderSide(color: Colors.grey.shade400, width: 1.5),
                    onChanged: (value) {
                      FirebaseFirestore.instance.collection("tasks").doc(task.id).update({"isCompleted": value});
                    },
                  ),
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
                          fontWeight: FontWeight.w600,
                          color: task["isCompleted"] ? Colors.grey : textColor,
                          decoration: task["isCompleted"] ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        task["desc"],
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade500, height: 1.4),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${task["priority"]}",
                              style: TextStyle(fontSize: 12, color: priorityColor, fontWeight: FontWeight.w600),
                            ),
                          ),
                          if (dueDateStr != null) ...[
                            const SizedBox(width: 12),
                            Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(
                              dueDateStr,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                            ),
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showTaskBottomSheet(BuildContext context, {QueryDocumentSnapshot? existingTask}) {
    final isEditing = existingTask != null;
    
    final titleController = TextEditingController(text: isEditing ? existingTask["title"] : "");
    final descController = TextEditingController(text: isEditing ? existingTask["desc"] : "");
    String selectedPriority = isEditing ? existingTask["priority"] : "Low";
    
    DateTime? selectedDate;
    if (isEditing && (existingTask.data() as Map).containsKey('dueDate') && existingTask['dueDate'] != null) {
      selectedDate = (existingTask['dueDate'] as Timestamp).toDate();
    }

    final surfaceColor = Theme.of(context).colorScheme.surface;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final inputColor = Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade100;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48, height: 5, margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  Text(
                    isEditing ? "Edit Task" : "Create New Task",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: titleController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: "Task Title",
                      filled: true, fillColor: inputColor,
                      prefixIcon: Icon(Icons.title, color: Colors.grey.shade500),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descController,
                    maxLines: 3,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: "Description",
                      filled: true, fillColor: inputColor,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Icon(Icons.description_outlined, color: Colors.grey.shade500),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedPriority,
                          dropdownColor: surfaceColor,
                          style: TextStyle(color: textColor),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          items: const [
                            DropdownMenuItem(value: "Low", child: Text("Low")),
                            DropdownMenuItem(value: "Medium", child: Text("Medium")),
                            DropdownMenuItem(value: "High", child: Text("High")),
                          ],
                          onChanged: (value) => setModalState(() => selectedPriority = value!),
                          decoration: InputDecoration(
                            filled: true, fillColor: inputColor,
                            prefixIcon: Icon(Icons.flag_outlined, color: Colors.grey.shade500),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setModalState(() => selectedDate = picked);
                            }
                          },
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(color: inputColor, borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_month_rounded, color: Colors.grey.shade500, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  selectedDate == null ? "Set Date" : "${selectedDate!.day}/${selectedDate!.month}",
                                  style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: UIhelper.custombutton(() async {
                      final String title = titleController.text.trim();
                      if (title.isEmpty) return;

                      final taskData = {
                        "uid": uid,
                        "title": title,
                        "desc": descController.text.trim(),
                        "priority": selectedPriority,
                        "dueDate": selectedDate != null ? Timestamp.fromDate(selectedDate!) : null,
                      };

                      if (isEditing) {
                        await FirebaseFirestore.instance.collection("tasks").doc(existingTask.id).update(taskData);
                      } else {
                        taskData["isCompleted"] = false;
                        taskData["createdAt"] = Timestamp.now();
                        final String taskId = "${title}_${DateTime.now().millisecondsSinceEpoch}";
                        await FirebaseFirestore.instance.collection("tasks").doc(taskId).set(taskData);
                      }

                      if (context.mounted) Navigator.pop(context);
                    }, isEditing ? "Update Task" : "Add Task"),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}