import 'package:flutter/material.dart';
import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

class LazyStackWidget<T extends AbsNodeType> extends StatefulWidget {
  const LazyStackWidget({
    super.key,
    required this.properties,
    required this.listTrees,
    required this.getNewAddedTreeChildren,
  });

  final TreeViewProperties<T> properties;
  final List<TreeType<T>> listTrees;

  /// If this function not null, data was parsed to tree only 1 time; else
  /// data was parsed in run-time (lazy-loading).
  final FunctionGetTreeChildren<T> getNewAddedTreeChildren;

  @override
  State<LazyStackWidget> createState() => _LazyStackWidgetState<T>();
}

class _LazyStackWidgetState<T extends AbsNodeType>
    extends State<LazyStackWidget<T>> {
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
                setState(() => updateTreeMultipleChoice(
                      leaf,
                      value,
                      isThisLazyTree: true,
                    ));
              },
      ),
    );
  }

  Widget _buildInnerNodeWidget(TreeType<T> innerNode) {
    return ListTile(
      onTap: () => _pressInnerNode(innerNode),
      tileColor: null,
      title: Text(
        innerNode.data.title,
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
            : (value) => setState(() => updateTreeMultipleChoice(
                  innerNode,
                  value,
                  isThisLazyTree: true,
                )),
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

  void _pressInnerNode(TreeType<T> innerNode) {
    /// children was loaded before -> call it existed children & return
    if (innerNode.isChildrenLoadedLazily) {
      if (innerNode.children.isEmpty) return;
      setState(() => listTrees = innerNode.children);
      return;
    }

    /// mark current tree (inner node)'s [isChildrenLoadedLazily = true]
    innerNode.isChildrenLoadedLazily = true;
    var newAddedTreeChildren = widget.getNewAddedTreeChildren(innerNode);

    /// if inner node has no children, mark it as unavailable & not chosen,
    /// then update tree and -> `return`
    if (newAddedTreeChildren.isEmpty) {
      var snackBar = const SnackBar(content: Text("This one has no children"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        innerNode.data.isUnavailable = true;
        innerNode.data.isChosen = false;
        updateTreeMultipleChoice(
          innerNode,
          false,
          isThisLazyTree: true,
        );
      });
      return;
    }

    /// else, update new children's `isChosen` properties in case of current
    /// tree has `isChosen = true`, then continue call stack
    if (innerNode.data.isChosen == true) {
      for (var e in newAddedTreeChildren) {
        if (!e.data.isUnavailable) e.data.isChosen = true;
      }
    }
    innerNode.children.addAll(newAddedTreeChildren);
    setState(() => listTrees = newAddedTreeChildren);
  }
}
