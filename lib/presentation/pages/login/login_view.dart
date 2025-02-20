import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
import '../../../app/extensions/color.dart';
import '../../../app/services/authen_service.dart';
import '../../controllers/auth/auth_controller.dart';

class LoginView extends GetView<AuthController> with WindowListener{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LoginView({Key? key}) : super(key: key);
  final auth = Get.find<AuthenService>();
  final GlobalKey webViewKey = GlobalKey();
  double progress            = 0;
  bool isToken = false;
  var scaffoldLoginKey = GlobalKey<ScaffoldState>();
  Color colorHeader = HexColor("#479CEC");
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    auth.title.value ='ログイン';
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        // backgroundColor: Colors.white,
        key: scaffoldLoginKey,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.blue, //change your color here
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Container(
            padding: const EdgeInsets.only(top: 0,bottom: 0),
            width: MediaQuery.of(context).size.width,
            height: 80,
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(0, 0),
                  child: const Text('ログイン', style: TextStyle( fontWeight: FontWeight.w500, fontSize: 20, color: Colors.blue),),
                ),
              ],
            ),
          ),// Status bar colors bar color
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Image.asset('assets/images/logo.png', height: 100,),
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          width: w / 1.3,
                          child: TextFormField(
                            autofocus: true,
                            controller: controller.txtUserName,
                            // keyboardType: TextInputType,
                            decoration: const InputDecoration(
                              hintText: 'ID',
                              border: InputBorder.none,
                            ),
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //   return controller.errorMessage = 'User name cant be empty';
                            //   }
                            //   return null;
                            // },
                          ),
                        ),
                        Container(
                          height: 1,
                          width: w / 1.3,
                          color: Colors.grey,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          width: w / 1.3,
                          child: TextFormField(
                            controller: controller.txtPassword,
                            decoration: const InputDecoration(
                              hintText: 'パスワード',
                              border: InputBorder.none,
                            ),
                            obscureText: controller.showHidePass,
                            validator: ((value) {
                              return null;

                              // if (value!.isEmpty) {
                              // return controller.errorMessage = 'Password cant be empty';
                              // }
                              // return null;
                            }),
                            onFieldSubmitted: (value){
                              controller.signInPassword();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(() => controller.showError.value == true ? Container(
                    alignment: Alignment.centerLeft,
                    height: h / 21,
                    width: w / 1.3,
                    child: Text(controller.errorTxt.value, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 15),)
                ): SizedBox(height: h / 60,)),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    // foregroundColor: HexColor('#0A76D5'),
                    fixedSize: Size(w / 1.3, h / 18),
                    // backgroundColor: HexColor('F2F9FE'),
                    backgroundColor: colorHeader,
                    // side: BorderSide(width: 1, color: HexColor('#0A76D5')),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'ログイン',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w100,
                      color:Colors.white,
                    ),
                  ),
                  onPressed: () {
                    controller.signInPassword();
                    // controller.signUpWith('nhan');
                  },
                ),
                ///-- LOGIN GOOGLE
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  width: w / 1.3,
                  child:const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          height: 0.3,
                        ),
                      ),
                      Text(" OR "),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          height: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    // foregroundColor: HexColor('#0A76D5'),
                    fixedSize: Size(w / 1.3, h / 18),
                    backgroundColor: Colors.white,
                    // side: BorderSide(width: 1, color: HexColor('#0A76D5')),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Image.asset('assets/images/google-login.png', alignment: Alignment.centerLeft,),
                      ),
                      const Text(
                        'Sign In with Google',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w100,
                          color:Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    controller.signInGoogle();
                  },
                ),
                Obx(() =>  controller.showLoginGoogleError == true ? Container(
                    alignment: Alignment.centerLeft,
                    height: h / 21,
                    width: w / 1.3,
                    child: Text(controller.errorTxt.value, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 15),)
                ) : SizedBox(
                  height: h / 60,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
