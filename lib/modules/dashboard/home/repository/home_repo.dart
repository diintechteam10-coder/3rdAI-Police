import 'package:flutter/material.dart';
import '../models/alert_stats.dart';
import '../models/feedback_model.dart';
import '../models/request_stats.dart';

class HomeRepository {
  Future<Map<String, dynamic>> fetchHomeData() async {
    await Future.delayed(const Duration(seconds: 2));

    return {
      "alerts": [
        AlertStatModel(id: "1", title: "Total Alerts", count: 120, icon: Icons.notifications, color: Colors.blue),
        AlertStatModel(id: "2", title: "Active", count: 45, icon: Icons.warning, color: Colors.orange),
        AlertStatModel(id: "3", title: "Resolved", count: 75, icon: Icons.check_circle, color: Colors.green),
      ],
      "requests": [
        RequestStatModel(id: "1", title: "Pending", count: 12, icon: Icons.hourglass_bottom, color: Colors.blue),
        RequestStatModel(id: "2", title: "Approved", count: 30, icon: Icons.check, color: Colors.green),
        RequestStatModel(id: "3", title: "Rejected", count: 5, icon: Icons.close, color: Colors.red),
        RequestStatModel(id: "4", title: "In Progress", count: 8, icon: Icons.work, color: Colors.orange),
      ],
      "feedback": [
        FeedbackModel(id: "1", userName: "Rahul", message: "Great service!", rating: 4.5),
        FeedbackModel(id: "2", userName: "Aman", message: "Very fast response.", rating: 5),
      ],
      "banners": [
        "https://picsum.photos/600/300",
        "https://picsum.photos/600/301",
      ]
    };
  }
}