import 'package:get/get.dart';
import 'package:photo_idea_app/common/enums.dart';
import 'package:photo_idea_app/data/datasources/local_photo_data_source.dart';

class IsSavedController extends GetxController {
  final _state = IsSavedState().obs;
  IsSavedState get state => _state.value;
  set state(IsSavedState n) => _state.value = n;

  Future<void> executeRequest(int id) async {
    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
    );

    final (
      success,
      message,
      isSaved,
    ) = await LocalPhotoDataSource.checkIsSave(id);

    state = state.copyWith(
      fetchStatus: success ? FetchStatus.success : FetchStatus.failed,
      message: message,
      status: isSaved,
    );
  }

  static delete() {
    Get.delete<IsSavedController>(force: true);
  }
}

class IsSavedState {
  final FetchStatus fetchStatus;
  final String message;
  final bool status;

  IsSavedState({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
    this.status = false,
  });

  IsSavedState copyWith({
    FetchStatus? fetchStatus,
    String? message,
    bool? status,
  }) {
    return IsSavedState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}
