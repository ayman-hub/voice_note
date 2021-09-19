import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:twitter_login/twitter_login.dart';
import 'package:voice_note/voice/domain/entities/login_data.dart';

import 'constant_data.dart';


final FacebookLogin facebookSignIn = new FacebookLogin();

Future<dynamic> loginWithFacebook() async {
  try{
    final FacebookLoginResult result = await facebookSignIn.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (result.status) {
      case FacebookLoginStatus.success:
        final FacebookAccessToken? accessToken = result.accessToken;
        // FacebookAuthCredential authCredential = FacebookAuthProvider.credential(accessToken.token);
        // print("authCredential: ${authCredential.asMap()}");
        //sl<Cases>().setFacebookUserID(accessToken.userId);
        // return accessToken.token;
        final graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v2.12/${accessToken!.userId}?fields=name,email,picture.width(500)&access_token=${result.accessToken!.token}'));
        print(
            'https://graph.facebook.com/v2.12/${accessToken.userId}?fields=name,email,picture.width(500)&access_token=${result.accessToken!.token}');
        final profile = json.decode(graphResponse.body);
        print(profile.toString());
        LoginData login =
            LoginData(email: profile['email'], type: LoginType.social);
        return login;
      case FacebookLoginStatus.cancel:
        print('Login cancelled by the user.');
        logOut();
        return 'Login cancelled by the user.';
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.error}');
        return 'Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.error}';
        break;
    }
  }on PlatformException catch(e){
    return e.message;
  }
}


Future<Null> logOut() async {
  await facebookSignIn.logOut();
  print('Logged out.');
}





final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

Future<dynamic> signInWithGoogle() async {
  print("this is google");
  try{
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount!.authentication;
print(googleSignInAuthentication.accessToken);
print(googleSignInAuthentication.idToken);


  final AuthCredential authCredential =  GoogleAuthProvider.credential(accessToken:googleSignInAuthentication.accessToken, idToken: googleSignInAuthentication.idToken);
UserCredential user = await _auth.signInWithCredential(authCredential);
  //assert(!user.user.isAnonymous);
  //assert( user.user!.email. != null);

LoginData login = LoginData(email: user.user!.email.toString(),type: LoginType.social);
  return login;
  }on PlatformException catch(e){
    return '${e.message}';
  }catch(e){
    return 'cancel : $e';
  }

}

void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}

signInWithTwitter()async{
  final twitterLogin = TwitterLogin(
    // Consumer API keys
    apiKey: '80lTbti8GQ6V4iiLEclWwmq66',
    // Consumer API Secret keys
    apiSecretKey: 'gEltwQpSt5rntouuNciTYOxFsr7WhTv3KzC4B6uxvvSOmg3UKZ',
    // Registered Callback URLs in TwitterApp
    // Android is a deeplink
    // iOS is a URLScheme
    redirectURI: 'twittersdk://',
  );
  try{
    final authResult = await twitterLogin.login();
    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        print('success');
        return LoginData(email: authResult.user!.email.toString(),type: LoginType.social);
        break;
      case TwitterLoginStatus.cancelledByUser:
        print('cancel');
        return "cancel";
        break;
      case TwitterLoginStatus.error:
        print('error : ${authResult.errorMessage}');
        return authResult.errorMessage;
        break;
    }
  }on PlatformException catch (error){
    return "${error.message}";
  }catch(e){
    return "error has happen please try again ";
  }
}