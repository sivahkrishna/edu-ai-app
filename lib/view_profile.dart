// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'homepage.dart';
//
// void main() {
//   runApp(const view_profile());
// }
//
// class view_profile extends StatelessWidget {
//   const view_profile({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: view_profilesub(),
//     );
//   }
// }
//
// class view_profilesub extends StatefulWidget {
//   const view_profilesub({Key? key}) : super(key: key);
//
//   @override
//   State<view_profilesub> createState() => _State();
// }
//
// class _State extends State<view_profilesub> {
//   Future<List<Joke>> _getJokes() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? ip = prefs.getString("url");
//     if (ip == null) {
//       print("IP not found");
//       return [];
//     }
//
//     try {
//       var response = await http.post(Uri.parse("$ip/stud_view_profile"),
//           body:{"sid": prefs.getString("sid").toString()});
//
//       if (response.statusCode == 200) {
//         var jsonData = json.decode(response.body);
//         List<Joke> jokes = [];
//         for (var joke in jsonData["data"]) {
//           jokes.add(Joke(
//             joke["id"].toString(),
//             joke["std_name"].toString(),
//             joke["course"].toString(),
//             joke["semester"].toString(),
//             joke["ad_num"].toString(),
//             joke["gender"].toString(),
//             joke["dob"].toString(),
//             joke["email"].toString(),
//             joke["phone"].toString(),
//             joke["place"].toString(),
//             joke["city"].toString(),
//             joke["state"].toString(),
//             joke["pin"].toString(),
//             joke["image"].toString(),
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
//         title: const Text("View profile"),
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
//                   "No profile found 😕",
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
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.all(16),
//                     subtitle: Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           infoRow(Icons.switch_account_rounded, "Name: ${row.std_name}"),
//                           infoRow(Icons.subject, "Course: ${row.course}"),
//                           infoRow(Icons.subject_sharp, "Semester: ${row.semester}"),
//                           infoRow(Icons.numbers, "Admission Number: ${row.ad_num}"),
//                           infoRow(Icons.male, "Gender: ${row.gender}"),
//                           infoRow(Icons.date_range, "Date Of Birth: ${row.dob}"),
//                           infoRow(Icons.email, "Email: ${row.email}"),
//                           infoRow(Icons.phone, "Phone Number: ${row.phone}"),
//                           infoRow(Icons.place, "Place: ${row.place}"),
//                           infoRow(Icons.location_city, "City: ${row.city}"),
//                           infoRow(Icons.stacked_bar_chart, "State: ${row.state}"),
//                           infoRow(Icons.pin, "Pin: ${row.pin}"),
//                           infoRow(Icons.image, "Image: ${row.image}"),
//
//                         ],
//                       ),
//                     ),
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
//   final String std_name;
//   final String course;
//   final String semester;
//   final String ad_num;
//   final String gender;
//   final String dob;
//   final String email;
//   final String phone;
//   final String place;
//   final String city;
//   final String state;
//   final String pin;
//   final String image;
//
//   Joke(this.id, this.std_name, this.course, this.semester, this.ad_num,
//       this.gender, this.dob, this.email, this.phone, this.place, this.city,
//       this.state, this.pin, this.image);
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';

void main() {
  runApp(const view_profile());
}

class view_profile extends StatelessWidget {
  const view_profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: view_profilesub(),
    );
  }
}

class view_profilesub extends StatefulWidget {
  const view_profilesub({Key? key}) : super(key: key);

  @override
  State<view_profilesub> createState() => _State();
}

class _State extends State<view_profilesub> {
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

  Future<List<Joke>> _getJokes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ip = prefs.getString("url");
    if (ip == null) {
      print("IP not found");
      return [];
    }

