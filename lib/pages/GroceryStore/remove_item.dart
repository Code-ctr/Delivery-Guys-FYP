import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:flutter/material.dart';

class RemoveItemPage extends StatelessWidget {
  const RemoveItemPage({super.key});

  // Function to fetch items from Firebase
  Future<List<Map<String, dynamic>>> fetchItems() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('items')
          .where('store', isEqualTo: 'NDS')
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Store the document ID for future use
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching items: $e");
      return [];
    }
  }

  // Function to delete item from Firebase
  Future<void> deleteItem(String itemId) async {
    try {
      await FirebaseFirestore.instance.collection('items').doc(itemId).delete();
      print("Item deleted successfully");
    } catch (e) {
      print("Error deleting item: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Remove Item Panel"),
        actions: const [ManageProfilePage()],
        backgroundColor: const Color.fromARGB(255, 126, 104, 70),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Container(
                height: 510,
                width: 350,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(13)),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No items found'));
                    }

                    List<Map<String, dynamic>> items = snapshot.data!;

                    return ListView.builder(
                      itemCount: items.length,
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        Map<String, dynamic> item = items[index];
                        String imageUrl = item['imageURL'] ?? '';
                        String itemName = item['name'] ?? '';
                        String itemId = item['id'] ?? '';

                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: ListTile(
                              leading: Image.network(
                                imageUrl,
                                height: 36,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image);
                                },
                              ),
                              title: Text(itemName),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  // Confirm before deleting
                                  bool confirm = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirm Deletion"),
                                        content: const Text(
                                            "Are you sure you want to delete this item?"),
                                        actions: [
                                          TextButton(
                                            child: const Text("Cancel"),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(false); // Return false
                                            },
                                          ),
                                          TextButton(
                                            child: const Text("Delete"),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(true); // Return true
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm) {
                                    await deleteItem(itemId);
                                    // Refresh the list after deletion
                                    (context as Element).markNeedsBuild();
                                  }
                                },
                              ),
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
        ),
      ),
    );
  }
}
