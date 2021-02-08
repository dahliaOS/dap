import 'dart:math';

import 'package:integrity_agent/integrity_agent.dart' as integrity_agent;
import 'package:integrity_agent/manifest_model.dart';
import "package:path/path.dart" show dirname;
import 'dart:io';
import 'dart:async';
import 'dart:convert';

void main() async {
  var agentName = 'demo';
  Map<String, String> envVars = Platform.environment;
  var appDir = dirname(Platform.script.toString()).substring(7);
  String ogInput;
  var results = await Process.run(
      'find', [appDir, '-maxdepth', '1', '-perm', '-111', '-type', 'f']);
  ogInput = results.stdout.toString();
  var executable = ogInput.split('\n');
  executable.removeWhere((item) => item.contains(agentName));
  var md5sum = await Process.run('md5sum', [executable[0].toString()]);
  var hash = md5sum.stdout.toString().substring(0, 32);
  print(hash);

  var jsonCheck = await Process.run('cat', [appDir + '/manifest.json']);
  var rawJson = jsonCheck.stdout.toString();
  final jsonString = rawJson;
  final json = jsonDecode(jsonString);
  final manifest = Manifest.fromJson(json);
  print(manifest);
  var propList = manifest.toString().split(' ');

  var initROHash = await Process.run(
      'cat', [envVars['HOME'] + '/.pkg/hashes/' + propList[1] + '.hash']);
  var hashInput = initROHash.stdout.toString().replaceAll("\n", "");

  print(hashInput);

  if (hash == hashInput) {
    print('validation successful');
  } else {
    stdout.write('DANGER! THE APPLICATION ' +
        propList[1] +
        ' (' +
        propList[0] +
        ') IS CORRUPT AND MAY BE INSECURE!. (R)einstall, (D)elete, or (C)ancel ? (R/D/C):');
    var input = stdin.readLineSync();
    if (input == 'r' || input == 'R') {
      Process.run('pkg', ['install', propList[1],'-y'])
          .then((ProcessResult results) {
        print(results.stdout);
      });
    } else if (input == 'd' || input == 'D') {
       Process.run('pkg', ['remove', propList[1],'-y'])
          .then((ProcessResult results) {
        print(results.stdout);
      });
    } else if (input == 'c' || input == 'C') {
      print('Cancelled');
    } else {
      print('Invalid input: ' + input + '\nCancelled');
    }
  }
  //find package file name in manifest file
  //executable.removeWhere((item) => !item.contains(agentName));
}
