import 'package:pkg/pkg.dart' as pkg;
import 'package:args/args.dart';
import 'dart:io';

void main(List<String> arguments) {
  if (arguments[0] == 'install') {
    if (arguments.contains('-y') && arguments.length >= 2) {
      // Install the package with no input from the user
      pkg.validateInfo(arguments);
      //TODO, in the future, use this to iiterate beween the list pkg.applications.forEach((element) => );
      pkg.validateInstall();
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
      print('did not contain y, good');
    } else {
      // Indicate that no package was specified in input
      print(pkg.pkgManagerName.toUpperCase() + ': ERROR: no package specified');
    }
  } else if (arguments[0] == 'search') {
    // Query for package from database using command input, and print results
    print("yep, that's a search");
  } else {
    // Print an error to indicate the command is not valid
    print(pkg.pkgManagerName.toUpperCase() +
        ': ERROR: unknown command ' +
        arguments[0]);
  }
}
