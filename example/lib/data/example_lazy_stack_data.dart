import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

import 'custom_node_type.dart';

TreeType<CustomNodeType> createRoot() => TreeType<CustomNodeType>(
      data: CustomNodeType.sampleInner("0"),
      children: [],
      parent: null,
    );

//? ------------------ lv 1

List<TreeType<CustomNodeType>> createChildrenOfRoot() => [
      TreeType<CustomNodeType>(
        data: CustomNodeType.sampleInner("1.1"),
        children: [],
        parent: null,
      ),
      TreeType<CustomNodeType>(
        data: CustomNodeType.sampleInner("1.2"),
        children: [],
        parent: null,
      ),
    ];

//? ------------------ lv 2

List<TreeType<CustomNodeType>> createChildrenOfLv1_1() => [
      TreeType<CustomNodeType>(
        data: CustomNodeType.sampleInner("2.1"),
        children: [],
        parent: null,
      ),
      TreeType<CustomNodeType>(
        data: CustomNodeType.sampleInner("2.2"),
        children: [],
        parent: null,
      ),
      TreeType<CustomNodeType>(
        data: CustomNodeType.sampleInner("2.3"),
        children: [],
        parent: null,
      ),
    ];

//? ------------------ lv 3

List<TreeType<CustomNodeType>> createChildrenOfLv2_1() => [
      TreeType<CustomNodeType>(
        data: CustomNodeType.sampleLeaf("3.1"),
        children: [],
        parent: null,
      ),
      TreeType<CustomNodeType>(
        data: CustomNodeType.sampleLeaf("3.2"),
        children: [],
        parent: null,
      ),
      TreeType<CustomNodeType>(
        data: CustomNodeType.sampleLeaf("3.3"),
        children: [],
        parent: null,
      ),
    ];

List<TreeType<CustomNodeType>> createChildrenOfLv2_2() => [
      TreeType<CustomNodeType>(
        data: CustomNodeType.sampleLeaf("3.4"),
        children: [],
        parent: null,
      ),
    ];
