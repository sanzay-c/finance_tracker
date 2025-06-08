import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddWalletScreen extends StatefulWidget {
  const AddWalletScreen({super.key});

  @override
  State<AddWalletScreen> createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends State<AddWalletScreen> {
  final TextEditingController _walletController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  void _removeImage() {
    setState(() => _selectedImage = null);
  }

  void _submitWallet() {
    final walletName = _walletController.text.trim();
    if (walletName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Wallet name is required')));
      return;
    }

    print('Wallet: $walletName');
    print('Image path: ${_selectedImage?.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorByTheme(
        context: context,
        colorClass: AppColors.backgroundColor,
      ),
      appBar: AppBar(
        backgroundColor: getColorByTheme(
          context: context,
          colorClass: AppColors.backgroundColor,
        ),
        title: Text('New Wallet'),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wallet', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: _walletController,
              decoration: InputDecoration(
                hintText: 'Enter Wallet Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            Text('Wallet Icon', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),

            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.upload, size: 20),
                      SizedBox(width: 8),
                      Text('Upload Image'),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            if (_selectedImage != null)
              Stack(
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: _removeImage,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: Icon(Icons.close, color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                ],
              ),

            const Spacer(),
            ElevatedButton(
              onPressed: _submitWallet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade700,
                minimumSize: Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Submit", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
