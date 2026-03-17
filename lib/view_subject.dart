// import 'dart:convert';
// import 'package:edu_ai_app/view_internal_mark.dart';
// import 'package:edu_ai_app/view_unit.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'homepage.dart';
//
// void main() {
//   runApp(const view_subject());
// }
//
// class view_subject extends StatelessWidget {
//   const view_subject({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: view_subjectsub(),
//     );
//   }
// }
//
// class view_subjectsub extends StatefulWidget {
//   const view_subjectsub({Key? key}) : super(key: key);
//
//   @override
//   State<view_subjectsub> createState() => _State();
// }
//
// class _State extends State<view_subjectsub> {
//   Future<List<Joke>> _getJokes() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? ip = prefs.getString("url");
//     if (ip == null) {
//       print("IP not found");
//       return [];
//     }
//
//     try {
//       var response = await http.post(Uri.parse("$ip/stud_view_subject"),
//           body:{"sid": prefs.getString("sid")});
//       if (response.statusCode == 200) {
//         var jsonData = json.decode(response.body);
//         List<Joke> jokes = [];
//         for (var joke in jsonData["data"]) {
//           jokes.add(Joke(
//             joke["id"].toString(),
//             joke["sid"].toString(),
//             joke["sub_name"].toString(),
//             joke["semester"].toString(),
//             joke["course"].toString(),
//             joke["fname"].toString(),
//             joke["fid"].toString(),
//           ));
//         }
//         return jokes;
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//     return [];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // 🌈 Modern gradient app bar
//       appBar: AppBar(
//         title: const Text("View subject"),
//         backgroundColor: Colors.brown.shade800,
//         elevation: 4,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new),
//           onPressed: () {
//             Navigator.pushReplacement(
//                 context, MaterialPageRoute(builder: (context) => const HomeApp()));
//           },
//         ),
//       ),
//
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFF3E5AB), Color(0xFFBCAAA4)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: FutureBuilder(
//           future: _getJokes(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(color: Colors.brown),
//               );
//             }
//
//             if (!snapshot.hasData || snapshot.data.isEmpty) {
//               return const Center(
//                 child: Text(
//                   "No subject found 😕",
//                   style: TextStyle(fontSize: 18, color: Colors.black54),
//                 ),
//               );
//             }
//
//             return ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: snapshot.data.length,
//               itemBuilder: (context, index) {
//                 final row = snapshot.data[index];
//                 return Container(
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFFFFFFFF), Color(0xFFFFF3E0)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.brown.withOpacity(0.2),
//                         blurRadius: 8,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             infoRow(Icons.subject, "Subject Name: ${row.sub_name}"),
//                             infoRow(Icons.school, "Semester: ${row.semester}"),
//                             infoRow(Icons.subject_sharp, "Course: ${row.course}"),
//                             infoRow(Icons.assistant, "Faculty Name: ${row.fname}"),
//                             infoRow(Icons.perm_identity, "Faculty ID: ${row.fid}"),
//                           ],
//                         ),
//                       ),
//                       // Added buttons section
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             // Internal Mark Button
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 4),
//                                 child: ElevatedButton.icon(
//                                   onPressed: () async {
//
//                                     SharedPreferences prefs = await SharedPreferences.getInstance();
//                                     await prefs.setString("subid", row.sid.toString());
//
//                                     Navigator.push(context, MaterialPageRoute(builder: (context) => view_internal_mark()));
//                                   },
//                                   icon: const Icon(Icons.score, size: 16),
//                                   label: const Text('Internal Mark',
//                                     style: TextStyle(fontSize: 12),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.green.shade700,
//                                     foregroundColor: Colors.white,
//                                     padding: const EdgeInsets.symmetric(vertical: 10),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             // Unit Button
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 4),
//                                 child: ElevatedButton.icon(
//                                   onPressed: () async {
//                                     SharedPreferences prefs = await SharedPreferences.getInstance();
//                                     await prefs.setString("suballocid", row.id.toString());
//
//                                     Navigator.push(context, MaterialPageRoute(builder: (context) => view_unit()));
//                                   },
//                                   icon: const Icon(Icons.menu_book, size: 16),
//                                   label: const Text('Unit',
//                                     style: TextStyle(fontSize: 12),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.blue.shade700,
//                                     foregroundColor: Colors.white,
//                                     padding: const EdgeInsets.symmetric(vertical: 10),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             // Chat with Faculty Button
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 4),
//                                 child: ElevatedButton.icon(
//                                   onPressed: () {
//                                     // Add your chat navigation logic here
//                                     print('Chat with ${row.fname}');
//                                   },
//                                   icon: const Icon(Icons.chat, size: 16),
//                                   label: const Text('Chat',
//                                     style: TextStyle(fontSize: 12),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.purple.shade700,
//                                     foregroundColor: Colors.white,
//                                     padding: const EdgeInsets.symmetric(vertical: 10),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget infoRow(IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 3),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.brown.shade400, size: 18),
//           const SizedBox(width: 6),
//           Flexible(
//             child: Text(
//               text,
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontSize: 14.5,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class Joke {
//   final String id;
//   final String sid;
//   final String sub_name;
//   final String semester;
//   final String course;
//   final String fname;
//   final String fid;
//
//   Joke(this.id, this.sid, this.sub_name, this.semester, this.course, this.fname, this.fid);
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'chat.dart';
import 'homepage.dart';
import 'view_internal_mark.dart';
import 'view_unit.dart';

void main() {
  runApp(const view_subject());
}

class view_subject extends StatelessWidget {
  const view_subject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: view_subjectsub(),
    );
  }
}

