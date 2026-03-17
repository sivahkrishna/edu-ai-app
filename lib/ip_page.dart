// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:typed_data';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'Login_Page.dart';
//
// void main(){
//   return runApp(MaterialApp(
//     home: ip_page(),
//   ));
// }
//
// class ip_page extends StatefulWidget {
//   @override
//   _AdduserState createState() => _AdduserState();
// }
//
// class _AdduserState extends State<ip_page> {
//   final txtFullName = new TextEditingController(text: "192.168.43.234");
//
//   bool _valName=false;
//
//   Future _saveDetails(String ip) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString("ip", ip);
//     await prefs.setString("url", "http://$ip:8000");
//
//     Navigator.push(context, MaterialPageRoute(builder: (context) => Login_Page()));
//
//   }
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     txtFullName.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("EDU AI"),
//       ),
//       body:
//       Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           children: <Widget>[
//
//             TextField(
//               decoration: new InputDecoration(
//                 hintText: "IP Page",
//                 errorText: _valName ? 'Required':null,
//
//               ),
//               controller: txtFullName,
//             ),
//
//
//             ButtonBar(
//               children:<Widget> [
//                 ElevatedButton(
//                   onPressed:() {
//                     setState(()  {
//                       //for validation
//                       txtFullName.text.isEmpty?_valName=true:_valName=false;
//                       print("success");
//                       if(_valName == false)
//                         {
//                           _saveDetails(txtFullName.text);
//                         }
//
//                     });
//                   },
//                   // color: Colors.green,
//                   child: Text("Save"),
//                 ),
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
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login_Page.dart';

void main() {
  return runApp(MaterialApp(
    home: ip_page(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'Inter',
    ),
  ));
}

class ip_page extends StatefulWidget {
  @override
  _AdduserState createState() => _AdduserState();
}

class _AdduserState extends State<ip_page> {
  final txtFullName = TextEditingController(text: "192.168.20.6");
  bool _valName = false;
  bool _isLoading = false;

  // Updated color palette from faculty homepage
  final Color _primaryColor = Color(0xFF27374D);      // Deep navy blue
  final Color _secondaryColor = Color(0xFF526D82);    // Muted steel blue
  final Color _accentColor = Color(0xFF9DB2BF);       // Soft periwinkle gray
  final Color _lightBgColor = Color(0xFFDDE6ED);      // Light icy blue background
  final Color _darkTextColor = Color(0xFF27374D);     // Deep navy for text
  final Color _lightTextColor = Color(0xFF526D82);    // Steel blue for secondary text
  final Color _buttonColor = Color(0xFF526D82);       // Steel blue for buttons
  final Color _whiteColor = Color(0xFFFFFFFF);        // Pure white

  Future<void> _saveDetails(String ip) async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("ip", ip);
      await prefs.setString("url", "http://$ip:8000");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login_Page()),
      );
    } catch (e) {
      print("Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    txtFullName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            // Removed fixed height to prevent overflow
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Header section
                SizedBox(height: 40),
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_primaryColor, _secondaryColor],
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
                      size: 60,
                      color: _whiteColor,
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Title
                Text(
                  "Server Configuration",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: _primaryColor,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 8),

                // Subtitle
                Text(
                  "Enter your server IP address to connect to EDU AI platform",
                  style: TextStyle(
                    fontSize: 16,
                    color: _secondaryColor,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 30),

                // Input field
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
                    controller: txtFullName,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _whiteColor,
                      hintText: "Enter server IP address",
                      hintStyle: TextStyle(color: _accentColor),
                      errorText: _valName ? 'IP address is required' : null,
                      errorStyle: TextStyle(color: Colors.red[400]),
                      prefixIcon: Container(
                        padding: EdgeInsets.all(16),
                        child: Icon(
                          Icons.language_rounded,
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
                    keyboardType: TextInputType.url,
                  ),
                ),
                SizedBox(height: 8),

                // Helper text
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    "Example: 192.168.1.100 or your-domain.com",
                    style: TextStyle(
                      fontSize: 14,
                      color: _secondaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Action button
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
                        txtFullName.text.isEmpty
                            ? _valName = true
                            : _valName = false;

                        if (!_valName) {
                          _saveDetails(txtFullName.text);
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
                          "Connecting...",
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
                        Icon(Icons.check_circle_rounded, size: 22, color: _whiteColor),
                        SizedBox(width: 12),
                        Text(
                          "Connect to Server",
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
                SizedBox(height: 20),

                // Info box
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _accentColor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_rounded,
                        color: _primaryColor,
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Make sure your server is running and accessible from this device",
                          style: TextStyle(
                            color: _secondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // Footer
                Center(
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
                      Text(
                        "EDU AI Platform • Secure Connection",
                        style: TextStyle(
                          color: _secondaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20), // Added bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}

