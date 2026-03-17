// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:math' as math;
//
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// void main() {
//   runApp(Text_Summarizer());
// }
//
// class Text_Summarizer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Document Analyzer',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: DocumentUploadPage(),
//     );
//   }
// }
//
// class DocumentUploadPage extends StatefulWidget {
//   @override
//   _DocumentUploadPageState createState() => _DocumentUploadPageState();
// }
//
// class _DocumentUploadPageState extends State<DocumentUploadPage> {
//   PlatformFile? _selectedFile;
//   bool _isUploading = false;
//   String? _summary;
//   String? _error;
//   double _progress = 0.0;
//   Uint8List? _fileBytes;
//
//   Future<void> _pickDocument() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['doc', 'docx'],
//         allowMultiple: false,
//         withData: true, // This is crucial for web - gets file bytes
//       );
//
//       if (result != null && result.files.isNotEmpty) {
//         PlatformFile file = result.files.first;
//
//         setState(() {
//           _selectedFile = file;
//           _fileBytes = file.bytes; // Store bytes for web upload
//           _summary = null;
//           _error = null;
//         });
//
//         print('Selected file: ${file.name}, size: ${file.size} bytes');
//       }
//     } catch (e) {
//       setState(() {
//         _error = 'Error picking file: $e';
//       });
//       print('Error details: $e');
//     }
//   }
//
//   Future<void> _uploadDocument() async {
//     if (_selectedFile == null) {
//       setState(() {
//         _error = 'Please select a document first';
//       });
//       return;
//     }
//
//     setState(() {
//       _isUploading = true;
//       _progress = 0.0;
//       _summary = null;
//       _error = null;
//     });
//
//     // Simulate progress animation during upload
//     _simulateProgress();
//
//     try {
//       // Configure URL based on platform
//       String baseUrl;
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       if (kIsWeb) {
//         baseUrl = prefs.getString("url").toString(); // For web (adjust if needed)
//       } else {
//         baseUrl = prefs.getString("url").toString(); // For Android emulator
//         // For iOS simulator: 'http://localhost:8000'
//         // For physical device: 'http://YOUR_COMPUTER_IP:8000'
//       }
//
//       var uri = Uri.parse('$baseUrl/upload_and_analyze_with_gemini');
//
//       var request = http.MultipartRequest('POST', uri);
//
//       // Handle file upload differently for web vs mobile
//       if (kIsWeb) {
//         // Web platform - use bytes
//         if (_fileBytes != null) {
//           request.files.add(
//             http.MultipartFile.fromBytes(
//               'document',
//               _fileBytes!,
//               filename: _selectedFile!.name,
//             ),
//           );
//         } else {
//           throw Exception('File bytes are not available for web upload');
//         }
//       } else {
//         // Mobile/Desktop platform - use file path
//         if (_selectedFile!.path != null) {
//           request.files.add(
//             await http.MultipartFile.fromPath(
//               'document',
//               _selectedFile!.path!,
//               filename: _selectedFile!.name,
//             ),
//           );
//         } else {
//           throw Exception('File path is not available');
//         }
//       }
//
//       // Add additional parameters if needed
//       request.fields['analyze_type'] = 'summary';
//
//       // Send request and get response
//       var response = await http.Response.fromStream(await request.send());
//
//       // Complete progress
//       setState(() {
//         _progress = 1.0;
//       });
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           _summary = data['summary'];
//           _isUploading = false;
//         });
//
//         _showResultDialog(data);
//       } else {
//         String errorBody = response.body;
//         if (errorBody.length > 100) {
//           errorBody = errorBody.substring(0, 100) + '...';
//         }
//
//         setState(() {
//           _error = 'Server Error ${response.statusCode}\n$errorBody';
//           _isUploading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _error = 'Upload failed: ${e.toString()}';
//         _isUploading = false;
//       });
//       print('Upload error: $e');
//     }
//   }
//
//   void _simulateProgress() {
//     // Animate progress bar during upload
//     const totalSteps = 20;
//     for (int i = 1; i <= totalSteps; i++) {
//       Future.delayed(Duration(milliseconds: i * 100), () {
//         if (mounted && _isUploading) {
//           setState(() {
//             // Animate from 0.1 to 0.9 during upload
//             _progress = (i / totalSteps) * 0.8 + 0.1;
//           });
//         }
//       });
//     }
//   }
//
//   void _showResultDialog(Map<String, dynamic> data) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Analysis Results'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Summary:',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 data['summary'] ?? 'No summary available',
//                 style: TextStyle(height: 1.5),
//               ),
//               SizedBox(height: 16),
//               if (data.containsKey('key_phrases') && data['key_phrases'] is List)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Key Phrases:',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8),
//                     Wrap(
//                       spacing: 4,
//                       runSpacing: 4,
//                       children: (data['key_phrases'] as List)
//                           .take(8)
//                           .where((phrase) => phrase.toString().isNotEmpty)
//                           .map((phrase) => Chip(
//                         label: Text(
//                           phrase.toString(),
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ))
//                           .toList(),
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _formatFileSize(int bytes) {
//     if (bytes <= 0) return "0 B";
//
//     const suffixes = ["B", "KB", "MB", "GB", "TB"];
//     final i = (math.log(bytes) / math.log(1024)).floor();
//
//     return '${(bytes / math.pow(1024, i)).toStringAsFixed(i > 0 ? 1 : 0)} ${suffixes[i]}';
//   }
//
//   double log(double x) {
//     return math.log(x) / math.log(math.e);
//   }
//
//   double pow(double x, int exponent) {
//     return math.pow(x, exponent).toDouble();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Document Analyzer'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Upload Section
//             Card(
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.cloud_upload,
//                       size: 60,
//                       color: Colors.blue,
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       'Upload Word Document',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'Supported formats: .doc, .docx',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     SizedBox(height: 20),
//
//                     // File selection
//                     OutlinedButton.icon(
//                       onPressed: _isUploading ? null : _pickDocument,
//                       icon: Icon(Icons.attach_file),
//                       label: Text('Select Document'),
//                       style: OutlinedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 30,
//                           vertical: 15,
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(height: 10),
//
//                     // Selected file info
//                     if (_selectedFile != null)
//                       Container(
//                         margin: EdgeInsets.only(top: 10),
//                         padding: EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: Colors.blue[50],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.description, color: Colors.blue),
//                             SizedBox(width: 10),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     _selectedFile!.name,
//                                     style: TextStyle(fontWeight: FontWeight.bold),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   SizedBox(height: 4),
//                                   Text(
//                                     _formatFileSize(_selectedFile!.size),
//                                     style: TextStyle(fontSize: 12, color: Colors.grey),
//                                   ),
//                                   if (kIsWeb)
//                                     Text(
//                                       'Web file ready for upload',
//                                       style: TextStyle(fontSize: 10, color: Colors.green),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.close),
//                               onPressed: _isUploading ? null : () {
//                                 setState(() {
//                                   _selectedFile = null;
//                                   _fileBytes = null;
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//
//                     SizedBox(height: 20),
//
//                     // Progress indicator
//                     if (_isUploading)
//                       Column(
//                         children: [
//                           LinearProgressIndicator(
//                             value: _progress,
//                             backgroundColor: Colors.grey[200],
//                             valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             '${(_progress * 100).toStringAsFixed(0)}%',
//                             style: TextStyle(fontSize: 12, color: Colors.blue),
//                           ),
//                           SizedBox(height: 16),
//                         ],
//                       ),
//
//                     // Upload button
//                     ElevatedButton.icon(
//                       onPressed: _isUploading ? null : _uploadDocument,
//                       icon: _isUploading
//                           ? SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       )
//                           : Icon(Icons.send),
//                       label: Text(_isUploading ? 'Processing...' : 'Analyze Document'),
//                       style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 40,
//                           vertical: 15,
//                         ),
//                         minimumSize: Size(double.infinity, 50),
//                       ),
//                     ),
//
//                     SizedBox(height: 8),
//
//                     // Platform indicator
//                     Text(
//                       kIsWeb ? 'Web Mode' : 'Mobile Mode',
//                       style: TextStyle(
//                         fontSize: 10,
//                         color: Colors.grey,
//                         fontStyle: FontStyle.italic,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 20),
//
//             // Results Section
//             if (_summary != null || _error != null)
//               Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Analysis Results',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 16),
//
//                       if (_summary != null)
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Summary:',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.green,
//                               ),
//                             ),
//                             SizedBox(height: 8),
//                             Container(
//                               padding: EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Colors.green[50],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 _summary!,
//                                 style: TextStyle(height: 1.5),
//                               ),
//                             ),
//                           ],
//                         ),
//
//                       if (_error != null)
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(height: _summary != null ? 16 : 0),
//                             Text(
//                               'Error:',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.red,
//                               ),
//                             ),
//                             SizedBox(height: 8),
//                             Container(
//                               padding: EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Colors.red[50],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(_error!),
//                             ),
//                           ],
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//
//             // Spacer
//             if (_summary == null && _error == null) Spacer(),
//
//             // Info text
//             Padding(
//               padding: const EdgeInsets.only(top: 20),
//               child: Column(
//                 children: [
//                   if (kIsWeb)
//                     Text(
//                       'Note: For web uploads, ensure CORS is enabled on the Django server',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.orange,
//                         fontSize: 12,
//                       ),
//                     ),
//                   SizedBox(height: 4),
//                   Text(
//                     'Documents are analyzed using NLP and AI techniques to generate summaries.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(Text_Summarizer());
}

