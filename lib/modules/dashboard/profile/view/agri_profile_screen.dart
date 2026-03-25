import 'package:flutter/material.dart';

class AgriProfileScreen extends StatelessWidget {
  const AgriProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F1),
      appBar: AppBar(
        title: const Text("Kisan Profile", style: TextStyle(color: Color(0xFF2E7D32))),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF2E7D32)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFE8F5E9),
              child: Icon(Icons.person, size: 60, color: Color(0xFF2E7D32)),
            ),
            const SizedBox(height: 16),
            const Text("Aman Kumar", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("Farmer ID: #AGRI9876", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            _buildProfileItem(Icons.landscape, "Land Info", "5 Acres - Wheat"),
            _buildProfileItem(Icons.location_on, "Location", "New Delhi, India"),
            _buildProfileItem(Icons.language, "Bhasha (Language)", "Hindi / Hinglish"),
            _buildProfileItem(Icons.notifications, "Notifications", "On"),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // Reuse existing logout logic if available
                Navigator.of(context).pushReplacementNamed('/login'); // Assuming route exists
              },
              child: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 22),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}
