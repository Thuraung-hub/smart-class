import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/check_in_record.dart';
import '../theme.dart';

class HistoryScreen extends StatelessWidget {
  final List<CheckInRecord> records;

  const HistoryScreen({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Center(
        child: Text(
          'No records yet.',
          style: TextStyle(color: AppTheme.zinc400, fontStyle: FontStyle.italic),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.zinc100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.className,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.zinc900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('MMM d, yyyy – HH:mm').format(record.timestamp),
                          style: const TextStyle(fontSize: 12, color: AppTheme.zinc400),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.emeraldLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.check_circle_outline,
                        color: AppTheme.emerald, size: 18),
                  ),
                ],
              ),
              if (record.reflection != null && record.reflection!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.zinc50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '"${record.reflection}"',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.zinc600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
