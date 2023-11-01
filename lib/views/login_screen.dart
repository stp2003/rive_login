import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //*** tec ->
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //??
  var animationLink = 'assets/login-teddy.riv';
  late SMITrigger failTrigger, successTrigger;
  late SMIBool isChecking, isHandsUp;
  late SMINumber lookNum;
  Artboard? artBoard;
  late StateMachineController? stateMachineController;

  //??
  @override
  void initState() {
    super.initState();
    initArtBoard();
  }

  //??
  initArtBoard() {
    rootBundle.load(animationLink).then((value) {
      final file = RiveFile.import(value);
      final art = file.mainArtboard;
      stateMachineController =
          StateMachineController.fromArtboard(art, "Login Machine")!;

      if (stateMachineController != null) {
        art.addController(stateMachineController!);

        for (var element in stateMachineController!.inputs) {
          if (element.name == 'isChecking') {
            isChecking = element as SMIBool;
          } else if (element.name == 'isHandsUp') {
            isHandsUp = element as SMIBool;
          } else if (element.name == 'trigSuccess') {
            successTrigger = element as SMITrigger;
          } else if (element.name == 'trigFail') {
            failTrigger = element as SMITrigger;
          } else if (element.name == 'numLook') {
            lookNum = element as SMINumber;
          }
        }
      }
      setState(() {
        artBoard = art;
      });
    });
  }

  //??
  checking() {
    isHandsUp.change(false);
    isChecking.change(true);
    lookNum.change(0);
  }

  //??
  handsUp() {
    isHandsUp.change(true);
    isChecking.change(false);
  }

  //??
  login() {
    isHandsUp.change(false);
    isChecking.change(false);
    if (emailController.text == 'shashwatshandilya2003@gmail.com' &&
        passwordController.text == '123456') {
      successTrigger.fire();
    } else {
      failTrigger.fire();
    }
  }

  //??
  moveEyes(value) {
    lookNum.change(value.length.toDouble());
  }

  //??
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd6e2ea),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //??
              if (artBoard != null)
                SizedBox(
                  width: 400.0,
                  height: 350.0,
                  child: Rive(artboard: artBoard!),
                ),
              Container(
                alignment: Alignment.center,
                width: 400.0,
                padding: const EdgeInsets.only(bottom: 15.0),
                margin: const EdgeInsets.only(bottom: 60.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 30.0),
                          TextField(
                            onTap: checking,
                            onChanged: ((value) => moveEyes(value)),
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontSize: 14.0),
                            cursorColor: Colors.orange,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              focusColor: Colors.orangeAccent,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextField(
                            onTap: handsUp,
                            controller: passwordController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontSize: 14.0),
                            cursorColor: Colors.orange,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              focusColor: Colors.orangeAccent,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: false,
                                    onChanged: (value) {},
                                  ),
                                  const Text('Remember me'),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
