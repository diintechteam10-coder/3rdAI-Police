import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../../widgets/modern_textfield.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../models/response/profile_response.dart';

class EditProfileScreen extends StatefulWidget {
  final PartnerData partnerData;

  const EditProfileScreen({super.key, required this.partnerData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _designationController;
  late TextEditingController _policeStationController;
  late TextEditingController _experienceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.partnerData.name);
    _phoneController = TextEditingController(text: widget.partnerData.phone);
    _designationController = TextEditingController(text: widget.partnerData.designation);
    _policeStationController = TextEditingController(text: widget.partnerData.policeStation);
    _experienceController = TextEditingController(text: widget.partnerData.experience.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _designationController.dispose();
    _policeStationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final updatedData = {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'designation': _designationController.text,
      'policeStation': _policeStationController.text,
      'experience': int.tryParse(_experienceController.text) ?? 0,
    };

    context.read<ProfileBloc>().add(UpdateProfile(updatedData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileUpdateLoading;

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildSectionTitle('Personal Information'),
                    const SizedBox(height: 16),
                    ModernTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      prefixIcon: Icons.person_outline,
                      textColor: Colors.white,
                      labelColor: Colors.white70,
                      iconColor: const Color(0xFFD4AF37),
                      fillColor: const Color(0xFF132B4C),
                    ),
                    const SizedBox(height: 16),
                    ModernTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      textColor: Colors.white,
                      labelColor: Colors.white70,
                      iconColor: const Color(0xFFD4AF37),
                      fillColor: const Color(0xFF132B4C),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Professional Details'),
                    const SizedBox(height: 16),
                    ModernTextField(
                      controller: _designationController,
                      label: 'Designation',
                      prefixIcon: Icons.badge_outlined,
                      textColor: Colors.white,
                      labelColor: Colors.white70,
                      iconColor: const Color(0xFFD4AF37),
                      fillColor: const Color(0xFF132B4C),
                    ),
                    const SizedBox(height: 16),
                    ModernTextField(
                      controller: _policeStationController,
                      label: 'Police Station',
                      prefixIcon: Icons.local_police_outlined,
                      textColor: Colors.white,
                      labelColor: Colors.white70,
                      iconColor: const Color(0xFFD4AF37),
                      fillColor: const Color(0xFF132B4C),
                    ),
                    const SizedBox(height: 16),
                    ModernTextField(
                      controller: _experienceController,
                      label: 'Years of Experience',
                      prefixIcon: Icons.history_outlined,
                      keyboardType: TextInputType.number,
                      textColor: Colors.white,
                      labelColor: Colors.white70,
                      iconColor: const Color(0xFFD4AF37),
                      fillColor: const Color(0xFF132B4C),
                    ),
                    const SizedBox(height: 40),
                    _SaveButton(
                      isLoading: isLoading,
                      onPressed: _saveProfile,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFD4AF37),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _SaveButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFD4AF37)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4AF37).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
              : Text(
                  'Save Changes',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
        ),
      ),
    );
  }
}
