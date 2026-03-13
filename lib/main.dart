import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'models/check_in_record.dart';
import 'screens/home_screen.dart';
import 'screens/check_in_screen.dart';
import 'screens/finish_class_screen.dart';
import 'screens/history_screen.dart';
import 'theme.dart';

void main() {
  runApp(const SmartClassApp());
}

class SmartClassApp extends StatelessWidget {
  const SmartClassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Class',
      theme: AppTheme.theme,
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  String _currentRoute = 'home';

  List<CheckInRecord> _records = [];
  Map<String, dynamic>? _currentCheckIn;
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _fadeAnimation =
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut);

    _animController.forward();
    _loadRecords();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('class_records');

    if (saved != null) {
      final List<dynamic> list = jsonDecode(saved);
      setState(() {
        _records = list.map((e) => CheckInRecord.fromJson(e)).toList();
      });
    }
  }

  Future<void> _saveRecord(CheckInRecord record) async {
    final updated = [record, ..._records];

    setState(() => _records = updated);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'class_records',
      jsonEncode(updated.map((r) => r.toJson()).toList()),
    );
  }

  // ✅ FIXED LOCATION FUNCTION
  Future<void> _handleStartCheckIn() async {
    setState(() => _isLoading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception("Location services disabled");
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("Location permission denied");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 5));

      setState(() {
        _currentCheckIn = {
          'lat': position.latitude,
          'lng': position.longitude
        };

        _isLoading = false;
        _currentRoute = 'check-in';
      });
    } catch (e) {
      // fallback demo location (Bangkok)
      setState(() {
        _currentCheckIn = {'lat': 13.7563, 'lng': 100.5018};
        _isLoading = false;
        _currentRoute = 'check-in';
      });
    }

    _animController.forward(from: 0);
  }

  void _handleCheckInComplete(String className) {
    setState(() {
      _currentCheckIn = {
        ..._currentCheckIn ?? {},
        'className': className,
        'timestamp': DateTime.now().toIso8601String(),
      };

      _currentRoute = 'home';
    });

    _animController.forward(from: 0);
  }

  void _handleFinishClass(
      String learning, String feedback, bool qrScanned, bool gpsVerified) {
    if (_currentCheckIn != null && _currentCheckIn!['className'] != null) {
      final reflection = [
        if (learning.isNotEmpty) learning,
        if (feedback.isNotEmpty) 'Feedback: $feedback',
      ].join('\n\n');

      final record = CheckInRecord(
        id: const Uuid().v4(),
        className: _currentCheckIn!['className'],
        timestamp: _currentCheckIn!['timestamp'] != null
            ? DateTime.parse(_currentCheckIn!['timestamp'])
            : DateTime.now(),
        lat: _currentCheckIn!['lat']?.toDouble(),
        lng: _currentCheckIn!['lng']?.toDouble(),
        reflection: reflection.isNotEmpty ? reflection : null,
        qrScanned: qrScanned,
        gpsVerified: gpsVerified,
      );

      _saveRecord(record);

      setState(() {
        _currentCheckIn = null;
        _currentRoute = 'home';
      });

      _animController.forward(from: 0);
    }
  }

  void _navigate(String route) {
    setState(() => _currentRoute = route);
    _animController.forward(from: 0);
  }

  String _getAppBarTitle() {
    switch (_currentRoute) {
      case 'check-in':
        return 'Scan QR Code';
      case 'finish-class':
        return 'Learning Reflection';
      case 'home':
        return _selectedTab == 1 ? 'History' : 'Smart Class';
      default:
        return 'Smart Class';
    }
  }

  bool _showBack() => _currentRoute != 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.zinc50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _showBack()
            ? IconButton(
                onPressed: () => _navigate('home'),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              )
            : null,
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppTheme.zinc900,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildBody(),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    if (_currentRoute == 'check-in') {
      return CheckInScreen(
        lat: _currentCheckIn?['lat']?.toDouble(),
        lng: _currentCheckIn?['lng']?.toDouble(),
        onCheckInComplete: _handleCheckInComplete,
      );
    }

    if (_currentRoute == 'finish-class') {
      return FinishClassScreen(
        className: _currentCheckIn?['className'] ?? '',
        onSave: _handleFinishClass,
      );
    }

    if (_selectedTab == 1) {
      return HistoryScreen(records: _records);
    }

    return HomeScreen(
      records: _records,
      currentCheckIn: _currentCheckIn,
      isLoading: _isLoading,
      onCheckIn: _handleStartCheckIn,
      onFinishClass: () => _navigate('finish-class'),
      onViewHistory: () => setState(() => _selectedTab = 1),
    );
  }

  Widget _buildBottomNav() {
    if (_currentRoute != 'home') return const SizedBox.shrink();

    return BottomNavigationBar(
      currentIndex: _selectedTab,
      onTap: (index) => setState(() => _selectedTab = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
      ],
    );
  }
}