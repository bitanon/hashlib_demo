import 'package:hashlib/hashlib.dart';
import 'package:hashlib_codecs/hashlib_codecs.dart';

String toOTPAuthURL(TOTP totp) {
  return Uri(
    scheme: 'otpauth',
    host: 'totp',
    path: '${totp.label}',
    queryParameters: {
      'issuer': totp.issuer,
      'secret': toBase32(totp.secret, padding: false),
      'algorithm': totp.algorithm,
      'digits': totp.digits.toString(),
      'period': totp.period.toString(),
    },
  ).toString();
}

/// Decode Time-based OTPAuth instances from URL
Iterable<TOTP> parseTOTP(String input) sync* {
  input = input.trim();
  var uri = Uri.parse(input);
  if (uri.scheme == 'otpauth') {
    yield* _parseOTPAuth(uri);
  } else if (uri.scheme == 'otpauth-migration') {
    var data = fromBase64(
      input
          .split('?')
          .last
          .split('&')
          .firstWhere((d) => d.startsWith('data='))
          .split('=')
          .skip(1)
          .join('='),
    );
    yield* _parseOTPAuthMigrations(data);
  }
}

/// Decode OTPAuth instance from URL
Iterable<TOTP> _parseOTPAuth(Uri uri) sync* {
  if (uri.scheme != 'otpauth') {
    return;
  }

  var query = uri.queryParameters;
  if (!query.containsKey('secret')) {
    return;
  }
  var secret = fromBase32(query['secret']!);

  var algorithm = query['algorithm'] ?? 'SHA1';
  var algo = BlockHashRegistry.lookup(algorithm);
  if (algo == null) {
    return;
  }

  int digits = int.parse(query['digits'] ?? '6');
  if (digits < 6 || digits > 12) {
    return;
  }

  var label = Uri.decodeComponent(uri.path.substring(1));
  var issuer = query['issuer'];
  if (issuer != null) {
    issuer = Uri.decodeComponent(issuer);
  }

  switch (uri.host.toLowerCase()) {
    case 'totp':
      int period = int.parse(query['period'] ?? '30');
      yield TOTP(
        secret,
        algo: algo,
        digits: digits,
        period: period,
        label: label,
        issuer: issuer,
      );
    default:
      return;
  }
}

/// Decode Google Authenticator migration codes
Iterable<TOTP> _parseOTPAuthMigrations(List<int> data) sync* {
  for (int i = 2, len; i < data.length; ++i) {
    if (!(data[i - 2] == 10 && data[i] == 10)) continue;

    String secret;
    String label = 'Unknown';
    String issuer = '';
    String algorithm = 'SHA1';
    String digits = '6';
    String type = 'totp';

    i++;
    len = data[i];
    i++;
    secret = toBase32(data.skip(i).take(len));
    i += len;

    bool release = false;
    while (i < data.length && !release) {
      switch (data[i]) {
        case 18:
          i++;
          len = data[i];
          i++;
          label = String.fromCharCodes(data.skip(i).take(len));
          i += len;
          break;
        case 26:
          i++;
          len = data[i];
          i++;
          issuer = String.fromCharCodes(data.skip(i).take(len));
          i += len;
          break;
        case 32:
          i++;
          if (data[i] == 2) {
            algorithm = 'SHA256';
          } else if (data[i] == 3) {
            algorithm = 'SHA512';
          } else {
            algorithm = 'SHA1';
          }
          i++;
          break;
        case 40:
          i++;
          if (data[i] == 2) {
            digits = '8';
          } else {
            digits = '6';
          }
          i++;
          break;
        case 48:
          i++;
          if (data[i] == 1) {
            type = 'hotp';
          } else {
            type = 'totp';
          }
          i++;
          break;
        default:
          release = true;
          break;
      }
    }

    if (label.isEmpty && issuer.isNotEmpty) {
      label = issuer;
    }
    var params = [];
    if (issuer.isNotEmpty) {
      params.add('issuer=$issuer');
    }
    params.add('secret=$secret');
    params.add('algorithm=$algorithm');
    params.add('digits=$digits');

    yield* _parseOTPAuth(Uri(
      scheme: 'otpauth',
      host: type,
      path: '/$label',
      query: params.join('&'),
    ));
  }
}
