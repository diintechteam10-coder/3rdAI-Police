// import 'package:flutter/material.dart';

// class AgriAiAssistantScreen extends StatelessWidget {
//   const AgriAiAssistantScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F1),
//       appBar: AppBar(
//         title: const Text("AI Krishi Expert", style: TextStyle(color: Color(0xFF2E7D32))),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 _buildBotMessage("Namaste! Kaise hain aap? Main aapki fasal (crops) ki dekhbhal mein madad kar sakta hoon."),
//                 _buildUserMessage("Meri tamatar ki fasal mein kide lag rahe hain, kya karoon?"),
//                 _buildBotMessage("K कृपया fasal ki ek photo kheench kar bhejein, taaki main bimari pehchan sakoon."),
//               ],
//             ),
//           ),
//           _buildChatInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildBotMessage(String text) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(15),
//             topRight: Radius.circular(15),
//             bottomRight: Radius.circular(15),
//           ),
//           border: Border.all(color: Colors.green.withOpacity(0.1)),
//         ),
//         child: Text(text, style: const TextStyle(fontSize: 14)),
//       ),
//     );
//   }

//   Widget _buildUserMessage(String text) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: const Color(0xFFE8F5E9),
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(15),
//             topRight: Radius.circular(15),
//             bottomLeft: Radius.circular(15),
//           ),
//         ),
//         child: Text(text, style: const TextStyle(fontSize: 14)),
//       ),
//     );
//   }

//   Widget _buildChatInput() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
//       ),
//       child: Row(
//         children: [
//           IconButton(icon: const Icon(Icons.camera_alt, color: Colors.green), onPressed: () {}),
//           Expanded(
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: "Sawal puchein...",
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
//                 fillColor: Colors.grey[100],
//                 filled: true,
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//               ),
//             ),
//           ),
//           IconButton(icon: const Icon(Icons.mic, color: Colors.green), onPressed: () {}),
//           IconButton(icon: const Icon(Icons.send, color: Colors.green), onPressed: () {}),
//         ],
//       ),
//     );
//   }
// }
