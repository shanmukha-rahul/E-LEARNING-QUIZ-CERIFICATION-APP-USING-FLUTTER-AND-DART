import 'dart:async';
import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../services/quiz_service.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String courseId;

  const QuizScreen({super.key, required this.courseId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizService _quizService = QuizService();
  late Quiz _quiz;
  int _currentQuestionIndex = 0;
  Map<int, int> _answers = {};
  int _timeRemaining = 0;
  late Timer _timer;
  bool _isSubmitting = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  void _loadQuiz() {
    final quiz = _quizService.getQuizByCourse(widget.courseId);
    if (quiz != null) {
      setState(() {
        _quiz = quiz;
        _timeRemaining = quiz.timeLimit * 60;
        _isLoading = false;
      });
      _startTimer();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        _submitQuiz();
      }
    });
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _answers[_currentQuestionIndex] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _submitQuiz() async {
    if (_isSubmitting) return;
    
    setState(() {
      _isSubmitting = true;
    });
    
    _timer.cancel();
    
    final attempt = _quizService.submitQuiz(
      _quiz,
      _answers,
      (_quiz.timeLimit * 60) - _timeRemaining,
      '1', // User ID
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          attempt: attempt,
          courseId: widget.courseId,
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading Quiz...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_quiz == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Quiz not available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('This course does not have a quiz yet.'),
            ],
          ),
        ),
      );
    }

    final currentQuestion = _quiz.questions[_currentQuestionIndex];
    final totalQuestions = _quiz.questions.length;
    final progress = (_currentQuestionIndex + 1) / totalQuestions;

    return Scaffold(
      appBar: AppBar(
        title: Text(_quiz.title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _timeRemaining < 60 ? Colors.red : Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _formatTime(_timeRemaining),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          
          // Question Counter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1}/$totalQuestions',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${((_currentQuestionIndex + 1) / totalQuestions * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Question
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentQuestion.question,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Options
                  ...currentQuestion.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected = _answers[_currentQuestionIndex] == index;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: isSelected ? Colors.blue[50] : null,
                      child: ListTile(
                        title: Text(option),
                        leading: Radio<int>(
                          value: index,
                          groupValue: _answers[_currentQuestionIndex],
                          onChanged: (value) => _selectAnswer(value!),
                        ),
                        onTap: () => _selectAnswer(index),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousQuestion,
                    child: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ),

          // Submit Button (only on last question)
          if (_currentQuestionIndex == totalQuestions - 1)
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Submit Quiz',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}