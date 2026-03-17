// import 'dart:convert';
// import 'package:edu_ai_app/view_subject.dart';
// import 'package:edu_ai_app/view_unit.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'homepage.dart';
//
// void main() {
//   runApp(const view_reference_link());
// }
//
// class view_reference_link extends StatelessWidget {
//   const view_reference_link({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: view_reference_linksub(),
//     );
//   }
// }
//
// class view_reference_linksub extends StatefulWidget {
//   const view_reference_linksub({Key? key}) : super(key: key);
//
//   @override
//   State<view_reference_linksub> createState() => _State();
// }
//
// class _State extends State<view_reference_linksub> {
//   Future<List<Joke>> _getJokes() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? ip = prefs.getString("url");
//     if (ip == null) {
//       print("IP not found");
//       return [];
//     }
//
//     try {
//       var response = await http.post(Uri.parse("$ip/stud_view_reference"),
//           body:{"unitid": prefs.getString("unitid"),});
//       if (response.statusCode == 200) {
//         var jsonData = json.decode(response.body);
//         List<Joke> jokes = [];
//         for (var joke in jsonData["data"]) {
//           jokes.add(Joke(
//             joke["id"].toString(),
//             joke["date"].toString(),
//             joke["title"].toString(),
//             joke["refer_link"].toString(),
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
//         title: const Text("View reference link"),
//         backgroundColor: Colors.brown.shade800,
//         elevation: 4,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new),
//           onPressed: () {
//             Navigator.pushReplacement(
//                 context, MaterialPageRoute(builder: (context) => const view_unit()));
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
//                   "No  Reference Link found 😕",
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
//                             infoRow(Icons.score, "Date: ${row.date}"),
//                             infoRow(Icons.score, "Title: ${row.title}"),
//                             infoRow(Icons.score, "Reference_Link: ${row.refer_link}"),
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
//   final String date;
//   final String title;
//   final String refer_link;
//
//   Joke(this.id, this.date , this.title , this.refer_link);
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';
import 'view_unit.dart';

void main() {
  runApp(const view_questions());
}

class view_questions extends StatelessWidget {
  const view_questions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: view_questionssub(),
    );
  }
}

class view_questionssub extends StatefulWidget {
  const view_questionssub({Key? key}) : super(key: key);

  @override
  State<view_questionssub> createState() => _State();
}

class _State extends State<view_questionssub> {
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
  final Color _linkColor = Color(0xFF526D82);         // Steel blue for links

  Future<List<Joke>> _getJokes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ip = prefs.getString("url");
    if (ip == null) {
      print("IP not found");
      return [];
    }

    try {
      var response = await http.post(
        Uri.parse("$ip/stud_view_qa"),
        body: {"unitid": prefs.getString("unitid")},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<Joke> jokes = [];
        for (var joke in jsonData["data"]) {
          jokes.add(Joke(
            joke["id"].toString(),
            joke["question"].toString(),
            joke["answer"].toString(),
          ));
        }
        return jokes;
      }
    } catch (e) {
      print("Error: $e");
    }
    return [];
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      _showSnackBar('Invalid URL format');
      return;
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showSnackBar('Could not launch URL');
    }
  }

  void _showSnackBar(String message) {
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

  void _copyToClipboard(String text, BuildContext context) {
    _showSnackBar('Link copied to clipboard!');
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
          "Questions",
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
                    "Loading questions...",
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
                      Icons.link_off_rounded,
                      size: 60,
                      color: _whiteColor,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "No Questionss",
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Qustions will be added soon",
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
                          Icons.link_rounded,
                          size: 45,
                          color: _whiteColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Questions",
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
                          "Total questions: ${snapshot.data.length}",
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

                // Resource List
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
                          // Resource Header
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
                            child: Column(children: [
                              Row(
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
                                      Icons.article_rounded,
                                      color: _primaryColor,
                                      size: 28,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: _whiteColor,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                "Question ${index + 1}",
                                                style: TextStyle(
                                                  color: _primaryColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          row.question,
                                          style: TextStyle(
                                            color: _whiteColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8,),
                              Row(
                                children: [
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          row.answer,
                                          style: TextStyle(
                                            color: _whiteColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],),
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
                        "EDU AI Platform • Questions and answers",
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

class Joke {
  final String id;
  final String question;
  final String answer;

  Joke(this.id, this.question, this.answer);
}

