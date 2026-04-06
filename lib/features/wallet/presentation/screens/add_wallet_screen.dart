import 'dart:io';

import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/features/wallet/presentation/bloc/add_wallet_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddWalletScreen extends StatefulWidget {
  const AddWalletScreen({super.key});

  @override
  State<AddWalletScreen> createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends State<AddWalletScreen> {
  final TextEditingController _walletController = TextEditingController();
  File? _selectedImage;
  bool _isPickingImage = false;

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    _isPickingImage = true;

    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => _selectedImage = File(picked.path));
      }
    } finally {
      _isPickingImage = false;
    }
  }

  void _removeImage() {
    setState(() => _selectedImage = null);
  }

  Future<String?> uploadImageToServer(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('wallets')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final snapshot = await storageRef.putFile(imageFile);
      try {
        final downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      } on FirebaseException catch (e) {
        if (e.code == 'object-not-found') {
          debugPrint('Storage object not found immediately after upload.');
          return null;
        } else {
          rethrow;
        }
      }
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _submitWallet() async {
    final walletName = _walletController.text.trim();
    if (walletName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wallet name is required'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    String? uploadedImageUrl;

    if (_selectedImage != null) {
      uploadedImageUrl = await uploadImageToServer(_selectedImage!);
    }

    final id = const Uuid().v4();

    context.read<AddWalletBloc>().add(
      SubmitWalletEvent(id: id, name: walletName, imageUrl: uploadedImageUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorByTheme(
        context: context,
        colorClass: AppColors.backgroundColor,
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: getColorByTheme(
          context: context,
          colorClass: AppColors.backgroundColor,
        ),
        title: const Text('New Wallet'),
      ),
      body: BlocConsumer<AddWalletBloc, AddWalletState>(
        listener: (context, state) {
          if (state is AddWalletSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Wallet added successfully'), 
              behavior: SnackBarBehavior.floating,
              
              ),
            );
            Navigator.pop(context, true);
          } else if (state is AddWalletError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },

        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wallet',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getColorByTheme(
                      context: context,
                      colorClass: AppColors.textColor,
                    ),
                  ),
                ),
                8.verticalSpace,
                TextField(
                  controller: _walletController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Wallet Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                20.verticalSpace,
                Text(
                  'Wallet Icon',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getColorByTheme(
                      context: context,
                      colorClass: AppColors.textColor,
                    ),
                  ),
                ),
                8.verticalSpace,
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                       color: Color(0xFF48319D),                       
                       ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.file_upload_outlined, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Upload Image',
                            style: TextStyle(
                              color: getColorByTheme(
                                context: context,
                                colorClass: AppColors.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                16.verticalSpace,
                if (_selectedImage != null)
                  Stack(
                    children: [
                      Container(
                        height: 90.h,
                        width: 90.w,
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
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const Spacer(),
                ElevatedButton(
                  onPressed: state is AddWalletLoading ? null : _submitWallet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getColorByTheme(
                      context: context,
                      colorClass: AppColors.backgroundColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 32,
                    ),
                    elevation: 15,
                    minimumSize: const Size.fromHeight(50),
                    side:  BorderSide(
                      color: Color(0xFF48319D),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: getColorByTheme(context: context, colorClass: AppColors.textColor)
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
