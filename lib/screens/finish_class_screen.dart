import 'package:flutter/material.dart';
import '../theme.dart';

class FinishClassScreen extends StatefulWidget {
  final String className;
  final Function(String learning, String feedback, bool qrScanned, bool gpsVerified) onSave;

  const FinishClassScreen({
    super.key,
    required this.className,
    required this.onSave,
  });

  @override
  State<FinishClassScreen> createState() => _FinishClassScreenState();
}

class _FinishClassScreenState extends State<FinishClassScreen> {
  final _learningController = TextEditingController();
  final _feedbackController = TextEditingController();
  bool _qrScanned = false;
  bool _gpsVerified = false;

  @override
  void dispose() {
    _learningController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_qrScanned || !_gpsVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please scan QR and get GPS location first.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    widget.onSave(
      _learningController.text,
      _feedbackController.text,
      _qrScanned,
      _gpsVerified,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Verification Buttons
          Row(
            children: [
              Expanded(
                child: _VerifyButton(
                  label: 'SCAN QR',
                  icon: Icons.qr_code_rounded,
                  isActive: _qrScanned,
                  onTap: () => setState(() => _qrScanned = true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _VerifyButton(
                  label: 'GET GPS',
                  icon: Icons.location_on_outlined,
                  isActive: _gpsVerified,
                  onTap: () => setState(() => _gpsVerified = true),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Learning Input
          _SectionLabel(label: 'What did you learn today?'),
          const SizedBox(height: 8),
          TextField(
            controller: _learningController,
            maxLines: 5,
            decoration: _inputDecoration('Key takeaways...'),
          ),

          const SizedBox(height: 20),

          // Feedback Input
          _SectionLabel(label: 'Class Feedback'),
          const SizedBox(height: 8),
          TextField(
            controller: _feedbackController,
            maxLines: 3,
            decoration: _inputDecoration('Optional feedback...'),
          ),

          const SizedBox(height: 28),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.emerald,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              icon: const Icon(Icons.save_rounded),
              label: const Text(
                'Save & Finish Class',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppTheme.zinc400),
        filled: true,
        fillColor: AppTheme.white,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.zinc200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.zinc200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.emerald, width: 2),
        ),
      );
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppTheme.zinc400,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _VerifyButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _VerifyButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.emeraldLight : AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? const Color(0xFF6EE7B7) : AppTheme.zinc200,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 24, color: isActive ? AppTheme.emerald : AppTheme.zinc400),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isActive ? AppTheme.emerald : AppTheme.zinc400,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
