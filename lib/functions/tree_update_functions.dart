/* 
 * Author: Nguyen Van Bien
 * Email: nvbien2000@gmail.com
 */

import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

/// **This function is used to update all unavailable nodes of current tree**.
///
/// Function returns a boolean, [true] if current tree is chosenable,
/// else [false].
///
/// When we first time parse data (json, map, list, etc) to tree data structure,
/// there could be some nodes are unavailable **but** haven't been updated yet.
///
/// Example: Client wants to choose few employees (which represent leaves)
/// in a department (which represent inner nodes). If department `A` doesn't
/// have any available employee, it will be also marked as `unavailable`.
///
/// It is **NECESSARY** to call this function at the first time the tree
/// initialized.
bool updateAllUnavailableNodes<T extends AbsNodeType>(TreeType<T> tree) {
  if (tree.isLeaf) return !tree.data.isUnavailable;

  bool isThisTreeAvailable = false;
  for (var child in tree.children) {
    if (updateAllUnavailableNodes(child)) isThisTreeAvailable = true;
  }

  if (isThisTreeAvailable) {
    return true;
  } else {
    tree.data.isUnavailable = true;
    return false;
  }
}

/// [checkAll] for this tree (from current node to bottom)
bool checkAll<T extends AbsNodeType>(TreeType<T> tree) {
  tree.data.isChosen = true;

  // need to use index, if not, it could create another instance of [TreeType]
  for (int i = 0; i < tree.children.length; i++) {
    checkAll(tree.children[i]);
  }

  return true;
}

/// [uncheckAll] for this tree (from current node to bottom)
bool uncheckALl<T extends AbsNodeType>(TreeType<T> tree) {
  tree.data.isChosen = false;

  // need to use index, if not, it could create another instance of [TreeType]
  for (int i = 0; i < tree.children.length; i++) {
    uncheckALl(tree.children[i]);
  }

  return true;
}

/// [updateTreeMultipleChoice] when choose/un-choose a node:
///
/// - [chosenValue]: same meaning as [isChosen] in [AbsNodeType].
/// - [isUpdatingParentRecursion]: is used to determine whether we are updating
/// the parent/ancestors tree or updating the children of this tree.
/// - [isThisLazyTree]: is this a lazy-load tree?
void updateTreeMultipleChoice<T extends AbsNodeType>(
  TreeType<T> tree,
  bool? chosenValue, {
  bool isUpdatingParentRecursion = false,
  bool isThisLazyTree = false,
}) {
  //? Step 1. update current node
  tree.data.isChosen = chosenValue;

  //? Step 2. update its children
  if (!tree.isLeaf && !isUpdatingParentRecursion) {
    /// if not [isUpdatingParentRecursion], means this is the first time call
    /// function [updateTree], [chosenValue] is not nullable for now
    if (chosenValue == true) {
      checkAll(tree);
    } else {
      uncheckALl(tree);
    }
  }

  //? Step 3. update parent
  if (!tree.isRoot) {
    var parent = tree.parent!;
    var parentChosenValue = isChosenAll(
      parent,
      isThisLazyTree: isThisLazyTree,
    );

    switch (parentChosenValue) {
      case EChosenAllValues.chosenSome:
        updateTreeMultipleChoice(
          parent,
          null,
          isUpdatingParentRecursion: true,
          isThisLazyTree: isThisLazyTree,
        );
        break;
      case EChosenAllValues.chosenAll:
        updateTreeMultipleChoice(
          parent,
          true,
          isUpdatingParentRecursion: true,
          isThisLazyTree: isThisLazyTree,
        );
        break;
      case EChosenAllValues.unchosenAll:
        updateTreeMultipleChoice(
          parent,
          false,
          isUpdatingParentRecursion: true,
          isThisLazyTree: isThisLazyTree,
        );
        break;
      default:
        throw Exception("""File: tree_function.dart
Function: updateTreeMultipleChoice
Exception: EChosenAllValues.notChosenable
Message: Some logic error happen""");
    }
  }
}

/// The tree is single choice, not multiple choice. Only leaf can be chosen.
void updateTreeSingleChoice<T extends AbsNodeType>(
    TreeType<T> tree, bool chosenValue) {
  /// if `chosenValue == true`, all of its ancestors ancestors must have value
  /// `isChosen == null` (because we need to customize UI of each inner node if
  /// one of its children is chosen), others have value `false`.
  ///
  /// Otherwise, just update everything - every nodes value to `false`.

  // uncheck all
  var root = findRoot(tree);
  uncheckALl(root);

  // if chosen value is true, update all of its ancestors value to null
  if (chosenValue) {
    _updateAncestorsToNull(tree);
  } else {}

  // update current node value
  tree.data.isChosen = chosenValue;
}

/// Update `isChosen` of current tree's ancestor to null
void _updateAncestorsToNull<T extends AbsNodeType>(TreeType<T> tree) {
  tree.data.isChosen = null;
  if (tree.isRoot) return;
  _updateAncestorsToNull(tree.parent!);
}

/// Update field `isShowedInSearching` of every node based on searching text.
void updateTreeWithSearchingTitle<T extends AbsNodeType>(
    TreeType<T> tree, String searchingText) {
  var root = findRoot(tree);

  // searching text is empty -> mark all nodes displayable
  if (searchingText.isEmpty) {
    _updateFullTrueIsShowedInSearching<T>(root);
    return;
  }

  //? Step 1: Mark entire tree to non-displayable
  _updateFullFalseIsShowedInSearching<T>(root);

  //? Step 2: Find all nodes that contains searching text
  List<TreeType<T>> foundNodes = [];
  searchAllTreesWithTitleDFS<T>(root, searchingText, foundNodes);

  //? Step 3: Update all branches from founded nodes to root as displayable
  for (var node in foundNodes) {
    _updateAncestorsToDisplayable<T>(node);
  }
}

/// Update field [isShowedInSearching] of ALL nodes to [true]
void _updateFullTrueIsShowedInSearching<T extends AbsNodeType>(
    TreeType<T> tree) {
  tree.data.isShowedInSearching = true;
  for (var child in tree.children) {
    _updateFullTrueIsShowedInSearching(child);
  }
}

/// Update field [isShowedInSearching] of ALL nodes to [false]
void _updateFullFalseIsShowedInSearching<T extends AbsNodeType>(
    TreeType<T> tree) {
  tree.data.isShowedInSearching = false;
  for (var child in tree.children) {
    _updateFullFalseIsShowedInSearching(child);
  }
}

void _updateAncestorsToDisplayable<T extends AbsNodeType>(TreeType<T> tree) {
  /// `isShowedInSearching` already is true means this branch has been updated
  /// before (see used in [updateTreeWithSearchingTitle()])
  if (tree.data.isShowedInSearching) return;

  tree.data.isShowedInSearching = true;
  if (tree.parent == null) return;
  _updateAncestorsToDisplayable(tree.parent!);
}

/// The tree is single choice, not multiple choice. Viettel DMS.4 customized
/// version: Every node can be chosen, so [T.isChosen] is never null.
void updateTreeSingleChoiceDms4<T extends AbsNodeType>(
    TreeType<T> tree, bool chosenValue) {
  // uncheck all - every node will have isChosen = false
  var root = findRoot(tree);
  uncheckALl(root);

  // update current node value
  tree.data.isChosen = chosenValue;
}
