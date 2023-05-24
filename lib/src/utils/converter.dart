import 'package:hashlib_codecs/hashlib_codecs.dart';

enum TextInputFormat {
  utf8,
  base2,
  base10,
  base16,
  base32,
  base64,
  ;

  @override
  String toString() => label;

  String get label {
    switch (this) {
      case utf8:
        return 'UTF-8';
      case base2:
        return 'Base-2 / Binary';
      case base10:
        return 'Base-10 / Decimal';
      case base16:
        return 'Base-16 / Hexadecimal';
      case base32:
        return 'Base-32';
      case base64:
        return 'Base-64';
    }
  }

  TextOutputFormat get output {
    switch (this) {
      case utf8:
        return TextOutputFormat.utf8;
      case base2:
        return TextOutputFormat.base2;
      case base10:
        return TextOutputFormat.base10;
      case base16:
        return TextOutputFormat.base16;
      case base32:
        return TextOutputFormat.base32;
      case base64:
        return TextOutputFormat.base64;
    }
  }

  List<int>? apply(String? input) {
    if (input == null) {
      return null;
    }
    try {
      switch (this) {
        case utf8:
          return input.codeUnits;
        case base2:
          return fromBinary(input);
        case base10:
          return fromBigInt(BigInt.parse(input, radix: 10));
        case base16:
          return fromHex(input);
        case base32:
          return fromBase32(input);
        case base64:
          return fromBase64(input);
      }
    } catch (err) {
      return null;
    }
  }
}

enum TextOutputFormat {
  utf8,
  base2,
  base10,
  base16,
  base16upper,
  base32,
  base32upper,
  base64,
  base64url,
  ;

  @override
  String toString() => label;

  String get label {
    switch (this) {
      case utf8:
        return 'UTF-8';
      case base2:
        return 'Base-2 / Binary';
      case base10:
        return 'Base-10 / Decimal';
      case base16:
        return 'Base-16 / Hexadecimal';
      case base16upper:
        return 'Base-16 / Hexadecimal (uppercase)';
      case base32:
        return 'Base-32';
      case base32upper:
        return 'Base-32 (uppercase)';
      case base64:
        return 'Base-64';
      case base64url:
        return 'Base-64 (url-safe)';
    }
  }

  TextInputFormat? get input {
    switch (this) {
      case utf8:
        return TextInputFormat.utf8;
      case base2:
        return TextInputFormat.base2;
      case base10:
        return TextInputFormat.base10;
      case base16:
      case base16upper:
        return TextInputFormat.base16;
      case base32:
      case base32upper:
        return TextInputFormat.base32;
      case base64:
      case base64url:
        return TextInputFormat.base64;
    }
  }

  String? apply(Iterable<int>? input) {
    if (input == null) {
      return null;
    }
    try {
      switch (this) {
        case utf8:
          return String.fromCharCodes(input);
        case base2:
          return toBinary(input);
        case base10:
          return toBigInt(input).toRadixString(10);
        case base16:
          return toHex(input);
        case base16upper:
          return toHex(input, upper: true);
        case base32:
          return toBase32(input, lower: true, padding: true);
        case base32upper:
          return toBase32(input, padding: true);
        case base64:
          return toBase64(input, padding: true);
        case base64url:
          return toBase64(input, padding: true, url: true);
      }
    } catch (err) {
      return null;
    }
  }
}
