import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/login/login_bloc.dart';
import 'package:validators/validators.dart';

class LoginPageBloc extends StatefulWidget {
  const LoginPageBloc({super.key});

  @override
  State<LoginPageBloc> createState() => _LoginPageBlocState();
}

class _LoginPageBlocState extends State<LoginPageBloc> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: const Color.fromARGB(255, 235, 235, 255),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: BlocConsumer<LoginBloc, LoginState> (
              listenWhen: (_, state) => state is LoginError || state is LoginSuccess,
              listener: (context, state) {
                if (state is LoginError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                }
                if(state is LoginSuccess){
                  Navigator.pushReplacementNamed(context, '/list');
                }
              },
              buildWhen: (_, state) => state is LoginForm || state is LoginLoading,
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                      child: TextFormField(
                        enabled: state is! LoginLoading,
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return null;
                          }
                          return isEmail(value) ? null : "Not an email!";
                        },
                      ),
                    ),
                    TextFormField(
                      enabled: state is! LoginLoading,
                      obscureText: true,
                      controller: passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      validator: (value) {
                      if (value == null || value == "") {
                        return null;
                      }
                        return isLength(value, 6) ? null : "Short password!";
                      },
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: rememberMe,
                            onChanged: state is LoginLoading ? null :  (bool? newValue) {
                              setState(() {
                                rememberMe = newValue!;
                              });
                            }
                        ),
                        const Text("Remember me")
                      ],
                    ),
                    ElevatedButton(
                      onPressed: state is LoginLoading ? null : () {
                        if(_formKey.currentState!.validate()) {
                          context.read<LoginBloc>().add(LoginSubmitEvent(
                              emailController.text, passwordController.text,
                              rememberMe));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 12.0,
                          textStyle: const TextStyle(color: Colors.white)),
                      child: const Text('Login'),
                    ),
                  ],
                );
              },
            ),
          ),
        )
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
