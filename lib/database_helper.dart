import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "crud.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE contacts ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "address TEXT,"
        "phone TEXT"
        ")");
  }

  Future<int> insertContact(Contact contact) async {
    var client = await db;
    return client.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    var client = await db;
    var res = await client.query('contacts');
    List<Contact> contacts =
    res.isNotEmpty ? res.map((c) => Contact.fromMap(c)).toList() : [];
    return contacts;
  }

  Future<int> updateContact(Contact contact) async {
    var client = await db;
    return await client.update('contacts', contact.toMap(),
        where: "id = ?", whereArgs: [contact.id]);
  }

  Future<int> deleteContact(int id) async {
    var client = await db;
    return await client.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }
}

class Contact {
  int? id;
  String name;
  String address;
  String phone;

  Contact({this.id, required this.name, required this.address, required this.phone});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'address': address, 'phone': phone};
  }

  factory Contact.fromMap(Map<String, dynamic> json) => Contact(
    id: json['id'],
    name: json['name'],
    address: json['address'],
    phone: json['phone'],
  );
}
