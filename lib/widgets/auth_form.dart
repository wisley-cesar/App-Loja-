import 'package:flutter/material.dart';
import 'package:loja/exception/auth_exception.dart';
import 'package:loja/models/auth.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passawordController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final _formkey = GlobalKey<FormState>();

    Map<String, String> _authData = {
      'email': '',
      'password': '',
    };

    bool _isLogin() => _authMode == AuthMode.Login;
    bool _isSignup() => _authMode == AuthMode.Signup;

    void _switchAuthMode() {
      setState(() {
        if (_isLogin()) {
          _authMode = AuthMode.Signup;
        } else {
          _authMode = AuthMode.Login;
        }
      });
    }

    void _showErroDialog(String msg) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Ocorreu um Erro'),
                content: Text(msg),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Fechar'),
                  )
                ],
              ));
    }

    Future<void> _submit() async {
      final isValid = _formkey.currentState?.validate() ?? false;

      if (!isValid) {
        return;
      }

      setState(() => _isLoading = true);

      _formkey.currentState?.save();
      Auth auth = Provider.of(context, listen: false);

      try {
        if (_isLogin()) {
          await auth.login(
            _authData['email']!,
            _authData['password']!,
          );
          //login
        } else {
          await auth.signup(
            _authData['email']!,
            _authData['password']!,
          );
        }
      } on AuthException catch (error) {
        _showErroDialog(error.toString());
      } catch (error) {
        _showErroDialog('Ocorreu um erro inesperado!');
      }

      setState(() => _isLoading = false);
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: Container(
        height: _isLogin() ? 310 : 400,
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail válido.';
                  }
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                onSaved: (password) => _authData['password'] = password ?? '',
                controller: _passawordController,
                validator: (_password) {
                  if (_password!.isEmpty || _password.length < 5) {
                    return 'Informe uma senha válida';
                  }
                },
              ),
              if (!_isLogin())
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: ' Confirmar Senha'),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: _isLogin()
                      ? null
                      : (_password) {
                          final password = _password ?? '';
                          if (password != _passawordController.text) {
                            return 'Senhas são diferentes';
                          }
                          return null;
                        },
                ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR',
                      ),
                    ),
              const Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child:
                    Text(_isLogin() ? 'DESEJA REGISTRAR' : 'JÁ POSSUI CONTA'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
