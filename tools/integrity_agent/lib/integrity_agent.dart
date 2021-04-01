import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'manifest_model.dart';
import "package:path/path.dart" show dirname;

var officialRepository = 'https://nmcain.github.io/packages';

void CheckApplicationManifest() async {
  //var appDir = dirname(Platform.script.toString()).substring(7);
  print('Reading' + officialRepository + '/manifest.json');
  var jsonCheck =
      await Process.run('curl', [officialRepository + '/manifest.json']);
  var rawJson = jsonCheck.stdout.toString();
  print(rawJson);
  final jsonString = rawJson;
  final json = jsonDecode(jsonString);
  final manifest = Manifest.fromJson(json);
}

void CheckHash() {
  var appDir = Platform.script.toString().substring(7);
  String executable;
  Process.run('find', ['.', '-maxdepth', '1', '-perm', '-111', '-type', '-f'])
      .then((ProcessResult results) {
    executable = results.stdout.toString().substring(2);
  });
  print(executable);
  //find . -maxdepth 1 -perm -111 -type f

  Process.run('md5sum', ['-e']);
}

/*
check if file matches local hash in ~/.pkg/hash/
if it matches launch the app
if it doesnt, alert the user, ask to Reinstall, Remove, or launch bypassing security
*/