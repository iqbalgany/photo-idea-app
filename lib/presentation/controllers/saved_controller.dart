import 'package:get/get.dart';
import 'package:photo_idea_app/common/enums.dart';
import 'package:photo_idea_app/data/datasources/local_photo_data_source.dart';
import 'package:photo_idea_app/data/models/photo_model.dart';

class SavedController extends GetxController {
  final _state = SavedState().obs;
  SavedState get state => _state.value;
  set state(SavedState n) => _state.value = n;

  Future<void> fetchRequest() async {
    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
    );

    final (
      success,
      message,
      list,
    ) = await LocalPhotoDataSource.fetchAll();

    state = state.copyWith(
      fetchStatus: success ? FetchStatus.success : FetchStatus.failed,
      message: message,
      list: list,
    );
  }

  static delete() {
    Get.delete<SavedController>(force: true);
  }
}

class SavedState {
  final FetchStatus fetchStatus;
  final String message;
  final List<PhotoModel>? list;

  SavedState({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
    this.list,
  });

  SavedState copyWith({
    FetchStatus? fetchStatus,
    String? message,
    List<PhotoModel>? list,
  }) {
    return SavedState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
      list: list ?? this.list,
    );
  }
}