class Text_Summarizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Document Analyzer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DocumentUploadPage(),
    );
  }
}

class DocumentUploadPage extends StatefulWidget {
  @override
  _DocumentUploadPageState createState() => _DocumentUploadPageState();
}

class _DocumentUploadPageState extends State<DocumentUploadPage> {
  PlatformFile? _selectedFile;
  bool _isUploading = false;
  String? _summary;
  String? _error;
  double _progress = 0.0;
  Uint8List? _fileBytes;

  // Consistent color palette from your other screens
  final Color _primaryColor = Color(0xFF27374D);      // Deep navy blue
  final Color _secondaryColor = Color(0xFF526D82);    // Muted steel blue
  final Color _accentColor = Color(0xFF9DB2BF);       // Soft periwinkle gray
  final Color _lightBgColor = Color(0xFFDDE6ED);      // Light icy blue background
  final Color _whiteColor = Color(0xFFFFFFFF);        // Pure white
  final Color _errorColor = Color(0xFFD32F2F);        // Error red
  final Color _successColor = Color(0xFF2E7D32);      // Success green

  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['doc', 'docx'],
        allowMultiple: false,
        withData: true, // This is crucial for web - gets file bytes
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        setState(() {
          _selectedFile = file;
          _fileBytes = file.bytes; // Store bytes for web upload
          _summary = null;
          _error = null;
        });

