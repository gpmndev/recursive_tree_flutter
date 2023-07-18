import 'package:flutter/material.dart';
import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

typedef FunctionGetTreeChildren<T extends AbsNodeType> = List<TreeType<T>>
    Function(TreeType<T> parent);

typedef FunctionBuildLeadingWidget<T extends AbsNodeType> = Widget Function(
    TreeType<T> tree, VoidCallback setStateCallback);
