// ignore: file_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_pick/croppage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditPhotoPage extends StatefulWidget {
  const EditPhotoPage({Key? key}) : super(key: key);

  @override
  State<EditPhotoPage> createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  // Request permissions for camera and storage
  Future<void> _requestPermissions() async {
    if (await Permission.camera.request().isDenied) {
      return;
    }

    if (await Permission.storage.request().isDenied) {
      return;
    }

    if (await Permission.photos.request().isDenied) {
      return;
    }
  }

  // Open Camera and directly upload the image
  Future<void> _openCamera() async {
    await _requestPermissions(); // Ensure permissions are granted
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  // Open Gallery and directly upload the image
  Future<void> _openGallery() async {
    await _requestPermissions(); // Ensure permissions are granted
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  // Remove image
  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF001B3E),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF001B3E),
          toolbarHeight: 90,
          centerTitle: true,
          leading: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          title: Text(
            "Edit Photo",
            style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 360,
                  width: 360,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: _imageFile != null
                      ? ClipOval(
                          child: Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                        )
                      : CircleAvatar(
                          radius: 150,
                          backgroundColor: Colors.grey[300],
                          child: const Icon(Icons.person, size: 200, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                
                
                children: [
                         const Divider(thickness: 1, color: Colors.grey),
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      const Icon(Icons.crop, color: Color(0xFF484C52), size: 14),
                      const SizedBox(width: 8),
                      TextButton(
  onPressed: () async {
    if (_imageFile != null) {
      final croppedImagePath = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Croppage(imagePath: _imageFile!.path),
        ),
      );

      // Update the image file if cropping is successful
      if (croppedImagePath != null) {
        setState(() {
          _imageFile = XFile(croppedImagePath); // Update with the cropped image
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an image first.")),
      );
    }
  },
  child: Text(
    "Crop",
    style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
  ),
),
                    ]
                      ),
                    ],
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      const Icon(Icons.photo, color: Color(0xFF484C52), size: 14),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 259,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    const Divider(thickness: 5, indent: 150, endIndent: 150, color: Colors.black),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Upload & take a picture',
                                      style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: _openCamera,
                                          child: _buildOptionContainer('assets/CAMERA.png', 'Camera'),
                                        ),
                                        GestureDetector(
                                          onTap: _openGallery,
                                          child: _buildOptionContainer('assets/files.png', 'Gallery'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "File types: png, jpg, jpeg  Max file size: 5MB",
                                      style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        
                        child: Text(
                          "Change Photo",
                          style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF333333)),
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      const Icon(Icons.delete, color: Color(0xFF484C52), size: 14),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: _removeImage,
                        child: Text(
                          "Remove Photo",
                          style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                ],
              ),
        )
      )
    );
          
    
  }

  // Helper function to build the option container for Camera/Gallery
  Widget _buildOptionContainer(String assetPath, String label) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 100,
            width: 143,
            color: const Color(0xFFEEEEEE),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(assetPath, height: 26, width: 31, fit: BoxFit.cover),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
