import 'dart:io';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:convert/convert.dart';

import 'package:http/http.dart' as http;
import 'package:webcrypto/webcrypto.dart' as web;

class BlockchainService {
  BlockchainService._privateConstructor();

  static final BlockchainService instance = BlockchainService._privateConstructor();
  static final String observerEndpoint = 'https://address.of.the.trustcerts.observer/'; //Change the address to the observer endpoint from trustcerts
  static final String portalEndpoint = 'https://address.of.the.trustcerts.portal/'; //Change the address to the portal endpoint from trustcerts
  static final String identifier = 'identifier provided by trustcerts'; //Change the identifier provided by trustcerts to interact with the observer endpoint
  static final Map<String, dynamic> privateKey = {
    "key_ops": [
      "sign"
    ],
    "ext": true,
    "kty": "RSA",
    "n": "",
    "e": "",
    "d": "",
    "p": "",
    "q": "",
    "dp": "",
    "dq": "",
    "qi": "",
    "alg": "RS256"
  }; //Change the private key to your own generated private key which the identifier from trustcerts is based on

  Future<Digest> hashFile(File file) async {
    var fileBytes = file.readAsBytesSync();

    var digest = sha256.convert(fileBytes);

    return digest;
  }

  Future<String> generateSignature(String value) async {
    web.RsassaPkcs1V15PrivateKey signer = await web.RsassaPkcs1V15PrivateKey.importJsonWebKey(privateKey, web.Hash.sha256);

    var signatureBytes = await signer.signBytes(utf8.encode(value));
    String signature = hex.encode(signatureBytes);

    return signature;
  }

  Future<dynamic> signFile(File file) async {
    int date = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    Digest digest = await hashFile(file);
    String hashHex = digest.toString();
    print('Hash hex: $hashHex');
    String algo = 'sha256';

    String value = jsonEncode({
      "date": date,
      "value": {
        "algorithm": algo,
        "hash": hashHex
      },
    });

    String signature = await generateSignature(value);

    String url = '${observerEndpoint}hash/create';

    String body = '''
          {
            "version": 1,
            "type": "HashCreation",
            "value": {
              "hash": "$hashHex",
              "algorithm": "$algo"
            },
            "metadata": {
              "date": $date
            },
            "signature": {
              "type": "single",
              "values": [
                {
                  "identifier": "$identifier",
                  "signature": "$signature"
                }
              ]
            }  
          }
    ''';

    final response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);

    print(response);
    print(response.body);

    return response.body;
  }

  Future<dynamic> validateFile(File file) async {
    Digest digest = await hashFile(file);
    String hashHex = digest.toString();
    print(hashHex);
    String url = '${portalEndpoint}hash/$hashHex';

    final response = await http.get(Uri.parse(url));

    return response;
  }
}