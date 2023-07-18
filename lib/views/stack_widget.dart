import 'package:flutter/material.dart';
import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

/// This tree widget is a stack view (not expandable view). So there is a
/// special requirement: you can start with a list of children tree rather than
/// the root. If you want to start with root, you can pass the argument:
/// `listTrees = [root]`
class StackWidget<T extends AbsNodeType> extends StatefulWidget {
  const StackWidget({
    super.key,
    required this.properties,
    required this.listTrees,
  });

  final TreeViewProperties<T> properties;
  final List<TreeType<T>> listTrees;

  @override
  State<StackWidget> createState() => _StackWidgetState<T>();
}

class _StackWidgetState<T extends AbsNodeType>
    extends State<StackWidget<T>> {
  List<TreeType<T>> listTrees = [];

  @override
  void initState() {
    listTrees = widget.listTrees;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (listTrees.isEmpty) {
      return widget.properties.emptyWidget;
    } else {
      return _buildTreeView();
    }
  }

  Widget _buildTreeView() {
    if (listTrees[0].parent == null) {
      return _buildRootOfTree();
    } else {
      return _buildOtherChildrenOfTree();
    }
  }

  Widget _buildRootOfTree() {
    return Column(
      children: [
        //? top title
        ListTile(
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          leading: const SizedBox(),
          title: Text(
            widget.properties.title,
            textAlign: TextAlign.center,
            style: widget.properties.titleStyle,
          ),
        ),
        const SizedBox(height: 10),

        //? main view
        Expanded(
          child: ListView.separated(
            itemCount: listTrees.length,
            itemBuilder: (_, int index) {
              if (listTrees[index].isLeaf) {
                return _buildLeafWidget(listTrees[index]);
              } else {
                return _buildInnerNodeWidget(listTrees[index]);
              }
            },
            separatorBuilder: (_, __) => const Divider(),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherChildrenOfTree() {
    return Column(
      children: [
        //? top title is current tree's parent title
        ListTile(
          //? back button
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: _pressBackToParent,
          ),
          //? close button
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          //? title
          title: Text(
            listTrees[0].parent!.data.title,
            style: widget.properties.titleStyle,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),

        //? main view
        Expanded(
          child: ListView.separated(
            itemCount: listTrees.length,
            itemBuilder: (BuildContext context, int index) {
              var currentTree = listTrees[index];

              if (currentTree.isLeaf) {
                return _buildLeafWidget(listTrees[index]);
              } else {
                return _buildInnerNodeWidget(currentTree);
              }
            },
            separatorBuilder: (_, __) => const Divider(),
          ),
        ),
      ],
    );
  }

  Widget _buildLeafWidget(TreeType<T> leaf) {
    return ListTile(
      onTap: () {},
      title: Text(
        leaf.data.title,
        style: widget.properties.listTileTitleStyle,
      ),
      leading: widget.properties.leafLeadingWidget,
      trailing: Checkbox(
        side: leaf.data.isUnavailable
            ? const BorderSide(color: Colors.grey, width: 1.0)
            : BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
        value: leaf.data.isChosen,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        //! leaf [isChosen] is always true or false, cannot be null
        onChanged: leaf.data.isUnavailable
            ? null
            : (value) {
                // leaf always has bool value (not null).
                setState(() => updateTreeMultipleChoice(leaf, value));
              },
      ),
    );
  }

  Widget _buildInnerNodeWidget(TreeType<T> innerNode) {
    return ListTile(
      onTap: () => _pressGoToChildren(innerNode),
      tileColor: null,
      title: Text(
        '${innerNode.data.title} (${innerNode.children.length})',
        style: widget.properties.listTileTitleStyle,
      ),
      leading: widget.properties.innerNodeLeadingWidget,
      trailing: Checkbox(
        tristate: true,
        side: innerNode.data.isUnavailable
            ? const BorderSide(color: Colors.grey, width: 1.0)
            : BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
        value: innerNode.data.isUnavailable ? false : innerNode.data.isChosen,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        activeColor: innerNode.data.isUnavailable
            ? Colors.grey
            : Theme.of(context).primaryColor,
        onChanged: innerNode.data.isUnavailable
            ? null
            : (value) {
                setState(() => updateTreeMultipleChoice(innerNode, value));
              },
      ),
    );
  }

  void _pressBackToParent() {
    setState(() {
      var parentOfCurrentTrees = listTrees[0].parent!;
      // is this parent already root?
      if (parentOfCurrentTrees.isRoot) {
        listTrees = [parentOfCurrentTrees];
      } else {
        var parentOfParentOfCurrentTree = parentOfCurrentTrees.parent!;
        listTrees = parentOfParentOfCurrentTree.children;
      }
    });
  }

  void _pressGoToChildren(TreeType<T> innerNode) {
    if (innerNode.children.isEmpty) return;
    setState(() => listTrees = innerNode.children);
  }
}
