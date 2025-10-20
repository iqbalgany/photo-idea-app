import 'package:get/get.dart';
import 'package:photo_idea_app/common/enums.dart';
import 'package:photo_idea_app/data/datasources/remote_photo_data_source.dart';
import 'package:photo_idea_app/data/models/photo_model.dart';

class SearchPhotosController extends GetxController {
  final _state = SearchPhotosState().obs;
  SearchPhotosState get state => _state.value;
  set state(SearchPhotosState n) => _state.value = n;

  void research(String query) {
    state = SearchPhotosState();
    fetchRequest(query);
  }

  Future<void> fetchRequest(String query) async {
    if (!state.hasMore) return;

    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
      currentPage: state.currentPage + 1,
    );

    final (success, message, newList) = await RemotePhotoDataSource.search(
      query,
      state.currentPage,
      20,
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
    Get.delete<SearchPhotosController>(force: true);
  }
}

class SearchPhotosState {
  final FetchStatus fetchStatus;
  final String message;
  final List<PhotoModel> list;
  final int currentPage;
  final bool hasMore;

  SearchPhotosState({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
    this.list = const [],
    this.currentPage = 0,
    this.hasMore = true,
  });

  SearchPhotosState copyWith({
    FetchStatus? fetchStatus,
    String? message,
    List<PhotoModel>? list,
    int? currentPage,
    bool? hasMore,
  }) {
    return SearchPhotosState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
      list: list ?? this.list,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
