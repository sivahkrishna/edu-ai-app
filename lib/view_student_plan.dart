// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:intl/intl.dart';
// import 'chat.dart';
// import 'homepage.dart';
// import 'view_internal_mark.dart';
// import 'view_unit.dart';
//
//
// class view_study_plan extends StatelessWidget {
//   const view_study_plan({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: view_study_plansub(),
//     );
//   }
// }
//
// class view_study_plansub extends StatefulWidget {
//   const view_study_plansub({Key? key}) : super(key: key);
//
//   @override
//   State<view_study_plansub> createState() => _State();
// }
//
// class _State extends State<view_study_plansub> {
//   // Color palette
//   final Color _primaryColor = Color(0xFFECFAE5);
//   final Color _secondaryColor = Color(0xFFDDF6D2);
//   final Color _accentColor = Color(0xFFCAE8BD);
//   final Color _buttonColor = Color(0xFFB0DB9C);
//   final Color _darkTextColor = Color(0xFF2E4A21);
//   final Color _lightTextColor = Color(0xFF5A7C4D);
//   final Color _cardColor = Colors.white;
//   final Color _iconColor = Color(0xFF4CAF50);
//   final Color _successColor = Color(0xFF4CAF50);
//   final Color _warningColor = Color(0xFFFF9800);
//   final Color _dangerColor = Color(0xFFF44336);
//
//   Map<String, dynamic>? studyData;
//   bool isLoading = true;
//
//   Future<void> _getStudyPlan() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? ip = prefs.getString("url");
//     if (ip == null) {
//       print("IP not found");
//       setState(() {
//         isLoading = false;
//       });
//       return;
//     }
//
//     try {
//       var response = await http.post(
//         Uri.parse("$ip/student_get_study_plan"),
//         body: {"sid": prefs.getString("sid")},
//       );
//
//       if (response.statusCode == 200) {
//         var jsonData = json.decode(response.body);
//         if (jsonData["status"] == "success") {
//           setState(() {
//             studyData = jsonData;
//             isLoading = false;
//           });
//         } else {
//           print("API Error: ${jsonData['message']}");
//           setState(() {
//             isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       print("Error: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _generateAndSharePDF() async {
//     if (studyData == null) return;
//
//     final pdf = pw.Document();
//
//     // PDF Header
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               // Header
//               pw.Container(
//                 width: double.infinity,
//                 padding: pw.EdgeInsets.all(20),
//                 decoration: pw.BoxDecoration(
//                   color: PdfColor.fromHex("#B0DB9C"),
//                   borderRadius: pw.BorderRadius.circular(10),
//                 ),
//                 child: pw.Column(
//                   children: [
//                     pw.Text(
//                       "STUDY PLAN & PERFORMANCE ANALYSIS",
//                       style: pw.TextStyle(
//                         fontSize: 24,
//                         fontWeight: pw.FontWeight.bold,
//                         color: PdfColor.fromHex("#2E4A21"),
//                       ),
//                     ),
//                     pw.SizedBox(height: 10),
//                     pw.Text(
//                       "Generated on ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
//                       style: pw.TextStyle(
//                         fontSize: 12,
//                         color: PdfColor.fromHex("#5A7C4D"),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               pw.SizedBox(height: 20),
//
//               // Student Info
//               pw.Container(
//                 padding: pw.EdgeInsets.all(15),
//                 decoration: pw.BoxDecoration(
//                   border: pw.Border.all(color: PdfColor.fromHex("#CAE8BD"), width: 1),
//                   borderRadius: pw.BorderRadius.circular(8),
//                 ),
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text(
//                       "STUDENT INFORMATION",
//                       style: pw.TextStyle(
//                         fontSize: 16,
//                         fontWeight: pw.FontWeight.bold,
//                         color: PdfColor.fromHex("#2E4A21"),
//                       ),
//                     ),
//                     pw.SizedBox(height: 10),
//                     pw.Row(
//                       children: [
//                         pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             _buildPDFRow("Name:", studyData!['student_info']['name']),
//                             _buildPDFRow("Course:", studyData!['student_info']['course']),
//                           ],
//                         ),
//                         pw.SizedBox(width: 40),
//                         pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             _buildPDFRow("Semester:", studyData!['student_info']['semester']),
//                             _buildPDFRow("Admission No:", studyData!['student_info']['admission_no']),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               pw.SizedBox(height: 25),
//
//               // Performance Summary
//               pw.Container(
//                 padding: pw.EdgeInsets.all(15),
//                 decoration: pw.BoxDecoration(
//                   color: PdfColor.fromHex("#ECFAE5"),
//                   borderRadius: pw.BorderRadius.circular(8),
//                 ),
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text(
//                       "PERFORMANCE SUMMARY",
//                       style: pw.TextStyle(
//                         fontSize: 16,
//                         fontWeight: pw.FontWeight.bold,
//                         color: PdfColor.fromHex("#2E4A21"),
//                       ),
//                     ),
//                     pw.SizedBox(height: 10),
//                     pw.Text(
//                       studyData!['analysis']['description'],
//                       style: pw.TextStyle(
//                         fontSize: 12,
//                         color: PdfColor.fromHex("#5A7C4D"),
//                       ),
//                     ),
//                     pw.SizedBox(height: 10),
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         _buildStatBox(
//                           "Overall Score",
//                           "${studyData!['analysis']['overall_score']}%",
//                           PdfColor.fromHex("#4CAF50"),
//                         ),
//                         _buildStatBox(
//                           "Class Average",
//                           "${studyData!['analysis']['class_average']}%",
//                           PdfColor.fromHex("#2196F3"),
//                         ),
//                         _buildStatBox(
//                           "Status",
//                           studyData!['analysis']['overall_status'],
//                           PdfColor.fromHex("#FF9800"),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               pw.SizedBox(height: 25),
//
//               // Study Plan Table
//               pw.Text(
//                 "WEEKLY STUDY PLAN",
//                 style: pw.TextStyle(
//                   fontSize: 18,
//                   fontWeight: pw.FontWeight.bold,
//                   color: PdfColor.fromHex("#2E4A21"),
//                 ),
//               ),
//               pw.SizedBox(height: 10),
//               _buildStudyPlanTable(),
//
//               pw.SizedBox(height: 25),
//
//               // Analysis Sections
//               pw.Row(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   // Strengths
//                   pw.Expanded(
//                     child: pw.Container(
//                       padding: pw.EdgeInsets.all(15),
//                       decoration: pw.BoxDecoration(
//                         color: PdfColor.fromHex("#DDF6D2"),
//                         borderRadius: pw.BorderRadius.circular(8),
//                       ),
//                       child: pw.Column(
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Text(
//                             "STRENGTHS",
//                             style: pw.TextStyle(
//                               fontSize: 14,
//                               fontWeight: pw.FontWeight.bold,
//                               color: PdfColor.fromHex("#2E4A21"),
//                             ),
//                           ),
//                           pw.SizedBox(height: 10),
//                           ...studyData!['analysis']['strengths'].map<Widget>((strength) {
//                             return pw.Padding(
//                               padding: pw.EdgeInsets.only(bottom: 5),
//                               child: pw.Text(
//                                 "✓ ${strength['subject']} (+${strength['advantage']}%)",
//                                 style: pw.TextStyle(
//                                   fontSize: 11,
//                                   color: PdfColor.fromHex("#5A7C4D"),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   pw.SizedBox(width: 10),
//
//                   // Weaknesses
//                   pw.Expanded(
//                     child: pw.Container(
//                       padding: pw.EdgeInsets.all(15),
//                       decoration: pw.BoxDecoration(
//                         color: PdfColor.fromHex("#FFEBEE"),
//                         borderRadius: pw.BorderRadius.circular(8),
//                       ),
//                       child: pw.Column(
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Text(
//                             "AREAS TO IMPROVE",
//                             style: pw.TextStyle(
//                               fontSize: 14,
//                               fontWeight: pw.FontWeight.bold,
//                               color: PdfColor.fromHex("#D32F2F"),
//                             ),
//                           ),
//                           pw.SizedBox(height: 10),
//                           ...studyData!['analysis']['weaknesses'].map<Widget>((weakness) {
//                             return pw.Padding(
//                               padding: pw.EdgeInsets.only(bottom: 5),
//                               child: pw.Text(
//                                 "⚠ ${weakness['subject']} (-${weakness['disadvantage']}%)",
//                                 style: pw.TextStyle(
//                                   fontSize: 11,
//                                   color: PdfColor.fromHex("#D32F2F"),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               pw.SizedBox(height: 25),
//
//               // Recommendations
//               pw.Container(
//                 padding: pw.EdgeInsets.all(15),
//                 decoration: pw.BoxDecoration(
//                   color: PdfColor.fromHex("#FFF3E0"),
//                   borderRadius: pw.BorderRadius.circular(8),
//                 ),
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text(
//                       "RECOMMENDATIONS",
//                       style: pw.TextStyle(
//                         fontSize: 14,
//                         fontWeight: pw.FontWeight.bold,
//                         color: PdfColor.fromHex("#E65100"),
//                       ),
//                     ),
//                     pw.SizedBox(height: 10),
//                     ...studyData!['analysis']['recommendations'].map<Widget>((rec) {
//                       return pw.Padding(
//                         padding: pw.EdgeInsets.only(bottom: 5),
//                         child: pw.Row(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             pw.Text("• ", style: pw.TextStyle(fontSize: 12)),
//                             pw.Expanded(
//                               child: pw.Text(
//                                 rec,
//                                 style: pw.TextStyle(
//                                   fontSize: 11,
//                                   color: PdfColor.fromHex("#5D4037"),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               ),
//
//               pw.SizedBox(height: 25),
//
//               // Footer
//               pw.Container(
//                 padding: pw.EdgeInsets.all(10),
//                 decoration: pw.BoxDecoration(
//                   color: PdfColor.fromHex("#F5F5F5"),
//                   borderRadius: pw.BorderRadius.circular(5),
//                 ),
//                 child: pw.Center(
//                   child: pw.Text(
//                     "Generated by EDU AI Platform • ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}",
//                     style: pw.TextStyle(
//                       fontSize: 10,
//                       color: PdfColor.fromHex("#757575"),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//
//     // Save and share PDF
//     final output = await getTemporaryDirectory();
//     final file = File("${output.path}/study_plan_${DateTime.now().millisecondsSinceEpoch}.pdf");
//     await file.writeAsBytes(await pdf.save());
//
//     // Share the PDF
//     await Printing.sharePdf(
//       bytes: await pdf.save(),
//       filename: 'Study_Plan_${studyData!['student_info']['name']}.pdf',
//     );
//   }
//
//   pw.Widget _buildPDFRow(String label, String value) {
//     return pw.Row(
//       children: [
//         pw.Text(
//           label,
//           style: pw.TextStyle(
//             fontSize: 12,
//             fontWeight: pw.FontWeight.bold,
//             color: PdfColor.fromHex("#5A7C4D"),
//           ),
//         ),
//         pw.SizedBox(width: 10),
//         pw.Text(
//           value,
//           style: pw.TextStyle(
//             fontSize: 12,
//             color: PdfColor.fromHex("#2E4A21"),
//           ),
//         ),
//       ],
//     );
//   }
//
//   pw.Widget _buildStatBox(String title, String value, PdfColor color) {
//     return pw.Container(
//       width: 100,
//       padding: pw.EdgeInsets.all(10),
//       decoration: pw.BoxDecoration(
//         color: color,
//         borderRadius: pw.BorderRadius.circular(5),
//       ),
//       child: pw.Column(
//         children: [
//           pw.Text(
//             title,
//             style: pw.TextStyle(
//               fontSize: 10,
//               color: PdfColors.white,
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//           pw.SizedBox(height: 5),
//           pw.Text(
//             value,
//             style: pw.TextStyle(
//               fontSize: 14,
//               color: PdfColors.white,
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   pw.Widget _buildStudyPlanTable() {
//     return pw.Table(
//       border: pw.TableBorder.all(color: PdfColor.fromHex("#CAE8BD"), width: 1),
//       children: [
//         pw.TableRow(
//           decoration: pw.BoxDecoration(color: PdfColor.fromHex("#ECFAE5")),
//           children: [
//             pw.Padding(
//               padding: pw.EdgeInsets.all(8),
//               child: pw.Text(
//                 "Subject",
//                 style: pw.TextStyle(
//                   fontWeight: pw.FontWeight.bold,
//                   color: PdfColor.fromHex("#2E4A21"),
//                 ),
//               ),
//             ),
//             pw.Padding(
//               padding: pw.EdgeInsets.all(8),
//               child: pw.Text(
//                 "Study Time",
//                 style: pw.TextStyle(
//                   fontWeight: pw.FontWeight.bold,
//                   color: PdfColor.fromHex("#2E4A21"),
//                 ),
//               ),
//             ),
//             pw.Padding(
//               padding: pw.EdgeInsets.all(8),
//               child: pw.Text(
//                 "Your Score",
//                 style: pw.TextStyle(
//                   fontWeight: pw.FontWeight.bold,
//                   color: PdfColor.fromHex("#2E4A21"),
//                 ),
//               ),
//             ),
//             pw.Padding(
//               padding: pw.EdgeInsets.all(8),
//               child: pw.Text(
//                 "Class Avg",
//                 style: pw.TextStyle(
//                   fontWeight: pw.FontWeight.bold,
//                   color: PdfColor.fromHex("#2E4A21"),
//                 ),
//               ),
//             ),
//             pw.Padding(
//               padding: pw.EdgeInsets.all(8),
//               child: pw.Text(
//                 "Priority",
//                 style: pw.TextStyle(
//                   fontWeight: pw.FontWeight.bold,
//                   color: PdfColor.fromHex("#2E4A21"),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         ...studyData!['data'].map<pw.TableRow>((subject) {
//           return pw.TableRow(
//             children: [
//               pw.Padding(
//                 padding: pw.EdgeInsets.all(8),
//                 child: pw.Text(subject['subject_name']),
//               ),
//               pw.Padding(
//                 padding: pw.EdgeInsets.all(8),
//                 child: pw.Text(
//                   subject['time'],
//                   style: pw.TextStyle(
//                     fontWeight: pw.FontWeight.bold,
//                     color: _getTimeColor(subject['time']),
//                   ),
//                 ),
//               ),
//               pw.Padding(
//                 padding: pw.EdgeInsets.all(8),
//                 child: pw.Text("${subject['student_score']}%"),
//               ),
//               pw.Padding(
//                 padding: pw.EdgeInsets.all(8),
//                 child: pw.Text("${subject['class_average']}%"),
//               ),
//               pw.Padding(
//                 padding: pw.EdgeInsets.all(8),
//                 child: _buildPriorityBadge(subject['priority']),
//               ),
//             ],
//           );
//         }).toList(),
//       ],
//     );
//   }
//
//   PdfColor _getTimeColor(String time) {
//     double hours = double.parse(time.split(' ')[0]);
//     if (hours >= 3) return PdfColor.fromHex("#F44336");
//     if (hours >= 2) return PdfColor.fromHex("#FF9800");
//     return PdfColor.fromHex("#4CAF50");
//   }
//
//   pw.Widget _buildPriorityBadge(String priority) {
//     PdfColor color;
//     switch (priority) {
//       case 'High':
//         color = PdfColor.fromHex("#F44336");
//         break;
//       case 'Medium':
//         color = PdfColor.fromHex("#FF9800");
//         break;
//       default:
//         color = PdfColor.fromHex("#4CAF50");
//     }
//
//     return pw.Container(
//       padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: pw.BoxDecoration(
//         color: color,
//         borderRadius: pw.BorderRadius.circular(20),
//       ),
//       child: pw.Text(
//         priority,
//         style: pw.TextStyle(
//           fontSize: 10,
//           color: PdfColors.white,
//           fontWeight: pw.FontWeight.bold,
//         ),
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _getStudyPlan();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _primaryColor,
//       appBar: AppBar(
//         backgroundColor: _buttonColor,
//         elevation: 0,
//         leading: Container(
//           margin: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 8,
//                 spreadRadius: 1,
//               ),
//             ],
//           ),
//           child: IconButton(
//             icon: Icon(Icons.arrow_back_rounded, color: _darkTextColor),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const HomeApp()),
//               );
//             },
//           ),
//         ),
//         title: Text(
//           "Study Plan & Analysis",
//           style: TextStyle(
//             color: _darkTextColor,
//             fontSize: 22,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           if (!isLoading && studyData != null)
//             Container(
//               margin: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 8,
//                     spreadRadius: 1,
//                   ),
//                 ],
//               ),
//               child: IconButton(
//                 icon: Icon(Icons.print_rounded, color: _darkTextColor),
//                 onPressed: _generateAndSharePDF,
//                 tooltip: "Export as PDF",
//               ),
//             ),
//           Container(
//             margin: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 8,
//                   spreadRadius: 1,
//                 ),
//               ],
//             ),
//             child: IconButton(
//               icon: Icon(Icons.refresh_rounded, color: _darkTextColor),
//               onPressed: _getStudyPlan,
//             ),
//           ),
//         ],
//       ),
//       body: isLoading
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 15,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: CircularProgressIndicator(
//                 strokeWidth: 3,
//                 valueColor: AlwaysStoppedAnimation<Color>(_buttonColor),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               "Analyzing Performance...",
//               style: TextStyle(
//                 color: _darkTextColor,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       )
//           : studyData == null
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 20,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: Icon(
//                 Icons.error_outline_rounded,
//                 size: 60,
//                 color: _lightTextColor,
//               ),
//             ),
//             SizedBox(height: 24),
//             Text(
//               "No Data Available",
//               style: TextStyle(
//                 color: _darkTextColor,
//                 fontSize: 24,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             SizedBox(height: 12),
//             Text(
//               "Unable to generate study plan",
//               style: TextStyle(
//                 color: _lightTextColor,
//                 fontSize: 16,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 32),
//             Container(
//               width: 200,
//               height: 50,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: _buttonColor.withOpacity(0.3),
//                     blurRadius: 10,
//                     offset: Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: ElevatedButton(
//                 onPressed: _getStudyPlan,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _buttonColor,
//                   foregroundColor: _darkTextColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.refresh_rounded, size: 20),
//                     SizedBox(width: 8),
//                     Text(
//                       "Try Again",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       )
//           : SingleChildScrollView(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Student Info Card
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: _cardColor,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.08),
//                     blurRadius: 15,
//                     offset: Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           color: _accentColor,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           Icons.person_rounded,
//                           size: 32,
//                           color: _darkTextColor,
//                         ),
//                       ),
//                       SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               studyData!['student_info']['name'],
//                               style: TextStyle(
//                                 color: _darkTextColor,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             Text(
//                               "${studyData!['student_info']['course']} • Semester ${studyData!['student_info']['semester']}",
//                               style: TextStyle(
//                                 color: _lightTextColor,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(height: 24),
//
//             // Performance Summary Card
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [_secondaryColor, _accentColor],
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.08),
//                     blurRadius: 15,
//                     offset: Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: _getStatusColor(studyData!['analysis']['overall_status']),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Icon(
//                           Icons.analytics_rounded,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                       ),
//                       SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Performance Status",
//                               style: TextStyle(
//                                 color: _darkTextColor,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Text(
//                               studyData!['analysis']['overall_status'],
//                               style: TextStyle(
//                                 color: _darkTextColor,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     studyData!['analysis']['description'],
//                     style: TextStyle(
//                       color: _lightTextColor,
//                       fontSize: 15,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     children: [
//                       _buildStatCircle(
//                         "Your Score",
//                         "${studyData!['analysis']['overall_score']}%",
//                         _successColor,
//                       ),
//                       SizedBox(width: 16),
//                       _buildStatCircle(
//                         "Class Average",
//                         "${studyData!['analysis']['class_average']}%",
//                         Color(0xFF2196F3),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(height: 24),
//
//             // Study Plan Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Weekly Study Plan",
//                   style: TextStyle(
//                     color: _darkTextColor,
//                     fontSize: 22,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: _accentColor,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     "${studyData!['data'].length} Subjects",
//                     style: TextStyle(
//                       color: _darkTextColor,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),
//             Text(
//               "Recommended study time based on your performance",
//               style: TextStyle(
//                 color: _lightTextColor,
//                 fontSize: 14,
//               ),
//             ),
//
//             SizedBox(height: 20),
//
//             // Study Plan List
//             ...studyData!['data'].asMap().entries.map((entry) {
//               final index = entry.key;
//               final subject = entry.value;
//               return Container(
//                 margin: EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                   color: _cardColor,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     // Subject Header
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: _getPriorityColor(subject['priority']),
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(16),
//                           topRight: Radius.circular(16),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Center(
//                               child: Text(
//                                 "${index + 1}",
//                                 style: TextStyle(
//                                   color: _darkTextColor,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w800,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 12),
//                           Expanded(
//                             child: Text(
//                               subject['subject_name'],
//                               style: TextStyle(
//                                 color: _darkTextColor,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               subject['priority'],
//                               style: TextStyle(
//                                 color: _getPriorityTextColor(subject['priority']),
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     // Subject Details
//                     Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               _buildDetailCard(
//                                 Icons.access_time_rounded,
//                                 "Study Time",
//                                 subject['time'],
//                                 _buttonColor,
//                               ),
//                               _buildDetailCard(
//                                 Icons.score_rounded,
//                                 "Your Score",
//                                 "${subject['student_score']}%",
//                                 _successColor,
//                               ),
//                               _buildDetailCard(
//                                 Icons.group_rounded,
//                                 "Class Average",
//                                 "${subject['class_average']}%",
//                                 Color(0xFF2196F3),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 12),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.compare_arrows_rounded, color: _lightTextColor, size: 16),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Performance Gap: ${subject['performance_gap']}%",
//                                 style: TextStyle(
//                                   color: subject['performance_gap'] > 0 ? _dangerColor : _successColor,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//
//             SizedBox(height: 24),
//
//             // Analysis Section
//             Text(
//               "Performance Analysis",
//               style: TextStyle(
//                 color: _darkTextColor,
//                 fontSize: 22,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//             SizedBox(height: 16),
//
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Strengths
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: _secondaryColor,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(Icons.thumb_up_rounded, color: _successColor, size: 20),
//                             SizedBox(width: 8),
//                             Text(
//                               "Strengths",
//                               style: TextStyle(
//                                 color: _darkTextColor,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//                         ...studyData!['analysis']['strengths'].map((strength) {
//                           return Padding(
//                             padding: EdgeInsets.only(bottom: 8),
//                             child: Row(
//                               children: [
//                                 Icon(Icons.check_circle_rounded, color: _successColor, size: 16),
//                                 SizedBox(width: 8),
//                                 Expanded(
//                                   child: Text(
//                                     "${strength['subject']}",
//                                     style: TextStyle(
//                                       color: _darkTextColor,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                                 Text(
//                                   "+${strength['advantage']}%",
//                                   style: TextStyle(
//                                     color: _successColor,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(width: 16),
//
//                 // Weaknesses
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Color(0xFFFFEBEE),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(Icons.warning_rounded, color: _dangerColor, size: 20),
//                             SizedBox(width: 8),
//                             Text(
//                               "Areas to Improve",
//                               style: TextStyle(
//                                 color: _darkTextColor,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//                         ...studyData!['analysis']['weaknesses'].map((weakness) {
//                           return Padding(
//                             padding: EdgeInsets.only(bottom: 8),
//                             child: Row(
//                               children: [
//                                 Icon(Icons.warning_amber_rounded, color: _dangerColor, size: 16),
//                                 SizedBox(width: 8),
//                                 Expanded(
//                                   child: Text(
//                                     "${weakness['subject']}",
//                                     style: TextStyle(
//                                       color: _darkTextColor,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                                 Text(
//                                   "-${weakness['disadvantage']}%",
//                                   style: TextStyle(
//                                     color: _dangerColor,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 24),
//
//             // Recommendations Card
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Color(0xFFFFF3E0),
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.lightbulb_rounded, color: Color(0xFFE65100), size: 24),
//                       SizedBox(width: 12),
//                       Text(
//                         "Recommendations",
//                         style: TextStyle(
//                           color: _darkTextColor,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//                   ...studyData!['analysis']['recommendations'].map((recommendation) {
//                     return Padding(
//                       padding: EdgeInsets.only(bottom: 12),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Icon(Icons.arrow_right_rounded, color: Color(0xFFE65100), size: 20),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               recommendation,
//                               style: TextStyle(
//                                 color: Color(0xFF5D4037),
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ],
//               ),
//             ),
//
//             SizedBox(height: 32),
//
//             // PDF Export Button
//             Center(
//               child: Container(
//                 width: 250,
//                 height: 56,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: _buttonColor.withOpacity(0.3),
//                       blurRadius: 15,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: ElevatedButton.icon(
//                   onPressed: _generateAndSharePDF,
//                   icon: Icon(Icons.picture_as_pdf_rounded, size: 24),
//                   label: Text(
//                     "Export as PDF",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _buttonColor,
//                     foregroundColor: _darkTextColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     elevation: 0,
//                   ),
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 32),
//             Center(
//               child: Text(
//                 "EDU AI Platform • Study Plan Generated on ${DateFormat('dd MMM yyyy').format(DateTime.now())}",
//                 style: TextStyle(
//                   color: _lightTextColor,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatCircle(String title, String value, Color color) {
//     return Column(
//       children: [
//         Container(
//           width: 70,
//           height: 70,
//           decoration: BoxDecoration(
//             color: color,
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: color.withOpacity(0.3),
//                 blurRadius: 10,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: Center(
//             child: Text(
//               value,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//           ),
//         ),
//         SizedBox(height: 8),
//         Text(
//           title,
//           style: TextStyle(
//             color: _lightTextColor,
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDetailCard(IconData icon, String title, String value, Color color) {
//     return Expanded(
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 4),
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: color.withOpacity(0.2), width: 1),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 20),
//             SizedBox(height: 6),
//             Text(
//               title,
//               style: TextStyle(
//                 color: _lightTextColor,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(height: 4),
//             Text(
//               value,
//               style: TextStyle(
//                 color: _darkTextColor,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     if (status.contains("Excellent")) return _successColor;
//     if (status.contains("Above")) return Color(0xFF4CAF50);
//     if (status.contains("Average")) return _warningColor;
//     return _dangerColor;
//   }
//
//   Color _getPriorityColor(String priority) {
//     switch (priority) {
//       case 'High':
//         return Color(0xFFFFEBEE);
//       case 'Medium':
//         return Color(0xFFFFF3E0);
//       default:
//         return Color(0xFFE8F5E9);
//     }
//   }
//
//   Color _getPriorityTextColor(String priority) {
//     switch (priority) {
//       case 'High':
//         return _dangerColor;
//       case 'Medium':
//         return Color(0xFFE65100);
//       default:
//         return _successColor;
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'chat.dart';
import 'homepage.dart';
import 'view_internal_mark.dart';
import 'view_unit.dart';


class view_study_plan extends StatelessWidget {
  const view_study_plan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: view_study_plansub(),
    );
  }
}

