// import 'package:flutter/material.dart';

// import '../../../core/constants/app_colors.dart';

// class ApprovalPendingScreen extends StatelessWidget {
//   const ApprovalPendingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.hourglass_empty_rounded,
//                 size: 80,
//                 color: AppColors.primary,
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 'Approval Pending',
//                 style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                   color: AppColors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'Your account approval is currently pending. Please wait until an administrator reviews and verifies your profile.',
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   color: AppColors.textSecondary,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
