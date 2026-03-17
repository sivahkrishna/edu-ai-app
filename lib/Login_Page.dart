// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:typed_data';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'homepage.dart';
//
// void main(){
//   return runApp(MaterialApp(
//     home: Login_Page(),
//   ));
// }
//
// class Login_Page extends StatefulWidget {
//   @override
//   _AdduserState createState() => _AdduserState();
// }
//
// class _AdduserState extends State<Login_Page> {
//   final txtEmail = new TextEditingController(text: "marco@gmail.com");
//   final txtPassword = new TextEditingController(text: "9037");
//
//   bool _valEmail=false;
//   bool _valPassword=false;
//
//   Future _saveDetails(String email, String password) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? ip = prefs.getString("url");
//
//     if (ip == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Server IP not found in preferences")),
//       );
//       return;
//     }
//
//     var response = await http.post(
//       Uri.parse("$ip/stud_login"),
//       body: {"un": email, "ps": password},
//     );
//
//     var jsonData = json.decode(response.body);
//     print(jsonData);
//
//     if (jsonData['status'] == "ok") {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString("sid", jsonData['sid']);
//       await prefs.setString("sname", jsonData['sname']);
//       await prefs.setString("semail", jsonData['semail']);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Login success")),
//       );
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const HomeApp()),
//       );
//
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Invalid login credentials")),
//       );
//     }
//
//   }
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     txtEmail.dispose();
//     txtPassword.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Login_Page"),
//       ),
//       body:
//       Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           children: <Widget>[
//
//             TextField(
//               decoration: new InputDecoration(
//                 hintText: "Email",
//                 errorText: _valEmail ? 'Required':null,
//
//               ),
//               controller: txtEmail,
//             ),
//
//             TextField(
//               decoration: new InputDecoration(
//                 hintText: "Password",
//                 errorText: _valPassword ? 'Required':null,
//
//               ),
//               controller: txtPassword,
//             ),
//
//
//             ButtonBar(
//               children:<Widget> [
//                 ElevatedButton(
//                   onPressed:() {
//                     setState(()  {
//                       //for validation
//                       txtEmail.text.isEmpty?_valEmail=true:_valEmail=false;
//                       txtPassword.text.isEmpty?_valPassword=true:_valPassword=false;
//                       print("kkkk");
//                       if(_valEmail == false && _valPassword == false)
//                         {
//                           _saveDetails(txtEmail.text, txtPassword.text);
//                         }
//
//                     });
//                   },
//                   // color: Colors.green,
//                   child: Text("Save"),
//
//                 ),
//
//               ],
//             )
//           ],
//
//         ),
//
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:edu_ai_app/forgotemail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';

void main() {
  return runApp(MaterialApp(
    home: Login_Page(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'Inter',
    ),
  ));
}

class Login_Page extends StatefulWidget {
  @override
  _AdduserState createState() => _AdduserState();
}

class _AdduserState extends State<Login_Page> {
  final txtEmail = TextEditingController(text: "sivaa123@gmail.com");
  final txtPassword = TextEditingController(text: "3635");
  bool _valEmail = false;
  bool _valPassword = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Updated color palette from faculty homepage
  final Color _primaryColor = Color(0xFF27374D);      // Deep navy blue
  final Color _secondaryColor = Color(0xFF526D82);    // Muted steel blue
  final Color _accentColor = Color(0xFF9DB2BF);       // Soft periwinkle gray
  final Color _lightBgColor = Color(0xFFDDE6ED);      // Light icy blue background
  final Color _darkTextColor = Color(0xFF27374D);     // Deep navy for text
  final Color _lightTextColor = Color(0xFF526D82);    // Steel blue for secondary text
  final Color _buttonColor = Color(0xFF526D82);       // Steel blue for buttons
  final Color _whiteColor = Color(0xFFFFFFFF);        // Pure white
  final Color _errorColor = Color(0xFFD32F2F);        // Keep error color red

  Future<void> _saveDetails(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? ip = prefs.getString("url");

      if (ip == null) {
        _showErrorSnackBar("Server IP not found. Please configure server first.");
        return;
      }

      var response = await http.post(
        Uri.parse("$ip/stud_login"),
        body: {"un": email, "ps": password},
      );

      var jsonData = json.decode(response.body);
      print(jsonData);

      if (jsonData['status'] == "ok") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("sid", jsonData['sid']);
        await prefs.setString("sname", jsonData['sname']);
        await prefs.setString("semail", jsonData['semail']);
        await prefs.setString("scourse", jsonData['scourse']);

        _showSuccessSnackBar("Login successful!");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeApp()),
        );
      } else {
        _showErrorSnackBar("Invalid login credentials");
      }
    } catch (e) {
      print("Error: $e");
      _showErrorSnackBar("Connection error. Please check server configuration.");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _buttonColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    txtEmail.dispose();
    txtPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Back button
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_primaryColor, _secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _primaryColor.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: _whiteColor,
                          size: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),

                    // Welcome section with gradient
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_primaryColor, _secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _primaryColor.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.school_rounded,
                          size: 50,
                          color: _whiteColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Title
                    Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [_primaryColor, _secondaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: _whiteColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    // Subtitle
                    Center(
                      child: Text(
                        "Sign in to your EDU AI account",
                        style: TextStyle(
                          fontSize: 16,
                          color: _secondaryColor,
                          height: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 50),

                    // Email field
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryColor.withOpacity(0.08),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: txtEmail,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: _whiteColor,
                          hintText: "Email address",
                          hintStyle: TextStyle(color: _accentColor),
                          errorText: _valEmail ? 'Email is required' : null,
                          errorStyle: TextStyle(color: _errorColor),
                          prefixIcon: Container(
                            padding: EdgeInsets.all(16),
                            child: Icon(
                              Icons.email_rounded,
                              color: _secondaryColor,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: _accentColor,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: _primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),

                    // Password field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryColor.withOpacity(0.08),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: txtPassword,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: _whiteColor,
                          hintText: "Password",
                          hintStyle: TextStyle(color: _accentColor),
                          errorText: _valPassword ? 'Password is required' : null,
                          errorStyle: TextStyle(color: _errorColor),
                          prefixIcon: Container(
                            padding: EdgeInsets.all(16),
                            child: Icon(
                              Icons.lock_rounded,
                              color: _secondaryColor,
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: _secondaryColor,
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: _accentColor,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: _primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>forgotemail()));
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: _secondaryColor,
                        ),
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),

                    // Login button with gradient
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [_secondaryColor, _primaryColor],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryColor.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                          setState(() {
                            txtEmail.text.isEmpty
                                ? _valEmail = true
                                : _valEmail = false;
                            txtPassword.text.isEmpty
                                ? _valPassword = true
                                : _valPassword = false;

                            if (!_valEmail && !_valPassword) {
                              _saveDetails(txtEmail.text, txtPassword.text);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: _whiteColor,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          disabledBackgroundColor: Colors.transparent,
                        ),
                        child: _isLoading
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(_whiteColor),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Signing in...",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _whiteColor,
                              ),
                            ),
                          ],
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login_rounded, size: 22, color: _whiteColor),
                            SizedBox(width: 12),
                            Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Flexible spacer
                    Flexible(
                      child: SizedBox(height: 20),
                    ),

                    // Footer with gradient line
                    Padding(
                      padding: EdgeInsets.only(bottom: 32, top: 20),
                      child: Column(
                        children: [
                          Container(
                            height: 3,
                            width: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [_accentColor, _primaryColor],
                              ),
                              borderRadius: BorderRadius.circular(1.5),
                            ),
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: Text(
                              "EDU AI Platform • Secure Login",
                              style: TextStyle(
                                color: _secondaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

