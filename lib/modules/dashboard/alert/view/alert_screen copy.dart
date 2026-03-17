// import 'package:flutter/material.dart';
// import 'common_filter_screen.dart';

// class AlertScreen extends StatefulWidget {
//   const AlertScreen({super.key});

//   @override
//   State<AlertScreen> createState() => _AlertScreenState();
// }

// class _AlertScreenState extends State<AlertScreen> {
//   int _selectedTab = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Color(0xFF0B1E3A), Color(0xFF1F3F66)],
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor:
//             Colors.transparent, // Ensures Scaffold doesn't block background
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const SizedBox(height: 16),
//                   const HeaderSection(),
//                   const SizedBox(height: 18),
//                   TabSwitcher(
//                     selectedIndex: _selectedTab,
//                     onTabChanged: (index) {
//                       setState(() {
//                         _selectedTab = index;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 18),
//                   if (_selectedTab == 0)
//                     const DeviceAlertCard()
//                   else
//                     Column(
//                       children: const [
//                         CitizenStatusChips(),
//                         SizedBox(height: 18),
//                         CitizenReportCard(),
//                       ],
//                     ),
//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class HeaderSection extends StatelessWidget {
//   const HeaderSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           'Alert Command Center',
//           style: TextStyle(
//             color: Color(0xFFFFFFFF),
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             fontFamily: 'Poppins',
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 Routepages
//               ),
//             );
//           },
//           child: const Icon(
//             Icons.filter_list,
//             color: Color(0xFFFFFFFF),
//             size: 24,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class TabSwitcher extends StatelessWidget {
//   final int selectedIndex;
//   final ValueChanged<int> onTabChanged;

//   const TabSwitcher({
//     super.key,
//     required this.selectedIndex,
//     required this.onTabChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 46,
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: const Color(0xFF0D2445),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFF2A4C86)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: GestureDetector(
//               onTap: () => onTabChanged(0),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 decoration: BoxDecoration(
//                   color: selectedIndex == 0
//                       ? const Color(0xFF2A4C86)
//                       : Colors.transparent,
//                   borderRadius: selectedIndex == 0
//                       ? BorderRadius.circular(8)
//                       : BorderRadius.zero,
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   'Device Alert',
//                   style: TextStyle(
//                     color: selectedIndex == 0
//                         ? const Color(0xFFFFFFFF)
//                         : const Color(0xFFB0C4DE),
//                     fontWeight: FontWeight.w500,
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: GestureDetector(
//               onTap: () => onTabChanged(1),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 decoration: BoxDecoration(
//                   color: selectedIndex == 1
//                       ? const Color(0xFF2A4C86)
//                       : Colors.transparent,
//                   borderRadius: selectedIndex == 1
//                       ? BorderRadius.circular(8)
//                       : BorderRadius.zero,
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   'Citizen Reports',
//                   style: TextStyle(
//                     color: selectedIndex == 1
//                         ? const Color(0xFFFFFFFF)
//                         : const Color(0xFFB0C4DE),
//                     fontWeight: FontWeight.w500,
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DeviceAlertCard extends StatelessWidget {
//   const DeviceAlertCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: const Color(0xFFE6D6CF),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             width: 3,
//             height: 60,
//             decoration: BoxDecoration(
//               color: const Color(0xFFFF3B30),
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(width: 14),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Container(
//               width: 60,
//               height: 60,
//               color: Colors.black12,
//               child: Image.network(
//                 'https://images.unsplash.com/photo-1555616654-21952e464c23?q=80&w=200&auto=format&fit=crop',
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) =>
//                     const Icon(Icons.videocam_off, color: Colors.grey),
//               ),
//             ),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Camera Offline',
//                       style: TextStyle(
//                         color: Color(0xFF222222),
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Poppins',
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 6,
//                         vertical: 2,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFFD6D6),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Text(
//                         'Critical',
//                         style: TextStyle(
//                           color: Color(0xFFFF3B30),
//                           fontSize: 12,
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 2),
//                 const Text(
//                   'Connectivity • 2 min ago',
//                   style: TextStyle(
//                     color: Color(0xFF555555),
//                     fontSize: 13,
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Row(
//                       children: const [
//                         Icon(
//                           Icons.location_on,
//                           color: Color(0xFFFF3B30),
//                           size: 14,
//                         ),
//                         SizedBox(width: 4),
//                         Text(
//                           'Hazratganj',
//                           style: TextStyle(
//                             color: Color(0xFF555555),
//                             fontSize: 13,
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: const [
//                         Text(
//                           'View Details',
//                           style: TextStyle(
//                             color: Color(0xFF666666),
//                             fontSize: 13,
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                         Icon(
//                           Icons.chevron_right,
//                           color: Color(0xFF666666),
//                           size: 16,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CitizenStatusChips extends StatelessWidget {
//   const CitizenStatusChips({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: [
//           _buildChip(
//             'Reported',
//             const Color(0xFFFFFFFF),
//             const Color(0xFFFF6F00),
//             FontWeight.w500,
//           ),
//           const SizedBox(width: 10),
//           _buildChip(
//             'Under Review',
//             const Color(0xFFBDBDBD),
//             const Color(0xFFFFFFFF),
//             FontWeight.normal,
//           ),
//           const SizedBox(width: 10),
//           _buildChip(
//             'Verified',
//             const Color(0xFFBDBDBD),
//             const Color(0xFFFFFFFF),
//             FontWeight.normal,
//           ),
//           const SizedBox(width: 10),
//           _buildChip(
//             'Action Taken',
//             const Color(0xFFBDBDBD),
//             const Color(0xFFFFFFFF),
//             FontWeight.normal,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChip(
//     String label,
//     Color bgColor,
//     Color textColor,
//     FontWeight weight,
//   ) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           color: textColor,
//           fontSize: 14,
//           fontWeight: weight,
//           fontFamily: 'Poppins',
//         ),
//       ),
//     );
//   }
// }

// class CitizenReportCard extends StatelessWidget {
//   const CitizenReportCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFE7DED5),
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             width: 3,
//             height: 60,
//             decoration: BoxDecoration(
//               color: const Color(0xFFFF4D4F),
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Snatching',
//                       style: TextStyle(
//                         color: Color(0xFF222222),
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Poppins',
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFFE8D6),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Row(
//                         children: const [
//                           Icon(
//                             Icons.history,
//                             color: Color(0xFFFF6F00),
//                             size: 14,
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             'Reported',
//                             style: TextStyle(
//                               color: Color(0xFFFF6F00),
//                               fontSize: 12,
//                               fontFamily: 'Poppins',
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 2),
//                 const Text(
//                   'Laxmi Nagar',
//                   style: TextStyle(
//                     color: Color(0xFF555555),
//                     fontSize: 14,
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     const Text(
//                       'Today 1:10 PM',
//                       style: TextStyle(
//                         color: Color(0xFF777777),
//                         fontSize: 13,
//                         fontFamily: 'Poppins',
//                       ),
//                     ),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: const [
//                         Text(
//                           'View',
//                           style: TextStyle(
//                             color: Color(0xFF333333),
//                             fontSize: 14,
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                         Icon(
//                           Icons.chevron_right,
//                           color: Color(0xFF333333),
//                           size: 18,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
