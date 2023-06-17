import 'package:flutter/material.dart';

import '../benchmark/blake2b.dart';
import '../benchmark/blake2s.dart';
import '../benchmark/keccak224.dart';
import '../benchmark/keccak256.dart';
import '../benchmark/keccak384.dart';
import '../benchmark/keccak512.dart';
import '../benchmark/md5.dart';
import '../benchmark/ripemd128.dart';
import '../benchmark/ripemd160.dart';
import '../benchmark/ripemd256.dart';
import '../benchmark/ripemd320.dart';
import '../benchmark/sha1.dart';
import '../benchmark/sha224.dart';
import '../benchmark/sha256.dart';
import '../benchmark/sha384.dart';
import '../benchmark/sha3_224.dart';
import '../benchmark/sha3_256.dart';
import '../benchmark/sha3_384.dart';
import '../benchmark/sha3_512.dart';
import '../benchmark/sha512.dart';
import '../benchmark/xxh128.dart';
import '../benchmark/xxh3.dart';
import '../benchmark/xxh32.dart';
import '../benchmark/xxh64.dart';

import '../demo/blake2b.dart';
import '../demo/blake2s.dart';
import '../demo/keccak224.dart';
import '../demo/keccak256.dart';
import '../demo/keccak384.dart';
import '../demo/keccak512.dart';
import '../demo/md5.dart';
import '../demo/ripemd128.dart';
import '../demo/ripemd160.dart';
import '../demo/ripemd256.dart';
import '../demo/ripemd320.dart';
import '../demo/sha1.dart';
import '../demo/sha224.dart';
import '../demo/sha256.dart';
import '../demo/sha384.dart';
import '../demo/sha3_224.dart';
import '../demo/sha3_256.dart';
import '../demo/sha3_384.dart';
import '../demo/sha3_512.dart';
import '../demo/sha512.dart';
import '../demo/shake128.dart';
import '../demo/shake256.dart';
import '../demo/xxh128.dart';
import '../demo/xxh3.dart';
import '../demo/xxh32.dart';
import '../demo/xxh64.dart';

class Algorithm {
  final String name;
  final String info;
  final Widget? benchmark;
  final Widget? demo;

  const Algorithm({
    required this.name,
    this.info = '',
    this.demo,
    this.benchmark,
  });
}

