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
//     home: Pass(),
//   ));
// }
//
// class Pass extends StatefulWidget {
//   @override
//   _AdduserState createState() => _AdduserState();
// }
//
// class _AdduserState extends State<Pass> {
//   final txtCurPass = new TextEditingController();
//   final txtNewPass = new TextEditingController();
//   final txtRenPass = new TextEditingController();
//
//   bool _valCurpass=false;
//   bool _valNewPass=false;
//   bool _valRenPass=false;
//
//   Future _saveDetails(String Curpass,String Newpass,String Renewpass) async {
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
//       Uri.parse("$ip/stud_change_password"),
//       body: {"cewp": Curpass,
//         "newp": Newpass,
//         "copsw": Renewpass,
//         "sid": prefs.getString("sid").toString(),
//
//       },
//     );
//
//     var jsonData = json.decode(response.body);
//     print(jsonData);
//
//     if (jsonData['status'] == "ok") {
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Password changed")),
//       );
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => Login_Page()),
//       );
//
//     } else if (jsonData['status'] == "mismatch")  {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Password mismatch")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Invalid password")),
//       );
//     }
//
//   }
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     txtCurPass.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Pass"),
//       ),
//       body:
//       Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           children: <Widget>[
//
//             TextField(
//               decoration: new InputDecoration(
//                 hintText: "Enter Current Password",
//                 errorText: _valCurpass ? 'Required':null,
//
//               ),
//               controller: txtCurPass,
//             ),
//
//             TextField(
//               decoration: new InputDecoration(
//                 hintText: "Enter New Password",
//                 errorText: _valNewPass ? 'Required':null,
//
//               ),
//               controller: txtNewPass,
//             ),
//
//             TextField(
//               decoration: new InputDecoration(
//                 hintText: "Re Enter New Password",
//                 errorText: _valRenPass ? 'Required':null,
//
//               ),
//               controller: txtRenPass,
//             ),
//
//             ButtonBar(
//               children:<Widget> [
//                 ElevatedButton(
//                   onPressed:() {
//                     setState(()  {
//                       //for validation
//                       txtCurPass.text.isEmpty?_valCurpass=true:_valCurpass=false;
//                       txtNewPass.text.isEmpty?_valNewPass=true:_valNewPass=false;
//                       txtRenPass.text.isEmpty?_valRenPass=true:_valRenPass=false;
//                       print("kkkk");
//                       if(_valCurpass == false && _valNewPass == false && _valRenPass == false)
//                         {
//                           _saveDetails(txtCurPass.text ,txtNewPass.text ,txtRenPass.text);
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
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Login_Page.dart';

void main() {
  return runApp(MaterialApp(
    home: Pass(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'Inter',
    ),
  ));
}

class Pass extends StatefulWidget {
  @override
  _AdduserState createState() => _AdduserState();
}

class _AdduserState extends State<Pass> {
  final txtCurPass = TextEditingController();
  final txtNewPass = TextEditingController();
  final txtRenPass = TextEditingController();

  bool _valCurpass = false;
  bool _valNewPass = false;
  bool _valRenPass = false;
  bool _isLoading = false;
  bool _obscureCurPass = true;
  bool _obscureNewPass = true;
  bool _obscureRenPass = true;

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
  final Color _successColor = Color(0xFF2E7D32);      // Dark green for success

  Future<void> _saveDetails(String Curpass, String Newpass, String Renewpass) async {
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
        Uri.parse("$ip/stud_change_password"),
        body: {
          "cewp": Curpass,
          "newp": Newpass,
          "copsw": Renewpass,
          "sid": prefs.getString("sid").toString(),
        },
      );

      var jsonData = json.decode(response.body);
      print(jsonData);

