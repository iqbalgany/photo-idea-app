import 'package:get/get.dart';
import 'package:photo_idea_app/common/enums.dart';
import 'package:photo_idea_app/data/datasources/local_photo_data_source.dart';
import 'package:photo_idea_app/data/models/photo_model.dart';

class SavePhotoController extends GetxController {
  final _state = SavePhotoState().obs;
  SavePhotoState get state => _state.value;
  set state(SavePhotoState n) => _state.value = n;

  Future<SavePhotoState> save(PhotoModel photo) async {
    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
    );

    final (success, message) = await LocalPhotoDataSource.savePhoto(photo);

    state = state.copyWith(
      fetchStatus: success ? FetchStatus.success : FetchStatus.failed,
      message: message,
    );

    return state;
  }

  Future<SavePhotoState> unsave(int id) async {
    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
    );

    final (success, message) = await LocalPhotoDataSource.unsavePhoto(id);

    state = state.copyWith(
      fetchStatus: success ? FetchStatus.success : FetchStatus.failed,
      message: message,
    );

    return state;
  }

  static delete() {
    Get.delete<SavePhotoController>(force: true);
  }
}

class SavePhotoState {
  final FetchStatus fetchStatus;
  final String message;

  SavePhotoState({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
  });

  SavePhotoState copyWith({
    FetchStatus? fetchStatus,
    String? message,
  }) {
    return SavePhotoState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
    );
  }
}
