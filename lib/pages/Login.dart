import 'package:flutter/material.dart';
import 'package:news_provider/data/Article.dart';
import 'package:news_provider/data/Save.dart';
import 'package:news_provider/data/User.dart';
import 'package:news_provider/data/dark.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<DarkTheme>(context);
    Articles articleIstance = Provider.of<Articles>(context);
    Saved savedIstance = Provider.of<Saved>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    User user = Provider.of<User>(context);
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenHeight / 4),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Your Email",
                      enabledBorder: UnderlineInputBorder(      
                        borderSide: BorderSide(color: user.error ? Colors.red : Colors.black45),   
                      ),  
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.getTheme() ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    onChanged: (value) => user.setEmail(value),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      enabledBorder: UnderlineInputBorder(      
                        borderSide: BorderSide(color: user.error ? Colors.red : Colors.black45),   
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.getTheme() ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    onChanged: (value) => user.setPassword(value),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {},
                        child: Text("Forgot Password ?"),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      FlatButton(
                        child: Text("Login"),
                        color: theme.getTheme() ? Colors.white : Colors.black,
                        textColor:
                            theme.getTheme() ? Colors.black : Colors.white,
                        padding: EdgeInsets.only(
                            left: 38, right: 38, top: 15, bottom: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        onPressed: () => user.login(articleIstance, savedIstance),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text(
              "Don't have an account ?",
              style: TextStyle(color: Colors.grey),
            ),
            FlatButton(
              onPressed: () {},
              child: Text("Create Account"),
            )
          ],
        )
      ],
    );
  }
}
