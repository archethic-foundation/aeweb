import 'dart:convert';
import 'dart:developer';

import 'package:aeweb/util/get_it_instance.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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
      print('Error while picking public cert file: $e');
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
      print('Error while picking private key file: $e');
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final response = await sl
        .get<ArchethicDAppClient>()
        .addService({'name': 'aeweb-${websiteNameTextController.text}'});
    response.when(
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
      success: (result) {
        log(
          'Transaction succeed : ${json.encode(result)}',
        );
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
