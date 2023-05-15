/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';

import 'package:aeweb/ui/views/unpublish_website/bloc/provider.dart';
import 'package:aeweb/util/transaction_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnpublishWebsiteUseCases with TransactionMixin {
  Future<void> run(
    WidgetRef ref,
  ) async {
    final unpublishWebsiteNotifier =
        ref.watch(UnpublishWebsiteFormProvider.unpublishWebsiteForm.notifier)
          ..setStep(0)
          ..setStepError('')
          ..setGlobalFees(0)
          ..setGlobalFeesValidated(null);
  }
}
