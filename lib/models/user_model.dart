class UserModel {
  final String email;
  final String name;
  final String uid;
  final DateTime createdAt;
  final bool isOnline;

  UserModel({
    required this.name,
    required this.email,
    required this.createdAt,
    required this.isOnline,
    required this.uid,
  });

  //To store data from dart to firbase
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'createdAt': createdAt,
      'isOnline': isOnline,
      'uid': uid,
    };
  }

  //to get data from firebase
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      createdAt: map['createdAt'],
      isOnline: map['isOnline'],
      uid: map['uid'],
    );
  }
}
