import 'package:get/get.dart';
import 'package:photo_idea_app/common/enums.dart';
import 'package:photo_idea_app/data/datasources/remote_photo_data_source.dart';
import 'package:photo_idea_app/data/models/photo_model.dart';

class RecommendationPhotosController extends GetxController {
  final _state = RecommendationPhotosState().obs;
  RecommendationPhotosState get state => _state.value;
  set state(RecommendationPhotosState n) => _state.value = n;

  Future<void> fetchRequest(String query) async {
    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
    );

    final (success, message, newList) = await RemotePhotoDataSource.search(
      query,
      1,
      8,
    );

    if (!success) {
      state = state.copyWith(
        fetchStatus: FetchStatus.failed,
        message: message,
      );
      return;
    }

    state = state.copyWith(
      fetchStatus: FetchStatus.success,
      message: message,
      list: newList,
    );
  }

  static delete() {
    Get.delete<RecommendationPhotosController>(force: true);
  }
}

class RecommendationPhotosState {
  final FetchStatus fetchStatus;
  final String message;
  final List<PhotoModel> list;

  RecommendationPhotosState({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
    this.list = const [],
  });

  RecommendationPhotosState copyWith({
    FetchStatus? fetchStatus,
    String? message,
    List<PhotoModel>? list,
    int? currentPage,
    bool? hasMore,
  }) {
    return RecommendationPhotosState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
      list: list ?? this.list,
    );
  }
}
