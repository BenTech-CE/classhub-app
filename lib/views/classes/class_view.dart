import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/api.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/views/classes/routes/class_mural_view.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ClassView extends StatefulWidget {
  final MinimalClassModel classObj;

  const ClassView({super.key, required this.classObj});

  @override
  State<ClassView> createState() => _ClassViewState();
}

class _ClassViewState extends State<ClassView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.classObj.name),
        backgroundColor: Colors.transparent,
        flexibleSpace: widget.classObj.bannerUrl != null ? Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            image: DecorationImage(
              image: NetworkImage(widget.classObj.bannerUrl!),
            fit: BoxFit.cover,
            ),
          ),
          foregroundDecoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            color: Color.fromARGB(127, 0, 0, 0)
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(widget.classObj.color),
                ],
                stops: const [0.0, 1],
              ),
            ),
          )
        ) : Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            color: Color(widget.classObj.color)
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(180),
          child: Container(
            width: double.maxFinite,
            height: 180,
          )
        )
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.fromLTRB(sPadding, sPadding, sPadding, sPadding),
          child: ClassMuralView(classObj: widget.classObj)
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        indicatorColor: cColorAzulSecondary,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedCanvas, color: Colors.black),
            label: "Mural",
          ),
          NavigationDestination(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedCalendar03, color: Colors.black),
            label: "Calendário",
          ),
          NavigationDestination(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedBookBookmark02, color: Colors.black),
            label: "Matérias",
          ),
        ],
      ),
    );
  }
}