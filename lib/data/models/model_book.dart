//
// class LoginModel {
//   bool?   result;
//   String? authenticationResult;
//   String? loginID;
//   String? errorMessage;
//
//   LoginModel({this.result, this.loginID, this.authenticationResult, this.errorMessage});
//   LoginModel.fromJson(Map<String, dynamic> json) {
//     result                = json['result'];
//     authenticationResult  = json['authenticationResult'];
//     loginID               = json['loginId'];
//     errorMessage          = json['msg'];
//   }
//
//     Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['result']               = result;
//     data['authenticationResult'] = authenticationResult;
//     data['loginId']              = loginID;
//     data['msg']                  = errorMessage;
//     return data;
//   }
// }