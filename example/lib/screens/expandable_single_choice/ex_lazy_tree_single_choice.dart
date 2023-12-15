import 'package:flutter/material.dart';
import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

import '../../models/custom_node_type.dart';
import '../../data/example_lazy_stack_data.dart';

class ExLazyTreeSingleChoice extends StatefulWidget {
  const ExLazyTreeSingleChoice({super.key});

  @override
  State<ExLazyTreeSingleChoice> createState() => _ExLazyTreeSingleChoiceState();
}

class _ExLazyTreeSingleChoiceState extends State<ExLazyTreeSingleChoice> {
  late TreeType<CustomNodeType> _tree;

  @override
  void initState() {
    _tree = createRoot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Example Single Choice Expandable Tree"),
        ),
        body: SingleChildScrollView(
          child: _VTSNodeWidget(
            _tree,
            onNodeDataChanged: () => setState(() {}),
          ),
        ),
      ),
    );
  }
}

//? ____________________________________________________________________________

class _VTSNodeWidget extends StatefulWidget {
  const _VTSNodeWidget(
    this.tree, {
    required this.onNodeDataChanged,
  });

  final TreeType<CustomNodeType> tree;

  /// IMPORTANT: Because this library **DOESN'T** use any state management
  /// library, therefore I need to use call back function like this - although
  /// it is more readable if using `Provider`.
  final VoidCallback onNodeDataChanged;

  @override
  State<_VTSNodeWidget> createState() => _VTSNodeWidgetState();
}

class _VTSNodeWidgetState<T extends AbsNodeType> extends State<_VTSNodeWidget>
    with SingleTickerProviderStateMixin, ExpandableTreeMixin<CustomNodeType> {
  final Tween<double> _turnsTween = Tween<double>(begin: -0.25, end: 0.0);
  bool _showLoading = false;

  @override
  initState() {
    super.initState();
    initTree();
    initRotationController();
    if (tree.data.isExpanded) {
      rotationController.forward();
    }
  }

  @override
  void initTree() {
    tree = widget.tree;
  }

  @override
  void initRotationController() {
    rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.disposeRotationController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => buildView();

  @override
  Widget buildNode() {
    return InkWell(
      onTap: toggleExpansion,
      child: Row(
        children: [
          _buildRotationIcon(),
          _buildLoadingWidget(),
          Expanded(child: _buildTitle()),
          _buildTrailing(),
        ],
      ),
    );
  }

  //* __________________________________________________________________________

  Widget _buildRotationIcon() {
    return RotationTransition(
      turns: _turnsTween.animate(rotationController),
      child: tree.isLeaf
          ? Container()
          : IconButton(
              iconSize: 16,
              icon: const Icon(Icons.expand_more, size: 16.0),
              onPressed: updateStateToggleExpansion,
            ),
    );
  }

  Widget _buildLoadingWidget() {
    if (_showLoading) {
      return const SizedBox(
        width: 12.0,
        height: 12.0,
        child: CircularProgressIndicator(strokeWidth: 1.0),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Text(
        (tree.isLeaf ? "+++ " : "- ") + tree.data.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildTrailing() {
    if (tree.data.isUnavailable) {
      return const Icon(Icons.close_rounded, color: Colors.red);
    }

    if (tree.isLeaf) {
      return Checkbox(
        value: tree.data.isChosen!, // leaves always is true or false
        onChanged: (value) {
          updateTreeSingleChoice(tree, !tree.data.isChosen!);
          widget.onNodeDataChanged();
        },
      );
    }

    return const SizedBox.shrink();
  }

  //* __________________________________________________________________________

  @override
  List<Widget> generateChildrenNodesWidget(
          List<TreeType<CustomNodeType>> list) =>
      List.generate(
        list.length,
        (int index) => _VTSNodeWidget(
          list[index],
          onNodeDataChanged: widget.onNodeDataChanged,
        ),
      );

  @override
  void toggleExpansion() async {
    if (tree.isLeaf) {
      return;
    } else {
      if (!tree.isChildrenLoadedLazily) {
        setState(() => _showLoading = true);
        await Future.delayed(const Duration(seconds: 1));
        tree.isChildrenLoadedLazily = true;
        var newAddedTreeChildren = getNewAddedTreeChildren(tree);

        /// if inner node has no children, mark it as unavailable & not chosen,
        /// then update tree and -> `return`
        if (newAddedTreeChildren.isEmpty) {
          var snackBar =
              const SnackBar(content: Text("This one has no children"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            tree.data.isUnavailable = true;
            tree.data.isChosen = false;
            _showLoading = false;
            updateTreeSingleChoice(tree, false);
          });
          return;
        }

        /// else, update new children's `isChosen` properties in case of current
        /// tree has `isChosen = true`, then continue call stack
        if (tree.data.isChosen == true) {
          for (var e in newAddedTreeChildren) {
            if (!e.data.isUnavailable) e.data.isChosen = true;
          }
        }
        tree.children.addAll(newAddedTreeChildren);
        setState(() => _showLoading = false);
      }

      setState(() => super.toggleExpansion());
    }
  }

  @override
  void updateStateToggleExpansion() {}
}

//! __________________________________________________________________________

List<TreeType<CustomNodeType>> getNewAddedTreeChildren(
    TreeType<CustomNodeType> parent) {
  List<TreeType<CustomNodeType>> newChildren;
  String parentTitle = parent.data.title;

  if (parentTitle.contains("0")) {
    newChildren = createChildrenOfRoot();
  } else if (parentTitle.contains("1.1")) {
    newChildren = createChildrenOfLv1_1();
  } else if (parentTitle.contains("2.1")) {
    newChildren = createChildrenOfLv2_1();
  } else if (parentTitle.contains("2.2")) {
    newChildren = createChildrenOfLv2_2();
  } else {
    newChildren = [];
  }

  for (var newChild in newChildren) {
    newChild.parent = parent;
  }

  return newChildren;
}
