<<<<<<< HEAD
abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

mixin TitleAndPriceValidators {
  final StringValidator titleValidator = NonEmptyStringValidator();
  final StringValidator priceValidator = NonEmptyStringValidator();
  final String invalidTitleErrorText = 'Title can\'t be empty';
  final String invalidPriceErrorText = 'Price can\'t be empty';
}
=======
abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

mixin TitleAndPriceValidators {
  final StringValidator titleValidator = NonEmptyStringValidator();
  final StringValidator priceValidator = NonEmptyStringValidator();
  final String invalidTitleErrorText = 'Title can\'t be empty';
  final String invalidPriceErrorText = 'Price can\'t be empty';
}
>>>>>>> 8ddb56bed4ea68597595ff99aef8608671358442
