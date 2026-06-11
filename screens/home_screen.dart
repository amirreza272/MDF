import 'package:flutter/material.dart';
import 'package:samadzadeh_mdf/data/models/group_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GroupModel> groups = [];

  final TextEditingController controller = TextEditingController();

  void addGroup(String name) {
    setState(() {
      groups.add(GroupModel(name: name, pieces: [], id: ''));
    });
  }

  void showAddDialog() {
    controller.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Group"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Group name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                addGroup(controller.text);
              }
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MDF Groups"),
      ),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];

          return ListTile(
            title: Text(group.name),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // بعداً میریم GroupScreen
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
