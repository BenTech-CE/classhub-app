import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/api.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/views/classes/class_mural_view.dart';
import 'package:flutter/material.dart';

class ClassView extends StatefulWidget {
  final MinimalClassModel classObj;

  const ClassView({super.key, required this.classObj});

  @override
  State<ClassView> createState() => _ClassViewState();
}

class _ClassViewState extends State<ClassView> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.classObj.name),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            image: DecorationImage(
              image: NetworkImage(Api.dummyImage),
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
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Mural"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: "Calendário"),
        BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: "Matérias"),
      ]),
    );
  }
}