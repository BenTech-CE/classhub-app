import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/api.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/views/classes/routes/class_calendar_view.dart';
import 'package:classhub/views/classes/routes/class_mural_view.dart';
import 'package:classhub/views/classes/routes/class_subjects_view.dart';
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

  late final List<Widget> widgetOptions;

  @override
  void initState() {
    super.initState();

    widgetOptions = [
      ClassMuralView(classObj: widget.classObj),
      ClassCalendarView(),
      ClassSubjectsView(),
    ];
  }

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
            borderRadius: _selectedIndex == 0 ? const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ) : null,
            image: DecorationImage(
              image: NetworkImage(widget.classObj.bannerUrl!),
            fit: BoxFit.cover,
            ),
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: _selectedIndex == 0 ? const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ) : null,
            color: const Color.fromARGB(127, 0, 0, 0)
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: _selectedIndex == 0 ? const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ) : null,
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
            borderRadius: _selectedIndex == 0 ? const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ) : null,
            color: Color(widget.classObj.color)
          ),
        ),
        bottom: _selectedIndex == 0 ? PreferredSize(
          preferredSize: const Size.fromHeight(180),
          child: Container(
            width: double.maxFinite,
            height: 180,
          )
        ) : null
      ),
      body: widgetOptions.elementAt(_selectedIndex),
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