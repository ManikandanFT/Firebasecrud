import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CRUDPage extends StatefulWidget {
  @override
  _CRUDPageState createState() => _CRUDPageState();
}

class _CRUDPageState extends State<CRUDPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();
  String _documentId = '';

  Future<void> createRecord() async {
    if (_controller.text.isNotEmpty) {
      DocumentReference docRef = await firestore.collection('items').add({
        'name': _controller.text,
      });
      setState(() {
        _documentId = docRef.id;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Record created')));
    }
  }

  Future<void> readRecord() async {
    if (_documentId.isNotEmpty) {
      DocumentSnapshot doc = await firestore.collection('items').doc(_documentId).get();
      if (doc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Record: ${doc['name']}')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No record found')));
      }
    }
  }

  Future<void> updateRecord() async {
    if (_documentId.isNotEmpty && _controller.text.isNotEmpty) {
      await firestore.collection('items').doc(_documentId).update({
        'name': _controller.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Record updated')));
    }
  }

  Future<void> deleteRecord() async {
    if (_documentId.isNotEmpty) {
      await firestore.collection('items').doc(_documentId).delete();
      setState(() {
        _documentId = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Record deleted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Firebase CRUD'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter Name'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  label: 'Create',
                  color: Colors.green,
                  onTap: createRecord,
                ),

                CustomButton(
                  label: 'Read',
                  color: Colors.blue,
                  onTap: readRecord,
                ),
              ],
            ),
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  label: 'Update',
                  color: Colors.orange,
                  onTap: updateRecord,
                ),
                CustomButton(
                  label: 'Delete',
                  color: Colors.red,
                  onTap: deleteRecord,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Button Widget
class CustomButton extends StatelessWidget {
  final String label;
  final Color color;
  final Function onTap;

  CustomButton({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}