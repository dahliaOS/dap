class Manifest {
  final String id;
  final String name;
  final String executable;
  //TODO: ADD NOTIFICATION LISTENER FOR TYPE INPUT
  //final String type;

  Manifest({this.id, this.name, this.executable});

  factory Manifest.fromJson(Map<String, dynamic> json) {
    return Manifest(id: json['id'], name: json['name'], executable: json['executable']);
  }

  // Override toString to have a beautiful log of student object
  @override
  String toString() {
    return '$id $name $executable';
  }
}