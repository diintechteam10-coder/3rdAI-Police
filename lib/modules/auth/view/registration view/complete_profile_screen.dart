import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      // backgroundColor: AppColors.bgColor,

      /// APP BAR
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Complete Profile",
          style: TextStyle(color: AppColors.white),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),

      body: SafeArea(
        child: BlocConsumer<CompleteProfileBloc, CompleteProfileState>(
          listener: (context, state) {
            if (state.isSuccess) {
              Navigator.pushNamed(context, RouteNames.uploadProfilePicScreen);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // /// HEADER
                  // Container(
                  //   width: double.infinity,
                  //   padding: const EdgeInsets.all(24),
                  //   decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //       colors: [
                  //         AppColors.primary.withOpacity(.9),
                  //         AppColors.primary.withOpacity(.7),
                  //       ],
                  //     ),
                  //     borderRadius: BorderRadius.circular(18),
                  //   ),
                  //   child: const Column(
                  //     children: [
                  //       Icon(
                  //         Icons.person_outline,
                  //         size: 50,
                  //         color: Colors.white,
                  //       ),
                  //       SizedBox(height: 10),
                  //       Text(
                  //         "Complete Your Profile",
                  //         style: TextStyle(
                  //           fontSize: 20,
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //       SizedBox(height: 4),
                  //       Text(
                  //         "Fill your professional details",
                  //         style: TextStyle(
                  //           color: Colors.white70,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),

                  // const SizedBox(height: 25),

                  /// FORM CARD
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 18,
                          color: Colors.black.withOpacity(.06),
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        /// NAME
                        ModernTextField(
                          label: "Full Name",
                          hint: "Enter your full name",
                          controller: _nameController,
                          onChanged: (value) {
                            context.read<CompleteProfileBloc>().add(
                              CompleteProfileInputChanged(
                                field: 'name',
                                value: value,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        /// EMAIL
                        ModernTextField(
                          label: "Email",
                          hint: "Enter your email",
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            context.read<CompleteProfileBloc>().add(
                              CompleteProfileInputChanged(
                                field: 'email',
                                value: value,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        /// DESIGNATION
                        ModernTextField(
                          label: "Designation",
                          hint: "Enter your designation",
                          controller: _designationController,
                          onChanged: (value) {
                            context.read<CompleteProfileBloc>().add(
                              CompleteProfileInputChanged(
                                field: 'designation',
                                value: value,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        /// POLICE ID
                        ModernTextField(
                          label: "Police ID",
                          hint: "Enter your police ID",
                          controller: _policeIdController,
                          onChanged: (value) {
                            context.read<CompleteProfileBloc>().add(
                              CompleteProfileInputChanged(
                                field: 'policeId',
                                value: value,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        /// AREA
                        ModernTextField(
                          label: "Area",
                          hint: "Enter your area",
                          controller: _areaController,
                          onChanged: (value) {
                            context.read<CompleteProfileBloc>().add(
                              CompleteProfileInputChanged(
                                field: 'area',
                                value: value,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        /// STATE
                        ModernTextField(
                          label: "State",
                          hint: "Enter your state",
                          controller: _stateController,
                          onChanged: (value) {
                            context.read<CompleteProfileBloc>().add(
                              CompleteProfileInputChanged(
                                field: 'state',
                                value: value,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        /// EXPERIENCE
                        ModernTextField(
                          label: "Experience (Years)",
                          hint: "Enter years of experience",
                          controller: _experienceController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            context.read<CompleteProfileBloc>().add(
                              CompleteProfileInputChanged(
                                field: 'experience',
                                value: value,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 28),

                        /// SUBMIT BUTTON
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: state.isValid
                              ? () {
                                  context.read<CompleteProfileBloc>().add(
                                    const CompleteProfileSubmitted(),
                                  );
                                }
                              : null,
                          child: state.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Submit Profile",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
