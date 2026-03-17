import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../widgets/coming_soon_screen.dart';
import '../../../auth/repository/google_auth_repository.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';
import '../models/response/profile_response.dart';
import '../../../auth/bloc/upload profile pic bloc/upload_pic_bloc.dart';
import '../../../auth/bloc/upload profile pic bloc/upload_pic_event.dart';
import '../../../auth/bloc/upload profile pic bloc/upload_pic_state.dart';
import '../../../auth/repository/upload_profile_pic_repo.dart';
import 'edit_profile_screen.dart';
import '../../../../widgets/shimmer_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UploadPicBloc(uploadRepo: UploadProfileImageRepo()),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B1E3A), Color(0xFF1F3F66)],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: BlocListener<UploadPicBloc, UploadPicState>(
              listener: (context, state) {
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state.isSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profile picture updated!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // UI will update reflecting the local file since we use BlocBuilder on UploadPicBloc
                } else if (state.imageFile != null &&
                    !state.isLoading &&
                    !state.isSuccess) {
                  // If image is picked but not uploading yet, trigger upload
                  context.read<UploadPicBloc>().add(UploadImageRequested());
                }
              },
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return ShimmerWidgets.profileShimmer();
                  }
                  if (state is ProfileError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  if (state is ProfileLoaded) {
                    final data = state.partnerData;
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            const ProfileHeader(),
                            const SizedBox(height: 18),
                            OfficerProfileCard(data: data),
                            const SizedBox(height: 18),
                            // Container(height: 1, color: const Color(0xFF3A5A8C)),
                            // const SizedBox(height: 18),
                            const SettingsSection(),
                            const SizedBox(height: 24),
                            const LogoutButton(),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Profile',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFFFFFFFF),
      ),
    );
  }
}

class OfficerProfileCard extends StatelessWidget {
  final PartnerData data;

  const OfficerProfileCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF132B4C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF2C5EA8), width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2C5EA8).withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  BlocBuilder<UploadPicBloc, UploadPicState>(
                    builder: (context, uploadState) {
                      if (uploadState.isSuccess &&
                          uploadState.imageFile != null) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(36),
                          child: Image.file(
                            uploadState.imageFile!,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(36),
                        child:
                            data.profilePicture != null &&
                                data.profilePicture!.isNotEmpty
                            ? Image.network(
                                data.profilePicture!,
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildPlaceholder();
                                },
                              )
                            : _buildPlaceholder(),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _showImageSourceSheet(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C5EA8),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF132B4C),
                            width: 2,
                          ),
                        ),
                        child: BlocBuilder<UploadPicBloc, UploadPicState>(
                          builder: (context, state) {
                            if (state.isLoading) {
                              return const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              );
                            }
                            return const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 14,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.designation,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFB0C4DE),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(height: 1, color: const Color(0xFF3A5A8C)),
                    const SizedBox(height: 8),
                    Text(
                      data.policeStation,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID: ${data.policeId}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFB0C4DE),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: -18,
          right: 16,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ProfileBloc>(),
                    child: EditProfileScreen(partnerData: data),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.edit_outlined,
              size: 16,
              color: Color(0xFF222222),
            ),
            label: const Text(
              'Edit',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF222222),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEAEAEA),
              elevation: 4,
              minimumSize: const Size(0, 36), // 👈 height control
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadowColor: Colors.black.withValues(alpha: 0.15),
            ),
          ),
        ),
      ],
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF132B4C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: context.read<UploadPicBloc>(),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Update Profile Picture",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Colors.blueAccent,
                  ),
                  title: const Text(
                    "Camera",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<UploadPicBloc>().add(PickImageFromCamera());
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: Colors.greenAccent,
                  ),
                  title: const Text(
                    "Gallery",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<UploadPicBloc>().add(PickImageFromGallery());
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 72,
      height: 72,
      color: Colors.grey,
      child: const Icon(Icons.person, color: Colors.white, size: 36),
    );
  }
}

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Manage your account',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Color(0xFFB0C4DE),
          ),
        ),
        const SizedBox(height: 16),
        _buildListTile(
          icon: Icons.privacy_tip,
          text: 'Privacy Policy',
          onTap: () async {
            final url = Uri.parse("https://3rdai.co/pp");
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          },
        ),
        const SizedBox(height: 12),
        _buildListTile(
          icon: Icons.help_outline,
          text: 'Help & Support',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ComingSoonScreen(title: "Help & Support"),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildListTile(
          icon: Icons.info_outline,
          text: 'About Us',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ComingSoonScreen(title: "About Us"),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFE9E9E9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF222222),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111111),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF888888), size: 20),
          ],
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF132B4C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Logout',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Color(0xFFB0C4DE)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3D00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              // 1. Clear Secure Storage
              await SecureStorageService.instance.deleteAll();

              // 2. Sign out from Google/Firebase
              try {
                final googleRepo = GoogleAuthRepository();
                await googleRepo.signOut();
              } catch (e) {
                print("Error during sign out: $e");
              }
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.signinMethodsScreen,
                  (route) => false,
                );
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 140,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6A00), Color(0xFFFF3D00)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF3D00).withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showLogoutDialog(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.logout, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
