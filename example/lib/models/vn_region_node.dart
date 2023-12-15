import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

class VNRegionNode extends AbsNodeType {
  VNRegionNode({
    required dynamic id,
    required dynamic title,
    bool isInner = true,
    this.level = 0,
  }) : super(id: id, title: title, isInner: isInner);

  int level;

  @override
  T clone<T extends AbsNodeType>() {
    var newData = VNRegionNode(
      id: id,
      title: title,
      isInner: isInner,
      level: level,
    );
    newData.isUnavailable = isUnavailable;
    newData.isChosen = isChosen;
    newData.isExpanded = isExpanded;
    newData.isFavorite = isFavorite;

    return newData as T;
  }
}
