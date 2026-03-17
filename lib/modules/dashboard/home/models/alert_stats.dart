import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AlertStatModel extends Equatable {
  final String id;
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const AlertStatModel({
    required this.id,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  AlertStatModel copyWith({
    String? id,
    String? title,
    int? count,
    IconData? icon,
    Color? color,
  }) {
    return AlertStatModel(
      id: id ?? this.id,
      title: title ?? this.title,
      count: count ?? this.count,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  factory AlertStatModel.fromJson(Map<String, dynamic> json) {
    return AlertStatModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      count: json['count'] ?? 0,
      icon: Icons.notifications, // backend usually icon nahi deta
      color: Colors.blue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'count': count,
    };
  }

  @override
  List<Object?> get props => [id, title, count, icon, color];
}