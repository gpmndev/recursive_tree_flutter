/* 
 * Author: Nguyen Van Bien
 * Email: nvbien2000@gmail.com
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

mixin ExpandableTreeMixin<T extends AbsNodeType> {
  late AnimationController rotationController;
  late TreeType<T> tree;

  /// Init [tree] at `initState`, example:
  /// ```dart
  /// void initTree() {
  ///   tree = widget.tree;
  /// }
  /// ```
  void initTree();

  /// Init [rotationController] at `initState`, example:
  /// ```dart
  /// void initRotationController() {
  ///   rotationController = AnimationController(
  ///     duration: const Duration(milliseconds: 300),
  ///     vsync: this,
  ///   );
  /// }
  /// ```
  void initRotationController();

  void disposeRotationController() {
    rotationController.dispose();
  }

  Widget buildView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildNode(),
        buildChildrenNodes(),
      ],
    );
  }

  Widget buildNode();

  Widget buildChildrenNodes({final EdgeInsets? padding = const EdgeInsets.only(left: 24)}) {
    return SizeTransition(
      sizeFactor: rotationController,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(children: generateChildrenNodesWidget(tree.children)),
      ),
    );
  }

  /// Return a list of [StatefulWidget] (which represents your tree view).
  /// Example:
  ///
  /// ```dart
  /// return List.generate(
  ///   children.length,
  ///   (int index) => VTSNodeWidget<T>(children[index]),
  /// );
  /// ```
  List<Widget> generateChildrenNodesWidget(List<TreeType<T>> children);

  void toggleExpansion() {
    tree.data.isExpanded = !tree.data.isExpanded;
    tree.data.isExpanded
        ? rotationController.forward()
        : rotationController.reverse();
  }

  void updateStateToggleExpansion();
}