        print('Selected file: ${file.name}, size: ${file.size} bytes');
      }
    } catch (e) {
      setState(() {
        _error = 'Error picking file: $e';
      });
      print('Error details: $e');
    }
  }

  Future<void> _uploadDocument() async {
    if (_selectedFile == null) {
      setState(() {
        _error = 'Please select a document first';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _progress = 0.0;
      _summary = null;
      _error = null;
    });

    // Simulate progress animation during upload
    _simulateProgress();

    try {
      // Configure URL based on platform
      String baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (kIsWeb) {
        baseUrl = prefs.getString("url").toString(); // For web (adjust if needed)
      } else {
        baseUrl = prefs.getString("url").toString(); // For Android emulator
        // For iOS simulator: 'http://localhost:8000'
        // For physical device: 'http://YOUR_COMPUTER_IP:8000'
      }

      var uri = Uri.parse('$baseUrl/upload_and_analyze_with_gemini');

      var request = http.MultipartRequest('POST', uri);

      // Handle file upload differently for web vs mobile
      if (kIsWeb) {
        // Web platform - use bytes
        if (_fileBytes != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'document',
              _fileBytes!,
              filename: _selectedFile!.name,
            ),
          );
        } else {
          throw Exception('File bytes are not available for web upload');
        }
      } else {
        // Mobile/Desktop platform - use file path
        if (_selectedFile!.path != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'document',
              _selectedFile!.path!,
              filename: _selectedFile!.name,
            ),
          );
        } else {
          throw Exception('File path is not available');
        }
      }

      // Add additional parameters if needed
      request.fields['analyze_type'] = 'summary';

      // Send request and get response
      var response = await http.Response.fromStream(await request.send());

      // Complete progress
      setState(() {
        _progress = 1.0;
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _summary = data['summary'];
          _isUploading = false;
        });

        _showResultDialog(data);
      } else {
        String errorBody = response.body;
        if (errorBody.length > 100) {
          errorBody = errorBody.substring(0, 100) + '...';
        }

        setState(() {
          _error = 'Server Error ${response.statusCode}\n$errorBody';
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Upload failed: ${e.toString()}';
        _isUploading = false;
      });
      print('Upload error: $e');
    }
  }

  void _simulateProgress() {
    // Animate progress bar during upload
    const totalSteps = 20;
    for (int i = 1; i <= totalSteps; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted && _isUploading) {
          setState(() {
            // Animate from 0.1 to 0.9 during upload
            _progress = (i / totalSteps) * 0.8 + 0.1;
          });
        }
      });
    }
  }

  void _showResultDialog(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _lightBgColor,
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
              'Analysis Results',
              style: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _lightBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.summarize_rounded,
                          color: _primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Summary',
                          style: TextStyle(
                            color: _primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      data['summary'] ?? 'No summary available',
                      style: TextStyle(
                        color: _secondaryColor,
                        height: 1.5,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              if (data.containsKey('key_phrases') && data['key_phrases'] is List)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _lightBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.key_rounded,
                            color: _primaryColor,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Key Phrases',
                            style: TextStyle(
                              color: _primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (data['key_phrases'] as List)
                            .take(8)
                            .where((phrase) => phrase.toString().isNotEmpty)
                            .map((phrase) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [_secondaryColor, _primaryColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: _primaryColor.withOpacity(0.2),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            phrase.toString(),
                            style: TextStyle(
                              color: _whiteColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: _secondaryColor,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('CLOSE'),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";

    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    final i = (math.log(bytes) / math.log(1024)).floor();

    return '${(bytes / math.pow(1024, i)).toStringAsFixed(i > 0 ? 1 : 0)} ${suffixes[i]}';
  }

  double log(double x) {
    return math.log(x) / math.log(math.e);
  }

  double pow(double x, int exponent) {
    return math.pow(x, exponent).toDouble();
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
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Document Analyzer',
          style: TextStyle(
            color: _whiteColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),

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
                      Icons.analytics_rounded,
                      size: 60,
                      color: _whiteColor,
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Title with gradient
                Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [_primaryColor, _secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      "AI Document Analysis",
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
                    "Upload Word documents for intelligent summarization",
                    style: TextStyle(
                      fontSize: 16,
                      color: _secondaryColor,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 40),

                // Upload Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _whiteColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Upload Icon Area
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: _lightBgColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.cloud_upload_rounded,
                            size: 50,
                            color: _primaryColor,
                          ),
                        ),
                        SizedBox(height: 20),

                        Text(
                          'Upload Word Document',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: _primaryColor,
                          ),
                        ),
                        SizedBox(height: 8),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _accentColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Supported formats: .doc, .docx',
                            style: TextStyle(
                              color: _secondaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // File selection button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _accentColor,
                              width: 2,
                            ),
                          ),
                          child: OutlinedButton.icon(
                            onPressed: _isUploading ? null : _pickDocument,
                            icon: Icon(
                              Icons.attach_file_rounded,
                              color: _secondaryColor,
                            ),
                            label: Text(
                              'Select Document',
                              style: TextStyle(
                                color: _secondaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: _secondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side: BorderSide.none,
                            ),
                          ),
                        ),

                        SizedBox(height: 16),

                        // Selected file info
                        if (_selectedFile != null)
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _lightBgColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _accentColor,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _whiteColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.description_rounded,
                                    color: _primaryColor,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedFile!.name,
                                        style: TextStyle(
                                          color: _primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            _formatFileSize(_selectedFile!.size),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: _secondaryColor,
                                            ),
                                          ),
                                          if (kIsWeb) ...[
                                            SizedBox(width: 8),
                                            Container(
                                              width: 4,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color: _secondaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Web ready',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: _successColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: _secondaryColor,
                                  ),
                                  onPressed: _isUploading ? null : () {
                                    setState(() {
                                      _selectedFile = null;
                                      _fileBytes = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                        SizedBox(height: 24),

                        // Progress indicator
                        if (_isUploading)
                          Column(
                            children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _accentColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: _progress,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [_secondaryColor, _primaryColor],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                '${(_progress * 100).toStringAsFixed(0)}% • Processing...',
                                style: TextStyle(
                                  color: _secondaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),

                        // Upload button
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
                            onPressed: _isUploading ? null : _uploadDocument,
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
                            child: _isUploading
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
                                  "Processing...",
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
                                Icon(Icons.auto_awesome_rounded, size: 22, color: _whiteColor),
                                SizedBox(width: 12),
                                Text(
                                  "Analyze with AI",
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
                  ),
                ),

                SizedBox(height: 24),

                // Results Section
                if (_summary != null || _error != null)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _whiteColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _lightBgColor,
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
                                'Analysis Results',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: _primaryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          if (_summary != null)
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _successColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _successColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.summarize_rounded,
                                        color: _successColor,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Generated Summary',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: _successColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    _summary!,
                                    style: TextStyle(
                                      color: _secondaryColor,
                                      height: 1.6,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          if (_error != null)
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _errorColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _errorColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_rounded,
                                    color: _errorColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _error!,
                                      style: TextStyle(
                                        color: _errorColor,
                                        fontSize: 14,
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

                SizedBox(height: 24),

                // Info Card
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _whiteColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _accentColor,
                      width: 1,
                    ),
                  ),
                  child: Column(
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
                          Expanded(
                            child: Text(
                              kIsWeb
                                  ? 'Web Mode: Ensure CORS is enabled on server'
                                  : 'Documents analyzed using NLP and AI',
                              style: TextStyle(
                                color: _secondaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (kIsWeb) ...[
                        SizedBox(height: 12),
                        Container(
                          height: 1,
                          color: _accentColor.withOpacity(0.3),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orange,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'CORS must be configured on Django server',
                                style: TextStyle(
                                  color: Colors.orange[700],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: 24),

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
                        "EDU AI Platform • Powered by Gemini",
                        style: TextStyle(
                          color: _secondaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

