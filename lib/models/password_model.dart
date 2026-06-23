class PasswordModel {

  int? id;
  String account;
  String username;
  String password;

  PasswordModel({
    this.id,
    required this.account,
    required this.username,
    required this.password,
  });

  // Convert object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'account': account,
      'username': username,
      'password': password,
    };
  }

  // Convert Map to object
  factory PasswordModel.fromMap(Map<String, dynamic> map) {

    return PasswordModel(
      id: map['id'],
      account: map['account'],
      username: map['username'],
      password: map['password'],
    );
  }
}