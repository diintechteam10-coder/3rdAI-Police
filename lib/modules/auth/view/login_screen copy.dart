// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import '../../../widgets/custom_button.dart';
// import '../../../widgets/modern_textfield.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   late final TextEditingController _emailController;
//   late final TextEditingController _passwordController;

//   @override
//   void initState() {
//     super.initState();
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final padding = MediaQuery.of(context).padding;

//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.only(
//           top: padding.top,
//           left: 24,
//           right: 24,
//           bottom: padding.bottom,
//         ),
//         child: SingleChildScrollView(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               minHeight:
//                   MediaQuery.of(context).size.height -
//                   padding.top -
//                   padding.bottom,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 40),

//                 const _AppLogo(),

//                 const SizedBox(height: 24),
//                 Text(
//                   'Welcome Back',
//                   style: Theme.of(context).textTheme.headlineLarge,
//                 ),

//                 const SizedBox(height: 8),

//                 Text(
//                   'Login to start receiving live consultations',
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//                 const SizedBox(height: 40),

//                 ModernTextField(
//                   controller: _emailController,
//                   hint: 'Email address',
//                   label: 'Email',
//                   keyboardType: TextInputType.emailAddress,
//                 ),

//                 const SizedBox(height: 16),

//                 ModernTextField(
//                   controller: _passwordController,
//                   hint: 'Password',
//                   label: 'Password',
//                   obscureText: true,
//                 ),

//                 const SizedBox(height: 28),

//                 CustomButton(text: 'Login', onTap: () {}, height: 6.h),

//                 const SizedBox(height: 24),

//                 // // const _DividerWithText(text: 'OR'),

//                 // const SizedBox(height: 24),

//                 // _GoogleLoginButton(onTap: () {}),

//                 // const SizedBox(height: 40),

//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.center,
//                 //   children: [
//                 //     Text(
//                 //       "Don't have an account? ",
//                 //       style: Theme.of(context).textTheme.bodyMedium,
//                 //     ),
//                 //     GestureDetector(
//                 //       onTap: () {
//                 //         print("button tabbed");
//                 //       },
//                 //       child: Text(
//                 //         "Sign Up",
//                 //         style: Theme.of(
//                 //           context,
//                 //         ).textTheme.bodyMedium?.copyWith(color: Colors.blue),
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 // const SizedBox(height: 24),

//                 Text(
//                   'By continuing, you agree to our Terms & Privacy Policy',
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.bodySmall,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // class _GoogleLoginButton extends StatelessWidget {
// //   final VoidCallback onTap;

// //   const _GoogleLoginButton({required this.onTap});

// //   @override
// //   Widget build(BuildContext context) {
// //     return OutlinedButton(
// //       onPressed: onTap,
// //       style: OutlinedButton.styleFrom(
// //         side: BorderSide(color: Theme.of(context).colorScheme.secondary),
// //         minimumSize: Size(double.infinity, 6.h),
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       ),
// //       child: Text(
// //         'Continue with Google',
// //         style: Theme.of(context).textTheme.bodyMedium,
// //       ),
// //     );
// //   }
// // }



// class _AppLogo extends StatelessWidget {
//   const _AppLogo();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 110,
//       width: 110,
//       decoration: const BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
//       ),
//       alignment: Alignment.center,
//       child: Text(
//         'B',
//         style: TextStyle(fontSize: 28.sp, color: Colors.black),
//       ),
//     );
//   }
// }

// // class _DividerWithText extends StatelessWidget {
// //   final String text;

// //   const _DividerWithText({required this.text});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       children: [
// //         const Expanded(child: Divider(color: Colors.blueGrey, thickness: 1)),
// //         const SizedBox(width: 12),
// //         Text(
// //           text,
// //           style: GoogleFonts.poppins(
// //             fontSize: 13.sp,
// //             color: AppColors.textSecondary,
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //         const SizedBox(width: 12),
// //         const Expanded(child: Divider(color: Colors.blueGrey, thickness: 1)),
// //       ],
// //     );
// //   }
// // }
