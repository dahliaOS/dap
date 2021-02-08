import 'dart:io';
import 'package:args/args.dart';

void validateInfo(List input) {
  var applications = new List<String>.from(input);
  applications.removeWhere((item) => item == '-y');
  applications.removeWhere((item) => item == 'install');
  bool isPlural = applications.length > 1;
  print(applications.length);
 print(isPlural?'Searching for packages '+applications.toString() :'Searching for package '+applications.toString() );

}

void getApplicationInfo() {}
void installApplication(String name, bool askConsent) {}
// get sum of file
//check if it matches web sum
//save sum to ro file in ~/.pkg/hash