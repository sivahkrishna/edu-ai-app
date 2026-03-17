// import 'package:edu_ai_app/text_summarizer.dart';
// import 'package:edu_ai_app/view_profile.dart';
// import 'package:edu_ai_app/view_student_plan.dart';
// import 'package:edu_ai_app/view_subject.dart';
// import 'package:flutter/material.dart';
//
// import 'Login_Page.dart';
// import 'Pass.dart';
//
// void main() {
//   runApp(const HomeApp());
// }
//
// class HomeApp extends StatelessWidget {
//   const HomeApp({super.key});
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Student Dashboard',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         useMaterial3: true,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: const homepage(),
//     );
//   }
// }
//
// class homepage extends StatelessWidget {
//   const homepage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         backgroundColor: Colors.blue[800],
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.account_circle),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => view_profile()),
//               );
//             },
//           ),
//
//         ],
//       ),
//       drawer: _buildDrawer(context),
//       body: Container(
//         color: Colors.grey[50],
//         child: Column(
//           children: [
//             // Welcome Section
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.blue[800],
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Welcome',
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.9),
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   const Text(
//                     'Edu AI',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Cards Grid
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Main Features Section
//                     _buildSectionTitle('Main'),
//                     GridView.count(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 16,
//                       mainAxisSpacing: 16,
//                       children: [
//                         _buildDashboardCard(
//                           context: context,
//                           icon: Icons.person,
//                           title: 'Profile',
//                           description: 'View and edit your profile',
//                           color: Colors.blue,
//                           page: view_profile(),
//                         ),
//                         _buildDashboardCard(
//                           context: context,
//                           icon: Icons.lock,
//                           title: 'Change Password',
//                           description: 'Update your security password',
//                           color: Colors.green,
//                           page: Pass(),
//                         ),
//                         _buildDashboardCard(
//                           context: context,
//                           icon: Icons.book,
//                           title: 'Subject',
//                           description: 'View your subjects',
//                           color: Colors.orange,
//                           page: view_subject(),
//                         ),
//                         _buildDashboardCard(
//                           context: context,
//                           icon: Icons.book,
//                           title: 'Study Analysis',
//                           description: 'Get performance analysis',
//                           color: Colors.orange,
//                           page: view_study_plan(),
//                         ),
//                         _buildDashboardCard(
//                           context: context,
//                           icon: Icons.library_books_sharp,
//                           title: 'Text Summarizer',
//                           description: 'Summarize your study materials',
//                           color: Colors.orange,
//                           page: DocumentUploadPage(),
//                         ),
//
//                         _buildDashboardCard(
//                           context: context,
//                           icon: Icons.logout,
//                           title: 'Logout',
//                           description: 'Logout your session',
//                           color: Colors.purple,
//                           page: Login_Page(),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 30),
//
//                     // Quick Actions Section
//                     // _buildSectionTitle('Quick Actions'),
//                     // GridView.count(
//                     //   shrinkWrap: true,
//                     //   physics: const NeverScrollableScrollPhysics(),
//                     //   crossAxisCount: 2,
//                     //   crossAxisSpacing: 16,
//                     //   mainAxisSpacing: 16,
//                     //   children: [
//                     //     _buildDashboardCard(
//                     //       context: context,
//                     //       icon: Icons.notifications,
//                     //       title: 'Notifications',
//                     //       description: 'Check your notifications',
//                     //       color: Colors.red,
//                     //       page: const NotificationsPage(),
//                     //     ),
//                     //     _buildDashboardCard(
//                     //       context: context,
//                     //       icon: Icons.history,
//                     //       title: 'Activity Log',
//                     //       description: 'View your recent activities',
//                     //       color: Colors.teal,
//                     //       page: const ActivityLogPage(),
//                     //     ),
//                     //     _buildDashboardCard(
//                     //       context: context,
//                     //       icon: Icons.help,
//                     //       title: 'Help Center',
//                     //       description: 'Get help and support',
//                     //       color: Colors.indigo,
//                     //       page: const HelpCenterPage(),
//                     //     ),
//                     //     _buildDashboardCard(
//                     //       context: context,
//                     //       icon: Icons.share,
//                     //       title: 'Share App',
//                     //       description: 'Share with friends',
//                     //       color: Colors.pink,
//                     //       page: const ShareAppPage(),
//                     //     ),
//                     //   ],
//                     // ),
//
//                     const SizedBox(height: 30),
//
//
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDrawer(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           // Drawer Header
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.blue[800],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Colors.white,
//                   child: Icon(
//                     Icons.person,
//                     size: 30,
//                     color: Colors.blue,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   'John Doe',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'john.doe@example.com',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.8),
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Menu Items
//           ListTile(
//             leading: const Icon(Icons.dashboard),
//             title: const Text('Dashboard'),
//             onTap: () {
//               Navigator.pop(context);
//               // Already on dashboard
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text('Profile'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => view_profile()),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.lock),
//             title: const Text('Change Password'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => Pass()),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.subject),
//             title: const Text('Subject'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) =>  view_subject()),
//               );
//             },
//           ),
//
//           const Divider(),
//
//           ListTile(
//             leading: Icon(Icons.logout, color: Colors.red[600]),
//             title: Text(
//               'Log Out',
//               style: TextStyle(color: Colors.red[600]),
//             ),
//             onTap: () {
//               Navigator.pop(context);
//               _showLogoutDialog(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: Colors.black87,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDashboardCard({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required String description,
//     required Color color,
//     required Widget page,
//   }) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => page),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: color,
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 description,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Text(
//                     'Tap to open',
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Colors.grey[500],
//                     ),
//                   ),
//                   const Spacer(),
//                   Icon(
//                     Icons.arrow_forward_ios,
//                     color: color,
//                     size: 12,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Log Out'),
//           content: const Text('Are you sure you want to log out?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => Login_Page()));
//                 // Add logout logic here
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Logged out successfully'),
//                     backgroundColor: Colors.green,
//                   ),
//                 );
//               },
//               child: const Text(
//                 'Log Out',
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'package:edu_ai_app/text_summarizer.dart';
import 'package:edu_ai_app/view_profile.dart';
import 'package:edu_ai_app/view_student_plan.dart';
import 'package:edu_ai_app/view_subject.dart';
import 'package:edu_ai_app/view_unit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import
import 'Login_Page.dart';
import 'Pass.dart';

void main() {
  runApp(const HomeApp());
}

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      debugShowCheckedModeBanner: false,
      home: const homepage(),
    );
  }
}

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  // Color palette matching your design system
  final Color _primaryColor = const Color(0xFF27374D);      // Deep navy blue
  final Color _secondaryColor = const Color(0xFF526D82);    // Muted steel blue
  final Color _accentColor = const Color(0xFF9DB2BF);       // Soft periwinkle gray
  final Color _lightBgColor = const Color(0xFFDDE6ED);      // Light icy blue background
  final Color _whiteColor = const Color(0xFFFFFFFF);        // Pure white
  final Color _successColor = const Color(0xFF2E7D32);      // Dark green for success
  final Color _warningColor = const Color(0xFFED6A02);      // Orange for warning
  final Color _infoColor = const Color(0xFF0288D1);         // Info blue

  // Student data variables - initialize with empty strings
  String _studentName = "";
  String _studentCourse = "";
  String _studentSemester = "";
  String _studentEmail = "";
  bool _isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _studentName = prefs.getString('sname') ?? "Student";
        _studentEmail = prefs.getString('semail') ?? "No email";
        _studentCourse = prefs.getString('scourse') ?? "Course not set";
        _studentSemester = prefs.getString('ssemester') ?? "1";
        _isLoading = false;
      });
      print("Student data loaded: $_studentName, $_studentCourse, Semester $_studentSemester");
    } catch (e) {
      print("Error loading student data: $e");
      setState(() {
        _studentName = "Student";
        _studentCourse = "Course not available";
        _studentSemester = "1";
        _studentEmail = "email@example.com";
        _isLoading = false;
      });
    }
  }

  // Optional: Add a method to refresh data if needed
  Future<void> _refreshStudentData() async {
    await _loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBgColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
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
          child: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu_rounded, color: _whiteColor),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [_whiteColor, _accentColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            "EDU AI",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
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
              icon: Icon(Icons.notifications_rounded, color: _whiteColor),
              onPressed: () {
                // Handle notifications
              },
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      // Show loading indicator while data is being fetched
      body: _isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: _primaryColor,
            ),
            const SizedBox(height: 20),
            Text(
              'Loading your dashboard...',
              style: TextStyle(
                color: _secondaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _refreshStudentData,
        color: _primaryColor,
        child: _buildDashboard(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 0, // Always show first item as selected since we're on dashboard
        onTap: (index) {
          // CHANGED: Navigate to new pages instead of switching within IndexedStack

          // Handle navigation based on index
          switch (index) {
            case 0: // Dashboard - already on dashboard
            // Optional: Show a message or refresh
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Already on Dashboard'),
                  backgroundColor: _infoColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
              break;
            case 1: // Units
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const view_subject()),
              );
              break;
            case 2: // Profile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const view_profile()),
              );
              break;
          }
        },
        backgroundColor: _whiteColor,
        selectedItemColor: _primaryColor,
        unselectedItemColor: _secondaryColor,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.transparent, // Always transparent
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.dashboard_rounded,
                color: _secondaryColor, // Always secondary color
              ),
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.transparent, // Always transparent
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.menu_book_rounded,
                color: _secondaryColor, // Always secondary color
              ),
            ),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.transparent, // Always transparent
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.person_rounded,
                color: _secondaryColor, // Always secondary color
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // Welcome Section with Student Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_secondaryColor, _primaryColor],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _whiteColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.handshake_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: TextStyle(
                              color: _whiteColor.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _studentName, // Now using real data
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _whiteColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _whiteColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.school_rounded,
                              color: _whiteColor.withOpacity(0.9),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _studentCourse, // Now using real data
                                style: TextStyle(
                                  color: _whiteColor.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 20,
                        color: _whiteColor.withOpacity(0.2),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.grade_rounded,
                              color: _whiteColor.withOpacity(0.9),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Semester $_studentSemester', // Now using real data
                              style: TextStyle(
                                color: _whiteColor.withOpacity(0.9),
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
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Stats
                Row(
                  children: [
                    _buildStatCard(
                      icon: Icons.assignment_rounded,
                      label: 'Subjects',
                      value: '6',
                      color: _infoColor,
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      icon: Icons.analytics_rounded,
                      label: 'Avg. Score',
                      value: '78%',
                      color: _successColor,
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      icon: Icons.timer_rounded,
                      label: 'Study Hrs',
                      value: '24',
                      color: _warningColor,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Main Features Section
                Text(
                  'Main Features',
                  style: TextStyle(
                    color: _primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                  children: [
                    _buildDashboardCard(
                      icon: Icons.person_rounded,
                      title: 'Profile',
                      description: 'View and edit your profile',
                      color: _infoColor,
                      page: const view_profile(),
                    ),
                    _buildDashboardCard(
                      icon: Icons.lock_rounded,
                      title: 'Change Password',
                      description: 'Update your security password',
                      color: _successColor,
                      page: Pass(),
                    ),
                    _buildDashboardCard(
                      icon: Icons.menu_book_rounded,
                      title: 'Subjects',
                      description: 'View your enrolled subjects',
                      color: _warningColor,
                      page: const view_subject(),
                    ),
                    _buildDashboardCard(
                      icon: Icons.analytics_rounded,
                      title: 'Study Analysis',
                      description: 'Get performance insights',
                      color: const Color(0xFF9C27B0),
                      page: const view_study_plan(),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Academic Tools Section
                Text(
                  'Academic Tools',
                  style: TextStyle(
                    color: _primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(
                    color: _whiteColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildToolTile(
                        icon: Icons.auto_awesome_rounded,
                        title: 'Text Summarizer',
                        description: 'Summarize your study materials with AI',
                        color: _infoColor,
                        page: DocumentUploadPage(),
                      ),
                      const Divider(height: 1, indent: 72),
                      _buildToolTile(
                        icon: Icons.show_chart_rounded,
                        title: 'Performance Analysis',
                        description: 'Track your academic progress',
                        color: _warningColor,
                        page: const view_study_plan(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),



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
                      const SizedBox(height: 16),
                      Text(
                        'EDU AI Platform • Student Dashboard',
                        style: TextStyle(
                          color: _secondaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Last updated: ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
                        style: TextStyle(
                          color: _accentColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _primaryColor.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: _primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: _secondaryColor,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolTile({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required Widget page,
  }) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        description,
        style: TextStyle(
          color: _secondaryColor,
          fontSize: 12,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _lightBgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_forward_rounded,
          color: _secondaryColor,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildUnitPreviewCard({
    required String code,
    required String name,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                code.substring(0, 2),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: _primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: _accentColor.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progress >= 0.7 ? _successColor :
                            progress >= 0.4 ? _warningColor :
                            _infoColor,
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        color: _secondaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: _whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _primaryColor.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Gradient overlay on hover (optional)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      color.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: _secondaryColor,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Open',
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: color,
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: _whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header with Gradient
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_secondaryColor, _primaryColor],
              ),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _whiteColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _studentName, // Now using real data
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _studentEmail, // Now using real data
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Menu Items with improved styling
          _buildDrawerItem(
            icon: Icons.dashboard_rounded,
            title: 'Dashboard',
            onTap: () {
              Navigator.pop(context);
              // Already on dashboard
            },
          ),
          _buildDrawerItem(
            icon: Icons.person_rounded,
            title: 'Profile',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const view_profile()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.lock_rounded,
            title: 'Change Password',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Pass()),
              );
            },
          ),

          const Divider(height: 32, indent: 20, endIndent: 20),

          _buildDrawerItem(
            icon: Icons.logout_rounded,
            title: 'Log Out',
            color: Colors.red,
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            },
          ),

          const SizedBox(height: 20),

          // Version info
          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: _secondaryColor.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? _secondaryColor).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: color ?? _secondaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? _primaryColor,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: _secondaryColor,
        size: 14,
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: _secondaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login_Page()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Logged out successfully'),
                    backgroundColor: _successColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}

