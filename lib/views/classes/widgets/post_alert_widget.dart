import 'package:classhub/models/class/mural/mural_model.dart';
import 'package:flutter/material.dart';

class PostAlertWidget extends StatefulWidget {
  final MaterialColor classColor;
  final MuralModel post;

  const PostAlertWidget({super.key, required this.classColor, required this.post});

  @override
  State<PostAlertWidget> createState() => _PostAlertWidgetState();
}

class _PostAlertWidgetState extends State<PostAlertWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: widget.classColor.shade100
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: widget.classColor.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.171),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              spacing: 12,
              children: [
                CircleAvatar(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: -4,
                  children: [
                    Text("João Gabriel Aguiar", style: TextStyle(
                      color: Colors.black87
                    )),
                    Text("23/12/2024", style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12
                    ))
                  ],
                ),
                Spacer(),
                Container(
                  width: 24,
                  height: 24,
                  child: IconButton(
                    onPressed: () {}, 
                    icon: Icon(Icons.more_vert, color: Colors.black87,),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            width: double.maxFinite,
            child: Text(
              widget.post.description,
              style: TextStyle(
                color: Colors.black87
              ),
              textAlign: TextAlign.start,
            ),
          )
        ],
      ),
    );
  }
}