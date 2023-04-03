import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/ui/views/update_website_sync/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateWebsiteSyncComparisonSheet extends ConsumerStatefulWidget {
  const UpdateWebsiteSyncComparisonSheet({
    super.key,
  });

  @override
  UpdateWebsiteSyncComparisonSheetState createState() =>
      UpdateWebsiteSyncComparisonSheetState();
}

class UpdateWebsiteSyncComparisonSheetState
    extends ConsumerState<UpdateWebsiteSyncComparisonSheet> {
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
    final updateWebsiteSyncProvider =
        ref.watch(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm);

    final filteredFiles = updateWebsiteSyncProvider.comparedFiles
        .where(
          (file) =>
              file.path.toLowerCase().contains(_searchText.toLowerCase()) &&
              (_selectedStatus == null || file.status == _selectedStatus),
        )
        .toList();

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
              padding: EdgeInsets.zero,
              shrinkWrap: true,
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
                return Center(
                  child: Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      leading: SizedBox(
                        height: double.infinity,
                        child: Icon(iconData, color: iconColor),
                      ),
                      title:
                          Text(file.path, style: const TextStyle(fontSize: 12)),
                      subtitle: Text(
                        statusText,
                        style: const TextStyle(fontSize: 10),
                      ),
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
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Flexible(
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _selectedStatus = null;
              });
            },
            icon: const Icon(
              Icons.filter_alt_outlined,
            ),
            label: Text(
              'All',
              style: textTheme.labelMedium,
            ),
            style: ButtonStyle(
              backgroundColor: _selectedStatus == null
                  ? MaterialStateProperty.all(
                      Colors.blue[100]!.withOpacity(0.2))
                  : null,
            ),
          ),
        ),
        Flexible(
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _selectedStatus = HostingContentComparisonStatus.localOnly;
              });
            },
            icon: const Icon(Icons.cloud_upload, color: Colors.orange),
            label: Text(
              'Local only',
              style: textTheme.labelMedium,
            ),
            style: ButtonStyle(
              backgroundColor:
                  _selectedStatus == HostingContentComparisonStatus.localOnly
                      ? MaterialStateProperty.all(
                          Colors.orange[100]!.withOpacity(0.2),
                        )
                      : null,
            ),
          ),
        ),
        Flexible(
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _selectedStatus = HostingContentComparisonStatus.remoteOnly;
              });
            },
            icon: const Icon(Icons.cloud_download, color: Colors.blue),
            label: Text(
              'Remote only',
              style: textTheme.labelMedium,
            ),
            style: ButtonStyle(
              backgroundColor:
                  _selectedStatus == HostingContentComparisonStatus.remoteOnly
                      ? MaterialStateProperty.all(
                          Colors.blue[100]!.withOpacity(0.2))
                      : null,
            ),
          ),
        ),
        Flexible(
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _selectedStatus =
                    HostingContentComparisonStatus.differentContent;
              });
            },
            icon: const Icon(Icons.sync_problem, color: Colors.red),
            label: Text(
              'Different',
              style: textTheme.labelMedium,
            ),
            style: ButtonStyle(
              backgroundColor: _selectedStatus ==
                      HostingContentComparisonStatus.differentContent
                  ? MaterialStateProperty.all(Colors.red[100]!.withOpacity(0.2))
                  : null,
            ),
          ),
        ),
        Flexible(
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _selectedStatus = HostingContentComparisonStatus.sameContent;
              });
            },
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
            label: Text(
              'Same',
              style: textTheme.labelMedium,
            ),
            style: ButtonStyle(
              backgroundColor:
                  _selectedStatus == HostingContentComparisonStatus.sameContent
                      ? MaterialStateProperty.all(
                          Colors.green[100]!.withOpacity(0.2),
                        )
                      : null,
            ),
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
