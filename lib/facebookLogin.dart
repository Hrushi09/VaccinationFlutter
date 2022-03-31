import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

import 'home_screen.dart';
import 'login.dart';



class facebookLogin extends StatefulWidget {
  final FacebookLogin plugin;

  const facebookLogin({Key? key, required this.plugin}) : super(key: key);

  @override
  _FAppState createState() => _FAppState();
}

class _FAppState extends State<facebookLogin> {
  String? _sdkVersion;
  FacebookAccessToken? _token;
  FacebookUserProfile? _profile;
  String? _email;
  String? _password;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();

    _getSdkVersion();
    _updateLoginInfo();
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = _token != null && _profile != null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen.shade900,
        title: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Text(
            'Vaccine Booking',
            style: TextStyle(
              color: Colors.blueGrey.shade600,
              fontSize: 25,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: FlatButton(
          color: Colors.lightGreen.shade900,
          child: Icon(
            Icons.arrow_back,
            color: Colors.blueGrey.shade100,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          FlatButton(
            onPressed: (){
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => login()),
                    (route) => false,);
            },
            child: Icon(
              Icons.logout,
              color: Colors.blueGrey.shade100,
            ),
          ),
        ],
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(color: Colors.yellow.shade100),

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_sdkVersion != null) Text(''),
                if (isLogin)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildUserInfo(context, _profile!, _token!, _email),

                  ),
                if(isLogin && FacebookLoginStatus != FacebookLoginStatus.cancel)
                  Padding(padding: EdgeInsets.all(30),
                    child: FlatButton(
                      color: Colors.blueAccent,
                      child: Text('Login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic
                        ),),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (Context) => homeScreen()));
                      },
                    ),),
                isLogin
                    ? OutlinedButton(
                  child: const Text('Log Out'),
                  onPressed: _onPressedLogOutButton,
                )
                    : Container(
                  color: Colors.blue,
                  child: OutlinedButton(
                    child: const Text('Log In',
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 32
                      ),),

                    onPressed: _onPressedLogInButton,

                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, FacebookUserProfile profile,
      FacebookAccessToken accessToken, String? email) {
    final avatarUrl = _imageUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (avatarUrl != null)
          Center(
            child: Image.network(avatarUrl),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('User: '),
            Text(
              '${profile.firstName} ${profile.lastName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Text('AccessToken: '),
        Text(
          accessToken.token,
          softWrap: true,
        ),
        if (email != null) Text('Email: $email'),
      ],
    );
  }

  Future<void> _onPressedLogInButton() async {
    await widget.plugin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    await _updateLoginInfo();
  }


  Future<void> _onPressedLogOutButton() async {
    await widget.plugin.logOut();
    await _updateLoginInfo();
  }

  Future<void> _getSdkVersion() async {
    final sdkVesion = await widget.plugin.sdkVersion;
    setState(() {
      _sdkVersion = sdkVesion;
    });
  }

  Future<void> _updateLoginInfo() async {
    final plugin = widget.plugin;
    final token = await plugin.accessToken;
    FacebookUserProfile? profile;
    String? email;
    String? imageUrl;

    if (token != null) {
      profile = await plugin.getUserProfile();
      if (token.permissions.contains(FacebookPermission.email.name)) {
        email = await plugin.getUserEmail();
      }
      imageUrl = await plugin.getProfileImageUrl(width: 100);
    }

    setState(() {
      _token = token;
      _profile = profile;
      _email = email;
      _imageUrl = imageUrl;
    });
  }
}