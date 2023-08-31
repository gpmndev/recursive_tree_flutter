// ignore_for_file: constant_identifier_names

import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

import 'vn.dart';
import 'vn_region_node.dart';

const VN_LEVEL = 0;
const PROVINCE_LEVEL = 1;
const DISTRICT_LEVEL = 2;
const WARD_LEVEL = 3;

TreeType<VNRegionNode> sampleVNRegionNode<T extends AbsNodeType>() {
  var root = TreeType<VNRegionNode>(
    data: VNRegionNode(id: 0, title: "Việt Nam", level: VN_LEVEL),
    children: [],
    parent: null,
  );

  //? -------------------

  for (Map<String, dynamic> province in vnJson.values) {
    var newProvince = TreeType<VNRegionNode>( // <---- province
      data: VNRegionNode(
        id: province["code"],
        title: province["name"],
        level: PROVINCE_LEVEL,
      ),
      children: [],
      parent: root,
    );

    root.children.add(newProvince);

    for (Map<String, dynamic> district in (province["quan-huyen"] as Map).values) {
      var newDistrict = TreeType<VNRegionNode>( // <---- district
        data: VNRegionNode(
          id: district["code"],
          title: district["name"],
          level: DISTRICT_LEVEL,
        ),
        children: [],
        parent: newProvince,
      );

      newProvince.children.add(newDistrict);

      for (Map<String, dynamic> ward in (district["xa-phuong"] as Map).values) {
        var newWard = TreeType<VNRegionNode>( // <---- ward
          data: VNRegionNode(
            id: ward["code"],
            title: ward["name"],
            level: WARD_LEVEL,
            isInner: false,
          ),
          children: [],
          parent: newDistrict,
        );

        newDistrict.children.add(newWard);
      }
    }
  }

  return root;
}
