import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return Scaffold();
  }
}
