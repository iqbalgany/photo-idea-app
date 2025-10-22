import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_idea_app/common/enums.dart';
import 'package:photo_idea_app/presentation/controllers/detail_photo_controller.dart';

class DetailPhotoPage extends StatefulWidget {
  const DetailPhotoPage({super.key, required this.id});
  final int id;

  static const routeName = '/photo/detail';

  @override
  State<DetailPhotoPage> createState() => _DetailPhotoPageState();
}

class _DetailPhotoPageState extends State<DetailPhotoPage> {
  final detailPhotoController = Get.put(DetailPhotoController());

  void fetchDetail() {
    detailPhotoController.fetch(widget.id);
  }

  @override
  void initState() {
    fetchDetail();
    super.initState();
  }

  @override
  void dispose() {
    DetailPhotoController.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          final state = detailPhotoController.state;
          if (state.fetchStatus == FetchStatus.init) {
            return const SizedBox();
          }
          if (state.fetchStatus == FetchStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.fetchStatus == FetchStatus.failed) {
            return Center(child: Text(state.message));
          }
          final photo = state.data!;
          return ListView(
            padding: EdgeInsets.all(0),
            children: [
              AspectRatio(
                aspectRatio: 0.8,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    buildImage(photo.source?.large2X ?? ''),
                    Positioned(
                      top: 60,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: [
                          buildBackButton(),
                          Spacer(),
                          buildPreview(),
                          buildSaveButton(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildImage(String imageUrl) {
    return ExtendedImage.network(
      imageUrl,
      fit: BoxFit.cover,
    );
  }

  Widget buildBackButton() {
    return BackButton(
      color: Colors.white,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.black38),
      ),
    );
  }

  Widget buildPreview() {
    return IconButton(onPressed: () {}, icon: Icon(Icons.visibility));
  }

  Widget buildSaveButton() {
    return BackButton(
      color: Colors.white,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.black38),
      ),
    );
  }
}
