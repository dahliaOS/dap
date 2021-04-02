import 'package:pkg/pkg.dart' as pkg;
import 'package:args/args.dart';
import 'dart:io';

void main(List<String> arguments) {
  if (arguments[0] == 'install') {
    if (arguments.contains('-y') && arguments.length >= 2) {
      // Install the package with no input from the user
      print(arguments.length.toInt());
      pkg.validateInfo(arguments);
      //TODO, in the future, use this to iiterate beween the list pkg.applications.forEach((element) => );
      print('Selected package: ' +
          pkg.realName +
          ' - version ' +
          pkg.version +
          ' - ' +
          pkg.description);
      print('Installing');
      pkg.checkArchitecture();
      pkg.downloadFile(
          pkg.applicationPath, pkg.officialRepository, pkg.dapFile);
      pkg.installApplication();
      print(pkg.realName +
          ' has been successfully installed. Launch it from the command line with: "' +
          pkg.altName +
          '"');
      //print(pkg.architecture);
    } else if (arguments.contains("-y") == false && arguments.length >= 2) {
      // Ask the user to confirm before installing the package
      pkg.validateInfo(arguments);
      //TODO, in the future, use this to iiterate beween the list pkg.applications.forEach((element) => );
      print('Selected package: ' +
          pkg.realName +
          ' - version ' +
          pkg.version +
          ' - ' +
          pkg.description);
      pkg.validateInstall();
      pkg.checkArchitecture();
      pkg.downloadFile(
          pkg.applicationPath, pkg.officialRepository, pkg.dapFile);
      pkg.installApplication();
      print(pkg.realName +
          ' has been successfully installed. Launch it from the command line with: "' +
          pkg.altName +
          '"');
    } else {
      // Indicate that no package was specified in input
      print(pkg.pkgManagerName.toUpperCase() + ': ERROR: no package specified');
    }
  } else if (arguments[0] == 'remove') {
    pkg.removalInfo(arguments);
    pkg.validateInstall();
    pkg.removeApplication();
  } else if (arguments[0] == 'search') {
    pkg.searchInfo(arguments);
  } else if (arguments.length <= 1) {
    print(pkg.pkgManagerName.toUpperCase() + ': ERROR: unknown command ');
  } else {
    // Print an error to indicate the command is not valid
    print(pkg.pkgManagerName.toUpperCase() +
        ': ERROR: unknown command ' +
        arguments[0]);
  }
}