class view_study_plansub extends StatefulWidget {
  const view_study_plansub({Key? key}) : super(key: key);

  @override
  State<view_study_plansub> createState() => _State();
}

class _State extends State<view_study_plansub> {
  // Updated color palette from your design system (navy/steel blue theme)
  final Color _primaryColor = Color(0xFF27374D);      // Deep navy blue
  final Color _secondaryColor = Color(0xFF526D82);    // Muted steel blue
  final Color _accentColor = Color(0xFF9DB2BF);       // Soft periwinkle gray
  final Color _lightBgColor = Color(0xFFDDE6ED);      // Light icy blue background
  final Color _darkTextColor = Color(0xFF27374D);     // Deep navy for text
  final Color _lightTextColor = Color(0xFF526D82);    // Steel blue for secondary text
  final Color _buttonColor = Color(0xFF526D82);       // Steel blue for buttons
  final Color _cardColor = Color(0xFFFFFFFF);         // Pure white for cards
  final Color _whiteColor = Color(0xFFFFFFFF);        // Pure white
  final Color _successColor = Color(0xFF2E7D32);      // Dark green for success
  final Color _warningColor = Color(0xFFED6A02);      // Orange for warning
  final Color _dangerColor = Color(0xFFD32F2F);       // Error red
  final Color _infoColor = Color(0xFF0288D1);         // Info blue

