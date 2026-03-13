import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/qr_scanner_screen.dart';

class CheckInScreen extends StatefulWidget {
  final double? lat;
  final double? lng;
  final Function(String className) onCheckInComplete;

  const CheckInScreen({
    super.key,
    this.lat,
    this.lng,
    required this.onCheckInComplete,
  });

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _scanAnimation = Tween<double>(begin: 0, end: 1).animate(_scanController);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  /// OPEN QR SCANNER
  Future<void> scanQR() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QRScannerScreen(),
      ),
    );

    if (result != null) {
      widget.onCheckInComplete(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [

          const SizedBox(height: 20),

          /// SCANNER FRAME
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: AppTheme.zinc100,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.emerald,
                  width: 2,
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [

                  const Center(
                    child: Icon(
                      Icons.qr_code_scanner,
                      size: 60,
                      color: Color(0xFFD4D4D8),
                    ),
                  ),

                  /// SCANNING LINE
                  AnimatedBuilder(
                    animation: _scanAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: _scanAnimation.value * 260,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: AppTheme.emerald,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.emerald.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Align QR code within the frame',
            style: TextStyle(
              color: AppTheme.zinc600,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          /// SCAN BUTTON
          ElevatedButton.icon(
            onPressed: scanQR,
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text("Scan QR Code"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.emerald,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// GPS INFO
          if (widget.lat != null && widget.lng != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppTheme.emeraldLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Icon(
                    Icons.location_on,
                    size: 14,
                    color: AppTheme.emerald,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    'GPS Verified: ${widget.lat!.toStringAsFixed(4)}, ${widget.lng!.toStringAsFixed(4)}',
                    style: const TextStyle(
                      color: AppTheme.emerald,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 36),

          /// SIMULATION SECTION
          const Text(
            'SIMULATE SCAN',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.zinc400,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          _ClassButton(
            label: 'Mobile App Development',
            onTap: () =>
                widget.onCheckInComplete('Mobile App Development'),
          ),

          const SizedBox(height: 12),

          _ClassButton(
            label: 'UX/UI Design',
            onTap: () =>
                widget.onCheckInComplete('UX/UI Design'),
          ),
        ],
      ),
    );
  }
}

class _ClassButton extends StatelessWidget {

  final String label;
  final VoidCallback onTap;

  const _ClassButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.zinc900,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}