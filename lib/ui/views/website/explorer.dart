/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key, required this.filesAndFolders});

  final archethic.Hosting filesAndFolders;

  @override
  ExplorerScreenState createState() => ExplorerScreenState();
}

class ExplorerScreenState extends State<ExplorerScreen> {
  final List<Node> _nodes = [];
  String _selectedNode = '';
  late TreeViewController treeViewController;
  final ExpanderPosition _expanderPosition = ExpanderPosition.start;
  final ExpanderType _expanderType = ExpanderType.none;
  final ExpanderModifier _expanderModifier = ExpanderModifier.none;
  @override
  void initState() {
    super.initState();
    treeViewController = TreeViewController(
      children: _nodes,
      selectedKey: _selectedNode,
    );

    widget.filesAndFolders.metaData.forEach(_addPathToTree);
  }

  void _addPathToTree(String file, archethic.HostingContentMetaData metaData) {
    final parts = file.split('/');
    Node? currentNode;
    var siblings = _nodes;
    final currentKey = StringBuffer();
    var isFolder = false;

    for (final part in parts) {
      currentKey.write('$currentKey/$part');

      if (part.contains('.') && part.startsWith('.') == false) {
        isFolder = false;
      } else {
        isFolder = true;
      }

      currentNode = siblings.firstWhere(
        (n) => n.key == currentKey.toString(),
        orElse: () {
          final node = Node(
            label: _getLabel(part, isFolder, metaData.size),
            key: currentKey.toString(),
            children: [],
            icon: isFolder ? Icons.folder : Icons.insert_drive_file,
          );
          siblings.add(node);
          return node;
        },
      );

      siblings = currentNode.children;
    }
  }

  String _getLabel(String label, bool isFolder, int size) {
    if (isFolder) {
      return label;
    } else {
      final formattedSize = filesize(size);
      return '$label ($formattedSize)';
    }
  }

  void _expandNode(String key, bool expanded) {
    final msg = '${expanded ? "Expanded" : "Collapsed"}: $key';
    debugPrint(msg);
    final node = treeViewController.getNode(key)!;
    List<Node> updated;

    updated = treeViewController.updateNode(
      key,
      node.copyWith(
        expanded: expanded,
        icon: expanded ? Icons.folder_open : Icons.folder,
      ),
    );

    setState(() {
      //  if (key == 'docs') docsOpen = expanded;
      treeViewController = treeViewController.copyWith(children: updated);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _treeViewTheme = TreeViewTheme(
      expanderTheme: ExpanderThemeData(
        type: _expanderType,
        modifier: _expanderModifier,
        position: _expanderPosition,
        size: 16,
      ),
      labelStyle: const TextStyle(
        fontSize: 16,
        letterSpacing: 0.3,
      ),
      parentLabelStyle: const TextStyle(
        fontSize: 16,
        letterSpacing: 0.1,
      ),
      iconTheme: const IconThemeData(
        size: 18,
        color: Colors.white,
      ),
      colorScheme: Theme.of(context).colorScheme,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const SelectableText('Content'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        onLongPress: () {
          _popupMenuButton(context);
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: TreeView(
                    controller: treeViewController,
                    onExpansionChanged: _expandNode,
                    onNodeTap: (key) {
                      setState(() {
                        _selectedNode = key;
                        treeViewController =
                            treeViewController.copyWith(selectedKey: key);
                      });
                    },
                    onNodeDoubleTap: (p0) => _popupMenuButton(context),
                    theme: _treeViewTheme,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(
                        treeViewController.getNode(_selectedNode) == null
                            ? ''
                            : treeViewController.getNode(_selectedNode)!.label,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _popupMenuButton(
  BuildContext context,
) {
  return PopupMenuButton(
    constraints: const BoxConstraints.expand(width: 300, height: 250),
    itemBuilder: (context) {
      return [
        PopupMenuItem(
          value: 'Explore',
          child: Row(
            children: const [
              Icon(Icons.explore),
              SizedBox(width: 8),
              Flexible(
                child: Text('Explore'),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Sync',
          child: Row(
            children: const [
              Icon(Icons.sync),
              SizedBox(width: 8),
              Flexible(
                child: Text('Sync'),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Upload',
          child: Row(
            children: const [
              Icon(Icons.cloud_upload),
              SizedBox(width: 8),
              Flexible(
                child: Text('Upload'),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Delete',
          child: Row(
            children: const [
              Icon(Icons.delete),
              SizedBox(width: 8),
              Flexible(
                child: Text('Delete files and SSL certificate / key'),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Download',
          child: Row(
            children: const [
              Icon(Icons.download),
              SizedBox(width: 8),
              Flexible(
                child: Text('Download'),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Certificate',
          child: Row(
            children: const [
              Icon(Icons.security),
              SizedBox(width: 8),
              Flexible(
                child: Text('Certificate management'),
              ),
            ],
          ),
        ),
      ];
    },
    onSelected: (value) async {},
  );
}
