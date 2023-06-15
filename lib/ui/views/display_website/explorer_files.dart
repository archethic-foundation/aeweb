/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/util/components/icon_animated.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:aeweb/util/generic/get_it_instance.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:url_launcher/url_launcher.dart';

class ExplorerFilesScreen extends ConsumerStatefulWidget {
  const ExplorerFilesScreen({super.key, required this.filesAndFolders});

  final Map<String, archethic.HostingRefContentMetaData> filesAndFolders;

  @override
  ExplorerFilesScreenState createState() => ExplorerFilesScreenState();
}

class ExplorerFilesScreenState extends ConsumerState<ExplorerFilesScreen> {
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

    widget.filesAndFolders.forEach(_addPathToTree);
  }

  void _addPathToTree(
    String file,
    archethic.HostingRefContentMetaData metaData,
  ) {
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
            data: metaData,
            key: currentKey.toString(),
            children: [],
            icon: isFolder ? Iconsax.folder : Icons.insert_drive_file,
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
        icon: expanded ? Iconsax.folder_open : Iconsax.folder,
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
        size: 12,
      ),
      labelStyle: const TextStyle(
        fontSize: 12,
        letterSpacing: 0.3,
      ),
      parentLabelStyle: const TextStyle(
        fontSize: 12,
        letterSpacing: 0.1,
      ),
      iconTheme: const IconThemeData(
        size: 12,
      ),
      colorScheme: ColorScheme.light(
        primary:
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
      ),
    );

    return Container(
      height: MediaQuery.of(context).size.height - 380,
      decoration: BoxDecoration(
        border: const GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              Color(0x003C89B9),
              Color(0xFFCC00FF),
            ],
            stops: [0, 1],
          ),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 30,
          right: 30,
          top: 20,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: SelectionArea(
                    child: Text(
                      AppLocalizations.of(context)!.explorerTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 50,
                    height: 1,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0x003C89B9),
                          Color(0xFFCC00FF),
                        ],
                        stops: [0, 1],
                        begin: AlignmentDirectional.centerEnd,
                        end: AlignmentDirectional.centerStart,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 460,
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
                theme: _treeViewTheme,
                nodeBuilder: (BuildContext context, Node node) {
                  return Container(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: IconAnimated(
                            icon: node.icon!,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Expanded(
                          flex: 80,
                          child: Text(node.label),
                        ),
                        Expanded(
                          flex: 10,
                          child: Align(
                            child: _popupMenuButton(
                              context,
                              ref,
                              node,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _popupMenuButton(
    BuildContext context,
    WidgetRef ref,
    Node node,
  ) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'Download',
            child: Row(
              children: [
                const Icon(Iconsax.document_download),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.exploreFilesPopupDownload,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'SeeFilesTx',
            child: Row(
              children: [
                const Icon(Iconsax.document),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.exploreFilesPopupSeeFilesTx,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Iconsax.export_3,
                  size: 12,
                ),
              ],
            ),
          ),
        ];
      },
      onSelected: (value) {
        switch (value) {
          case 'Download':
            break;
          case 'SeeFilesTx':
            final archethic.HostingRefContentMetaData metaData = node.data;
            for (final address in metaData.addresses) {
              launchUrl(
                Uri.parse(
                  '${sl.get<archethic.ApiService>().endpoint}/explorer/transaction/$address',
                ),
              );
            }
            break;
        }
      },
    );
  }
}
