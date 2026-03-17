import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'view_unit.dart';

void main() {
  runApp(const ExamPage());
}

class ExamPage extends StatelessWidget {
  const ExamPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExamSubPage(),
    );
  }
}

class ExamSubPage extends StatefulWidget {
  const ExamSubPage({Key? key}) : super(key: key);

  @override
  State<ExamSubPage> createState() => _ExamSubPageState();
}

class _ExamSubPageState extends State<ExamSubPage> {
  final Color _primaryColor = const Color(0xFF27374D);
  final Color _secondaryColor = const Color(0xFF526D82);
  final Color _accentColor = const Color(0xFF9DB2BF);
  final Color _lightBgColor = const Color(0xFFDDE6ED);
  final Color _whiteColor = const Color(0xFFFFFFFF);
  final Color _successColor = const Color(0xFF4CAF50);
  final Color _errorColor = const Color(0xFFE57373);

  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _totalQuestions = 0;
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _examCompleted = false;

  final TextEditingController _answerController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Statistics
  int _answeredCount = 0;
  Map<int, String> _userAnswers = {};
  Map<int, bool> _submittedQuestions = {};

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  @override
  void dispose() {
    _answerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchQuestions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? ip = prefs.getString("url");
      String? unitId = prefs.getString("unitid");

      if (ip == null || unitId == null) {
        _showSnackBar('Configuration error. Please login again.', isError: true);
        return;
      }

      var response = await http.post(
        Uri.parse("$ip/stud_view_qa"),
        body: {"unitid": unitId},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<Question> questions = [];

        for (var item in jsonData["data"]) {
          questions.add(Question(
            id: item["id"].toString(),
            question: item["question"].toString(),
          ));
        }

        setState(() {
          _questions = questions;
          _totalQuestions = questions.length;
          _currentQuestionIndex = 0;
          _isLoading = false;
          _answeredCount = 0;
          _userAnswers.clear();
          _submittedQuestions.clear();
          _examCompleted = false;
        });

        if (questions.isEmpty) {
          _showSnackBar('No questions available for this unit');
        }
      } else {
        _showSnackBar('Failed to load questions', isError: true);
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching questions: $e");
      _showSnackBar('Network error. Please check your connection.', isError: true);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitAnswer() async {
    String answer = _answerController.text.trim();

    if (answer.isEmpty) {
      _showSnackBar('Please enter an answer before submitting', isError: true);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? ip = prefs.getString("url").toString();
      String? studentId = prefs.getString("sid").toString();

      // if (ip == null) {
      //   _showSnackBar('Session error. Please login again.', isError: true);
      //   return;
      // }

      Question currentQuestion = _questions[_currentQuestionIndex];

      var response = await http.post(
        Uri.parse("$ip/submit_answer"),
        body: {
          "question_id": currentQuestion.id,
          "student_id": studentId,
          "answer": answer,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse["status"] == "ok") {
          setState(() {
            _userAnswers[_currentQuestionIndex] = answer;
            _submittedQuestions[_currentQuestionIndex] = true;
            _answeredCount = _submittedQuestions.length;
          });

          _showSnackBar('Answer submitted successfully!', isSuccess: true);
          _answerController.clear();

          // Auto-advance to next question after successful submission
          if (_currentQuestionIndex < _totalQuestions - 1) {
            Future.delayed(const Duration(milliseconds: 500), () {
              _goToNextQuestion();
            });
          } else {
            // Check if all questions are answered
            _checkExamCompletion();
          }
        } else {
          _showSnackBar(jsonResponse["message"] ?? 'Submission failed', isError: true);
        }
      } else {
        _showSnackBar('Server error. Please try again.', isError: true);
      }
    } catch (e) {
      print("Error submitting answer: $e");
      _showSnackBar('Network error. Please try again.', isError: true);
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _goToNextQuestion() {
    if (_currentQuestionIndex < _totalQuestions - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answerController.clear();
      });

      // Scroll to top when changing questions
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        // Restore previous answer if it exists
        _answerController.text = _userAnswers[_currentQuestionIndex] ?? '';
      });

      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _checkExamCompletion() {
    if (_answeredCount == _totalQuestions && _totalQuestions > 0) {
      setState(() {
        _examCompleted = true;
      });

      _showExamCompletionDialog();
    }
  }

  void _showExamCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _successColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: _successColor,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Exam Completed!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'You have successfully answered all $_totalQuestions questions.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const view_unit()),
                );
              },
              child: Text(
                'Return to Units',
                style: TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _jumpToQuestion(int index) {
    if (index >= 0 && index < _totalQuestions) {
      setState(() {
        _currentQuestionIndex = index;
        _answerController.text = _userAnswers[index] ?? '';
      });
    }
  }

  void _showSnackBar(String message, {bool isError = false, bool isSuccess = false}) {
    Color backgroundColor = isError ? _errorColor : (isSuccess ? _successColor : _secondaryColor);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: isError ? SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {},
        ) : null,
      ),
    );
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
          child: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: _whiteColor),
            onPressed: () {
              if (_answeredCount > 0) {
                _showExitConfirmationDialog();
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const view_unit()),
                );
              }
            },
          ),
        ),
        title: Text(
          "Exam",
          style: TextStyle(
            color: _whiteColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!_isLoading && _totalQuestions > 0)
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _whiteColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.quiz_rounded,
                    color: _primaryColor,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "$_answeredCount/$_totalQuestions",
                    style: TextStyle(
                      color: _primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _totalQuestions == 0
          ? _buildEmptyState()
          : _examCompleted
          ? _buildCompletionState()
          : _buildExamInterface(),
    );
  }

  Widget _buildLoadingState() {
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
          const SizedBox(height: 20),
          Text(
            "Loading exam questions...",
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

  Widget _buildEmptyState() {
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
              Icons.quiz_rounded,
              size: 60,
              color: _whiteColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Questions Available",
            style: TextStyle(
              color: _primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Questions will be added soon",
            style: TextStyle(
              color: _secondaryColor,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
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
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                _fetchQuestions();
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
                  const SizedBox(width: 8),
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

  Widget _buildCompletionState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_successColor, _secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _successColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.check_circle_rounded,
              size: 80,
              color: _whiteColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Exam Completed!",
            style: TextStyle(
              color: _primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "You have answered all $_totalQuestions questions",
            style: TextStyle(
              color: _secondaryColor,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
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
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const view_unit()),
                );
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
                  Icon(Icons.home_rounded, size: 20, color: _whiteColor),
                  const SizedBox(width: 8),
                  Text(
                    "Return to Units",
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

  Widget _buildExamInterface() {
    Question currentQuestion = _questions[_currentQuestionIndex];
    bool isAnswered = _submittedQuestions[_currentQuestionIndex] ?? false;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Progress",
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "$_answeredCount/$_totalQuestions Answered",
                      style: TextStyle(
                        color: _secondaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _answeredCount / _totalQuestions,
                    backgroundColor: _accentColor.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(_successColor),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Question Navigator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Question Navigator",
                  style: TextStyle(
                    color: _primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_totalQuestions, (index) {
                    bool isCurrent = index == _currentQuestionIndex;
                    bool isAnswered = _submittedQuestions[index] ?? false;

                    return GestureDetector(
                      onTap: () => _jumpToQuestion(index),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: isCurrent
                              ? LinearGradient(
                            colors: [_primaryColor, _secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                              : null,
                          color: isCurrent ? null : (isAnswered ? _successColor.withOpacity(0.2) : _accentColor.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isCurrent
                                ? Colors.transparent
                                : (isAnswered ? _successColor : _accentColor),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: isCurrent
                                  ? _whiteColor
                                  : (isAnswered ? _successColor : _secondaryColor),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Question Card
          Container(
            decoration: BoxDecoration(
              color: _whiteColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primaryColor, _secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
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
                        ),
                        child: Center(
                          child: Text(
                            "${_currentQuestionIndex + 1}",
                            style: TextStyle(
                              color: _primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: _whiteColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Question ${_currentQuestionIndex + 1} of $_totalQuestions",
                                style: TextStyle(
                                  color: _primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Answer the question below",
                              style: TextStyle(
                                color: _whiteColor.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isAnswered)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _successColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                ),

                // Question Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Question:",
                        style: TextStyle(
                          color: _secondaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentQuestion.question,
                        style: TextStyle(
                          color: _primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Answer Input Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            color: _secondaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Your Answer:",
                            style: TextStyle(
                              color: _secondaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: _lightBgColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _accentColor,
                            width: 1.5,
                          ),
                        ),
                        child: TextField(
                          controller: _answerController,
                          maxLines: 6,
                          minLines: 3,
                          enabled: !isAnswered && !_isSubmitting,
                          style: TextStyle(
                            color: _primaryColor,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            hintText: isAnswered
                                ? "You have already answered this question"
                                : "Type your answer here...",
                            hintStyle: TextStyle(
                              color: _secondaryColor.withOpacity(0.5),
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                      if (isAnswered) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_rounded,
                                color: _successColor,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "You've already submitted an answer for this question. You can navigate to other questions using the navigator above.",
                                  style: TextStyle(
                                    color: _successColor,
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Navigation and Submit Buttons
          Row(
            children: [
              // Previous Button
              Expanded(
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _secondaryColor,
                      width: 1.5,
                    ),
                  ),
                  child: TextButton(
                    onPressed: _currentQuestionIndex > 0 ? _goToPreviousQuestion : null,
                    style: TextButton.styleFrom(
                      foregroundColor: _currentQuestionIndex > 0 ? _secondaryColor : _secondaryColor.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back_rounded,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Previous",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Submit Button
              Expanded(
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isAnswered
                          ? [_secondaryColor.withOpacity(0.5), _primaryColor.withOpacity(0.5)]
                          : [_secondaryColor, _primaryColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isAnswered
                        ? []
                        : [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: (isAnswered || _isSubmitting) ? null : _submitAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: _whiteColor,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isAnswered ? Icons.check_circle_rounded : Icons.send_rounded,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isAnswered ? "Submitted" : "Submit Answer",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Next Button
          if (_currentQuestionIndex < _totalQuestions - 1)
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_accentColor, _secondaryColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _secondaryColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _goToNextQuestion,
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
                    Text(
                      "Next Question",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _whiteColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                      color: _whiteColor,
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 20),

          // Tips Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.tips_and_updates_rounded,
                      color: _secondaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Exam Tips",
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTipItem("Take your time to read each question carefully"),
                const SizedBox(height: 8),
                _buildTipItem("Write clear and concise answers"),
                const SizedBox(height: 8),
                _buildTipItem("You can review and change answers before final submission"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_rounded,
          color: _secondaryColor,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            tip,
            style: TextStyle(
              color: _secondaryColor,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Exit Exam?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'You have answered $_answeredCount out of $_totalQuestions questions. Your progress will be saved. Do you want to exit?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Continue Exam',
                style: TextStyle(
                  color: _secondaryColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const view_unit()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: _whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }
}

class Question {
  final String id;
  final String question;

  Question({
    required this.id,
    required this.question,
  });
}