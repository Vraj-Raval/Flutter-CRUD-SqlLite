import 'package:flutter/material.dart';
import 'package:crudsqllite/database_helper.dart';

class AddContactScreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  DatabaseHelper dbHelper = DatabaseHelper();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(nameController, 'Name'),
            SizedBox(height: 16.0),
            _buildTextField(addressController, 'Address'),
            SizedBox(height: 16.0),
            _buildTextField(phoneController, 'Phone', keyboardType: TextInputType.phone),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                _addContact();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  void _addContact() async {
    String name = nameController.text;
    String address = addressController.text;
    String phone = phoneController.text;
    if (name.isNotEmpty && address.isNotEmpty && phone.isNotEmpty) {
      await dbHelper.insertContact(Contact(
        name: name,
        address: address,
        phone: phone,
      ));
      Navigator.pop(context, true); // Return to previous screen
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill all fields.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
