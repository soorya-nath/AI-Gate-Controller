import 'dart:io';

import 'package:flutter/material.dart';
import 'package:front_end/constants/colours.dart';
import 'package:front_end/widgets/home/snackbarWidet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class Registrationpage extends StatefulWidget {
  @override
  _RegistrationpageState createState() => _RegistrationpageState();
}

class _RegistrationpageState extends State<Registrationpage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  File? _image;
  bool _isLoading = false;

  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _registerDriver() async {
    if (_nameController.text.isEmpty ||
        _contactController.text.isEmpty ||
        _licenseController.text.isEmpty ||
        _image == null) {
      snackbarwidget(
        context,
        Icons.error,
        "Please fill all fields and select an image",
        Colors.redAccent
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Supabase.instance.client.auth.refreshSession();
      final userId = supabase.auth.currentUser?.id;
      final imagePath = "${DateTime.now().millisecondsSinceEpoch}.jpg";

      // Upload image to Supabase Storage
      final imageBytes = await _image!.readAsBytes();
      await supabase.storage
          .from('drivers_images')
          .uploadBinary(imagePath, imageBytes);

      final imageUrl =
          supabase.storage.from('drivers_images').getPublicUrl(imagePath);

      final response = await supabase.from('drivers').insert({
        'name': _nameController.text,
        'contact': _contactController.text,
        'license_no': _licenseController.text,
        'image_url': imageUrl,
        'user_id': userId,
      }).select();

      print("Insert Response: $response");

      snackbarwidget(
        context,
        Icons.check_circle,
        "Driver Registered Successfully!",
        Colors.greenAccent
      );

      _nameController.clear();
      _contactController.clear();
      _licenseController.clear();
      setState(() {
        _image = null;
      });
    } catch (e) {
     print(e);
      snackbarwidget(context, Icons.error, "Something went wrong ! Driver not registerd", Colors.redAccent);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text("Register Driver",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: blue_clr,
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context,true);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                "Driver Information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: blue_clr,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField(_nameController, "Driver Name", Icons.person),
              _buildTextField(_contactController, "Contact Number", Icons.phone,
                  keyboardType: TextInputType.phone),
              _buildTextField(
                  _licenseController, "License Number", Icons.credit_card),
              const SizedBox(height: 15),
              const Text(
                "Upload Driver Image",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: _image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt,
                                size: 50, color: Colors.grey[600]),
                            const SizedBox(height: 10),
                            Text("Tap to select an image",
                                style: TextStyle(color: Colors.grey[700])),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_image!,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover),
                        ),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _registerDriver,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue_clr,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                        ),
                        child: const Text("Register Driver"),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: blue_clr),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:  BorderSide(color: blue_clr, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }
}
