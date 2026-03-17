// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sizer/sizer.dart';

// import '../../../core/constants/app_colors.dart';
// import '../alert/view/alert_screen.dart';
// import '../home/view/home_screen.dart';
// import '../profile/view/profile_screen.dart';
// import '../requests/view/request_screen.dart';
// import 'bottom nav bloc/bottom_nav_bloc.dart';
// import 'bottom nav bloc/bottom_nav_event.dart';
// import 'bottom nav bloc/bottom_nav_state.dart';

// class BottomNavView extends StatefulWidget {
//   const BottomNavView({super.key});

//   @override
//   State<BottomNavView> createState() => _BottomNavViewState();
// }

// class _BottomNavViewState extends State<BottomNavView> {
//   late final List<Widget> _pages;

//   @override
//   void initState() {
//     super.initState();
//     _pages = [
//       const HomeScreen(),
//       const AlertScreen(),
//       const _TabPage(title: "Comming Soon"),
//       const RequestScreen(),
//       const ProfileScreen(),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BottomNavBloc, BottomNavState>(
//       builder: (context, state) {
//         return Scaffold(
//           resizeToAvoidBottomInset: false,
//           body: IndexedStack(index: state.currentIndex, children: _pages),

//           bottomNavigationBar: Container(
//             height: 80, // 🔥 increased height
//             decoration: BoxDecoration(color: Color(0xFF031733)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 /// Home
//                 _navItem(
//                   context,
//                   icon: Icons.home_outlined,
//                   activeIcon: Icons.home,
//                   label: "Home",
//                   index: 0,
//                   currentIndex: state.currentIndex,
//                 ),

//                 /// Alerts
//                 _navItem(
//                   context,
//                   icon: Icons.notifications_none,
//                   activeIcon: Icons.notifications,
//                   label: "Alerts",
//                   index: 1,
//                   currentIndex: state.currentIndex,
//                 ),

//                 /// 🔥 CENTER BIG POP ITEM
//                 _navItem(
//                   context,
//                   index: 2,
//                   currentIndex: state.currentIndex,
//                 ),

//                 /// Requests
//                 _navItem(
//                   context,
//                   icon: Icons.assignment_outlined,
//                   activeIcon: Icons.assignment,
//                   label: "Requests",
//                   index: 3,
//                   currentIndex: state.currentIndex,
//                 ),

//                 /// Profile
//                 _navItem(
//                   context,
//                   icon: Icons.person_outline,
//                   activeIcon: Icons.person,
//                   label: "Profile",
//                   index: 4,
//                   currentIndex: state.currentIndex,
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   static Widget _navItem(
//     BuildContext context, {
//     required IconData icon,
//     required IconData activeIcon,
//     required String label,
//     required int index,
//     required int currentIndex,
//   }) {
//     final isSelected = index == currentIndex;

//     return GestureDetector(
//       onTap: () {
//         context.read<BottomNavBloc>().add(BottomNavTabChanged(index));
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFFFFA24C) : Colors.transparent,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               isSelected ? activeIcon : icon,
//               color: isSelected ? Colors.white : Colors.white54,
//               size: 22,
//             ),

//             if (isSelected) ...[
//               const SizedBox(width: 6),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   // static Widget _centerNavItem(
//   //   BuildContext context, {
//   //   required int index,
//   //   required int currentIndex,
//   // }) {
//   //   final isSelected = index == currentIndex;

//   //   return GestureDetector(
//   //     onTap: () {
//   //       context.read<BottomNavBloc>().add(BottomNavTabChanged(index));
//   //     },
//   //     child: Transform.translate(
//   //       offset: const Offset(0, -18),
//   //       child: Container(
//   //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//   //         decoration: BoxDecoration(
//   //           borderRadius: BorderRadius.circular(12),
//   //           gradient: LinearGradient(
//   //             colors: isSelected
//   //                 ? [const Color(0xFFFF8A00), const Color(0xFFFF4D00)]
//   //                 : [Colors.transparent, Colors.transparent],
//   //           ),
//   //           boxShadow: isSelected
//   //               ? [
//   //                   BoxShadow(
//   //                     color: const Color(0xFFFF6A00).withOpacity(0.35),
//   //                     blurRadius: 12,
//   //                     spreadRadius: 1,
//   //                     offset: const Offset(0, 4),
//   //                   ),
//   //                 ]
//   //               : [],
//   //         ),
//   //         child: Row(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: [
//   //             Image.asset(
//   //               isSelected
//   //                   ? 'assets/icons/ri_ai.png'
//   //                   : 'assets/icons/ri_ai (1).png',
//   //               width: 20,
//   //               height: 20,
//   //               color: isSelected ? Colors.white : const Color(0xFFFFA726),
//   //             ),
//   //             const SizedBox(width: 4),
//   //             const Text(
//   //               "AI",
//   //               style: TextStyle(
//   //                 fontWeight: FontWeight.w600,
//   //                 fontSize: 16,
//   //                 color: Color(0xFFFFA726),
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//   // // static Widget _centerNavItem(
//   //   BuildContext context, {
//   //   required IconData icon,
//   //   required int index,
//   //   required int currentIndex,
//   // }) {
//   //   final isSelected = index == currentIndex;

//   //   return GestureDetector(
//   //     onTap: () {
//   //       context.read<BottomNavBloc>().add(BottomNavTabChanged(index));
//   //     },
//   //     child: Transform.translate(
//   //       offset: const Offset(0, -25),
//   //       child: AnimatedContainer(
//   //         duration: const Duration(milliseconds: 250),
//   //         height: 65,
//   //         width: 65,
//   //         decoration: BoxDecoration(
//   //           shape: BoxShape.circle,
//   //           gradient: const LinearGradient(
//   //             colors: [Color(0xFF7B61FF), Color(0xFF5B4DFF)],
//   //           ),
//   //           boxShadow: [
//   //             BoxShadow(
//   //               color: const Color(0xFF6C63FF).withOpacity(0.6),
//   //               blurRadius: 20,
//   //               spreadRadius: 2,
//   //               offset: const Offset(0, 8),
//   //             ),
//   //           ],
//   //         ),
//   //         child: Icon(icon, size: 28, color: Colors.white),
//   //       ),
//   //     ),
//   //   );
//   // }
// }

// class _TabPage extends StatelessWidget {
//   final String title;

//   const _TabPage({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         title,
//         style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }
