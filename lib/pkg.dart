import 'dart:io';
import 'package:args/args.dart';
import 'packageModel.dart';
import 'dart:async';
import 'dart:convert';

const pkgManagerName = 'dap';
var officialRepository = 'https://nmcain.github.io/packages/';
var applicationPath = Platform.environment['HOME'] + '/Applications';
//Check if mutiple packages are selected for install
List applications;

//Init package values
var dapFile;
var realName;
var version;
var description;
var hash;
var architecture;
var altName;
bool installable;

void validateInfo(List input) {
  applications = List<String>.from(input);
  applications.removeWhere((item) => item == '-y');
  applications.removeWhere((item) => item == 'install');
  bool isPlural = applications.length > 1;
  //print(applications.length);
  print(isPlural
      ? 'Searching for packages ' + applications.toString()
      : 'Searching for package ' + applications.toString());
  CheckApplicationManifest(applications[0].toString());
}

void CheckApplicationManifest(String inputAltName) {
  //print(inputAltName);
  //var appDir = dirname(Platform.script.toString()).substring(7);
  print('Reading ' + officialRepository + 'manifest.json');

  var sysArch =
      Process.runSync('uname', ['-m']).stdout.toString().replaceAll('\n', '');

  var rawJson = Process.runSync('curl', [officialRepository + 'manifest.json'])
      .stdout
      .toString();

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
  altName = manifest.packages
      .firstWhere((e) => e.altName == inputAltName, orElse: () => null)
      .altName;
  // ignore: prefer_single_quotes
  if (architecture != sysArch && architecture != "none") {
    print('The package "' +
        dapFile +
        '" (' +
        architecture +
        ') is not compatible with your device (' +
        sysArch +
        ')');
    installable = false;
  } else {
    installable = true;
  }
}

void validateInstall() {
  if (!installable) {
    print(pkgManagerName.toUpperCase() + ': ERROR: incompatible architecture!');
    exit(1);
  }
  print("Selected package: " +
      realName +
      " - version " +
      version +
      " - " +
      description);
  stdout.write("Do you want to continue? [Y/n] ");
  String consent = stdin.readLineSync();
  if (consent != "Y" && consent != "y") {
    print(pkgManagerName.toUpperCase() + ': Operation cancelled');
    exit(0);
  }
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