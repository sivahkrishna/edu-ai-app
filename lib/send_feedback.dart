// import 'dart:convert';
// import 'package:edu_ai_app/view_unit.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:typed_data';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'Login_Page.dart';
//
// void main() {
//   return runApp(MaterialApp(
//     home: send_feedback(),
//   ));
// }
//
// class send_feedback extends StatefulWidget {
//   @override
//   _AdduserState createState() => _AdduserState();
// }
//
// class _AdduserState extends State<send_feedback> {
//   final txtFullName = TextEditingController();
//   bool _valName = false;
//
//   Future _saveDetails(String feed) async {
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
//       Uri.parse("$ip/stud_send_feedback"),
//       body: {"feed": feed,
//         "unitid": prefs.getString("unitid"),
//         "sid": prefs.getString("sid")},
//     );
//
//     var jsonData = json.decode(response.body);
//     print(jsonData);
//
//     if (jsonData['status'] == "ok") {
//             ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Feedback sent")),
//       );
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const view_unit()),
//       );
//
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed")),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     txtFullName.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("EDU AI"),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             // TextArea (Multi-line TextField)
//             TextField(
//               controller: txtFullName,
//               maxLines: 5, // Makes it a text area
//               minLines: 3, // Minimum lines to show
//               decoration: InputDecoration(
//                 hintText: "Enter your feedback here...",
//                 labelText: "Feedback",
//                 errorText: _valName ? 'Feedback is required' : null,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 contentPadding: EdgeInsets.all(16.0),
//               ),
//               textAlignVertical: TextAlignVertical.top,
//             ),
//
//             SizedBox(height: 20), // Spacing between textarea and button
//
//             // Button
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   // Validation
//                   txtFullName.text.isEmpty ? _valName = true : _valName = false;
//                   print("Button pressed");
//
//                   if (_valName == false) {
//                     _saveDetails(txtFullName.text);
//                   }
//                 });
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 16.0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//               ),
//               child: Text(
//                 "Send Feedback",
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'view_unit.dart';

void main() {
  return runApp(MaterialApp(
    home: send_feedback(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'Inter',
    ),
  ));
}

class send_feedback extends StatefulWidget {
  @override
  _AdduserState createState() => _AdduserState();
}

class _AdduserState extends State<send_feedback> {
  final txtFullName = TextEditingController();
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
  final Color _cardColor = Color(0xFFFFFFFF);         // Pure white for cards
  final Color _whiteColor = Color(0xFFFFFFFF);        // Pure white
  final Color _errorColor = Color(0xFFD32F2F);        // Keep error color red
  final Color _successColor = Color(0xFF2E7D32);      // Dark green for success

  Future<void> _saveDetails(String feed) async {
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
        Uri.parse("$ip/stud_send_feedback"),
        body: {
          "feed": feed,
          "unitid": prefs.getString("unitid"),
          "sid": prefs.getString("sid"),
        },
      );

      var jsonData = json.decode(response.body);
      print(jsonData);

      if (jsonData['status'] == "ok") {
        _showSuccessSnackBar("Feedback sent successfully!");

        // Clear the field
        txtFullName.clear();

        // Navigate back after a short delay
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const view_unit()),
          );
        });
      } else {
        _showErrorSnackBar("Failed to send feedback. Please try again.");
      }
    } catch (e) {
      print("Error: $e");
      _showErrorSnackBar("Connection error. Please check your internet connection.");
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
        backgroundColor: _primaryColor,
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
    txtFullName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBgColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_secondaryColor, _primaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: _whiteColor),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const view_unit()),
              );
            },
          ),
        ),
        title: Text(
          "Send Feedback",
          style: TextStyle(
            color: _whiteColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40),

              // Header Icon
              Center(
                child: Container(
                  width: 120,
                  height: 120,
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
                    Icons.feedback_rounded,
                    size: 60,
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
                    "Share Your Feedback",
                    style: TextStyle(
                      fontSize: 32,
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
                  "Help us improve the learning experience",
                  style: TextStyle(
                    fontSize: 16,
                    color: _secondaryColor,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40),

              // Feedback Label
              Padding(
                padding: EdgeInsets.only(bottom: 12, left: 8),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _accentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.edit_rounded,
                        color: _primaryColor,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Your Feedback",
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Feedback Text Area
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
                  maxLines: 8,
                  minLines: 5,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _whiteColor,
                    hintText: "Write your feedback here...",
                    hintStyle: TextStyle(color: _accentColor),
                    errorText: _valName ? 'Feedback is required' : null,
                    errorStyle: TextStyle(color: _errorColor),
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
                    contentPadding: EdgeInsets.all(20),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: _primaryColor,
                  ),
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
              SizedBox(height: 8),

              // Character Count (optional)
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${txtFullName.text.length}/500 characters",
                    style: TextStyle(
                      color: _secondaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Feedback Tips
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _accentColor,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.08),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _lightBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.lightbulb_rounded,
                            color: _primaryColor,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Tips for Great Feedback",
                          style: TextStyle(
                            color: _primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _lightBgColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildTipItem("Be specific about what you liked or didn't like"),
                          SizedBox(height: 8),
                          _buildTipItem("Suggest improvements where possible"),
                          SizedBox(height: 8),
                          _buildTipItem("Keep your feedback constructive and respectful"),
                          SizedBox(height: 8),
                          _buildTipItem("Mention specific topics or materials if relevant"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Send Button
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
                        "Sending...",
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
                      Icon(Icons.send_rounded, size: 22, color: _whiteColor),
                      SizedBox(width: 12),
                      Text(
                        "Send Feedback",
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
              SizedBox(height: 24),

              // Privacy Note
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
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _lightBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.security_rounded,
                        color: _primaryColor,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Your feedback is anonymous and will be used to improve course materials",
                        style: TextStyle(
                          color: _secondaryColor,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Footer
              SizedBox(height: 40),
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
                      "EDU AI Platform • Your Voice Matters",
                      style: TextStyle(
                        color: _secondaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_rounded,
          color: _secondaryColor,
          size: 16,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            tip,
            style: TextStyle(
              color: _secondaryColor,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

