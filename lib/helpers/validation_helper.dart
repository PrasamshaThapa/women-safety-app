import 'num_helper.dart';

class ValidationHelper {
  static String? passwordValidator(
    String? input, {
    String? emptyMessage,
    String? notLongMessage,
  }) {
    String? text;
    /*r'^
      (?=.*[A-Z])       // should contain at least one upper case
      (?=.*[a-z])       // should contain at least one lower case
      (?=.*?[0-9])      // should contain at least one digit
      (?=.*?[!@#\$&*~]) // should contain at least one Special character
        .{8,}             // Must be at least 8 characters in length
    $*/
    if (input?.isEmpty ?? true) {
      text = emptyMessage ?? 'Password Cannot Be Empty';
    } else {
      RegExp passwordValid = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()\-_=+{};:,<.>])[A-Za-z\d!@#$%^&*()\-_=+{};:,<.>.]{8,}$',
      );
      if (!passwordValid.hasMatch(input!)) {
        text =
            'Password Must Contain Minimum Eight Characters, At Least One Uppercase Letter, One Lowercase Letter, One Number And One Special Character';
      }
      if (input.length < 8) {
        text = notLongMessage ?? 'Password Must Be of Minimum 8 Characters';
      }
    }
    return text;
  }

  static String? emailValidator(String? input) {
    String? text;
    if (input?.isEmpty ?? true) {
      text = _emptyValidationText('Email');
    } else {
      bool emailValid =
          RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
              .hasMatch(input ?? '');
      if (!emailValid) {
        text = _invalidValidationText('Email');
      }
    }
    return text;
  }

  static String? phoneNumberValidator(String? input, {String? field}) {
    String? text;
    if (input?.isEmpty ?? true) {
      text = _emptyValidationText(field ?? 'Phone');
    } else {
      bool phoneValid = RegExp(r"^\+?(98|97)[0-9]{8}$").hasMatch(input ?? '');
      if (!phoneValid) {
        text = _invalidValidationText(field ?? 'Phone');
      }
    }
    return text;
  }

  static String? checkEmptyField(String? input, {required String field}) {
    String? text;
    if (input?.trim().isEmpty ?? true) {
      text = _emptyValidationText(field);
    }
    return text;
  }

  static String? checkMinimumLength(
    String? input, {
    required int minLength,
    required String field,
  }) {
    if (input?.trim().isEmpty ?? true) {
      return _emptyValidationText(field);
    } else if ((input?.trim().length ?? 0) < minLength) {
      return '$field must consist of at least $minLength characters';
    }
    return null;
  }

  static String? reTypePasswordValidator(
    String? input,
    String originalPassword, {
    String? message,
  }) {
    String? text;
    if (input != originalPassword) {
      text = message ?? 'Password Does not Match';
    }
    return text;
  }

  static String? oldNewPasswordValidator(
    String? input,
    String oldPassword, {
    String? field,
    String? sameMessage,
  }) {
    String? text;
    text = passwordValidator(input);
    if (text == null && input == oldPassword) {
      text =
          sameMessage ?? 'New Password Must Be Different Than Current Password';
    }
    return text;
  }

  static String? otpValidator(String? input) {
    int? convertedInput = int.tryParse(input ?? '');
    bool integerValid =
        RegExp(r"^([1-9]\d*)$").hasMatch(convertedInput.toString());

    if (!integerValid) {
      return 'Please Enter a Valid Code';
    }
    if ((input?.trim().isEmpty ?? true) || ((input?.length ?? 0) < 6)) {
      return 'Please Enter a Six-Digit Code';
    }

    return null;
  }

  static String? urlValidator(String? input, {String? field}) {
    if (input?.isEmpty ?? true) {
      return _emptyValidationText(field ?? 'URL');
    }
    bool stringValid = RegExp(r"^[a-z0-9]+$").hasMatch(input ?? '');
    if (!stringValid) {
      return '${_invalidValidationText(field ?? 'URL')} Containing Only Lowercase Alphabets And Digits';
    }
    return null;
  }

  static String? checkZeroValue(
    String input, {
    String? emptyMessage,
    String? negativeMessage,
  }) {
    int? convertedInput = int.tryParse(input);
    bool integerValid =
        RegExp(r"^([1-9]\d*)$").hasMatch(convertedInput.toString());
    if (input.trim().isEmpty == true) {
      return emptyMessage;
    } else {
      if (!integerValid) {
        return negativeMessage ?? 'Value cannot be a negative';
      }
    }
    return null;
  }

  static String? maxNumberValidator({
    required String? input,
    required String? maxValue,
    required String field,
    String? invalidMessage,
  }) {
    if (input?.trim().isEmpty ?? true) {
      return _emptyValidationText(field);
    }
    bool isValid = (NumHelper.parseString(input ?? '') ?? 0) <=
        (NumHelper.parseString(maxValue ?? '') ?? 0);
    if (!isValid) {
      return invalidMessage;
    }
    return null;
  }

  static String? minNumberValidator({
    required String? input,
    required String? minValue,
    required String field,
    String? invalidMessage,
  }) {
    if (input?.trim().isEmpty ?? true) {
      return _emptyValidationText(field);
    }
    bool isValid = (NumHelper.parseString(input ?? '') ?? 0) >
        (NumHelper.parseString(minValue ?? '') ?? 0);
    if (!isValid) {
      return invalidMessage;
    }
    return null;
  }

  static String _emptyValidationText(String field) => '$field Cannot Be Empty';
  static String _invalidValidationText(String field) =>
      'Please Enter a Valid $field';
  static String dropdownValidationText(String field) =>
      '    $field ${_emptyValidationText(field)}';
  static const formInvalidText = 'Please Submit a Valid Form';
}
