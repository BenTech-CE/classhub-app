import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/utils/role.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/management/class_model.dart';
import 'package:classhub/models/class/management/class_widget.model.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/viewmodels/class/management/class_management_viewmodel.dart';
import 'package:classhub/views/classes/routes/class_calendar_view.dart';
import 'package:classhub/views/classes/routes/class_mural_view.dart';
import 'package:classhub/views/classes/routes/class_subjects_view.dart';
import 'package:classhub/views/classes/sheets/list_members.dart';
import 'package:classhub/views/classes/sheets/notifications_config.dart';
import 'package:classhub/views/classes/widgets/base_class_widget.dart';
import 'package:classhub/widgets/ui/loading_widget.dart';
import 'package:classhub/views/classes/widgets/new_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ClassView extends StatefulWidget {
  final MinimalClassModel mClassObj;

  const ClassView({super.key, required this.mClassObj});

  @override
  State<ClassView> createState() => _ClassViewState();
}

class _ClassViewState extends State<ClassView> {
  final GlobalKey _sheet = GlobalKey();

  int _selectedIndex = 0;

  late final List<Widget> widgetOptions;

  late MaterialColor classColor;

  ClassModel? classObj;

  Future<void> _fetchClass() async {
    final classVM = context.read<ClassManagementViewModel>();

    ClassModel? cachedClass = classVM.getCachedClass(widget.mClassObj.id);
    if (cachedClass != null && mounted) {
      setState(() {
        classObj = cachedClass;
      });
    }

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

    WidgetsBinding.instance.addPostFrameCallback((_) =>
      _fetchClass()
    );
  }

  @override
  Widget build(BuildContext context) {
      // 1. Obter as dimensões da tela e o padding (área segura)
    final mediaQuery = MediaQuery.of(context);
    final bannerHeight = getBannerHeightByDpi(mediaQuery.devicePixelRatio);
    final screenHeight = mediaQuery.size.height;
    final safeAreaVertical = mediaQuery.padding.top + mediaQuery.padding.bottom;
    final sheetHeight = (screenHeight - bannerHeight - safeAreaVertical - kToolbarHeight) / screenHeight;
    final sheetMaxHeight = (screenHeight - safeAreaVertical - kToolbarHeight - 8) / screenHeight;

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
                actions: [
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(context: context, builder: (context) => NotificationsConfig(classId: widget.mClassObj.id,), showDragHandle: true, isScrollControlled: true);
                    },
                    icon: const Icon(HugeIcons.strokeRoundedNotification01),
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(context: context, builder: (context) => ListMembersSheet(mClassObj: widget.mClassObj,), showDragHandle: true, isScrollControlled: true);
                    },
                    icon: const Icon(HugeIcons.strokeRoundedUserGroup02),
                    color: Colors.white,
                  )
                ],
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
                        preferredSize: Size.fromHeight(getBannerHeightByDpi(MediaQuery.of(context).devicePixelRatio)),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(bottom: 24.0),
                          width: double.maxFinite,
                          height: getBannerHeightByDpi(MediaQuery.of(context).devicePixelRatio),
                          child: CarouselSlider(
                            options: CarouselOptions(
                                height: 130,
                                clipBehavior: Clip.none,
                                enlargeCenterPage: false,
                                viewportFraction: 0.8,
                                autoPlay: false,
                                enableInfiniteScroll: false),
                            items: [
                              BaseClassWidget(
                                canEdit: false,
                                classColor: classColor,
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
                                              ? InkWell(
                                                onTap: () async {
                                                  // Garante que o objeto e o código de convite não são nulos
                                                  if (classObj?.inviteCode != null) {
                                                    // 1. Monta a URL completa que será compartilhada
                                                    final String url = "https://classhub.space/${classObj!.inviteCode}";
                                                    
                                                    // 2. Chama a função de compartilhamento nativa do celular
                                                    await SharePlus.instance.share(
                                                      ShareParams(
                                                        uri: Uri.parse(url),
                                                      )
                                                    );
                                                  }
                                                },
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.min,
                                                    spacing: 4,
                                                    children: [
                                                      Text(
                                                        "${classObj?.inviteCode}",
                                                        style: TextStyle(
                                                            fontSize: 32,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: classColor
                                                                .shade900),
                                                      ),
                                                      HugeIcon(icon: HugeIcons.strokeRoundedShare01, color: classColor.shade900, size: 24),
                                                    ],
                                                  ),
                                              )
                                              : LoadingWidget(
                                                  color: classColor.shade900)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              /*BaseClassWidget(
                                canEdit: false, //widget.mClassObj.role >= Role.viceLider,
                                classColor: classColor,
                                widgetModel: ClassWidgetModel(title: "Eventos Próximos", description: ""),
                                child: Container()
                              ),*/
                              /*if (widget.mClassObj.role >= Role.viceLider)
                                NewCardWidget(classColor: classColor,)*/
                            ],
                          ),
                        ),
                      )
                    : null),
          ),
          _selectedIndex == 0
              ? DraggableScrollableSheet(
                  key: _sheet,
                  expand: true,
                  snap: true,
                  maxChildSize: sheetMaxHeight,
                  initialChildSize: sheetHeight,
                  minChildSize: sheetHeight,
                  shouldCloseOnMinExtent: false,
                  builder: (context, scrollController) => Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16))),
                    child: Column(
                      children: [
                        // --- A ALÇA DE ARRASTAR (DRAG HANDLE) ---
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0), // Espaçamento vertical
                          child: Center( // Centraliza a alça
                            child: Container(
                              width: 40.0,  // Largura da alça
                              height: 5.0,   // Altura da alça
                              decoration: BoxDecoration(
                                color: Colors.grey[400], // Cor da alça
                                borderRadius: BorderRadius.circular(10.0), // Bordas arredondadas
                              ),
                            ),
                          ),
                        ),
                        // --- FIM DA ALÇA DE ARRASTAR ---
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: widgetOptions.elementAt(_selectedIndex),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SafeArea(
                  child: Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    margin: const EdgeInsets.only(top: kToolbarHeight),
                    child: widgetOptions.elementAt(_selectedIndex),
                  ),
                ),
        ],
      ),
    );
  }
}
