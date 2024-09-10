import 'package:flutter/services.dart';
import 'package:material_hub/common_widgets/platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    super.key,
    required super.title,
    required PlatformException exception,
    super.cancelactionText = 'Cancel',
  }) : super(
          content: exception.message!,
          defaultactionText: 'OK',
        );
}
