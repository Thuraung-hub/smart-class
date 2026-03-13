import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/check_in_record.dart';
import '../theme.dart';

class HomeScreen extends StatelessWidget {
  final List<CheckInRecord> records;
  final Map<String, dynamic>? currentCheckIn;
  final bool isLoading;
  final VoidCallback onCheckIn;
  final VoidCallback onFinishClass;
  final VoidCallback onViewHistory;

  const HomeScreen({
    super.key,
    required this.records,
    required this.currentCheckIn,
    required this.isLoading,
    required this.onCheckIn,
    required this.onFinishClass,
    required this.onViewHistory,
  });

  @override
  Widget build(BuildContext context) {
    final bool isInClass = currentCheckIn?['className'] != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.emerald,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.emerald.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CURRENT STATUS',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isInClass
                      ? 'In Class: ${currentCheckIn!['className']}'
                      : 'Not Checked In',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : (isInClass ? onFinishClass : onCheckIn),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.emerald,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    icon: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.emerald,
                            ),
                          )
                        : Icon(isInClass ? Icons.menu_book_rounded : Icons.qr_code_rounded),
                    label: Text(
                      isLoading
                          ? 'Locating...'
                          : (isInClass ? 'Finish & Reflect' : 'Check-in Now'),
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Recent Reflections Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Reflections',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.zinc900,
                ),
              ),
              TextButton(
                onPressed: onViewHistory,
                child: const Text(
                  'View All',
                  style: TextStyle(color: AppTheme.emerald, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Records List
          if (records.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'No records yet.',
                  style: TextStyle(color: AppTheme.zinc400, fontStyle: FontStyle.italic),
                ),
              ),
            )
          else
            ...records.take(3).map((record) => _RecordCard(record: record)),
        ],
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final CheckInRecord record;
  const _RecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.zinc100),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.zinc100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.check_circle_outline, color: AppTheme.zinc600, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.className,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.zinc900)),
                Text(
                  DateFormat('MMM d, yyyy').format(record.timestamp),
                  style: const TextStyle(fontSize: 12, color: AppTheme.zinc400),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppTheme.zinc200),
        ],
      ),
    );
  }
}
