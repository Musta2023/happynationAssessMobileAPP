import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/models/assessment_analytics.dart';

class AssessmentAnalyticsState {
  final AsyncValue<AssessmentAnalytics> analytics;

  AssessmentAnalyticsState({
    this.analytics = const AsyncValue.loading(),
  });

  AssessmentAnalyticsState copyWith({
    AsyncValue<AssessmentAnalytics>? analytics,
  }) {
    return AssessmentAnalyticsState(
      analytics: analytics ?? this.analytics,
    );
  }
}

final assessmentAnalyticsProvider = StateNotifierProvider.family<
    AssessmentAnalyticsNotifier, AssessmentAnalyticsState, String>(
  (ref, assessmentId) => AssessmentAnalyticsNotifier(assessmentId),
);

class AssessmentAnalyticsNotifier extends StateNotifier<AssessmentAnalyticsState> {
  final String _assessmentId;
  final ApiClient _apiClient = Get.find<ApiClient>();

  AssessmentAnalyticsNotifier(this._assessmentId)
      : super(AssessmentAnalyticsState()) {
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    state = state.copyWith(analytics: const AsyncValue.loading());
    try {
      final response = await _apiClient.getAssessmentAnalytics(_assessmentId);
      final analytics = AssessmentAnalytics.fromJson(response.data);
      state = state.copyWith(analytics: AsyncValue.data(analytics));
    } on DioException catch (e, st) {
      state = state.copyWith(analytics: AsyncValue.error(e, st));
    } catch (e, st) {
      state = state.copyWith(analytics: AsyncValue.error(e, st));
    }
  }
}
