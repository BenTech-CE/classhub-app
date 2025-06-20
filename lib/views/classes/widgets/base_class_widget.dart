import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/models/class/management/class_widget.model.dart';
import 'package:flutter/material.dart';

class BaseClassWidget extends StatefulWidget {
  final MaterialColor classColor;
  final Widget child; 
  final bool canEdit;
  final ClassWidgetModel? widgetModel;

  const BaseClassWidget({
    Key? key,
    this.widgetModel,
    required this.classColor,
    required this.canEdit,
    required this.child,
    
  }) : super( key: key );

  @override
  State<BaseClassWidget> createState() => _BaseClassWidgetState();
}

class _BaseClassWidgetState extends State<BaseClassWidget> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  bool _showEditOptions = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();


    _scaleController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.075).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );


    _scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _didLongPress();
        
      }
    });

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // tremor
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 0.0015).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0015, end: 0.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1.0,
      ),
       TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: -0.0015).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1.0,
      ),
       TweenSequenceItem<double>(
        tween: Tween<double>(begin: -0.0015, end: 0.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1.0,
      ),
    ]).animate(_shakeController);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _longPressStart(LongPressStartDetails details) {
    print("Long Press: Started");
    if (widget.canEdit && !_showEditOptions) _scaleController.forward();
  }

  void _longPressEnd(LongPressEndDetails details) {
    print("Long Press: Ended");

    if (_scaleController.isAnimating && widget.canEdit) {
      _scaleController.reverse();
    }
  }

  void _didLongPress() {
    print("Long Press: Action Triggered after 2 seconds!");

    _scaleController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );

    setState(() {
      _showEditOptions = true;
    });

    _shakeController.repeat();
  }

  void _cancelEdit() {
    setState(() {
      _showEditOptions = false;
    });

    _shakeController.stop();
    _shakeController.reset();
  }

  void _edit() {
    print("Botão editar");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _cancelEdit,
      onLongPressStart: _longPressStart,
      onLongPressEnd: _longPressEnd,
      child: RotationTransition(
        turns: _shakeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Stack(
            alignment: Alignment.topRight,
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(sPadding3),
                width: double.maxFinite,
                height: 130,
                decoration: BoxDecoration(
                    color: widget.classColor.shade100,
                    border: Border.fromBorderSide(
                        BorderSide(color: widget.classColor.shade300, width: 4)),
                    borderRadius: const BorderRadius.all(Radius.circular(24))),
                child: widget.widgetModel != null ?
                  Column(
                    children: [
                      Text(
                        widget.widgetModel!.title ,style: TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.w600,
                        color: widget.classColor
                            .shade800),
                      ),
                      Text(widget.widgetModel!.description)
                    ],
                  )
                  : widget.child,
              ),
              if (_showEditOptions == true)
                Positioned(
                  top: -8,
                  right: 8,
                  child: Row(
                    spacing: 4,
                    children: [
                      GestureDetector(
                        onTap: _edit,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999)
                          ),
                          width: 32,
                          height: 32,
                          child: Icon(Icons.edit, color: widget.classColor, size: 20),
                        ),
                      )
                    ],
                  )
                ),
            ]
          ),
        ),
      ),
    );
  }
}
