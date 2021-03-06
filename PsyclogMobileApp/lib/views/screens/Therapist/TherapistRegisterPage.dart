import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:psyclog_app/service/WebServerService.dart';
import 'package:psyclog_app/views/util/ViewConstants.dart';

class TherapistRegisterPage extends StatefulWidget {
  @override
  _TherapistRegisterPageState createState() => _TherapistRegisterPageState();
}

class _TherapistRegisterPageState extends State<TherapistRegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordCheckController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _biographyController = TextEditingController();
  final _phoneController = TextEditingController();

  String _usernameErrorText;
  String _passwordErrorText;
  String _passwordCheckErrorText;
  String _emailErrorText;
  String _firstNameErrorText;
  String _lastNameErrorText;
  String _biographyErrorText;
  String _phoneErrorText;

  bool _usernameValidate;
  bool _passwordValidate;
  bool _passwordCheckValidate;
  bool _emailValidate;
  bool _firstNameValidate;
  bool _lastNameValidate;
  bool _biographyValidate;
  bool _phoneValidate;

  File therapistTranscriptFile;
  File therapistCVFile;

  final UnfocusDisposition disposition = UnfocusDisposition.scope;

  WebServerService _webServerService;
  PageController _pageController;
  int _pageIndex;

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    // checking Animation width sizes for safety
  }

  Future<bool> initializeService() async {
    _webServerService = await WebServerService.getWebServerService();
    if (_webServerService != null)
      return true;
    else
      return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageController = PageController(initialPage: 0);
    _pageIndex = 0;

    _usernameErrorText = "";
    _passwordErrorText = "";
    _passwordCheckErrorText = "";
    _emailErrorText = "";
    _firstNameErrorText = "";
    _lastNameErrorText = "";
    _biographyErrorText = "";
    _phoneErrorText = "";

    _usernameValidate = false;
    _passwordValidate = false;
    _passwordCheckValidate = false;
    _emailValidate = false;
    _firstNameValidate = false;
    _lastNameValidate = false;
    _biographyValidate = false;
    _phoneValidate = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordCheckController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _pageController.dispose();
    _biographyController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  Future<bool> _signUp(BuildContext context) async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String passwordCheck = _passwordCheckController.text;
    final String email = _emailController.text;
    final String firstName = _firstNameController.text;
    final String lastName = _lastNameController.text;
    final String phone = _phoneController.text;
    final String bio = _biographyController.text;

    if (username.isNotEmpty &&
        password.isNotEmpty &&
        passwordCheck.isNotEmpty &&
        email.isNotEmpty &&
        firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        phone.isNotEmpty &&
        bio.isNotEmpty &&
        therapistCVFile.path.isNotEmpty &&
        therapistTranscriptFile.path.isNotEmpty) {
      final bool isCreated = await _webServerService.attemptTherapistSignUp(
        username,
        password,
        passwordCheck,
        email,
        firstName,
        lastName,
        phone,
        bio,
        therapistCVFile.path,
        therapistTranscriptFile.path,
      );

      if (isCreated) {
        print("User is created");
        return isCreated;
      } else {
        setState(() {
          _pageIndex = 0;
          _pageController.animateToPage(_pageIndex, duration: Duration(milliseconds: 300), curve: Curves.decelerate);
        });
      }
    } else {
      setState(() {
        _pageIndex = 0;
        _pageController.animateToPage(_pageIndex, duration: Duration(milliseconds: 300), curve: Curves.decelerate);
      });

      final snackBar = SnackBar(
          duration: Duration(milliseconds: 1500),
          backgroundColor: ViewConstants.myBlack,
          content: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "Do not forget to fill out all the fields.",
              style: TextStyle(color: ViewConstants.myWhite),
            ),
          ));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    double _nextButtonWidth;
    double _backButtonWidth;

    final usernameField = Theme(
      data: ThemeData(
        primaryColor: ViewConstants.myWhite,
        accentColor: ViewConstants.myWhite,
        cursorColor: ViewConstants.myWhite,
        hintColor: ViewConstants.myWhite,
      ),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _usernameController,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.account_circle,
            color: ViewConstants.myWhite,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myWhite),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myBlue),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myWhite),
          ),
          errorText: _usernameValidate ? _usernameErrorText : null,
          errorStyle: TextStyle(fontSize: 15, color: ViewConstants.myPink, fontWeight: FontWeight.w400),
          hintText: 'Type your username',
          hintStyle: TextStyle(fontSize: 15, color: ViewConstants.myWhite, fontWeight: FontWeight.w400),
        ),
        style: TextStyle(color: ViewConstants.myWhite, fontWeight: FontWeight.w500, fontSize: 15),
        onEditingComplete: () {
          primaryFocus.unfocus(disposition: disposition);
          setState(() {
            _usernameController.text.isEmpty ? _usernameValidate = true : _usernameValidate = false;
            _usernameValidate ? _usernameErrorText = "This field cannot be empty" : _usernameErrorText = null;
          });
        },
      ),
    );

    final passwordField = Theme(
      data: ThemeData(
        primaryColor: ViewConstants.myWhite,
        cursorColor: ViewConstants.myWhite,
        hintColor: ViewConstants.myWhite,
      ),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock_open,
            color: ViewConstants.myWhite,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myWhite),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myBlue),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myWhite),
          ),
          errorText: _passwordValidate ? _passwordErrorText : null,
          errorStyle: TextStyle(fontSize: 15, color: ViewConstants.myPink, fontWeight: FontWeight.w400),
          hintText: 'Type your password',
          hintStyle: TextStyle(fontSize: 15, color: ViewConstants.myWhite, fontWeight: FontWeight.w400),
        ),
        style: TextStyle(color: ViewConstants.myWhite, fontWeight: FontWeight.w500),
        onEditingComplete: () {
          primaryFocus.unfocus(disposition: disposition);
          setState(() {
            _passwordController.text.isEmpty ? _passwordValidate = true : _passwordValidate = false;
            _passwordValidate ? _passwordErrorText = "This field cannot be empty" : _passwordErrorText = null;
          });
        },
      ),
    );

    final passwordFieldCheck = Theme(
      data: ThemeData(
        primaryColor: ViewConstants.myWhite,
        cursorColor: ViewConstants.myWhite,
        hintColor: ViewConstants.myWhite,
      ),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _passwordCheckController,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: ViewConstants.myWhite,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myWhite),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myBlue),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myWhite),
          ),
          errorText: _passwordCheckValidate ? _passwordCheckErrorText : null,
          errorStyle: TextStyle(fontSize: 15, color: ViewConstants.myPink, fontWeight: FontWeight.w400),
          hintText: 'Match your password',
          hintStyle: TextStyle(fontSize: 15, color: ViewConstants.myWhite, fontWeight: FontWeight.w400),
        ),
        style: TextStyle(color: ViewConstants.myWhite, fontWeight: FontWeight.w500),
        onEditingComplete: () {
          primaryFocus.unfocus(disposition: disposition);
          setState(() {
            _passwordCheckController.text.isEmpty ? _passwordCheckValidate = true : _passwordCheckValidate = false;
            _passwordCheckValidate ? _passwordCheckErrorText = "This field cannot be empty" : _passwordCheckErrorText = null;
          });
        },
      ),
    );

    final emailField = Theme(
      data: ThemeData(
        primaryColor: ViewConstants.myWhite,
        accentColor: ViewConstants.myWhite,
        cursorColor: ViewConstants.myWhite,
        hintColor: ViewConstants.myWhite,
      ),
      child: TextField(
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.mail,
              color: ViewConstants.myWhite,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ViewConstants.myWhite),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ViewConstants.myBlue),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: ViewConstants.myWhite),
            ),
            errorText: _emailValidate ? _emailErrorText : null,
            errorStyle: TextStyle(fontSize: 15, color: ViewConstants.myPink, fontWeight: FontWeight.w400),
            hintText: 'Type your e-mail',
            hintStyle: TextStyle(fontSize: 15, color: ViewConstants.myWhite, fontWeight: FontWeight.w400),
          ),
          style: TextStyle(color: ViewConstants.myWhite, fontWeight: FontWeight.w500, fontSize: 15),
          onEditingComplete: () {
            primaryFocus.unfocus(disposition: disposition);
            setState(() {
              _emailController.text.isEmpty ? _emailValidate = true : _emailValidate = false;
              _emailValidate ? _emailErrorText = "This field cannot be empty" : _emailErrorText = null;
            });
          }),
    );

    final firstNameField = Theme(
      data: ThemeData(
        primaryColor: ViewConstants.myWhite,
        accentColor: ViewConstants.myWhite,
        cursorColor: ViewConstants.myWhite,
        hintColor: ViewConstants.myWhite,
      ),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _firstNameController,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.portrait,
            color: ViewConstants.myWhite,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myWhite),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myBlue),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myWhite),
          ),
          errorText: _firstNameValidate ? _firstNameErrorText : null,
          errorStyle: TextStyle(fontSize: 15, color: ViewConstants.myPink, fontWeight: FontWeight.w400),
          hintText: 'Type your first name',
          hintStyle: TextStyle(fontSize: 15, color: ViewConstants.myWhite, fontWeight: FontWeight.w400),
        ),
        style: TextStyle(color: ViewConstants.myWhite, fontWeight: FontWeight.w500, fontSize: 15),
        onEditingComplete: () {
          primaryFocus.unfocus(disposition: disposition);
          setState(() {
            _firstNameController.text.isEmpty ? _firstNameValidate = true : _firstNameValidate = false;
            _firstNameValidate ? _firstNameErrorText = "This field cannot be empty" : _firstNameErrorText = null;
          });
        },
      ),
    );
    final lastNameField = Theme(
      data: ThemeData(
        primaryColor: ViewConstants.myWhite,
        accentColor: ViewConstants.myWhite,
        cursorColor: ViewConstants.myWhite,
        hintColor: ViewConstants.myWhite,
      ),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _lastNameController,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.people,
            color: ViewConstants.myWhite,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myWhite),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myBlue),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myWhite),
          ),
          errorText: _lastNameValidate ? _lastNameErrorText : null,
          errorStyle: TextStyle(fontSize: 15, color: ViewConstants.myPink, fontWeight: FontWeight.w400),
          hintText: 'Type your surname',
          hintStyle: TextStyle(fontSize: 15, color: ViewConstants.myWhite, fontWeight: FontWeight.w400),
        ),
        style: TextStyle(color: ViewConstants.myWhite, fontWeight: FontWeight.w500, fontSize: 15),
        onEditingComplete: () {
          primaryFocus.unfocus(disposition: disposition);
          setState(() {
            _lastNameController.text.isEmpty ? _lastNameValidate = true : _lastNameValidate = false;
            _lastNameValidate ? _lastNameErrorText = "This field cannot be empty" : _lastNameErrorText = null;
          });
        },
      ),
    );

    final biographyField = Theme(
      data: ThemeData(
        primaryColor: ViewConstants.myWhite,
        accentColor: ViewConstants.myWhite,
        cursorColor: ViewConstants.myWhite,
        hintColor: ViewConstants.myWhite,
      ),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _biographyController,
        maxLines: 8,
        maxLength: 120,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.menu_book,
            color: ViewConstants.myWhite,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myWhite),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myBlue),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myWhite),
          ),
          errorText: _biographyValidate ? _biographyErrorText : null,
          errorStyle: TextStyle(fontSize: 15, color: ViewConstants.myPink, fontWeight: FontWeight.w400),
          hintText: 'Type your biography',
          hintStyle: TextStyle(fontSize: 15, color: ViewConstants.myWhite, fontWeight: FontWeight.w400),
        ),
        style: TextStyle(color: ViewConstants.myWhite, fontWeight: FontWeight.w500, fontSize: 15),
        onEditingComplete: () {
          primaryFocus.unfocus(disposition: disposition);
          setState(() {
            _biographyController.text.isEmpty ? _biographyValidate = true : _biographyValidate = false;
            _biographyValidate ? _biographyErrorText = "This field cannot be empty" : _biographyErrorText = null;
          });
        },
      ),
    );

    final phoneField = Theme(
      data: ThemeData(
        primaryColor: ViewConstants.myWhite,
        accentColor: ViewConstants.myWhite,
        cursorColor: ViewConstants.myWhite,
        hintColor: ViewConstants.myWhite,
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: _phoneController,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.phone,
            color: ViewConstants.myWhite,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myWhite),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myBlue),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: ViewConstants.myWhite),
          ),
          errorText: _phoneValidate ? _phoneErrorText : null,
          errorStyle: TextStyle(fontSize: 15, color: ViewConstants.myPink, fontWeight: FontWeight.w400),
          hintText: 'Type your phone number',
          hintStyle: TextStyle(fontSize: 15, color: ViewConstants.myWhite, fontWeight: FontWeight.w400),
        ),
        style: TextStyle(color: ViewConstants.myWhite, fontWeight: FontWeight.w500, fontSize: 15),
        onEditingComplete: () {
          primaryFocus.unfocus(disposition: disposition);
          setState(() {
            _phoneController.text.isEmpty ? _phoneValidate = true : _phoneValidate = false;
            _phoneValidate ? _phoneErrorText = "This field cannot be empty" : _phoneErrorText = null;
          });
        },
      ),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: ViewConstants.myBlack,
      body: FutureBuilder(
        future: initializeService(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 20),
                      child: Text("Please fill your account information",
                          style: ViewConstants.fieldStyle
                              .copyWith(color: ViewConstants.myWhite, fontWeight: FontWeight.w500, fontSize: 18)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        margin: EdgeInsets.all(25),
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 25, left: 25, top: 30, bottom: 10),
                              child: usernameField,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 25, left: 25, top: 10, bottom: 10),
                              child: passwordField,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 25, left: 25, top: 10, bottom: 30),
                              child: passwordFieldCheck,
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(25),
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 25, left: 25, top: 30, bottom: 10),
                              child: emailField,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 25, left: 25, top: 10, bottom: 10),
                              child: firstNameField,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 25, left: 25, top: 10, bottom: 10),
                              child: lastNameField,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 25, left: 25, top: 10, bottom: 30),
                              child: phoneField,
                            )
                          ],
                        ),
                      ),
                      LayoutBuilder(builder: (context, constraints) {
                        return Container(
                          margin: EdgeInsets.all(25),
                          color: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 25, left: 25, top: 0, bottom: 10),
                                child: FlatButton(
                                  minWidth: constraints.minWidth,
                                  color: ViewConstants.myWhite,
                                  onPressed: () async {
                                    FilePickerResult therapistCV = await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['pdf', 'doc'],
                                    );

                                    if (therapistCV != null) {
                                      therapistCVFile = File(therapistCV.files.single.path);
                                      print(therapistCVFile.path);
                                    }
                                  },
                                  child: Text(
                                    "Pick your CV",
                                    style:
                                        TextStyle(fontSize: 15, color: ViewConstants.myBlack, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 25, left: 25, top: 10, bottom: 10),
                                child: FlatButton(
                                  minWidth: constraints.minWidth,
                                  color: ViewConstants.myWhite,
                                  onPressed: () async {
                                    FilePickerResult therapistTranscript = await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['pdf', 'doc'],
                                    );

                                    if (therapistTranscript != null) {
                                      therapistTranscriptFile = File(therapistTranscript.files.single.path);
                                      print(therapistTranscriptFile.path);
                                    }
                                  },
                                  child: Text(
                                    "Pick your Transcript",
                                    style:
                                        TextStyle(fontSize: 15, color: ViewConstants.myBlack, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 25, left: 25, top: 10, bottom: 0),
                                child: biographyField,
                              )
                            ],
                          ),
                        );
                      }),
                      Container(
                        margin: EdgeInsets.all(25),
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 3,
                              child: Center(
                                child: TweenAnimationBuilder(
                                  duration: Duration(milliseconds: 600),
                                  tween: Tween(begin: 0.0, end: MediaQuery.of(context).size.height / 3),
                                  curve: Curves.easeIn,
                                  builder: (BuildContext context, double size, Widget child) {
                                    return Icon(
                                      Icons.done,
                                      size: size,
                                      color: ViewConstants.myWhite,
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Text(
                                "Your account is ready to be created. Please continue.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: ViewConstants.myWhite,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                          _backButtonWidth = MediaQuery.of(context).size.width * ((4 - _pageIndex) / 5) * 0.9;
                          _nextButtonWidth = MediaQuery.of(context).size.width * ((_pageIndex + 1) / 5) * 0.9;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AnimatedContainer(
                                width: _backButtonWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  color: ViewConstants.myGrey,
                                ),
                                duration: Duration(milliseconds: 250),
                                child: FlatButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {
                                    primaryFocus.unfocus(disposition: disposition);
                                    if (_pageIndex == 3) {
                                      print("here");
                                    } else if (_pageIndex > 0) {
                                      setState(() {
                                        _pageIndex = _pageController.page.toInt() - 1;
                                        _pageController.animateToPage(_pageIndex,
                                            duration: Duration(milliseconds: 1), curve: Curves.decelerate);
                                      });
                                    } else if (_pageIndex == 0) {
                                      print("Navigating Back to Register Page...");
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    _pageIndex != 3 ? "Back" : "Done",
                                    style: TextStyle(color: ViewConstants.myWhite),
                                  ),
                                ),
                              ),
                              AnimatedContainer(
                                width: _nextButtonWidth,
                                duration: Duration(milliseconds: 250),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                  color: ViewConstants.myBlue,
                                ),
                                child: FlatButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () async {
                                    primaryFocus.unfocus(disposition: disposition);
                                    if (_pageIndex < 3) {
                                      bool isCreated = false;
                                      if (_pageIndex == 2) {
                                        isCreated = await _signUp(context);
                                        if (isCreated) {
                                          setState(() {
                                            _pageIndex = _pageController.page.toInt() + 1;
                                            _pageController.animateToPage(_pageIndex,
                                                duration: Duration(milliseconds: 1), curve: Curves.decelerate);
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          _pageIndex = _pageController.page.toInt() + 1;
                                          _pageController.animateToPage(_pageIndex,
                                              duration: Duration(milliseconds: 1), curve: Curves.decelerate);
                                        });
                                      }
                                    } else if (_pageIndex == 3) {
                                      if (true) {
                                        print("Navigating to Login Page...");
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          ViewConstants.loginRoute,
                                          (route) => false,
                                        );
                                      }
                                    }
                                  },
                                  child: Text(
                                    (_pageIndex != 3 ? "Next" : "Continue"),
                                    style: TextStyle(color: ViewConstants.myWhite),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
