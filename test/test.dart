library test.test;

import 'dart:convert';
import 'dart:developer';

import 'package:aeweb/util/file_util.dart';
import 'package:aeweb/util/transaction_util.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:test/test.dart';

void main() {
  group('useCase', () {
    test('createTxReferenceFromPath', () async {
      final path =
          '/Volumes/Macintosh HD/Users/SSE/SSE/app/ARCHETHIC/archethic-website/';

      // Get the list of files in the path
      final files = await TestFileMixin().listFilesFromPath(
        path,
      );

      // Create transactions with file contents
      final contents = TestFileMixin().setContents(path, files!.keys.toList());

      final transactionsList = <Transaction>[];
      for (final content in contents) {
        transactionsList.add(
          TestTransactionMixin().newTransactionFile(content),
        );
      }

      // Create transaction reference
      final transactionReference =
          TestTransactionMixin().newTransactionReference(files);
      log(
        const JsonEncoder.withIndent('  ').convert(
          transactionReference.data!.content,
        ),
      );
      expect(
        transactionReference.type,
        'hosting',
      );
    });
  });
}

class TestFileMixin with FileMixin {}

class TestTransactionMixin with TransactionMixin {}
