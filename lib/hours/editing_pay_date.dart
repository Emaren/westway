import 'package:flutter/material.dart';

import 'pay_date_card.dart';

class EditingPayDate extends ChangeNotifier {
  PayDateCard? _payDate;

  PayDateCard? get payDate => _payDate;

  set payDate(PayDateCard? value) {
    _payDate = value;
    notifyListeners();
  }
}
