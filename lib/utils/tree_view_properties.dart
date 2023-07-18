import 'package:flutter/material.dart';
import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

class TreeViewProperties<T extends AbsNodeType> {
  TreeViewProperties({
    // this.loadingWidget = const CircularProgressIndicator(),
    // this.errorWidget = const DefaultErrorWidget("Error"),
    this.emptyWidget = const DefaultEmptyWidget(),
    this.title = "",
    this.titleStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    this.listTileTitleStyle,
  });

  // /// Default is [CircularProgressIndicator].
  // Widget loadingWidget;

  // /// Default is triangle warning icon with description text.
  // Widget errorWidget;

  /// Default is [DefaultEmptyWidget].
  Widget emptyWidget;

  String title;

  /// Default is bold 18
  TextStyle titleStyle;

  TextStyle? listTileTitleStyle;
  Widget? leafLeadingWidget;
  Widget? innerNodeLeadingWidget;
}

// class DefaultErrorWidget extends StatelessWidget {
//   const DefaultErrorWidget(this.title, {super.key});
//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const Icon(Icons.warning, color: Colors.red),
//         const SizedBox(height: 10),
//         Text(title),
//       ],
//     );
//   }
// }

class DefaultEmptyWidget extends StatelessWidget {
  const DefaultEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.list_outlined, color: Colors.orange),
        SizedBox(height: 10),
        Text("Empty list"),
      ],
    );
  }
}