      if (jsonData['status'] == "ok") {
        _showSuccessSnackBar("Password changed successfully!");

        // Clear all fields
        txtCurPass.clear();
        txtNewPass.clear();
        txtRenPass.clear();

        // Navigate to login after a short delay
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login_Page()),
          );
        });
      } else if (jsonData['status'] == "mismatch") {
        _showErrorSnackBar("New passwords do not match. Please try again.");
      } else {
        _showErrorSnackBar("Current password is incorrect.");
      }
    } catch (e) {
      print("Error: $e");
      _showErrorSnackBar("Connection error. Please try again.");
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

  bool _validatePasswords() {
    if (txtNewPass.text != txtRenPass.text) {
      _showErrorSnackBar("New passwords do not match");
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    txtCurPass.dispose();
    txtNewPass.dispose();
    txtRenPass.dispose();
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
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(
          "Change Password",
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
                    Icons.lock_reset_rounded,
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
                    "Update Your Password",
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
                  "Enter your current password and set a new one",
                  style: TextStyle(
                    fontSize: 16,
                    color: _secondaryColor,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40),

              // Current Password Field Label
              Padding(
                padding: EdgeInsets.only(bottom: 8, left: 8),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _accentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.lock_rounded, size: 16, color: _primaryColor),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Current Password",
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Current Password Field
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
                  controller: txtCurPass,
                  obscureText: _obscureCurPass,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _whiteColor,
                    hintText: "Enter current password",
                    hintStyle: TextStyle(color: _accentColor),
                    errorText: _valCurpass ? 'Current password is required' : null,
                    errorStyle: TextStyle(color: _errorColor),
                    prefixIcon: Icon(
                      Icons.lock_rounded,
                      color: _secondaryColor,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureCurPass = !_obscureCurPass;
                        });
                      },
                      child: Icon(
                        _obscureCurPass
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
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
                ),
              ),

              // New Password Field Label
              Padding(
                padding: EdgeInsets.only(bottom: 8, left: 8),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _accentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.lock_open_rounded, size: 16, color: _primaryColor),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "New Password",
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // New Password Field
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
                  controller: txtNewPass,
                  obscureText: _obscureNewPass,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _whiteColor,
                    hintText: "Enter new password",
                    hintStyle: TextStyle(color: _accentColor),
                    errorText: _valNewPass ? 'New password is required' : null,
                    errorStyle: TextStyle(color: _errorColor),
                    prefixIcon: Icon(
                      Icons.lock_open_rounded,
                      color: _secondaryColor,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureNewPass = !_obscureNewPass;
                        });
                      },
                      child: Icon(
                        _obscureNewPass
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
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
                ),
              ),

              // Confirm New Password Field Label
              Padding(
                padding: EdgeInsets.only(bottom: 8, left: 8),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _accentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.lock_outline_rounded, size: 16, color: _primaryColor),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Confirm New Password",
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Confirm New Password Field
              Container(
                margin: EdgeInsets.only(bottom: 8),
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
                  controller: txtRenPass,
                  obscureText: _obscureRenPass,
                  onChanged: (value) {
                    if (txtNewPass.text.isNotEmpty && value.isNotEmpty && txtNewPass.text != value) {
                      // Show real-time validation feedback
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _whiteColor,
                    hintText: "Confirm new password",
                    hintStyle: TextStyle(color: _accentColor),
                    errorText: _valRenPass ? 'Please confirm your new password' : null,
                    errorStyle: TextStyle(color: _errorColor),
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: _secondaryColor,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureRenPass = !_obscureRenPass;
                        });
                      },
                      child: Icon(
                        _obscureRenPass
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
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
                ),
              ),

              // Password Match Indicator
              if (txtNewPass.text.isNotEmpty && txtRenPass.text.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (txtNewPass.text == txtRenPass.text ? _successColor : _errorColor).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          txtNewPass.text == txtRenPass.text
                              ? Icons.check_circle_rounded
                              : Icons.error_rounded,
                          color: txtNewPass.text == txtRenPass.text
                              ? _successColor
                              : _errorColor,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          txtNewPass.text == txtRenPass.text
                              ? "Passwords match"
                              : "Passwords do not match",
                          style: TextStyle(
                            color: txtNewPass.text == txtRenPass.text
                                ? _successColor
                                : _errorColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),

              // Password Requirements Info
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
                        Text(
                          "Password Requirements",
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
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _lightBgColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildRequirementItem("At least 8 characters"),
                          SizedBox(height: 8),
                          _buildRequirementItem("Include uppercase and lowercase letters"),
                          SizedBox(height: 8),
                          _buildRequirementItem("Include numbers and special characters"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Update Button
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
                      txtCurPass.text.isEmpty
                          ? _valCurpass = true
                          : _valCurpass = false;
                      txtNewPass.text.isEmpty
                          ? _valNewPass = true
                          : _valNewPass = false;
                      txtRenPass.text.isEmpty
                          ? _valRenPass = true
                          : _valRenPass = false;

                      if (!_valCurpass && !_valNewPass && !_valRenPass) {
                        if (_validatePasswords()) {
                          _saveDetails(
                            txtCurPass.text,
                            txtNewPass.text,
                            txtRenPass.text,
                          );
                        }
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
                        "Updating...",
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
                      Icon(Icons.update_rounded, size: 22, color: _whiteColor),
                      SizedBox(width: 12),
                      Text(
                        "Update Password",
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
                      "EDU AI Platform • Secure Password Change",
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

  Widget _buildRequirementItem(String text) {
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
            text,
            style: TextStyle(
              color: _secondaryColor,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

