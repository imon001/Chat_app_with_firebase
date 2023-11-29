import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../widgets/image_input.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _key = GlobalKey<FormState>();
  var _isLogin = true;
  var _isAuthenticating = false;
  String _email = '';
  String _password = '';
  String _name = '';
  File? _imgFile;

  void _submit() async {
    final isValid = _key.currentState!.validate();
    if (!isValid || !_isLogin && _imgFile == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image is required.")));
      setState(() {
        _isAuthenticating = false;
      });

      return;
    }

    _key.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(email: _email, password: _password);
      } else {
        final userCred = await _firebase.createUserWithEmailAndPassword(email: _email, password: _password);

        final strgRef = FirebaseStorage.instance.ref().child('user_images').child('${userCred.user!.uid}.jpg');

        await strgRef.putFile(_imgFile!);
        final imgUrl = await strgRef.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(userCred.user!.uid).set({
          'user_name': _name,
          'email': _email,
          'img_url': imgUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message ?? "Authentication failed.")));
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(width: 250, margin: const EdgeInsets.all(20), child: Image.asset('assets/images/chat.png')),
            Card(
                // margin: const EdgeInsets.all(),
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Form(
                  key: _key,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!_isLogin)
                          ImageInput(
                            onClickedImg: (img) {
                              _imgFile = img;
                            },
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (!_isLogin)
                          TextFormField(
                            onSaved: (v) {
                              _name = v!.trim();
                            },
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            keyboardType: TextInputType.name,
                            validator: MultiValidator([RequiredValidator(errorText: 'Name is required'), MinLengthValidator(3, errorText: 'Minimum 3 character required')]),
                            enableSuggestions: false,
                            decoration: InputDecoration(
                              label: Text(
                                "Name",
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                              ),
                              contentPadding: const EdgeInsets.all(10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            onSaved: (v) {
                              _email = v!.trim();
                            },
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: MultiValidator([RequiredValidator(errorText: 'email is required'), EmailValidator(errorText: 'Please enter a valid email')]),
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                              label: Text('Email',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      )),
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          onSaved: (v) {
                            _password = v!.trim();
                          },
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Password is required'),
                            MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
                            PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
                          ]),
                          obscureText: true,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                              label: Text('Password',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ))),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (_isAuthenticating)
                          SizedBox(
                            width: 35,
                            child: LoadingIndicator(
                              indicatorType: Indicator.ballSpinFadeLoader,
                              colors: [
                                Theme.of(context).colorScheme.onBackground,
                              ],
                              strokeWidth: 4,
                            ),
                          ),
                        if (!_isAuthenticating)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                onPressed: _submit,
                                splashColor: Theme.of(context).colorScheme.onBackground,
                                color: Theme.of(context).colorScheme.background,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  _isLogin ? "Log In" : "Sing Up",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (!_isAuthenticating)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin ? "Create an account" : "Already have an account?Log in",
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
