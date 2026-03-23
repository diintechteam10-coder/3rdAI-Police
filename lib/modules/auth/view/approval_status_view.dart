import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/constants/app_keys.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/utils/snackbar_util.dart';
import '../bloc/approval_status_bloc/approval_status_bloc.dart';
import '../bloc/approval_status_bloc/approval_status_event.dart';
import '../bloc/approval_status_bloc/approval_status_state.dart';

class ApprovalStatusView extends StatefulWidget {
  final String email;
  const ApprovalStatusView({super.key, required this.email});

  @override
  State<ApprovalStatusView> createState() => _ApprovalStatusViewState();
}

class _ApprovalStatusViewState extends State<ApprovalStatusView> {
  String? _displayEmail;

  @override
  void initState() {
    super.initState();
    _displayEmail = widget.email;
    _initializeAndCheck();
  }

  Future<void> _initializeAndCheck() async {
    if (_displayEmail == null || _displayEmail!.isEmpty) {
      final savedEmail = await SecureStorageService.instance.read(AppKeys.email);
      if (mounted) {
        setState(() {
          _displayEmail = savedEmail;
        });
      }
    }
    _checkStatus();
  }

  void _checkStatus() {
    if (_displayEmail != null && _displayEmail!.isNotEmpty) {
      context.read<ApprovalStatusBloc>().add(CheckApprovalStatus(_displayEmail!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: BlocConsumer<ApprovalStatusBloc, ApprovalStatusState>(
        listener: (context, state) {
          if (state is ApprovalStatusError) {
            SnackbarUtil.showError(context: context, message: state.message);
          } else if (state is ApprovalStatusLoaded) {
            if (state.response.data?.isVerified == true) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.bottomNav,
                (route) => false,
              );
            }
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.hourglass_empty_rounded,
                    size: 80,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Approval Pending',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your account approval is currently pending. Please wait until an administrator reviews and verifies your profile.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  if (state is ApprovalStatusLoading)
                    const CircularProgressIndicator(color: AppColors.primary)
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _checkStatus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Refresh Status',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
