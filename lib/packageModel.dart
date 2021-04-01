class PackageManifest {
  final bool active;
  final List<IndividualPackage> packages;

  PackageManifest({this.active, this.packages});

  factory PackageManifest.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['packages'] as List;

    // print(list.runtimeType);
    List<IndividualPackage> packageList =
        list.map((i) => IndividualPackage.fromJson(i)).toList();

    return PackageManifest(active: parsedJson['active'], packages: packageList);
  }
}

class IndividualPackage {
  final String id;
  final String altName;
  final String realName;
  final String version;
  final String description;
  final String hash;
  final String architecture;

  IndividualPackage(
      {this.id,
      this.altName,
      this.realName,
      this.version,
      this.description,
      this.hash,
      this.architecture});
  factory IndividualPackage.fromJson(Map<String, dynamic> parsedJson) {
    return IndividualPackage(
        id: parsedJson['id'],
        altName: parsedJson['altName'],
        realName: parsedJson['realName'],
        version: parsedJson['version'],
        description: parsedJson['description'],
        hash: parsedJson['hash'],
        architecture: parsedJson['architecture']);
  }
}
