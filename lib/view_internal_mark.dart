// import 'dart:convert';
// import 'package:edu_ai_app/view_subject.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'homepage.dart';
//
// void main() {
//   runApp(const view_internal_mark());
// }
//
// class view_internal_mark extends StatelessWidget {
//   const view_internal_mark({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: view_internal_marksub(),
//     );
//   }
// }
//
// class view_internal_marksub extends StatefulWidget {
//   const view_internal_marksub({Key? key}) : super(key: key);
//
//   @override
//   State<view_internal_marksub> createState() => _State();
// }
//
// class _State extends State<view_internal_marksub> {
//   Future<List<Joke>> _getJokes() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? ip = prefs.getString("url");
//     if (ip == null) {
//       print("IP not found");
//       return [];
//     }
//
//     try {
//       var response = await http.post(Uri.parse("$ip/stud_view_internal_mark"),
//           body:{"sid": prefs.getString("sid"), "subid":prefs.get("subid")});
//       if (response.statusCode == 200) {
//         var jsonData = json.decode(response.body);
//         List<Joke> jokes = [];
//         for (var joke in jsonData["data"]) {
//           jokes.add(Joke(
//             joke["id"].toString(),
//             joke["mark"].toString(),
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
//         title: const Text("View internal marks"),
//         backgroundColor: Colors.brown.shade800,
//         elevation: 4,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new),
//           onPressed: () {
//             Navigator.pushReplacement(
//                 context, MaterialPageRoute(builder: (context) => const view_subject()));
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
//                   "No internal mark found 😕",
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
//                             infoRow(Icons.score, "Mark: ${row.mark}"),
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
//   final String mark;
//
//   Joke(this.id, this.mark);
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';
import 'view_subject.dart';

void main() {
  runApp(const view_internal_mark());
}

class view_internal_mark extends StatelessWidget {
  const view_internal_mark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: view_internal_marksub(),
    );
  }
}

class view_internal_marksub extends StatefulWidget {
  const view_internal_marksub({Key? key}) : super(key: key);

  @override
  State<view_internal_marksub> createState() => _State();
}

class _State extends State<view_internal_marksub> {
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

  // Score colors (keeping the same but with navy undertones)
  final Color _highScoreColor = Color(0xFF2E7D32);    // Dark green
  final Color _mediumScoreColor = Color(0xFFED6A02);  // Orange
  final Color _lowScoreColor = Color(0xFFD32F2F);     // Red

  String avg="", min_mark="", max_mark="";

  Future<List<Joke>> _getJokes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ip = prefs.getString("url");
    if (ip == null) {
      print("IP not found");
      return [];
    }

