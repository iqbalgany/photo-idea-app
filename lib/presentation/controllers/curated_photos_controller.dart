// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get/get.dart';
import 'package:photo_idea_app/common/enums.dart';
import 'package:photo_idea_app/data/datasources/remote_photo_data_source.dart';
import 'package:photo_idea_app/data/models/photo_model.dart';

class CuratedPhotosController extends GetxController {
  final _state = CuratedPhotosState().obs;
  CuratedPhotosState get state => _state.value;
  set state(CuratedPhotosState n) => _state.value = n;

  void reset() {
    state = CuratedPhotosState();
    fetchRequest();
  }

  Future<void> fetchRequest() async {
    if (!state.hasMore) return;

    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
      currentPage: state.currentPage + 1,
    );

    final (success, message, newList) =
        await RemotePhotoDataSource.fetchCurated(
      state.currentPage,
      10,
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
      list: [...state.list, ...newList!],
      hasMore: newList.isNotEmpty,
    );
  }

  static delete() {
    Get.delete<CuratedPhotosController>(force: true);
  }
}

class CuratedPhotosState {
  final FetchStatus fetchStatus;
  final String message;
  final List<PhotoModel> list;
  final int currentPage;
  final bool hasMore;

  CuratedPhotosState({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
    this.list = const [],
    this.currentPage = 0,
    this.hasMore = true,
  });

  CuratedPhotosState copyWith({
    FetchStatus? fetchStatus,
    String? message,
    List<PhotoModel>? list,
    int? currentPage,
    bool? hasMore,
  }) {
    return CuratedPhotosState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
      list: list ?? this.list,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
