import 'dart:math';

import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

class CustomNodeType extends AbsNodeType {
  CustomNodeType({
    required dynamic id,
    required dynamic title,
    this.subtitle,
    bool isInner = true,
  }) : super(id: id, title: title, isInner: isInner);

  String? subtitle;

  CustomNodeType.sampleInner(String level) : super(id: -1, title: "") {
    super.id = Random().nextInt(100000);
    super.title = "(inner) title of level $level";
    subtitle = "subtitle of level = $level";
  }

  CustomNodeType.sampleLeaf(String level) : super(id: -1, title: "") {
    super.id = Random().nextInt(100000);
    super.title = "(leaf) title of level $level";
    subtitle = "subtitle of level = $level";
    super.isInner = false;
    super.isFavorite = false;
  }

  /// isExpanded = true
  CustomNodeType.sampleInnerExpanded(String level) : super(id: -1, title: "") {
    super.id = Random().nextInt(100000);
    super.title = "(inner) title of level $level";
    subtitle = "subtitle of level = $level";
    isExpanded = true;
  }

  /// isExpanded = true
  CustomNodeType.sampleLeafExpanded(String level) : super(id: -1, title: "") {
    super.id = Random().nextInt(100000);
    super.title = "(leaf) title of level $level";
    subtitle = "subtitle of level = $level";
    super.isInner = false;
    super.isFavorite = false;
    isExpanded = true;
  }

  @override
  T clone<T extends AbsNodeType>() {
    var newData = CustomNodeType(
      id: id,
      title: title,
      subtitle: subtitle,
      isInner: isInner,
    );
    newData.isUnavailable = isUnavailable;
    newData.isChosen = isChosen;
    newData.isExpanded = isExpanded;
    newData.isFavorite = isFavorite;

    return newData as T;
  }
}
