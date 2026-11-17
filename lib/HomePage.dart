import 'package:flutter/material.dart';
import 'package:rentr/crud_service.dart';

class HomePage extends StatelessWidget {
  final CrudService service = CrudService();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController qtyCtrl = TextEditingController();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Firebase Peralta'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => openAddDialog(context),
      ),
      body: StreamBuilder<QuerySnapshot>(
      stream: service.getItems(),
      builder:(context, snapshot) {
        if (snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(child: Text('No items found.', style: TextStyle(fontSize: 18)));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var item = docs[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  item['name'],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Quantity: ${item['quantity']}',
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => openEditDialog(context, item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, item.id),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
      )
    );
  }
}

        void _confirmDelete(BuildContext context, String id) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Delete item'),
              content: const Text('Are you sure you want to delete this item?'),
              actions: [
                TextButton(
                  child: const Text("Delete", style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    service.deleteItem(id);
                    Navigator.pop(context);
                  }
              ],
            ),
          );
        }