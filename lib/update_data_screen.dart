import 'package:flutter/material.dart';
import 'package:crudsqllite/database_helper.dart';

class UpdateContactScreen extends StatefulWidget {
  final Contact contact;

  UpdateContactScreen({required this.contact});

  @override
  _UpdateContactScreenState createState() => _UpdateContactScreenState();
}

class _UpdateContactScreenState extends State<UpdateContactScreen> {
  DatabaseHelper dbHelper = DatabaseHelper();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.contact.name;
    addressController.text = widget.contact.address;
    phoneController.text = widget.contact.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Contact'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildTextField(nameController, 'Name'),
          _buildTextField(addressController, 'Address'),
          _buildTextField(phoneController, 'Phone', keyboardType: TextInputType.phone),
          SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              _updateContact();
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  void _updateContact() async {
    String name = nameController.text;
    String address = addressController.text;
    String phone = phoneController.text;
    if (name.isNotEmpty && address.isNotEmpty && phone.isNotEmpty) {
      Contact updatedContact = Contact(
        id: widget.contact.id,
        name: name,
        address: address,
        phone: phone,
      );
      await dbHelper.updateContact(updatedContact);
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
