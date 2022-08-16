import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/app_controller.dart';
import '../../../Util/App_components.dart';

class Resources extends StatefulWidget {
  const Resources({Key? key}) : super(key: key);

  @override
  State<Resources> createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
  final controller = Get.put(AppController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor:
            controller.isDark.value ? Colors.grey[900] : Colors.white,
        appBar: AppBar(
          // leading: const Icon(Icons.home, size: 20,color: Colors.black87,),
          backgroundColor: 
              controller.isDark.value ? Colors.grey[900] : Colors.white,
          title: Components.header_1("Resources",),
          elevation: 0,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Components.showDividerLine(),
                  ),
                  Components.resourceListCard(context),
                ],
              ),
            )),
      ),);
  }
}
