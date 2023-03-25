/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aeweb/util/get_it_instance.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class WebsiteAdd extends StatefulWidget {
  const WebsiteAdd({super.key});

  @override
  WebsiteAddState createState() => WebsiteAddState();
}

class WebsiteAddState extends State<WebsiteAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _publicCertPath = '';
  late String _privateKeyPath = '';
  final websiteNameTextController = TextEditingController(
    text: '',
  );

  @override
  void dispose() {
    websiteNameTextController.dispose();
    super.dispose();
  }

  Future<void> _selectPublicCertFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pem', 'crt'],
      );
      if (result != null) {
        setState(() {
          _publicCertPath = result.files.single.path!;
        });
      }
    } on Exception catch (e) {
      log('Error while picking public cert file: $e');
    }
  }

  Future<void> _selectPrivateKeyFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _privateKeyPath = result.files.single.path!;
        });
      }
    } on Exception catch (e) {
      log('Error while picking private key file: $e');
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final responseAddService = await sl
        .get<ArchethicDAppClient>()
        .addService({'name': 'aeweb-${websiteNameTextController.text}'});
    responseAddService.when(
      failure: (failure) {
        log(
          'Transaction failed',
          error: failure,
        );
        var message = 'An error occured';
        switch (failure.code) {
          case 4901:
            message = 'Please, connect your Archethic wallet';
            break;
          default:
            message = failure.message ?? 'An error occured';
            break;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          ),
        );
      },
      success: (result) async {
        log(
          'Transaction succeed : ${json.encode(result)}',
        );

        // Get genesis addresses
        var baseAddress = '';
        var refAddress = '';
        var filesAddress = '';

        const keychainFundingService = 'archethic-wallet-TEST';
        final keychainWebsiteService =
            'aeweb-${websiteNameTextController.text}';

        var responseDeriveAddress = await sl
            .get<ArchethicDAppClient>()
            .keychainDeriveAddress({'serviceName': keychainFundingService});
        responseDeriveAddress.when(
          failure: (failure) {},
          success: (result) {
            baseAddress = result.address;
          },
        );

        responseDeriveAddress =
            await sl.get<ArchethicDAppClient>().keychainDeriveAddress(
          {'serviceName': keychainWebsiteService},
        )
              ..when(
                failure: (failure) {},
                success: (result) {
                  refAddress = result.address;
                },
              );

        responseDeriveAddress =
            await sl.get<ArchethicDAppClient>().keychainDeriveAddress(
          {'serviceName': keychainWebsiteService, 'pathSuffix': 'files'},
        )
              ..when(
                failure: (failure) {},
                success: (result) {
                  filesAddress = result.address;
                },
              );

        // Get the chains size
        final transactionIndexMap = await sl
            .get<ApiService>()
            .getTransactionIndex([baseAddress, refAddress, filesAddress]);
        final baseIndex = transactionIndexMap[baseAddress] ?? 0;
        final refIndex = transactionIndexMap[refAddress] ?? 0;
        final filesIndex = transactionIndexMap[filesAddress] ?? 0;

        var isWebsiteUpdate = false;

        // Check if website is already deployed
        if (refIndex > 0) {
          log('Check last update...');
          isWebsiteUpdate = true;
          final lastRefTxMap = await sl
              .get<ApiService>()
              .getTransaction([refAddress], request: 'data { content }');
          final prevRefTxContent = lastRefTxMap[refAddress]!.data!.content!;
        }

        // Convert directory structure into array of file content
        log('Analyzing website folder...');

        const folderPath = '';
        final normalizedFolderPath = _normalizeFolderPath(folderPath);
        getFolderFiles(normalizedFolderPath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(json.encode(result)),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }

  String _normalizeFolderPath(String folderPath) {
    final normalizedPath = folderPath.endsWith(path.separator)
        ? folderPath.substring(0, folderPath.length - 1)
        : folderPath;
    return path.normalize(normalizedPath);
  }

  void handleDirectory(
    String folderPath,
    List<Map<String, dynamic>> files,
    bool includeGitIgnoredFiles,
    List<String> filters,
  ) {
    if (!filters.contains(folderPath)) {
      final entity = FileSystemEntity.typeSync(folderPath);
      if (entity == FileSystemEntityType.directory) {
        Directory(folderPath).listSync().forEach((child) {
          handleDirectory(
            path.join(folderPath, child.path),
            files,
            includeGitIgnoredFiles,
            filters,
          );
        });
      } else if (entity == FileSystemEntityType.file) {
        handleFile(folderPath, files);
      }
    }
  }

  List<Map<String, dynamic>> getFolderFiles(
    String folderPath, {
    bool includeGitIgnoredFiles = false,
  }) {
    var files = <Map<String, dynamic>>[];
    final filters = <String>[];

    final fileSystemEntity = FileSystemEntity.typeSync(folderPath);
    if (fileSystemEntity == FileSystemEntityType.directory) {
      handleDirectory(folderPath, files, includeGitIgnoredFiles, filters);

      files = files.map((file) {
        file['filePath'] = file['filePath'].replaceFirst(folderPath, '');
        return file;
      }).toList();
    } else if (fileSystemEntity == FileSystemEntityType.file) {
      final data = File(folderPath).readAsBytesSync();
      final filePath = path.basename(folderPath);
      files.add({'filePath': filePath, 'data': data});
    }

    return files;
  }

  void handleFile(String filePath, List<Map<String, dynamic>> files) {
    final data = File(filePath).readAsBytesSync();
    files.add({'filePath': filePath, 'data': data});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create a new website'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                "Service's name :",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextFormField(
                controller: websiteNameTextController,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _selectPublicCertFile,
                icon: const Icon(Icons.upload_file),
                label: const Text(
                  'Add PEM file of the public certificate for the domain',
                ),
              ),
              const SizedBox(height: 16),
              Text(_publicCertPath),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _selectPrivateKeyFile,
                icon: const Icon(Icons.upload_file),
                label: const Text(
                  'Add PEM file of the private key related to the certificate for the domain',
                ),
              ),
              const SizedBox(height: 16),
              Text(_privateKeyPath),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create website'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
