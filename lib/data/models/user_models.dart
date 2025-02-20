
class LoginModel {
  String? result;
  String? idX;
  String? userId;
  String? userPw;
  String? email;
  String? state;
  String? corpName;
  String? loginPrevious;
  String? loginType;
  String? autoLogin;
  String? sessionId;
  String? errorMessage;

  LoginModel({
    this.result,
    this.idX,
    this.userId,
    this.userPw,
    this.email,
    this.state,
    this.corpName,
    this.loginPrevious,
    this.loginType,
    this.autoLogin,
    this.sessionId,
    this.errorMessage
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    result                = json['result'];
    idX                   = json['idx'];
    userId                = json['user_id'];
    userPw                = json['user_pw'];
    email                 = json['email'];
    state                 = json['state'];
    corpName              = json['mem_id'];
    loginPrevious         = json['login_previous'];
    loginType             = json['login_type'];
    autoLogin             = json['autologin'];
    sessionId             = json['session_id'];
    errorMessage          = json['msg'];
  }

    Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['result']               = result;
    data['idx']                  = idX;
    data['user_id']              = userId;
    data['user_pw']              = userPw;
    data['email']                = email;
    data['state']                = state;
    data['mem_id']               = corpName;
    data['login_previous']       = loginPrevious;
    data['login_type']           = loginType;
    data['autologin']            = autoLogin;
    data['session_id']           = sessionId;
    data['msg']                  = errorMessage;
    return data;
  }
}
