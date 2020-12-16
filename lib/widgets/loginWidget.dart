import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mazajflutter/router.dart' as router;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'package:mazajflutter/blocs/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  String _phone, _password;
  bool _incorrctPassword = false;
  String message;

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          documentNode: LOGIN, // this is the mutation string you just created
          // or do something with the result.data on completion
          onCompleted: (dynamic resultData) async {
            if (resultData != null) {
              context
                  .read<AuthBloc>()
                  .setToken(resultData["driverLogin"]["token"]);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString(
                  "user-name", resultData["driverLogin"]["profile"]["name"]);
              prefs.setString(
                  "user-number", resultData["driverLogin"]["profile"]["phone"]);

              main();
              Navigator.pushNamedAndRemoveUntil(
                  context, router.HomeViewRoute, (route) => false);
            }
          },
          onError: (e) {
            print(e.graphqlErrors);
            message = e.toString();

            setState(() => _incorrctPassword = true);
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult result,
        ) {
          void _submit() async {
            if (_formKey.currentState.validate()) {
              runMutation({
                "phone": _phone,
                "password": _password,
                "firebaseToken": pushNotificationService.token
              });
            }
          }

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: _incorrctPassword
                    ? AlertDialog(
                        title: Text('الرقم او كلمة المرور خطاء'),
                        content: Text('الرجاء المحاولة مره اخرى'),
                        actions: [
                          FlatButton(
                            textColor: Color(0xFF6200EE),
                            onPressed: () =>
                                setState(() => _incorrctPassword = false),
                            child: Text('اعادة المحاولة'),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'رقم الجوال'),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            // validator: (i) =>
                            //     (i.length == 10) ? null : "رقم الجوال يجب ان يكون 10 ارقام",
                            onChanged: (v) => setState(() => _phone = v),
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'كلمة المرور'),
                            onChanged: (v) => setState(() => _password = v),
                          ),
                          !result.loading
                              ? RaisedButton.icon(
                                  onPressed: _submit,
                                  label: Text("تسجيل الدخول"),
                                  icon: Icon(Icons.login),
                                )
                              : RaisedButton(
                                  onPressed: _submit,
                                  child: Text("جاري التحميل"),
                                ),
                        ],
                      ),
              ),
            ),
          );
        });
  }
}

dynamic LOGIN = gql(r'''
  mutation DriverLogin ($phone: String!, $password: String!, $firebaseToken: String) {
  driverLogin(phone: $phone, password:  $password, firebaseToken: $firebaseToken) {
    token
    profile {
      phone
      name
    }
  }
}
  ''');
