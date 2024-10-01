import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GoogleAuthPage(),
    );
  }
}

class GoogleAuthPage extends StatefulWidget {
  @override
  _GoogleAuthPageState createState() => _GoogleAuthPageState();
}

class _GoogleAuthPageState extends State<GoogleAuthPage> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Auth'),
      ),
      body: Center(
        child: _currentUser != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(_currentUser!.photoUrl ?? ''),
                    radius: 40,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Signed in as ${_currentUser!.displayName}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _handleSignOut,
                    child: Text('Sign out'),
                  ),
                ],
              )
            : ElevatedButton.icon(
                onPressed: _handleSignIn,
                icon: Icon(Icons.login),
                label: Text('Sign in with Google'),
              ),
      ),
    );
  }
}
