import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetario/provider/login_form_provider.dart';
import 'package:recetario/service/services.dart';
import 'package:recetario/widget/widget.dart';
import 'package:recetario/ui/input_decoration.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250,
            ),
            CardContainer(
                child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(
                  height: 30,
                ),
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: _LoginForm(),
                ),
              ],
            )),
            SizedBox(height: 50),
            TextButton( onPressed: () => Navigator.pushReplacementNamed(context, 'register'), 
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                shape: MaterialStateProperty.all(StadiumBorder())
              ),
              child: Text('Crear una nueva cuenta',
                style: TextStyle(fontSize: 18, color: Colors.black87
                )
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginform = Provider.of<LoginFormProvider>(context);

    return Container(
        child: Form(
      key: loginform.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecorations(
                hintText: "email@gmail.com",
                labelText: "Correo electronico",
                prefixIcon: (Icons.alternate_email_sharp)),
            onChanged: (value) => loginform.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = new RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El valor ingresado no es un correo valido';
            },
          ),
          SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecorations(
                hintText: '******',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_open_outlined),
            onChanged: (value) => loginform.password = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña debe ser de 6 caracteres';
            },
          ),
          SizedBox(height: 30),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(
                loginform.isLoading ? 'hola' : 'Ingresar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: loginform.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final authserver = Provider.of<AuthServer>(context, listen: false);

                    if (!loginform.isValidForm()) return;

                    loginform.isLoading = true;

                    final String errorMessage = await authserver.login(loginform.email, loginform.password);

                    if( errorMessage == null ){
                    Navigator.pushReplacementNamed(context, 'home');
                    }else{
                      /* print(errorMessage); */
                      NotificationsService.showSnackbar('Correo o contraseña invalida');
                      loginform.isLoading = false;
                    }                    
                  },
          )
        ],
      ),
    ));
  }
}
