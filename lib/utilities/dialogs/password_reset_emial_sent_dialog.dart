import 'package:flutter/material.dart';
import 'package:oifood/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password Rest',
    content: 'We have sent you an email with the link bitch ass nigga',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
