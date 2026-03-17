import 'package:equatable/equatable.dart';

class FeedbackModel extends Equatable {
  final String id;
  final String userName;
  final String message;
  final double rating;
  final String? userImage;

  const FeedbackModel({
    required this.id,
    required this.userName,
    required this.message,
    required this.rating,
    this.userImage,
  });

  FeedbackModel copyWith({
    String? id,
    String? userName,
    String? message,
    double? rating,
    String? userImage,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      message: message ?? this.message,
      rating: rating ?? this.rating,
      userImage: userImage ?? this.userImage,
    );
  }

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] ?? '',
      userName: json['user_name'] ?? '',
      message: json['message'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      userImage: json['user_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'message': message,
      'rating': rating,
      'user_image': userImage,
    };
  }

  @override
  List<Object?> get props => [id, userName, message, rating, userImage];
}