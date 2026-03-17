import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/route_names.dart';
import '../../bloc/upload profile pic bloc/upload_pic_bloc.dart';
import '../../bloc/upload profile pic bloc/upload_pic_event.dart';
import '../../bloc/upload profile pic bloc/upload_pic_state.dart';
import '../../../../widgets/shimmer_widgets.dart';

class UploadProfilePicScreen extends StatelessWidget {
  const UploadProfilePicScreen({super.key});
  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Choose Profile Picture",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  context.read<UploadPicBloc>().add(PickImageFromCamera());
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo, color: Colors.green),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  context.read<UploadPicBloc>().add(PickImageFromGallery());
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<UploadPicBloc, UploadPicState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              } else if (state.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile picture uploaded!")),
                );
                Navigator.pushReplacementNamed(context, RouteNames.bottomNav);
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Upload Profile Picture",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// 🔥 Avatar Preview
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 75,
                          backgroundColor: Colors.white,
                          backgroundImage: state.imageFile != null
                              ? FileImage(state.imageFile!)
                              : null,
                          child: state.imageFile == null
                              ? const Icon(
                                  Icons.person,
                                  size: 80,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),

                        GestureDetector(
                          onTap: () {
                            _showImageSourceSheet(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    /// Upload Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: state.isLoading
                            ? null
                            : () {
                                context.read<UploadPicBloc>().add(
                                  UploadImageRequested(),
                                );
                              },
                        child: state.isLoading
                            ? ShimmerWidgets.base(
                                baseColor: AppColors.primary.withOpacity(0.1),
                                highlightColor: AppColors.primary.withOpacity(0.3),
                                child: Container(
                                  height: 20,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              )
                            : const Text(
                                "Upload",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.bottomNav);
                      },
                      child: const Text(
                        "Skip for now",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
