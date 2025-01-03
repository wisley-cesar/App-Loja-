import 'package:flutter/material.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passawordController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    Map<String, String> _authData = {
      'email': '',
      'password': '',
    };

    void _submit() {}

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: Container(
        height: 320,
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Form(
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
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: ' Confirmar Senha'),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: _authMode == AuthMode.Login
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
              ElevatedButton(
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
            ],
          ),
        ),
      ),
    );
  }
}
