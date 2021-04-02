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
  var isPlural = applications.length > 1;
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

void checkArchitecture() {
  if (!installable) {
    print(pkgManagerName.toUpperCase() + ': ERROR: incompatible architecture!');
    exit(1);
  }
}

void validateInstall() {
  stdout.write('Do you want to continue? [Y/n] ');
  var consent = stdin.readLineSync();
  if (consent != 'Y' && consent != 'y') {
    print(pkgManagerName.toUpperCase() + ': Operation cancelled');
    exit(0);
  }
}

void downloadFile(String installationPath, String repository, String dapFile) {
  var fileSave = installationPath + '/data/';
  print('Downloading file: ' +
      repository +
      dapFile +
      ' to ' +
      installationPath +
      '/data ...');
  Process.runSync('wget', [repository + dapFile, '-P', fileSave]);
}

void installApplication() {
  print('Checking signature of ' + dapFile);
  var localHash =
      Process.runSync('md5sum', [applicationPath + '/data/' + dapFile])
          .stdout
          .toString()
          .substring(0, 32);
  if (localHash != hash) {
    print(pkgManagerName.toUpperCase() +
        ': ERROR: HASH MISMATCH! REMOTE HASH: ' +
        hash +
        ' LOCAL HASH: ' +
        localHash);
    Process.runSync('rm', [applicationPath + '/data/' + dapFile]);
    exit(1);
  }
  print('Activating file: ' + dapFile);
  Process.runSync('chmod', ['+x', applicationPath + '/data/' + dapFile]);
  print('Linking file: ' + dapFile);
  Process.runSync('ln', [
    '-s',
    applicationPath + '/data/' + dapFile,
    applicationPath + '/links/' + altName
  ]);
  //Mark downloaded file as executable
  //link file to appDir/links
}
// get sum of file
//check if it matches web sum
//save sum to ro file in ~/.pkg/hash