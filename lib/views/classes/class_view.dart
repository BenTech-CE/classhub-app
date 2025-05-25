import 'package:carousel_slider/carousel_slider.dart';
import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/api.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/management/class_model.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/viewmodels/class/management/class_management_viewmodel.dart';
import 'package:classhub/views/classes/routes/class_calendar_view.dart';
import 'package:classhub/views/classes/routes/class_mural_view.dart';
import 'package:classhub/views/classes/routes/class_subjects_view.dart';
import 'package:classhub/widgets/ui/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class ClassView extends StatefulWidget {
  final MinimalClassModel mClassObj;

  const ClassView({super.key, required this.mClassObj});

  @override
  State<ClassView> createState() => _ClassViewState();
}

class _ClassViewState extends State<ClassView> {
  int _selectedIndex = 0;

  late final List<Widget> widgetOptions;

  late MaterialColor classColor;

  ClassModel? classObj;

  Future<void> _fetchClass() async {
    final classVM = context.read<ClassManagementViewModel>();

    ClassModel? cl = await classVM.getClass(widget.mClassObj.id);

    if (cl != null && mounted) {
      setState(() {
        classObj = cl;
      });

      return;
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          classVM.error!,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorError,
      ));
    }
  }

  @override
  void initState() {
    super.initState();

    classColor = generateMaterialColor(Color(widget.mClassObj.color));

    widgetOptions = [
      ClassMuralView(mClassObj: widget.mClassObj),
      ClassCalendarView(mClassObj: widget.mClassObj),
      ClassSubjectsView(mClassObj: widget.mClassObj),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      /*showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        isScrollControlled: true,
        barrierColor: Colors.transparent,
        useRootNavigator: true,
        //backgroundColor: Colors.white,
        builder: (context) => DraggableScrollableSheet(
          expand: false,
          snap: true,
          maxChildSize: 0.9,
          initialChildSize: 0.7,
          minChildSize: 0.7,
          shouldCloseOnMinExtent: false,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: widgetOptions.elementAt(_selectedIndex),
          ),
        ),
      );*/

      _fetchClass();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        indicatorColor: classColor.shade200,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: HugeIcon(
                icon: HugeIcons.strokeRoundedCanvas, color: Colors.black),
            label: "Mural",
          ),
          NavigationDestination(
            icon: HugeIcon(
                icon: HugeIcons.strokeRoundedCalendar03, color: Colors.black),
            label: "Calendário",
          ),
          NavigationDestination(
            icon: HugeIcon(
                icon: HugeIcons.strokeRoundedBookBookmark02,
                color: Colors.black),
            label: "Matérias",
          ),
        ],
      ),
      body: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
                centerTitle: true,
                title: Text(widget.mClassObj.name),
                backgroundColor: Colors.transparent,
                flexibleSpace: widget.mClassObj.bannerUrl != null
                    ? Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.mClassObj.bannerUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        foregroundDecoration: const BoxDecoration(
                            color: Color.fromARGB(127, 0, 0, 0)),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color(widget.mClassObj.color),
                              ],
                              stops: const [0.0, 1],
                            ),
                          ),
                        ))
                    : Container(
                        decoration:
                            BoxDecoration(color: Color(widget.mClassObj.color)),
                      ),
                bottom: _selectedIndex == 0
                    ? PreferredSize(
                        preferredSize: const Size.fromHeight(200),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(bottom: 24.0),
                          width: double.maxFinite,
                          height: 200,
                          child: CarouselSlider(
                            options: CarouselOptions(
                                height: 130,
                                viewportFraction: 0.9,
                                autoPlay: false,
                                enableInfiniteScroll: false),
                            items: [
                              Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  padding: const EdgeInsets.all(sPadding3),
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                      color: classColor.shade100,
                                      border: Border.fromBorderSide(BorderSide(
                                          color: classColor.shade300,
                                          width: 4)),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(24))),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Código da Turma",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color: classColor.shade800),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            classObj != null
                                                ? Text(
                                                    "${classObj?.inviteCode}",
                                                    style: TextStyle(
                                                        fontSize: 32,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: classColor
                                                            .shade900),
                                                  )
                                                : LoadingWidget(
                                                    color: classColor.shade900)
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                padding: const EdgeInsets.all(sPadding3),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    color: classColor.shade100,
                                    border: Border.fromBorderSide(BorderSide(
                                        color: classColor.shade300, width: 4)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(24))),
                                child: Text(
                                    "${MediaQuery.of(context).size.height} screenHeight"),
                              ),
                            ],
                          ),
                        ),
                      )
                    : null),
          ),
          _selectedIndex == 0 ? DraggableScrollableSheet(
            expand: true,
            snap: true,
            maxChildSize: calculatePercentageWithReference(
                914, 0.87, MediaQuery.of(context).size.height),
            initialChildSize: calculatePercentageWithReference(
                914, 0.64, MediaQuery.of(context).size.height),
            minChildSize: calculatePercentageWithReference(
                914, 0.64, MediaQuery.of(context).size.height),
            shouldCloseOnMinExtent: false,
            builder: (context, scrollController) => Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: SingleChildScrollView(
                controller: scrollController,
                child: widgetOptions.elementAt(_selectedIndex),
              ),
            ),
          ) : Container(
            width: double.maxFinite,
            margin: const EdgeInsets.only(top: sAppBar + 24),
            child: widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
