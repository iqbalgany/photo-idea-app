import 'package:d_input/d_input.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:photo_idea_app/common/app_constants.dart';
import 'package:photo_idea_app/common/enums.dart';
import 'package:photo_idea_app/data/models/photo_model.dart';
import 'package:photo_idea_app/presentation/controllers/curated_photos_controller.dart';
import 'package:photo_idea_app/presentation/pages/detail_photo_page.dart';
import 'package:photo_idea_app/presentation/pages/search_photo_page.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  final curatedPhotosController = Get.put(CuratedPhotosController());
  final queryController = TextEditingController();
  final scrollController = ScrollController();
  final categories = [
    'happy',
    'people',
    'trip',
    'sea',
    'friends',
    'sky',
    'business',
    'nature',
  ];

  final showUpButton = RxBool(false);

  void refresh() {
    curatedPhotosController.reset();
  }

  void gotoSearch() {
    final query = queryController.text;
    Navigator.pushNamed(
      context,
      SearchPhotoPage.routeName,
      arguments: query,
    );
  }

  void gotoDetail(PhotoModel photo) {
    Navigator.pushNamed(
      context,
      DetailPhotoPage.routeName,
      arguments: photo.id,
    );
  }

  void gotoUpPage() {
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    curatedPhotosController.fetchRequest();
    scrollController.addListener(
      () {
        // sl<FDLog>().basic(scrollController.offset.toString());
        bool reachMax = scrollController.offset ==
            scrollController.position.maxScrollExtent;
        if (reachMax) {
          curatedPhotosController.fetchRequest();
        }

        bool passMaxheight =
            scrollController.offset > MediaQuery.sizeOf(context).height;

        showUpButton.value = passMaxheight;
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    CuratedPhotosController.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator.adaptive(
          onRefresh: () async => refresh(),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.all(0),
            children: [
              buildHeader(),
              buildCategories(),
              buildCuratedPhotos(),
              buildLoadingOrFailed(),
              Gap(80),
            ],
          ),
        ),
        Positioned(
          bottom: 30,
          right: 30,
          child: buildUpwardButton(),
        ),
      ],
    );
  }

  Widget buildHeader() {
    return Stack(
      children: [
        Image.asset(
          AppConstants.homeHeaderImage,
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height * 0.6,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
          child: ColoredBox(color: Colors.black38),
        ),
        Positioned(
          left: 30,
          right: 30,
          top: 0,
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Find Something Cool',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              Gap(12),
              Text(
                'Explore your great idea\nMore and more',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              Gap(20),
              buildSearch(),
            ],
          ),
        )
      ],
    );
  }

  Widget buildSearch() {
    return DInputMix(
      controller: queryController,
      inputOnFieldSubmitted: (value) => gotoSearch(),
      hint: 'Search photo here...',
      hintStyle: TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.white60,
      ),
      inputStyle: TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
      boxColor: Colors.transparent,
      boxBorder: Border.all(
        color: Colors.white70,
      ),
      suffixIcon: IconSpec(
        icon: Icons.search,
        color: Colors.white70,
        onTap: gotoSearch,
      ),
    );
  }

  Widget buildCategories() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(right: 8),
        itemBuilder: (context, index) {
          final item = categories[index];
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 16 : 8),
            child: ActionChip(
              onPressed: () {},
              label: Text(item),
              labelStyle:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCuratedPhotos() {
    return Obx(
      () {
        final state = curatedPhotosController.state;
        if (state.fetchStatus == FetchStatus.init) {
          return const SizedBox();
        }

        final list = state.list;
        return GridView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            childAspectRatio: 1,
          ),
          padding: EdgeInsets.all(0),
          itemBuilder: (context, index) {
            final item = list[index];
            return buildPhotoItem(item);
          },
        );
      },
    );
  }

  Widget buildPhotoItem(PhotoModel photo) {
    return GestureDetector(
      onTap: () => gotoDetail(photo),
      child: ExtendedImage.network(
        photo.source?.medium ?? '',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildLoadingOrFailed() {
    return Obx(
      () {
        final state = curatedPhotosController.state;
        if (state.fetchStatus == FetchStatus.loading) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state.fetchStatus == FetchStatus.failed) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(child: Text(state.message)),
          );
        }
        if (state.fetchStatus == FetchStatus.success && !state.hasMore) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(child: Text('No More Photo.')),
          );
        }
        return SizedBox();
      },
    );
  }

  buildUpwardButton() {
    return Obx(
      () {
        if (showUpButton.value) {
          return FloatingActionButton.small(
            heroTag: 'icon_scroll_upward',
            onPressed: gotoUpPage,
            child: Icon(Icons.arrow_upward),
          );
        }
        return SizedBox();
      },
    );
  }
}
