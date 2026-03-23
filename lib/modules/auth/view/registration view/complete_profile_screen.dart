import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../widgets/modern_textfield.dart';
import '../../bloc/complete profile bloc/complete_profile_bloc.dart';
import '../../bloc/complete profile bloc/complete_profile_event.dart';
import '../../bloc/complete profile bloc/complete_profile_state.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _designationController;
  late final TextEditingController _policeIdController;
  late final TextEditingController _areaController;
  late final TextEditingController _stateController;
  late final TextEditingController _experienceController;

  @override
  void initState() {
    super.initState();
    final state = context.read<CompleteProfileBloc>().state;
    _nameController = TextEditingController(text: state.name);
    _emailController = TextEditingController(text: state.email);
    _designationController = TextEditingController(text: state.designation);
    _policeIdController = TextEditingController(text: state.policeId);
    _areaController = TextEditingController(text: state.area);
    _stateController = TextEditingController(text: state.state);
    _experienceController = TextEditingController(
      text: state.experience > 0 ? state.experience.toString() : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _designationController.dispose();
    _policeIdController.dispose();
    _areaController.dispose();
    _stateController.dispose();
    _experienceController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: BlocConsumer<CompleteProfileBloc, CompleteProfileState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.pushNamed(context, RouteNames.uploadProfilePicScreen);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // 🎨 BACKGROUND HEADER GRADIENT
              Container(
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // 🚀 MAIN CONTENT
              SafeArea(
                child: Column(
                  children: [
                    // --- AppBar ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),

                    // --- Header Text ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Complete Profile",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Fill the form below to secure your identity",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- Form Container ---
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: SingleChildScrollView(
                          padding:  EdgeInsets.fromLTRB(24, 32, 24, 15.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormHeader("User Information", Icons.person_outline),
                              const SizedBox(height: 20),

                              /// NAME
                              ModernTextField(
                                label: "Full Name",
                                hint: "Enter your full name",
                                controller: _nameController,
                                prefixIcon: Icons.person,
                                onChanged: (value) => _onInputChanged('name', value),
                              ),
                              const SizedBox(height: 16),

                              /// EMAIL
                              ModernTextField(
                                label: "Email Address",
                                hint: "Enter your email",
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: Icons.email,
                                onChanged: (value) => _onInputChanged('email', value),
                              ),
                              const SizedBox(height: 32),

                              _buildFormHeader("Professional Details", Icons.badge_outlined),
                              const SizedBox(height: 20),

                              /// DESIGNATION
                              ModernTextField(
                                label: "Designation",
                                hint: "e.g. Sub-Inspector",
                                controller: _designationController,
                                prefixIcon: Icons.work,
                                onChanged: (value) => _onInputChanged('designation', value),
                              ),
                              const SizedBox(height: 16),

                              /// POLICE ID
                              ModernTextField(
                                label: "Police ID",
                                hint: "Enter your unique badge ID",
                                controller: _policeIdController,
                                prefixIcon: Icons.verified_user,
                                onChanged: (value) => _onInputChanged('policeId', value),
                              ),
                              const SizedBox(height: 16),

                              /// EXPERIENCE
                              ModernTextField(
                                label: "Experience (Years)",
                                hint: "Enter years of experience",
                                controller: _experienceController,
                                keyboardType: TextInputType.number,
                                prefixIcon: Icons.history,
                                onChanged: (value) => _onInputChanged('experience', value),
                              ),
                              const SizedBox(height: 32),

                              _buildFormHeader("Location Info", Icons.location_on_outlined),
                              const SizedBox(height: 20),

                              /// AREA
                              ModernTextField(
                                label: "Area / Station",
                                hint: "Assigned jurisdiction",
                                controller: _areaController,
                                prefixIcon: Icons.map,
                                onChanged: (value) => _onInputChanged('area', value),
                              ),
                              const SizedBox(height: 16),

                              /// STATE
                              ModernTextField(
                                label: "State",
                                hint: "Operational state",
                                controller: _stateController,
                                prefixIcon: Icons.flag,
                                onChanged: (value) => _onInputChanged('state', value),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 🚀 STICKY BOTTOM BUTTON
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    onPressed: state.isValid && !state.isLoading
                        ? () {
                            context.read<CompleteProfileBloc>().add(
                                  const CompleteProfileSubmitted(),
                                );
                          }
                        : null,
                    child: state.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Submit Profile",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onInputChanged(String field, String value) {
    context.read<CompleteProfileBloc>().add(
          CompleteProfileInputChanged(field: field, value: value),
        );
  }

  Widget _buildFormHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }
}


