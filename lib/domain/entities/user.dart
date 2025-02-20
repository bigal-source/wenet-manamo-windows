class UserEntity {
  int? id;
  String? idx;
  String ?session;
  int ?isLogin;
  String ?email;
  String ?lastLogin;
  String ?data;

  UserEntity({this.id,this.idx, this.session, this.isLogin, this.email, this.lastLogin, this.data});

  factory UserEntity.fromMap(Map<String, dynamic> json) => UserEntity(
    id           : json["id"],
    idx          : json["idx"],
    session      : json["session"],
    isLogin      : json["isLogin"],
    email        : json["email"],
    lastLogin    : json["lastLogin"],
    data         : json["data"],
  );
  Map<String, dynamic> toMap() => {
    "id"           : id,
    "idx"          : idx,
    "session"      : session,
    "isLogin"      : isLogin,
    "email"        : email,
    "lastLogin"    : lastLogin,
    "data"         : data,
  };
}