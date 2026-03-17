

import '../models/alert_stats.dart';
import '../models/feedback_model.dart';
import '../models/request_stats.dart';

class HomeState {
  final bool isLoading;
  final List<AlertStatModel> alerts;
  final List<RequestStatModel> requests;
  final List<FeedbackModel> feedback;
  final List<String> banners;
  final String? error;

  HomeState({
    this.isLoading = false,
    this.alerts = const [],
    this.requests = const [],
    this.feedback = const [],
    this.banners = const [],
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    List<AlertStatModel>? alerts,
    List<RequestStatModel>? requests,
    List<FeedbackModel>? feedback,
    List<String>? banners,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      alerts: alerts ?? this.alerts,
      requests: requests ?? this.requests,
      feedback: feedback ?? this.feedback,
      banners: banners ?? this.banners,
      error: error,
    );
  }
}