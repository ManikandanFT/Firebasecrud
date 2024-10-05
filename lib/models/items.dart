import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String id; // Document ID from Firestore
  String name;

  Item({required this.id, required this.name});

  // Factory constructor to create an Item from a Firestore document
  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map; // Cast to Map
    return Item(
      id: doc.id, // Use the document ID
      name: data['name'] ?? '', // Use a default value if 'name' is not found
    );
  }

  // Convert an Item to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
