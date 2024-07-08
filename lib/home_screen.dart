import 'package:flutter/material.dart';
import 'package:crudsqllite/database_helper.dart';
import 'package:crudsqllite/update_data_screen.dart';
import 'package:crudsqllite/add_data_screen.dart';
import 'package:crudsqllite/contact_details_screen.dart'; // New screen for viewing details by ID

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _refreshContacts();
  }

  void _refreshContacts() async {
    List<Contact> fetchedContacts = await dbHelper.getContacts();
    setState(() {
      contacts = fetchedContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Contacts')),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: ()=>Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactDetailsScreen(contact: contacts[index]),
              ),
            ),
            child: Card(
              elevation: 4, // Add a shadow to the card
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                title: Text(
                  contacts[index].name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      'Address: ${contacts[index].address}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Phone: ${contacts[index].phone}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete_forever),
                      color: Colors.red,
                      onPressed: () {
                        _deleteContact(contacts[index].id!);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit_document),
                      color: Colors.blueGrey,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateContactScreen(contact: contacts[index]),
                          ),
                        ).then((value) => _refreshContacts());
                      },
                    ),

                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddContactScreen()),
          ).then((value) => _refreshContacts());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _deleteContact(int id) async {
    await dbHelper.deleteContact(id);
    _refreshContacts();
  }
}