const algorithms = <Algorithm>[
  Algorithm(
    name: 'MD5',
    info: 'It can be used as a checksum to verify data integrity against '
        'unintentional corruption. Although it was widely used as a '
        'cryptographic hash function once, it has been found to suffer from '
        'extensive vulnerabilities.',
    demo: MD5Demo(),
    benchmark: MD5Benchmark(),
  ),
  Algorithm(
    name: 'SHA-1',
    info: 'It produces a message digest based on principle similar to MD5, '
        'except it can generate a 160-bit hash. Since 2005, SHA-1 has not been '
        'considered secure and NIST formally deprecated it in 2001. It is no '
        'longer allowed in digital signatures, however it is safe to use it as '
        'a checksum to verify data integrity.',
    demo: SHA1Demo(),
    benchmark: SHA1Benchmark(),
  ),
  Algorithm(
    name: 'SHA-224',
    info: 'It is a member of SHA-2 family which uses 224-bit internal state to '
        'generate a message digest of 224-bit long.',
    demo: SHA224Demo(),
    benchmark: SHA224Benchmark(),
  ),
  Algorithm(
    name: 'SHA-256',
    info: 'It is a member of SHA-2 family which uses 256-bit internal state to '
        'generate a message digest of 256-bit long.',
    demo: SHA256Demo(),
    benchmark: SHA256Benchmark(),
  ),
  Algorithm(
    name: 'SHA-384',
    info: 'It is a member of SHA-2 family which uses 384-bit internal state to '
        'generate a message digest of 384-bit long.',
    demo: SHA384Demo(),
    benchmark: SHA384Benchmark(),
  ),
  Algorithm(
    name: 'SHA-512',
    info: 'It is a member of SHA-2 family which uses 512-bit internal state to '
        'generate a message digest of 512-bit long.',
    demo: SHA512Demo(),
    benchmark: SHA512Benchmark(),
  ),
  Algorithm(
    name: 'SHA3-224',
    info: 'It is a member of SHA-3 family which uses 224-bit blocks to generate'
        ' a message digest of 224-bit long.',
    demo: SHA3of224Demo(),
    benchmark: SHA3of224Benchmark(),
  ),
  Algorithm(
    name: 'SHA3-256',
    info: 'It is a member of SHA-3 family which uses 256-bit blocks to generate'
        ' a message digest of 256-bit long.',
    demo: SHA3of256Demo(),
    benchmark: SHA3of256Benchmark(),
  ),
  Algorithm(
    name: 'SHA3-384',
    info: 'It is a member of SHA-3 family which uses 384-bit blocks to generate'
        ' a message digest of 384-bit long.',
    demo: SHA3of384Demo(),
    benchmark: SHA3of384Benchmark(),
  ),
  Algorithm(
    name: 'SHA3-512',
    info: 'It is a member of SHA-3 family which uses 512-bit blocks to generate'
        ' a message digest of 512-bit long.',
    demo: SHA3of512Demo(),
    benchmark: SHA3of512Benchmark(),
  ),
  Algorithm(
    name: 'SHAKE-128',
    info: 'It is a member of SHA-3 family which uses uses 128-bit blocks to '
        'generate a message digest of arbitrary length.',
    demo: SHAKE128Demo(),
  ),
  Algorithm(
    name: 'SHAKE-256',
    info: 'It is a member of SHA-3 family which uses uses 256-bit blocks to '
        'generate a message digest of arbitrary length.',
    demo: SHAKE256Demo(),
  ),
  Algorithm(
    name: 'Keccak-224',
    info: 'It is a secure and versatile hash function family that uses a simple'
        ' sponge constructions and Keccak-f cryptographic permutation. After '
        'its selection as the winner of the SHA-3 competition, Keccak has '
        'been standardized in NIST standards with a change in padding.',
    demo: Keccak224Demo(),
    benchmark: Keccak224Benchmark(),
  ),
  Algorithm(
    name: 'Keccak-256',
    info: 'It is a secure and versatile hash function family that uses a simple'
        ' sponge constructions and Keccak-f cryptographic permutation. After '
        'its selection as the winner of the SHA-3 competition, Keccak has '
        'been standardized in NIST standards with a change in padding.',
    demo: Keccak256Demo(),
    benchmark: Keccak256Benchmark(),
  ),
  Algorithm(
    name: 'Keccak-384',
    info: 'It is a secure and versatile hash function family that uses a simple'
        ' sponge constructions and Keccak-f cryptographic permutation. After '
        'its selection as the winner of the SHA-3 competition, Keccak has '
        'been standardized in NIST standards with a change in padding.',
    demo: Keccak384Demo(),
    benchmark: Keccak384Benchmark(),
  ),
  Algorithm(
    name: 'Keccak-512',
    info: 'It is a secure and versatile hash function family that uses a simple'
        ' sponge constructions and Keccak-f cryptographic permutation. After '
        'its selection as the winner of the SHA-3 competition, Keccak has '
        'been standardized in NIST standards with a change in padding.',
    demo: Keccak512Demo(),
    benchmark: Keccak512Benchmark(),
  ),
  Algorithm(
    name: 'Blake2b',
    info:
        "It is a highly secure cryptographic hash function optimized for 64-bit"
        " platforms. It generates hash values of data ranging from 1 to 64 "
        "bytes in size. It doesn't require a separate keying mechanism and can "
        "be used in various applications, serving as a more efficient "
        "alternative to other hash algorithms like SHA and HMAC-SHA.",
    demo: Blake2bDemo(),
    benchmark: Blake2bBenchmark(),
  ),
  Algorithm(
    name: 'Blake2s',
    info: "It is a cryptographic hash function optimized for 8-bit to 32-bit "
        "platforms. It generates hash values of data ranging from 1 to 32 bytes"
        " in size. Blake2s is highly secure and can be used in various "
        "applications as a fast and secure replacement for legacy algorithms "
        "like MD5 and HMAC-MD5",
    demo: Blake2sDemo(),
    benchmark: Blake2sBenchmark(),
  ),
  Algorithm(
    name: 'RIPEMD-128',
    info: 'It is a cryptographic hash function that produces a fixed-size, '
        '128-bit hash value. While it provides reasonable level of security, '
        'it is less commonly used than RIPEMD-160, the more secure algorithm '
        'in the same family.',
    demo: RIPEMD128Demo(),
    benchmark: RIPEMD128Benchmark(),
  ),
  Algorithm(
    name: 'RIPEMD-160',
    info: 'It is a cryptographic hash function that produces a fixed-size, '
        '160-bit hash value. It is used to verify the integrity and '
        'authenticity of messages and is resistant to various types of attacks,'
        ' including collisions and preimage attacks. It is commonly used in '
        'security protocols and applications.',
    demo: RIPEMD160Demo(),
    benchmark: RIPEMD160Benchmark(),
  ),
  Algorithm(
    name: 'RIPEMD-256',
    info: 'It is a cryptographic hash function that produces a fixed-size, '
        '256-bit hash value. It shares some design principles with RIPEMD-128, '
        'but provides a higher level of security. It is also less commonly '
        'used than RIPEMD-160.',
    demo: RIPEMD256Demo(),
    benchmark: RIPEMD256Benchmark(),
  ),
  Algorithm(
    name: 'RIPEMD-320',
    info: 'It is a cryptographic hash function that produces a fixed-size, '
        '320-bit hash value. It shares some design principles with RIPEMD-160,'
        ' but provides a higher level of security having a larger output size '
        'and a more complex message expansion function.',
    demo: RIPEMD320Demo(),
    benchmark: RIPEMD320Benchmark(),
  ),
  Algorithm(
    name: 'xxHash-32 (XXH32)',
    info: 'It is a fast and efficient non-cryptographic hash function for '
        '32-bit platforms. It is designed for producing a quick and reliable '
        'hash value for a given data, which can be used for many applications, '
        'such as checksum, data validation, etc. In addition, it has a good '
        'distribution of hash values, which helps to reduce collision.',
    demo: XXH32Demo(),
    benchmark: XXH32Benchmark(),
  ),
  Algorithm(
    name: 'xxHash-64 (XXH64)',
    info: 'It is a fast and efficient non-cryptographic hash function for '
        '64-bit platforms. It is designed for producing a quick and reliable '
        'hash value for a given data, which can be used for many applications, '
        'such as checksum, data validation, etc. In addition, it has a good '
        'distribution of hash values, which helps to reduce collision.',
    demo: XXH64Demo(),
    benchmark: XXH64Benchmark(),
  ),
  Algorithm(
    name: 'xxHash3-64 (XXH3)',
    info: 'It is a new high-performance variant of XXHash algorithm that is '
        'designed to be fast, with a low memory footprint, and to produce high'
        '-quality hash values with good distribution and low collision rates. '
        'This is an implementation of 64-bit XXH3 hash algorithm.',
    demo: XXH3Demo(),
    benchmark: XXH3Benchmark(),
  ),
  Algorithm(
    name: 'xxHash3-128 (XXH128)',
    info: 'It is a new high-performance variant of XXHash algorithm that is '
        'designed to be fast, with a low memory footprint, and to produce high'
        '-quality hash values with good distribution and low collision rates. '
        'This is an implementation of 128-bit XXH3 hash algorithm.',
    demo: XXH128Demo(),
    benchmark: XXH128Benchmark(),
  ),
];
