import 'dart:io';
import 'package:args/args.dart';
import 'packageModel.dart';
import 'dart:async';
import 'dart:convert';

var officialRepository = 'https://nmcain.github.io/packages/';
var applicationPath = Platform.environment['HOME'] + '/Applications';
//Init packatge values
var dapFile;
var realName;
var version;
var description;
var hash;
var architecture;

void validateInfo(List input) {
  var applications = List<String>.from(input);
  applications.removeWhere((item) => item == '-y');
  applications.removeWhere((item) => item == 'install');
  bool isPlural = applications.length > 1;
  //print(applications.length);
  print(isPlural
      ? 'Searching for packages ' + applications.toString()
      : 'Searching for package ' + applications.toString());
  CheckApplicationManifest(applications[0].toString());
}

void CheckApplicationManifest(String inputAltName) async {
  //print(inputAltName);
  //var appDir = dirname(Platform.script.toString()).substring(7);
  print('Reading ' + officialRepository + 'manifest.json');
  var jsonCheck =
      await Process.run('curl', [officialRepository + 'manifest.json']);
  var rawJson = jsonCheck.stdout.toString();

  final jsonString = rawJson;
  final json = jsonDecode(jsonString);
  final manifest = PackageManifest.fromJson(json);
  dapFile = manifest.packages
          .firstWhere((e) => e.altName == inputAltName, orElse: () => null)
          .id +
      '.dap';
  realName = manifest.packages
      .firstWhere((e) => e.altName == inputAltName, orElse: () => null)
      .realName;
  version = manifest.packages
      .firstWhere((e) => e.altName == inputAltName, orElse: () => null)
      .version;
  description = manifest.packages
      .firstWhere((e) => e.altName == inputAltName, orElse: () => null)
      .description;
  hash = manifest.packages
      .firstWhere((e) => e.altName == inputAltName, orElse: () => null)
      .hash;
  architecture = manifest.packages
      .firstWhere((e) => e.altName == inputAltName, orElse: () => null)
      .architecture;
  print(realName);
  //await downloadFile(applicationPath, officialRepository, dapFile);
  print('Complete');
}

bool downloadFile(String installationPath, String repository, String dapFile) {
  var client = HttpClient();
  var _downloadData = <int>[];
  var fileSave = File(installationPath + '/data/' + dapFile);
  print('Downloading file: ' +
      repository +
      dapFile +
      ' to ' +
      installationPath +
      '/data');
  client
      .getUrl(Uri.parse(repository + dapFile))
      .then((HttpClientRequest request) {
    return request.close();
  }).then((HttpClientResponse response) {
    response.listen((d) => _downloadData.addAll(d), onDone: () {
      fileSave.writeAsBytes(_downloadData);
    });
  });
  return (true);
}

void getApplicationInfo() {}
void installApplication(String name, bool askConsent) {}
// get sum of file
//check if it matches web sum
//save sum to ro file in ~/.pkg/hash