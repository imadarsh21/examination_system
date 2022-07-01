import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:examination_system/model/http_exception.dart';
import 'package:examination_system/providers/auth.dart';
import 'package:email_auth/email_auth.dart';

enum AuthMode { signup, login }

AuthMode _authMode = AuthMode.signup;

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://cdn.pixabay.com/photo/2017/08/02/14/26/winter-landscape-2571788_960_720.jpg"),
                  fit: BoxFit.cover,

              ),
              color: Colors.transparent
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 20.0, top: 30),
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 2.5),
                    child: const Text(
                      "Examination Portal",
                      style: TextStyle(
                        // color: Color.fromRGBO(220, 20, 60, 1),
                        color: Colors.black54,
                        fontSize: 40,
                        fontFamily: 'Georama',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    // flex: deviceSize.width > 600 ? 1 : 1,
                    width: deviceSize.width > 850
                        ? deviceSize.width * 0.55
                        : deviceSize.width * 0.8,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {

  EmailAuth? emailAuth;

  bool otpSending = false;
  bool showSignupButton = true;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController fullNameEditingController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'fullName': '',
    "dob": '',
    "rollNumber": ''
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  AnimationController? _controller;
  Animation<Size>? _heightAnimation;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _heightAnimation = Tween<Size>(
            begin: const Size(double.infinity, 600),
            end: const Size(double.infinity, 400))
        .animate(
            CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn));
    // _heightAnimation!.addListener(() {setState(() {});});
    // we don't really need to do this manually if we are using AnimatedBuilder to construct the widget we want to animate
    _opacityAnimation = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller!, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("An error occurred"),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authData["email"]!, _authData["password"]!);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
            _authData["email"]!,
            _authData["password"]!,
            _authData["fullName"]!,
            _authData["dob"]!,
            _authData["rollNumber"]!);
      }
    } on HttpException catch (error) {
      var errorMessage = "Authentication Failed";
      if (error.message.toString().contains("EMAIL_EXIST")) {
        errorMessage = "This email is already in use";
      } else if (error.message.toString().contains("INVALID_EMAIL")) {
        errorMessage = "This is not a valid email address";
      } else if (error.message.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "Password is too short";
      } else if (error.message.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "This email does not exist";
      } else if (error.message.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Invalid password";
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      debugPrint(error.toString());
      const errorMessage = "Could not authenticate you. Please try again later";
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.signup) {
      setState(() {
        _authMode = AuthMode.login;
      });
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.signup;
      });
      _controller!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    //we can also use animated container here as we are ony going to animate a single container
    return AnimatedBuilder(
      animation: _heightAnimation!,
      builder: (ctx, ch) => Container(
        // height: _authMode == AuthMode.signup ? 340 : 260,
        height: _heightAnimation!.value.height,
        constraints:
            BoxConstraints(minHeight: _heightAnimation!.value.height),
        //_authMode == AuthMode.signup ? 340 : 260),
        width: deviceSize.width * 0.85,
        padding: const EdgeInsets.all(16.0),
        child: ch,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AnimatedContainer(
                constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.signup ? 40 : 0,
                    maxHeight: _authMode == AuthMode.signup ? 60 : 0),
                duration: const Duration(milliseconds: 400),
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: TextFormField(
                    controller: fullNameEditingController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(color: Colors.black54),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, 0.75)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, 0.85)),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: _authMode == AuthMode.signup? (value) {
                      if (value!.isEmpty || double.tryParse(value) != null) {
                        return 'Invalid name!';
                      }
                      return null;
                    } : null,
                    onSaved: (value) {
                      _authData['fullName'] = value!;
                    },
                  ),
                ),
              ),
              Stack(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-Mail',
                      labelStyle: TextStyle(color: Colors.black54),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: Color.fromRGBO(0, 0, 0, 0.75)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: Color.fromRGBO(0, 0, 0, 0.85)),
                      ),
                      // border: UnderlineInputBorder(
                      //   borderSide: BorderSide(color: Color.fromRGBO(220,20,60, 1)),
                      // ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value!;
                    },
                  ),
                  _authMode == AuthMode.signup? Container(
                    margin: const EdgeInsets.only(top: 8.5),
                    alignment: Alignment.centerRight,
                    child: otpSending? const CircularProgressIndicator() : TextButton(onPressed: (){
                      setState(() {
                        otpSending = true;
                      });
                      sendOtp().then((_) {
                        setState(() {
                          otpSending = false;
                        });
                      });
                    }, child: const Text("Send OTP"))
                  ) : const Text("")
                ],
              ),
              AnimatedContainer(
                constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.signup ? 40 : 0,
                    maxHeight: _authMode == AuthMode.signup ? 60 : 0),
                duration: const Duration(milliseconds: 400),
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: _otpController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Enter OTP',
                          labelStyle: TextStyle(color: Colors.black54),
                          hintText: "6 digits",
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, 0.75)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, 0.85)),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: _authMode == AuthMode.signup? (value) {
                          if ((value!.isEmpty || value.length != 6)) {
                            return 'Invalid OTP!';
                          }
                          return null;
                        } : null,
                        onSaved: (value) {
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8.5),
                        height: 28,
                        alignment: Alignment.centerRight,
                        child: TextButton(onPressed: () async{
                          await verify(context);
                        }, child: const Text("Verify OTP")),
                      )

                    ],
                  ),
                ),
              ),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Roll Number',
                  labelStyle: TextStyle(color: Colors.black54),
                  hintText: "10 digits",
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: Color.fromRGBO(0, 0, 0, 0.75)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: Color.fromRGBO(0, 0, 0, 0.85)),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length != 10) {
                    return 'Invalid roll number!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['rollNumber'] = value!;
                },
              ),

              AnimatedContainer(
                constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.signup ? 40 : 0,
                    maxHeight: _authMode == AuthMode.signup ? 60 : 0),
                duration: const Duration(milliseconds: 400),
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'DOB',
                      labelStyle: TextStyle(color: Colors.black54),
                      hintText: "dd/mm/yyyy",
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, 0.75)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, 0.85)),
                      ),
                      // border: UnderlineInputBorder(
                      //   borderSide: BorderSide(color: Color.fromRGBO(220,20,60, 1)),
                      // ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: _authMode == AuthMode.signup? (value) {
                      if (value!.isEmpty || DateTime.tryParse(value) != null) {
                        return 'Invalid DOB!';
                      }
                      return null;
                    } : null,
                    onSaved: (value) {
                      _authData['dob'] = value!;
                    },
                  ),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(0, 0, 0, 0.75)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(0, 0, 0, 0.85)),
                  ),
                ),
                obscureText: true,
                controller: _passwordController,
                validator: _authMode == AuthMode.signup? (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Password is too short!';
                  }
                  return null;
                } : null,
                onSaved: (value) {
                  _authData['password'] = value!;
                },
              ),
              // if (_authMode == AuthMode.signup)
              AnimatedContainer(
                constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.signup ? 60 : 0,
                    maxHeight: _authMode == AuthMode.signup ? 120 : 0),
                duration: const Duration(milliseconds: 400),
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: TextFormField(
                    enabled: _authMode == AuthMode.signup,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(color: Colors.black54),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, 0.75)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, 0.85)),
                      ),
                    ),
                    obscureText: true,
                    validator: _authMode == AuthMode.signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 2.0),
                  child: _authMode == AuthMode.signup? (showSignupButton? ElevatedButton(
                    child: const Text('SIGN UP',
                      style: TextStyle(
                        // color: Theme.of(context).primaryTextTheme.button!.color,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      // primary: const Color.fromRGBO(220, 20, 60, 1),
                      primary: Colors.black38,
                    ),
                    onPressed: () {
                      _submit();
                      // await Provider.of<Auth>(context, listen: false).getName();
                    },
                  ): ElevatedButton(
                    child: const Text('SIGN UP',
                      style: TextStyle(
                        // color: Theme.of(context).primaryTextTheme.button!.color,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      // primary: const Color.fromRGBO(220, 20, 60, 1),
                      primary: Colors.black38,
                    ),
                    onPressed: (){},
                  )) : ElevatedButton(
                    child: const Text('LOGIN',
                      style: TextStyle(
                        // color: Theme.of(context).primaryTextTheme.button!.color,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      // primary: const Color.fromRGBO(220, 20, 60, 1),
                      primary: Colors.black38,
                    ),
                    onPressed: () {
                      _submit();
                      // await Provider.of<Auth>(context, listen: false).getName();
                    },
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 2),
                child: TextButton(
                  child: Text(
                    _authMode == AuthMode.signup
                        ? "ALREADY REGISTERED? LOGIN"
                        : "NOT REGISTERED YET? SIGNUP",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 0, 0, 0.8)),
                  ),
                  style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: (){
                    _switchAuthMode();
                    },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 30.0,
              //   ),
              //   child: TextButton(
              //     child: const Text(
              //       "Forgot Password?",
              //       style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           color: Color.fromRGBO(0, 0, 0, 0.8)),
              //     ),
              //     style: TextButton.styleFrom(
              //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //     ),
              //     onPressed: () => Navigator.of(context).push(
              //       MaterialPageRoute(
              //           builder: (context) => const ForgotPassword()),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> sendOtp() async{
    if(_authMode == AuthMode.signup){
      emailAuth = EmailAuth(
        sessionName: "exam session",
      );
      bool result = await emailAuth!.sendOtp(
          recipientMail: _emailController.value.text, otpLength: 6);
      if (result) {
        return result;
      }
    }

    return false;

  }

  Future verify(context) {
    bool x = (emailAuth!.validateOtp(
        recipientMail: _emailController.value.text,
        userOtp: _otpController.value.text));
    if(x){
      return showDialog(context: context, builder: (context){
        return AlertDialog(
          title: const Text("Correct OTP"),
          content: const Text("OTP has been verified"),
          actions: [
            TextButton(onPressed: (){
              setState(() {
                showSignupButton = true;
              });
              Navigator.of(context).pop();
            }, child: const Text("OK"))
          ],
        );
      });
    }

    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text("Invalid OTP"),
        content: const Text("Please enter the correct OTP"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("OK"))
        ],
      );
    });
  }

}
