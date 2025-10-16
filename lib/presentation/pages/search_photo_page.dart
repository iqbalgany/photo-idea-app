import 'package:d_input/d_input.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:photo_idea_app/presentation/controllers/search_photos_controller.dart';

import '../../common/enums.dart';
import '../../data/models/photo_mode.dart';

class SearchPhotoPage extends StatefulWidget {
  const SearchPhotoPage({super.key, required this.query});
  final String query;

  static const routeName = '/search';

  @override
  State<SearchPhotoPage> createState() => _SearchPhotoPageState();
}

class _SearchPhotoPageState extends State<SearchPhotoPage> {
  final queryController = TextEditingController();
  final searchPhotoController = Get.put(SearchPhotosController());
  final scrollController = ScrollController();
  final showUpButton = RxBool(false);

  void startSearch() {
    final query = queryController.text;
    if (query == '') return;
    searchPhotoController.research(query);
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
    final widgetQuery = widget.query;
    if (widgetQuery != '') {
      queryController.text = widgetQuery;
      startSearch();
    }
    scrollController.addListener(() {
      // sl<FDLog>().basic(scrollController.offset.toString());
      bool reachMax =
          scrollController.offset == scrollController.position.maxScrollExtent;

      if (reachMax) {
        final query = queryController.text;
        if (query == '') return;
        searchPhotoController.fetchRequest(query);
      }

      bool passMaxheight =
          scrollController.offset > MediaQuery.sizeOf(context).height;
      showUpButton.value = passMaxheight;
    });
    super.initState();
  }

  @override
  void dispose() {
    SearchPhotosController.delete();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: buildSearch(),
      ),
      floatingActionButton: buildUpwardButton(),
      body: ListView(
        controller: scrollController,
        padding: EdgeInsets.all(0),
        children: [
          buildSearchPhotos(),
          buildLoadingOrFailed(),
          Gap(20),
        ],
      ),
    );
  }

  Widget buildSearch() {
    return DInputMix(
      controller: queryController,
      hint: 'Search photos here...',
      boxColor: Colors.white,
      inputPadding: EdgeInsets.all(4),
      prefixIcon: IconSpec(
        icon: Icons.arrow_back,
        onTap: () => Navigator.pop(context),
        boxSize: Size(40, 40),
      ),
      suffixIcon: IconSpec(
        icon: Icons.search,
        onTap: startSearch,
        boxSize: Size(40, 40),
      ),
    );
  }

  Widget buildSearchPhotos() {
    return Obx(
      () {
        final state = searchPhotoController.state;
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
    return ExtendedImage.network(
      photo.source?.medium ?? '',
      fit: BoxFit.cover,
    );
  }

  Widget buildLoadingOrFailed() {
    return Obx(
      () {
        final state = searchPhotoController.state;
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
