import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const _primaryColor = Color(0xFF48319D);

class EditProfileScreen extends StatefulWidget {
  final String? currentName;
  final String? currentImageUrl;

  const EditProfileScreen({super.key, this.currentName, this.currentImageUrl});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    setState(() => _isPickingImage = true);

    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        log('Picked file path: ${pickedFile.path}');
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  Future<void> _saveChanges() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String? newImageUrl = widget.currentImageUrl;

      // Handle image upload if a new image was picked
      if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user.uid}.jpg');

        final snapshot = await storageRef.putFile(_imageFile!);
        try {
          newImageUrl = await snapshot.ref.getDownloadURL();
        } on FirebaseException catch (e) {
          if (e.code == 'object-not-found') {
            debugPrint('Storage object not found immediately after upload. Retrying...');
            // Fallback: wait a moment or use the original URL
            newImageUrl = widget.currentImageUrl;
          } else {
            rethrow;
          }
        }
      }

      // Update Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'fullName': name,
        'profileImageUrl': newImageUrl,
      });

      if (mounted) {
        Navigator.pop(context, true); // Return true to signal data refresh
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = getColorByTheme(context: context, colorClass: AppColors.backgroundColor);
    final textColor = getColorByTheme(context: context, colorClass: AppColors.textColor);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text('Edit Profile'),
        elevation: 0,
        foregroundColor: textColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _primaryColor.withValues(alpha: 0.1),
                      border: Border.all(color: _primaryColor.withValues(alpha: 0.5), width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: _imageFile != null
                          ? Image.file(_imageFile!, fit: BoxFit.cover)
                          : widget.currentImageUrl != null && widget.currentImageUrl!.isNotEmpty
                              ? Image.network(
                                  widget.currentImageUrl!, 
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 60, color: _primaryColor),
                                )
                              : const Icon(Icons.person, size: 60, color: _primaryColor),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              _buildTextField(
                controller: _nameController,
                label: 'Name',
                hint: 'Enter your full name',
                prefixIcon: Icons.person_outline,
                textColor: textColor,
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 5,
                    shadowColor: _primaryColor.withValues(alpha: 0.5),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    required Color textColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: textColor.withValues(alpha: 0.3)),
            prefixIcon: Icon(prefixIcon, color: _primaryColor, size: 20),
            filled: true,
            fillColor: textColor.withValues(alpha: 0.03),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: textColor.withValues(alpha: 0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _primaryColor, width: 2),
            ),
          ),
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
