import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:delivery_guys_fyp/components/textfield.dart';
import 'package:delivery_guys_fyp/pages/FireBase/fire_registeration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class AddItemsPage extends StatefulWidget {
  const AddItemsPage({super.key});

  @override
  State<AddItemsPage> createState() => _AddItemsPageState();
}

class _AddItemsPageState extends State<AddItemsPage> {
  final List<String> locations = [
    " ",
    "Vegetables",
    "Fruits",
    "Dariy",
    "Meat",
    "Sweet",
    "Snacks",
    "Dry Fruits",
    "Other items"
  ];

  String selectedLocation = " ";
  final AuthService _authService = AuthService();
  final itemnamecon = TextEditingController();
  final itempricecon = TextEditingController();
  final itemquantitycon = TextEditingController();
  String store = "";

  File? _image;
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserdetail();
  }

  void _getUserdetail() async {
    User? user = _authService.getCurrentUser();
    if (user != null) {
      String? userName = await _authService.getUserFullName(user.uid);

      setState(() {
        if (userName != null) store = userName;
      });
    }
  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      String fileExtension = path.extension(imageFile.path);
      TaskSnapshot storageReference = await FirebaseStorage.instance
          .ref()
          .child('item_images/${DateTime.now()}$fileExtension')
          .putFile(imageFile);

      String downloadURL = await storageReference.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  void message(String alert, String m) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alert),
          content: Text(m),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: const Text("New Items Panel"),
        backgroundColor: const Color.fromARGB(255, 144, 124, 65),
        actions: const [ManageProfilePage()],
      ),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Container(
            height: 590,
            width: 380,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(30)),
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Click below on Add image to add Image of items for sell",
                  style: TextStyle(
                    color: Color.fromARGB(255, 180, 196, 188),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 7,
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 146, 204, 175),
                    minimumSize: const Size(200, 50),
                  ),
                  child: const Text("Choose Image"),
                ),
                const SizedBox(
                  height: 7,
                ),
                if (_image != null)
                  Container(
                    height: 200,
                    width: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.file(_image!, fit: BoxFit.cover),
                  ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 70,
                  width: 330,
                  child: DropdownButtonFormField<String>(
                    focusColor: Colors.white,
                    value: selectedLocation,
                    items: locations.map((String location) {
                      return DropdownMenuItem<String>(
                        value: location,
                        child: Text(location),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLocation = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Select Catagroy',
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                MyTextField(
                    controller: itemnamecon,
                    hinttext: "Item name",
                    obscuretext: false,
                    enabled: true),
                const SizedBox(
                  height: 5,
                ),
                MyTextField(
                    controller: itempricecon,
                    hinttext: "Item price",
                    obscuretext: false,
                    enabled: true),
                const SizedBox(
                  height: 5,
                ),
                MyTextField(
                    controller: itemquantitycon,
                    hinttext: "Item Quantity",
                    obscuretext: false,
                    enabled: true),
                const SizedBox(
                  height: 7,
                ),
                MyButton(
                  heigh: 50,
                  hintText: "Add",
                  color: Colors.indigo,
                  onTap: () async {
                    if (_image != null &&
                        itemnamecon.text.isNotEmpty &&
                        itempricecon.text.isNotEmpty &&
                        itemquantitycon.text.isNotEmpty &&
                        selectedLocation.isNotEmpty) {
                      String? imageURL = await uploadImageToFirebase(_image!);

                      if (imageURL != null) {
                        Map<String, dynamic> itemData = {
                          'name': itemnamecon.text,
                          'price': itempricecon.text,
                          'quantity': itemquantitycon.text,
                          'category': selectedLocation,
                          'imageURL': imageURL,
                          'store': store
                        };

                        await _authService.saveItem(itemData);

                        setState(() {
                          _image = null;
                          itemnamecon.clear();
                          itempricecon.clear();
                          itemquantitycon.clear();
                          selectedLocation = " ";
                        });

                        message("Item Added",
                            "The item is Sucessfull added to your store");
                      } else {
                        message("Image Erro",
                            "Errror occur Can not upload Image and to your Store");
                      }
                    } else {
                      message("Empty Field", "Not all Field are Filled");
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ]),
            ),
          ),
        ),
      )),
    );
  }
}
