import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';

class Croppage extends StatefulWidget {
  final String imagePath; 

  const Croppage({super.key, required this.imagePath});

  @override
  State<Croppage> createState() => _CroppageState();
}

class _CroppageState extends State<Croppage> {
  CroppedFile? _croppedImage;

  Future<void> _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: widget.imagePath, 
      compressQuality: 90,
      compressFormat: ImageCompressFormat.jpg,
      aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 16)
    );

    if (croppedFile != null) {
      setState(() {
        _croppedImage = croppedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF001B3E),
        toolbarHeight: 90,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (_croppedImage != null) {
                Navigator.pop(context, _croppedImage!.path); // Return cropped image path
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please crop the image first.")),
                );
              }
            },
            icon: const Icon(Icons.check_sharp, color: Colors.white),
          ),
        ],
        title: Text(
          "Crop",
          style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _croppedImage != null
                  ? Image.file(File(_croppedImage!.path), width: 400, height: 400, fit: BoxFit.cover)
                  : Image.file(File(widget.imagePath), width: 400, height: 400, fit: BoxFit.cover),
              const SizedBox(height: 20),
              MaterialButton(
                onPressed: _cropImage, // Call the crop function
                color: const Color(0xFF004C99), // Button color
                textColor: Colors.white, // Text color
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                minWidth: 360, // Set width
                height: 50, // Set height
                child: const Text('Crop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
