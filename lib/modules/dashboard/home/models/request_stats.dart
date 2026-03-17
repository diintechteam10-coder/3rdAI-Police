import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RequestStatModel extends Equatable {
  final String id;
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const RequestStatModel({
    required this.id,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  RequestStatModel copyWith({
    String? id,
    String? title,
    int? count,
    IconData? icon,
    Color? color,
  }) {
    return RequestStatModel(
      id: id ?? this.id,
      title: title ?? this.title,
      count: count ?? this.count,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  factory RequestStatModel.fromJson(Map<String, dynamic> json) {
    return RequestStatModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      count: json['count'] ?? 0,
      icon: Icons.work,
      color: Colors.green,
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