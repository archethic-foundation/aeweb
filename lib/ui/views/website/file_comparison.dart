import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:flutter/material.dart';

class FileComparisonWidget extends StatefulWidget {
  const FileComparisonWidget({super.key, required this.comparedFiles});

  final List<HostingContentComparison> comparedFiles;

  @override
  FileComparisonWidgetState createState() => FileComparisonWidgetState();
}

class FileComparisonWidgetState extends State<FileComparisonWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  HostingContentComparisonStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredFiles = widget.comparedFiles
        .where(
          (file) =>
              file.path.toLowerCase().contains(_searchText.toLowerCase()) &&
              (_selectedStatus == null || file.status == _selectedStatus),
        )
        .toList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const SelectableText('Comparison'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search files...',
              ),
            ),
          ),
          _buildFilterStatusWidget(),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text('Displayed files: ${filteredFiles.length}'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFiles.length,
              itemBuilder: (context, index) {
                final file = filteredFiles[index];
                IconData iconData;
                Color iconColor;
                String statusText;
                switch (file.status) {
                  case HostingContentComparisonStatus.localOnly:
                    iconData = Icons.cloud_upload;
                    iconColor = Colors.orange;
                    statusText = 'Local only';
                    break;
                  case HostingContentComparisonStatus.remoteOnly:
                    iconData = Icons.cloud_download;
                    iconColor = Colors.blue;
                    statusText = 'Remote only';
                    break;
                  case HostingContentComparisonStatus.differentContent:
                    iconData = Icons.sync_problem;
                    iconColor = Colors.red;
                    statusText = 'Different content';
                    break;
                  case HostingContentComparisonStatus.sameContent:
                    iconData = Icons.check_circle_outline;
                    iconColor = Colors.green;
                    statusText = 'Same content';
                    break;
                }
                return Card(
                  child: ListTile(
                    leading: Icon(iconData, color: iconColor),
                    title: Text(file.path),
                    subtitle: Text(statusText),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // TODO(redDwarf03): à renseigner
                      },
                      child: const Text('View content'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildFilterStatusWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton.icon(
          onPressed: () {
            setState(() {
              _selectedStatus = null;
            });
          },
          icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
          label: const Text('All', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor: _selectedStatus == null
                ? MaterialStateProperty.all(Colors.blue[100]!.withOpacity(0.2))
                : null,
          ),
        ),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _selectedStatus = HostingContentComparisonStatus.localOnly;
            });
          },
          icon: const Icon(Icons.cloud_upload, color: Colors.orange),
          label:
              const Text('Local only', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor:
                _selectedStatus == HostingContentComparisonStatus.localOnly
                    ? MaterialStateProperty.all(
                        Colors.orange[100]!.withOpacity(0.2),
                      )
                    : null,
          ),
        ),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _selectedStatus = HostingContentComparisonStatus.remoteOnly;
            });
          },
          icon: const Icon(Icons.cloud_download, color: Colors.blue),
          label:
              const Text('Remote only', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor: _selectedStatus ==
                    HostingContentComparisonStatus.remoteOnly
                ? MaterialStateProperty.all(Colors.blue[100]!.withOpacity(0.2))
                : null,
          ),
        ),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _selectedStatus = HostingContentComparisonStatus.differentContent;
            });
          },
          icon: const Icon(Icons.sync_problem, color: Colors.red),
          label: const Text('Different', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor: _selectedStatus ==
                    HostingContentComparisonStatus.differentContent
                ? MaterialStateProperty.all(Colors.red[100]!.withOpacity(0.2))
                : null,
          ),
        ),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _selectedStatus = HostingContentComparisonStatus.sameContent;
            });
          },
          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          label: const Text('Same', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor: _selectedStatus ==
                    HostingContentComparisonStatus.sameContent
                ? MaterialStateProperty.all(Colors.green[100]!.withOpacity(0.2))
                : null,
          ),
        ),
      ],
    );
  }

  String statusToString(HostingContentComparisonStatus status) {
    switch (status) {
      case HostingContentComparisonStatus.localOnly:
        return 'Local only';
      case HostingContentComparisonStatus.remoteOnly:
        return 'Remote only';
      case HostingContentComparisonStatus.differentContent:
        return 'Different content';
      case HostingContentComparisonStatus.sameContent:
        return 'Same content';
    }
  }
}