    try {
      var response = await http.post(
        Uri.parse("$ip/stud_view_profile"),
        body: {"sid": prefs.getString("sid").toString()},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<Joke> jokes = [];
        for (var joke in jsonData["data"]) {
          jokes.add(Joke(
            joke["id"].toString(),
            joke["std_name"].toString(),
            joke["course"].toString(),
            joke["semester"].toString(),
            joke["ad_num"].toString(),
            joke["gender"].toString(),
            joke["dob"].toString(),
            joke["email"].toString(),
            joke["phone"].toString(),
            joke["place"].toString(),
            joke["city"].toString(),
            joke["state"].toString(),
            joke["pin"].toString(),
            joke["image"].toString(),
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
          "Student Profile",
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
                    "Loading Profile...",
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
                      Icons.person_off_rounded,
                      size: 60,
                      color: _whiteColor,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "No Profile Found",
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Student profile information is not available",
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
                            "Try Again",
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
                // Profile Header Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  margin: EdgeInsets.only(bottom: 24),
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
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [_primaryColor, _secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: _accentColor,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _primaryColor.withOpacity(0.2),
                              blurRadius: 15,
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
                      SizedBox(height: 16),
                      Text(
                        snapshot.data[0].std_name,
                        style: TextStyle(
                          color: _primaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: _accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          snapshot.data[0].course,
                          style: TextStyle(
                            color: _secondaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Semester ${snapshot.data[0].semester} • ${snapshot.data[0].ad_num}",
                        style: TextStyle(
                          color: _lightTextColor,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                // Section Title
                Padding(
                  padding: EdgeInsets.only(bottom: 12, left: 8),
                  child: Text(
                    "Personal Information",
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // Personal Details Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(bottom: 24),
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
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        icon: Icons.person_outline_rounded,
                        label: "Full Name",
                        value: snapshot.data[0].std_name,
                      ),
                      SizedBox(height: 16),
                      _buildDetailRow(
                        icon: snapshot.data[0].gender.toLowerCase() == "male"
                            ? Icons.male_rounded
                            : Icons.female_rounded,
                        label: "Gender",
                        value: snapshot.data[0].gender,
                      ),
                      SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.cake_rounded,
                        label: "Date of Birth",
                        value: snapshot.data[0].dob,
                      ),
                      SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.email_rounded,
                        label: "Email Address",
                        value: snapshot.data[0].email,
                      ),
                      SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.phone_rounded,
                        label: "Phone Number",
                        value: snapshot.data[0].phone,
                      ),
                    ],
                  ),
                ),

                // Section Title
                Padding(
                  padding: EdgeInsets.only(bottom: 12, left: 8),
                  child: Text(
                    "Academic Information",
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // Academic Details Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(bottom: 24),
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
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        icon: Icons.school_rounded,
                        label: "Course",
                        value: snapshot.data[0].course,
                      ),
                      SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.book_rounded,
                        label: "Semester",
                        value: snapshot.data[0].semester,
                      ),
                      SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.numbers_rounded,
                        label: "Admission Number",
                        value: snapshot.data[0].ad_num,
                      ),
                    ],
                  ),
                ),

                // Section Title
                Padding(
                  padding: EdgeInsets.only(bottom: 12, left: 8),
                  child: Text(
                    "Address Information",
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // Address Details Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
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
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        icon: Icons.location_on_rounded,
                        label: "Place",
                        value: snapshot.data[0].place,
                      ),
                      SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.location_city_rounded,
                        label: "City",
                        value: snapshot.data[0].city,
                      ),
                      SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.map_rounded,
                        label: "State",
                        value: snapshot.data[0].state,
                      ),
                      SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.pin_drop_rounded,
                        label: "PIN Code",
                        value: snapshot.data[0].pin,
                      ),
                    ],
                  ),
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
                        "EDU AI Platform • Student Profile",
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
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryColor.withOpacity(0.1), _secondaryColor.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: _secondaryColor,
            size: 20,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: _lightTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: _primaryColor,
                  fontSize: 16,
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
  final String std_name;
  final String course;
  final String semester;
  final String ad_num;
  final String gender;
  final String dob;
  final String email;
  final String phone;
  final String place;
  final String city;
  final String state;
  final String pin;
  final String image;

  Joke(
      this.id,
      this.std_name,
      this.course,
      this.semester,
      this.ad_num,
      this.gender,
      this.dob,
      this.email,
      this.phone,
      this.place,
      this.city,
      this.state,
      this.pin,
      this.image,
      );
}

