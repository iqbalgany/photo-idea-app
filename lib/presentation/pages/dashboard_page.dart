import 'package:fd_log/fd_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_idea_app/core/di.dart';
import 'package:photo_idea_app/presentation/pages/fragments/home_fragment.dart';
import 'package:photo_idea_app/presentation/pages/fragments/saved_fragment.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final indexFragment = RxInt(0);

  final menuBottomNav = [Icons.home, Icons.bookmark];

  @override
  void initState() {
    sl<FDLog>().title('title', 'body');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: indexFragment.value,
          children: [
            HomeFragment(),
            SavedFragment(),
          ],
        );
      }),
      resizeToAvoidBottomInset: false,
      extendBody: true,
      bottomNavigationBar: buildBottomNav(),
    );
  }

  Widget buildBottomNav() {
    final primaryColor = Theme.of(context).primaryColor;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 6,
              color: Colors.black26,
            ),
          ],
        ),
        child: Obx(() {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              menuBottomNav.length,
              (index) {
                final bool isActive = indexFragment == index;
                return RawMaterialButton(
                  onPressed: () {
                    indexFragment.value = index;
                  },
                  elevation: isActive ? 8 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  constraints: BoxConstraints.tightFor(
                    height: 54,
                    width: 54,
                  ),
                  fillColor: isActive ? primaryColor : Colors.white,
                  child: Icon(
                    menuBottomNav[index],
                    color:
                        isActive ? Colors.white : primaryColor.withOpacity(0.5),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