    try {
      var response = await http.post(
        Uri.parse("$ip/stud_view_internal_mark"),
        body: {"sid": prefs.getString("sid"), "subid": prefs.get("subid")},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        // setState(() {
        //   avg=jsonData['avg'].toString();
        //   min_mark=jsonData['min_mark'].toString();
        //   max_mark=jsonData['max_mark'].toString();
        // });

        List<Joke> jokes = [];
        for (var joke in jsonData["data"]) {
          jokes.add(Joke(
            joke["id"].toString(),
            joke["subject"].toString(),
            joke["mark"].toString(),
          ));
        }
        return jokes;
      }
    } catch (e) {
      print("Error: $e");
    }
    return [];
  }

  Color _getScoreColor(String mark) {
    try {
      double score = double.tryParse(mark) ?? 0;
      if (score >= 15) return _highScoreColor;
      if (score >= 10) return _mediumScoreColor;
      return _lowScoreColor;
    } catch (e) {
      return _darkTextColor;
    }
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
                MaterialPageRoute(builder: (context) => const view_subject()),
              );
            },
          ),
        ),
        title: Text(
          "Internal Marks",
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
                    "Loading Marks...",
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
                      Icons.assessment_rounded,
                      size: 60,
                      color: _whiteColor,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "No Marks Available",
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Internal marks have not been published yet",
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

          // Calculate statistics
          // double totalMarks = 0;
          // double highestMark = 0;
          // double lowestMark = double.infinity;
          //
          // for (var markData in snapshot.data) {
          //   try {
          //     double mark = double.tryParse(markData.mark) ?? 0;
          //     totalMarks += mark;
          //     if (mark > highestMark) highestMark = mark;
          //     if (mark < lowestMark) lowestMark = mark;
          //   } catch (e) {}
          // }

          // double averageMark = snapshot.data.isNotEmpty ? totalMarks / snapshot.data.length : 0;
          // if (lowestMark == double.infinity) lowestMark = 0;

          return SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Stats
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
                          Icons.bar_chart_rounded,
                          size: 45,
                          color: _whiteColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Internal Marks",
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
                          "Total Assessments: ${snapshot.data.length}",
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

                // Statistics Card
                // Container(
                //   width: double.infinity,
                //   padding: EdgeInsets.all(20),
                //   margin: EdgeInsets.only(bottom: 24),
                //   decoration: BoxDecoration(
                //     color: _cardColor,
                //     borderRadius: BorderRadius.circular(20),
                //     border: Border.all(
                //       color: _accentColor,
                //       width: 1,
                //     ),
                //     boxShadow: [
                //       BoxShadow(
                //         color: _primaryColor.withOpacity(0.08),
                //         blurRadius: 15,
                //         offset: Offset(0, 5),
                //       ),
                //     ],
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Row(
                //         children: [
                //           Container(
                //             padding: EdgeInsets.all(8),
                //             decoration: BoxDecoration(
                //               color: _lightBgColor,
                //               borderRadius: BorderRadius.circular(10),
                //             ),
                //             child: Icon(
                //               Icons.trending_up_rounded,
                //               color: _primaryColor,
                //               size: 20,
                //             ),
                //           ),
                //           SizedBox(width: 12),
                //           Text(
                //             "Performance Summary",
                //             style: TextStyle(
                //               color: _primaryColor,
                //               fontSize: 20,
                //               fontWeight: FontWeight.w700,
                //             ),
                //           ),
                //         ],
                //       ),
                //       SizedBox(height: 16),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           _buildStatCard(
                //             icon: Icons.trending_up_rounded,
                //             label: "Average",
                //             value: avg,
                //             color: _getScoreColor(avg.toString()),
                //           ),
                //           _buildStatCard(
                //             icon: Icons.arrow_upward_rounded,
                //             label: "Highest",
                //             value: max_mark,
                //             color: _getScoreColor(max_mark.toString()),
                //           ),
                //           _buildStatCard(
                //             icon: Icons.arrow_downward_rounded,
                //             label: "Lowest",
                //             value: min_mark,
                //             color: _getScoreColor(min_mark.toString()),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),

                // Marks List Header
                Padding(
                  padding: EdgeInsets.only(bottom: 16, left: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.list_alt_rounded,
                          color: _primaryColor,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Assessment Details",
                        style: TextStyle(
                          color: _primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Marks List
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final row = snapshot.data[index];
                    final scoreColor = _getScoreColor(row.mark);

                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: _cardColor,
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
                      child: ListTile(
                        contentPadding: EdgeInsets.all(20),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _primaryColor.withOpacity(0.1),
                                _secondaryColor.withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.assessment_rounded,
                            color: _secondaryColor,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          row.subject,
                          style: TextStyle(
                            color: _primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            "Internal Mark",
                            style: TextStyle(
                              color: _lightTextColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: scoreColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: scoreColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            row.mark,
                            style: TextStyle(
                              color: scoreColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Performance Guide
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(top: 24, bottom: 16),
                  decoration: BoxDecoration(
                    color: _whiteColor,
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
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _lightBgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.info_rounded,
                              color: _primaryColor,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Performance Guide",
                            style: TextStyle(
                              color: _primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          _buildPerformanceIndicator(
                            color: _highScoreColor,
                            label: "Excellent (16-20)",
                          ),
                          _buildPerformanceIndicator(
                            color: _mediumScoreColor,
                            label: "Good (10-15)",
                          ),
                          _buildPerformanceIndicator(
                            color: _lowScoreColor,
                            label: "Needs Improvement (0-9)",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Footer with gradient line
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
                        "EDU AI Platform • Academic Performance",
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

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: _lightTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceIndicator({
    required Color color,
    required String label,
  }) {
    return Container(
      width: (MediaQuery.of(context).size.width - 80) / 3,
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: _secondaryColor,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class Joke {
  final String id;
  final String subject;
  final String mark;

  Joke(this.id, this.subject, this.mark);
}

