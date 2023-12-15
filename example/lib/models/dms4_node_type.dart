import 'dart:math';

import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

/// IMPORTANT: [isChosen] is always true or false, not null
class Dms4NodeType extends AbsNodeType {
  Dms4NodeType({
    required dynamic id,
    required dynamic title,
    bool isInner = true,
    bool isChosen = false,
  }) : super(id: id, title: title, isInner: isInner, isChosen: isChosen);

  Dms4NodeType.sampleInner(String level) : super(id: -1, title: "") {
    super.id = Random().nextInt(100000);
    super.title = "(inner) title of level $level";
    super.isChosen = false;
  }

  Dms4NodeType.sampleLeaf(String level) : super(id: -1, title: "") {
    super.id = Random().nextInt(100000);
    super.title = "(leaf) title of level $level";
    super.isInner = false;
    super.isChosen = false;
  }

  @override
  T clone<T extends AbsNodeType>() {
    var newData = Dms4NodeType(
      id: id,
      title: title,
      isInner: isInner,
    );
    newData.isUnavailable = isUnavailable;
    newData.isChosen = isChosen;
    newData.isExpanded = isExpanded;
    newData.isFavorite = isFavorite;

    return newData as T;
  }
}
