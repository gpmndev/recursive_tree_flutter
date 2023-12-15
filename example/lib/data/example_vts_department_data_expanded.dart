import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

import 'custom_node_type.dart';

TreeType<CustomNodeType> sampleTreeExpanded<T extends AbsNodeType>() {
  var root = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleInnerExpanded("0"),
    children: [],
    parent: null,
  );

//? ------------------ lv 1

  var lv1_1 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleInnerExpanded("1.1"),
    children: [],
    parent: null,
  );

  var lv1_2 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleInnerExpanded("1.2"),
    children: [],
    parent: null,
  );

//? ------------------ lv 2

  var lv2_1 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleInnerExpanded("2.1"),
    children: [],
    parent: null,
  );

  var lv2_2 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleInnerExpanded("2.2"),
    children: [],
    parent: null,
  );

  var lv2_3 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleInnerExpanded("2.3"),
    children: [],
    parent: null,
  );

//? ------------------ lv 3

  var lv3_1 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleLeafExpanded("3.1"),
    children: [],
    parent: null,
  );

  var lv3_2 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleLeafExpanded("3.2"),
    children: [],
    parent: null,
  );

  var lv3_3 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleLeafExpanded("3.3"),
    children: [],
    parent: null,
  );

  var lv3_4 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleLeafExpanded("3.4"),
    children: [],
    parent: null,
  );

//* ________________________________________

  lv1_1.parent = root;
  lv1_2.parent = root;
  lv2_1.parent = lv1_1;
  lv2_2.parent = lv1_1;
  lv2_3.parent = lv1_1;
  lv3_1.parent = lv2_1;
  lv3_2.parent = lv2_1;
  lv3_3.parent = lv2_1;
  lv3_4.parent = lv2_2;

  root.children.addAll([lv1_1, lv1_2]);
  lv1_1.children.addAll([lv2_1, lv2_2, lv2_3]);
  lv2_1.children.addAll([lv3_1, lv3_2, lv3_3]);
  lv2_2.children.addAll([lv3_4]);

  updateAllUnavailableNodes(root);

  return root;
}
