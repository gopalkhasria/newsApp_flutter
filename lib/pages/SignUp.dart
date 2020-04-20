import 'package:flutter/material.dart';
import 'package:news_provider/data/Article.dart';
import 'package:news_provider/data/User.dart';
import 'package:news_provider/data/dark.dart';
import 'package:news_provider/navbar.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<DarkTheme>(context);
    Articles articleIstance = Provider.of<Articles>(context);
    User user = Provider.of<User>(context);
    return Scaffold(
      appBar: myAppBar(context),
      body: user.exist ? errorWidget() :
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
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
                        "SignUp",
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
                        labelText: "Your Name",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: user.error ? Colors.red : Colors.black45),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                theme.getTheme() ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      onChanged: (value) => user.setName(value),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Your Email",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: user.error ? Colors.red : Colors.black45),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                theme.getTheme() ? Colors.white : Colors.black,
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
                          borderSide: BorderSide(
                              color: user.error ? Colors.red : Colors.black45),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                theme.getTheme() ? Colors.white : Colors.black,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        DropdownButton(
                            hint: Text('Select your country', style: TextStyle(color: 
                              user.error ? Colors.red :
                              theme.getTheme() ? Colors.white : Colors.black,
                            ),),
                            value: user.selectValue,
                            items: <String>[
                              'us:United States',
                              'ca:Canda',
                              'it:italia',
                              'fr:france',
                              'gb:United Kingdom',
                              'ru:Russia'
                            ].map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (value) => user.setCountry(value))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        FlatButton(
                          child: Text("SignUp"),
                          color: theme.getTheme() ? Colors.white : Colors.black,
                          textColor:
                              theme.getTheme() ? Colors.black : Colors.white,
                          padding: EdgeInsets.only(
                              left: 38, right: 38, top: 15, bottom: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () =>
                              user.signup(articleIstance,context),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget errorWidget() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(image: AssetImage("assets/error.png"), fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            "Account already exist. Please login",
            style: TextStyle(fontSize: 20),
          )),
        )
      ],
    ),
  );
}