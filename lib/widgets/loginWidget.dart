import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mazajflutter/router.dart' as router;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../main.dart';

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
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("token", resultData["driverLogin"]["token"]);
              prefs.setString(
                  "name", resultData["driverLogin"]["profile"]["name"]);
              prefs.setString(
                  "phone", resultData["driverLogin"]["profile"]["phone"]);
              final AuthLink authLink = AuthLink(
                getToken: () => resultData["driverLogin"]["token"],
              );
              final Link link = authLink.concat(httpLink);
              client = GraphQLClient(
                cache: InMemoryCache(),
                link: link,
              );
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
                          SizedBox(
                            width: 130,
                            child: OutlineButton(
                              onPressed: _submit,
                              child: Row(
                                children: [
                                  Icon(Icons.login),
                                  Text("تسجيل الدخول")
                                ],
                              ),
                            ),
                          ),
                          Text('${message}'),
                        ],
                      ),
              ),
            ),
          );
        });
  }
}

dynamic LOGIN = gql(r'''
  mutation DriverLogin ($phone: String!, $password: String!) {
  driverLogin(phone: $phone, password:  $password) {
    token
    profile {
      phone
      name
    }
  }
}
  ''');