  Map<String, dynamic>? studyData;
  bool isLoading = true;

  Future<void> _getStudyPlan() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ip = prefs.getString("url");
    if (ip == null) {
      print("IP not found");
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      var response = await http.post(
        Uri.parse("$ip/student_get_study_plan"),
        body: {"sid": prefs.getString("sid")},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData["status"] == "success") {
          setState(() {
            studyData = jsonData;
            isLoading = false;
          });
        } else {
          print("API Error: ${jsonData['message']}");
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getStudyPlan();
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
          "Study Plan & Analysis",
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
              onPressed: _getStudyPlan,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
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
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(_whiteColor),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                "Analyzing Performance...",
                style: TextStyle(
                  color: _whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Generating your personalized study plan",
              style: TextStyle(
                color: _secondaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      )
          : studyData == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
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
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 60,
                color: _whiteColor,
              ),
            ),
            SizedBox(height: 30),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                "No Data Available",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: _whiteColor,
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Unable to generate study plan",
              style: TextStyle(
                color: _secondaryColor,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Container(
              width: 200,
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
                onPressed: _getStudyPlan,
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
      )
          : SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Icon and Title
            Center(
              child: Column(
                children: [
                  Container(
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
                      Icons.analytics_rounded,
                      size: 50,
                      color: _whiteColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [_primaryColor, _secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      "Your Study Plan",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: _whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Student Info Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _whiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.1),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_secondaryColor, _primaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      size: 30,
                      color: _whiteColor,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studyData!['student_info']['name'],
                          style: TextStyle(
                            color: _primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${studyData!['student_info']['course']} • Semester ${studyData!['student_info']['semester']}",
                          style: TextStyle(
                            color: _secondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Performance Summary Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_secondaryColor, _primaryColor],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.2),
                    blurRadius: 15,
                    offset: Offset(0, 8),
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
                          color: _whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.analytics_rounded,
                          color: _primaryColor,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Performance Summary",
                        style: TextStyle(
                          color: _whiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    studyData!['analysis']['description'],
                    style: TextStyle(
                      color: _whiteColor.withOpacity(0.9),
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCircle(
                        "Your Score",
                        "${studyData!['analysis']['overall_score']}%",
                        _getStatusColor(studyData!['analysis']['overall_status']),
                      ),
                      _buildStatCircle(
                        "Class Average",
                        "${studyData!['analysis']['class_average']}%",
                        _infoColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Study Plan Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Weekly Study Plan",
                  style: TextStyle(
                    color: _primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_secondaryColor, _primaryColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    "${studyData!['data'].length} Subjects",
                    style: TextStyle(
                      color: _whiteColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "Recommended study time based on your performance",
              style: TextStyle(
                color: _secondaryColor,
                fontSize: 15,
              ),
            ),

            SizedBox(height: 20),

            // Study Plan List
            ...studyData!['data'].asMap().entries.map((entry) {
              final index = entry.key;
              final subject = entry.value;
              return Container(
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: _whiteColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.08),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Subject Header with Priority Color
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getPriorityColor(subject['priority']).withOpacity(0.15),
                            _getPriorityColor(subject['priority']).withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: _getPriorityColor(subject['priority']).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [_secondaryColor, _primaryColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                  color: _whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              subject['subject_name'],
                              style: TextStyle(
                                color: _primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _getPriorityColor(subject['priority']),
                                  _getPriorityColor(subject['priority']).withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Priority : "+subject['priority'],
                              style: TextStyle(
                                color: _whiteColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Subject Details
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildDetailCard(
                                Icons.access_time_rounded,
                                "Study Time",
                                subject['time'],
                                _primaryColor,
                              ),
                              _buildDetailCard(
                                Icons.score_rounded,
                                "Your Score",
                                "${subject['student_score']}",
                                _getScoreColor(subject['student_score']),
                              ),
                              _buildDetailCard(
                                Icons.group_rounded,
                                "Class Avg",
                                "${subject['class_average']}%",
                                _secondaryColor,
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: _lightBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.compare_arrows_rounded,
                                  color: subject['performance_gap'] > 0 ? _dangerColor : _successColor,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Performance Gap: ${subject['performance_gap']}%",
                                  style: TextStyle(
                                    color: subject['performance_gap'] > 0 ? _dangerColor : _successColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            SizedBox(height: 24),

            // Analysis Section
            Text(
              "Performance Analysis",
              style: TextStyle(
                color: _primaryColor,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Strengths
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _whiteColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _successColor.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
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
                                color: _successColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.thumb_up_rounded,
                                color: _successColor,
                                size: 16,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Strengths",
                              style: TextStyle(
                                color: _primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        ...studyData!['analysis']['strengths'].map((strength) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: _successColor,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    strength['subject'],
                                    style: TextStyle(
                                      color: _secondaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _successColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "+${strength['advantage']}%",
                                    style: TextStyle(
                                      color: _successColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        if (studyData!['analysis']['strengths'].isEmpty)
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "No specific strengths identified",
                              style: TextStyle(
                                color: _secondaryColor,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 12),

                // Weaknesses
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _whiteColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _dangerColor.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
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
                                color: _dangerColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.warning_rounded,
                                color: _dangerColor,
                                size: 16,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Areas to Improve",
                              style: TextStyle(
                                color: _primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        ...studyData!['analysis']['weaknesses'].map((weakness) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: _dangerColor,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    weakness['subject'],
                                    style: TextStyle(
                                      color: _secondaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _dangerColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "-${weakness['disadvantage']}%",
                                    style: TextStyle(
                                      color: _dangerColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        if (studyData!['analysis']['weaknesses'].isEmpty)
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "No specific areas identified",
                              style: TextStyle(
                                color: _secondaryColor,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Recommendations Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_warningColor.withOpacity(0.1), _warningColor.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _warningColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _warningColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.lightbulb_rounded,
                          color: _warningColor,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Recommendations",
                        style: TextStyle(
                          color: _primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ...studyData!['analysis']['recommendations'].map((recommendation) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.arrow_right_rounded,
                            color: _warningColor,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              recommendation,
                              style: TextStyle(
                                color: _secondaryColor,
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  if (studyData!['analysis']['recommendations'].isEmpty)
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "No specific recommendations at this time",
                        style: TextStyle(
                          color: _secondaryColor,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 32),

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
                    "EDU AI Platform • Study Plan",
                    style: TextStyle(
                      color: _secondaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Generated on ${DateFormat('dd MMM yyyy').format(DateTime.now())}",
                    style: TextStyle(
                      color: _accentColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCircle(String title, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _whiteColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: _whiteColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailCard(IconData icon, String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                color: _secondaryColor,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: _primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status.contains("Excellent")) return _successColor;
    if (status.contains("Above")) return _successColor;
    if (status.contains("Average")) return _warningColor;
    return _dangerColor;
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return _dangerColor;
      case 'Medium':
        return _warningColor;
      default:
        return _successColor;
    }
  }

  Color _getScoreColor(int studentScore) {
    // For internal marks out of 20
    if (studentScore >= 17) return _successColor;      // 17-20: Excellent (85-100%)
    if (studentScore >= 14) return _infoColor;          // 14-16: Good (70-84%)
    if (studentScore >= 10) return _warningColor;       // 10-13: Average (50-69%)
    return _dangerColor;                                 // Below 10: Needs Improvement (<50%)
  }
}

