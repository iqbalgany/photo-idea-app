import 'package:d_info/d_info.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:photo_idea_app/common/enums.dart';
import 'package:photo_idea_app/data/models/photo_model.dart';
import 'package:photo_idea_app/presentation/controllers/detail_photo_controller.dart';
import 'package:photo_idea_app/presentation/controllers/is_saved_controller.dart';
import 'package:photo_idea_app/presentation/controllers/recommendation_photo_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPhotoPage extends StatefulWidget {
  const DetailPhotoPage({super.key, required this.id});
  final int id;

  static const routeName = '/photo/detail';

  @override
  State<DetailPhotoPage> createState() => _DetailPhotoPageState();
}

class _DetailPhotoPageState extends State<DetailPhotoPage> {
  final detailPhotoController = Get.put(DetailPhotoController());
  final isSavedController = Get.put(IsSavedController());
  final recommendationPhotoController =
      Get.put(RecommendationPhotosController());

  void openURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      DInfo.toastError('Could not launch URL');
    }
  }

  void fetchDetail() {
    detailPhotoController.fetch(widget.id).then((photo) {
      if (photo == null) return;

      fetchRecommendation(photo.alt ?? '');
    });
  }

  void fetchRecommendation(String query) {
    recommendationPhotoController.fetchRequest(query);
  }

  void checkIsSaved() {
    isSavedController.executeRequest(widget.id);
  }

  @override
  void initState() {
    fetchDetail();
    checkIsSaved();
    super.initState();
  }

  @override
  void dispose() {
    RecommendationPhotosController.delete();
    DetailPhotoController.delete();
    IsSavedController.delete();
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
                          buildPreview(photo.source?.original ?? ''),
                          buildSaveButton(),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: buildOpenOnPexels(photo.url ?? ''),
                    ),
                  ],
                ),
              ),
              Gap(20),
              buildDescription(photo.alt ?? ''),
              buildPhotographer(
                photo.photographer ?? '',
                photo.photographerUrl ?? '',
              ),
              Gap(20),
              buildRecommendation(),
              Gap(20),
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

  Widget buildPreview(String imageURL) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => Stack(
            children: [
              Positioned.fill(
                  child: InteractiveViewer(
                      child: ExtendedImage.network(imageURL))),
              Align(
                alignment: Alignment.topCenter,
                child: CloseButton(
                  color: Colors.white,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black38),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      color: Colors.white,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.black38),
      ),
      icon: Icon(Icons.visibility),
    );
  }

  Widget buildSaveButton() {
    return Obx(() {
      final isSaved = isSavedController.state.status;
      return IconButton(
        onPressed: () {
          if (isSaved) {
            // remove
          } else {
            // insert
          }
        },
        color: Colors.white,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.black38),
        ),
        icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
      );
    });
  }

  Widget buildOpenOnPexels(String url) {
    return GestureDetector(
      onTap: () => openURL(url),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: Colors.black38,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          'Open on Pexels',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildDescription(String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        description == '' ? 'no description' : description,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Colors.black45,
        ),
      ),
    );
  }

  Widget buildPhotographer(String name, String url) {
    return ListTile(
      leading: Icon(
        Icons.account_circle,
        size: 48,
        color: Colors.grey,
      ),
      horizontalTitleGap: 10,
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: GestureDetector(
        onTap: () => openURL(url),
        child: Text(
          'See Profile on Pexels',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black38,
            decoration: TextDecoration.underline,
            decorationThickness: 0.5,
          ),
        ),
      ),
    );
  }

  Widget buildRecommendation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'More like this',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Gap(12),
        Obx(
          () {
            final state = recommendationPhotoController.state;
            if (state.fetchStatus == FetchStatus.init) {
              return SizedBox();
            }
            if (state.fetchStatus == FetchStatus.loading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state.fetchStatus == FetchStatus.failed) {
              return Center(child: Text('No Recommendation'));
            }
            final list = state.list;
            return SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: list.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(right: 16),
                itemBuilder: (context, index) {
                  final photo = list[index];
                  return Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 16 : 8),
                    child: buildRecommendationItem(photo),
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }

  Widget buildRecommendationItem(PhotoModel photo) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ExtendedImage.network(
          photo.source?.medium ?? "",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