class view_subjectsub extends StatefulWidget {
  const view_subjectsub({Key? key}) : super(key: key);

  @override
  State<view_subjectsub> createState() => _State();
}

class _State extends State<view_subjectsub> {
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
  final Color _iconColor = Color(0xFF526D82);         // Steel blue for icons

  // Button colors using navy palette
  final Color _internalMarkColor = Color(0xFF27374D);  // Deep navy
  final Color _unitColor = Color(0xFF526D82);          // Steel blue
  final Color _chatColor = Color(0xFF9DB2BF);          // Soft periwinkle

  Future<List<Joke>> _getJokes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ip = prefs.getString("url");
    if (ip == null) {
      print("IP not found");
      return [];
    }

    try {
      var response = await http.post(
        Uri.parse("$ip/stud_view_subject"),
        body: {"sid": prefs.getString("sid")},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<Joke> jokes = [];
        for (var joke in jsonData["data"]) {
          jokes.add(Joke(
            joke["id"].toString(),
            joke["sid"].toString(),
            joke["sub_name"].toString(),
            joke["semester"].toString(),
            joke["course"].toString(),
            joke["fname"].toString(),
            joke["fid"].toString(),
          ));
        }
        return jokes;
      }
    } catch (e) {
      print("Error: $e");
    }
    return [];
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
                MaterialPageRoute(builder: (context) => const HomeApp()),
              );
            },
          ),
        ),
        title: Text(
          "My Subjects",
          style: TextStyle(
            color: _whiteColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_secondaryColor, _primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.refresh_rounded, color: _whiteColor),
              onPressed: () {
                setState(() {});
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getJokes(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
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
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(_whiteColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Loading Subjects...",
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
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
                      Icons.subject_rounded,
                      size: 60,
                      color: _whiteColor,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "No Subjects Found",
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "You are not enrolled in any subjects",
                    style: TextStyle(
                      color: _secondaryColor,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_secondaryColor, _primaryColor],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: _whiteColor,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh_rounded, size: 20, color: _whiteColor),
                          SizedBox(width: 8),
                          Text(
                            "Refresh",
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
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
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
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.menu_book_rounded,
                          size: 45,
                          color: _whiteColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Your Subjects",
                        style: TextStyle(
                          color: _primaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: _accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Total Subjects: ${snapshot.data.length}",
                          style: TextStyle(
                            color: _secondaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),

                // Subject List
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final row = snapshot.data[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _accentColor,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryColor.withOpacity(0.08),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Subject Header
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [_primaryColor, _secondaryColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: _whiteColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: _primaryColor.withOpacity(0.2),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.subject_rounded,
                                    color: _primaryColor,
                                    size: 28,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        row.sub_name,
                                        style: TextStyle(
                                          color: _whiteColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Semester ${row.semester} • ${row.course}",
                                        style: TextStyle(
                                          color: _whiteColor.withOpacity(0.9),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Subject Details
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow(
                                  icon: Icons.person_rounded,
                                  label: "Faculty",
                                  value: row.fname,
                                ),
                                SizedBox(height: 12),
                                _buildDetailRow(
                                  icon: Icons.badge_rounded,
                                  label: "Faculty ID",
                                  value: row.fid,
                                ),
                              ],
                            ),
                          ),

                          // Action Buttons
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [_internalMarkColor, _secondaryColor],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _primaryColor.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        await prefs.setString("subid", row.sid.toString());
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => view_internal_mark()),
                                        );
                                      },
                                      icon: Icon(Icons.assessment_rounded, size: 18, color: _whiteColor),
                                      label: Text(
                                        'Internal Mark',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: _whiteColor,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: _whiteColor,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 14),
                                        elevation: 0,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [_unitColor, _primaryColor],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _secondaryColor.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        await prefs.setString("suballocid", row.id.toString());
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => view_unit()),
                                        );
                                      },
                                      icon: Icon(Icons.menu_book_rounded, size: 18, color: _whiteColor),
                                      label: Text(
                                        'Units',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: _whiteColor,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: _whiteColor,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 14),
                                        elevation: 0,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [_chatColor, _secondaryColor],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _accentColor.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        await prefs.setString("fid", row.fid.toString());
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => MyChatApp()),
                                        );
                                        print('Chat with ${row.fname}');
                                      },
                                      icon: Icon(Icons.chat_rounded, size: 18, color: _whiteColor),
                                      label: Text(
                                        'Chat',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: _whiteColor,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: _whiteColor,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 14),
                                        elevation: 0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Footer
                SizedBox(height: 32),
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
                        "EDU AI Platform • Subjects Dashboard",
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
          );
        },
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryColor.withOpacity(0.1), _secondaryColor.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: _secondaryColor,
            size: 18,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: _lightTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: _primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Joke {
  final String id;
  final String sid;
  final String sub_name;
  final String semester;
  final String course;
  final String fname;
  final String fid;

  Joke(this.id, this.sid, this.sub_name, this.semester, this.course, this.fname, this.fid);
}

