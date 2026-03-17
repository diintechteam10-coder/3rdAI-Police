import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../models/device/device_alert_model.dart';

class DeviceAlertDetailsScreen extends StatelessWidget {
  final DeviceAlert deviceAlert;

  const DeviceAlertDetailsScreen({
    super.key,
    required this.deviceAlert,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "DEVICE DIAGNOSTICS",
          style: GoogleFonts.orbitron(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [Color(0xFF0F172A), Color(0xFF020617)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 20.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSystemHeader(),
                SizedBox(height: 24.sp),
                _buildAlertStatusCard(),
                SizedBox(height: 24.sp),
                _buildDiagnosticMetrics(),
                SizedBox(height: 24.sp),
                _buildActionPanel(context),
                SizedBox(height: 40.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSystemHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceAlert.subType.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Device ID: #${deviceAlert.id.toUpperCase()}",
                  style: GoogleFonts.shareTechMono(
                    color: Colors.blueAccent.withOpacity(0.8),
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            _severityIndicator(),
          ],
        ),
        SizedBox(height: 12.sp),
        Row(
          children: [
            Icon(Icons.access_time_filled, color: Colors.grey[500], size: 16.sp),
            SizedBox(width: 6.sp),
            Text(
              DateFormat('dd MMM yyyy • hh:mm a').format(deviceAlert.createdAt),
              style: GoogleFonts.poppins(
                color: Colors.grey[500],
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _severityIndicator() {
    final color = _getSeverityColor();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.sp,
            height: 8.sp,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.8), blurRadius: 8, spreadRadius: 1),
              ],
            ),
          ),
          SizedBox(width: 8.sp),
          Text(
            deviceAlert.severity.name.toUpperCase(),
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertStatusCard() {
    return _glassContainer(
      child: Row(
        children: [
          _statusItem("TYPE", deviceAlert.type.name),
          _vDivider(),
          _statusItem("STATUS", "ACTIVE"),
          _vDivider(),
          _statusItem("NODES", "ONLINE"),
        ],
      ),
    );
  }

  Widget _buildDiagnosticMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("SYSTEM HEALTH METRICS"),
        SizedBox(height: 12.sp),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12.sp,
          crossAxisSpacing: 12.sp,
          childAspectRatio: 1.5,
          children: [
            _metricCard("CPU USAGE", "42%", Icons.memory, Colors.green),
            _metricCard("SIGNAL", "92 dBm", Icons.wifi, Colors.blue),
            _metricCard("STORAGE", "88%", Icons.storage, Colors.orange),
            _metricCard("TEMP", "45°C", Icons.thermostat, Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildActionPanel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("CONTROL PANEL"),
        SizedBox(height: 12.sp),
        Row(
          children: [
            Expanded(
              child: _actionButton(
                "ACKNOWLEDGE",
                Icons.check_circle_outline,
                Colors.blueAccent,
                () {},
              ),
            ),
            SizedBox(width: 12.sp),
            Expanded(
              child: _actionButton(
                "RESOLVE",
                Icons.done_all,
                Colors.green,
                () => Navigator.pop(context),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.sp),
        _actionButton(
          "RUN REMOTE DIAGNOSTICS",
          Icons.settings_remote,
          Colors.orangeAccent,
          () {},
          isFullWidth: true,
        ),
      ],
    );
  }

  // --- HELPERS ---

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.orbitron(
        color: Colors.blueAccent.withOpacity(0.7),
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _metricCard(String label, String value, IconData icon, Color color) {
    return _glassContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(height: 8.sp),
          Text(
            value,
            style: GoogleFonts.shareTechMono(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.grey[500],
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusItem(String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.grey[500],
              fontSize: 10.sp,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 4.sp),
          Text(
            value.toUpperCase(),
            style: GoogleFonts.shareTechMono(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool isFullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(vertical: 14.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
          color: color.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18.sp),
            SizedBox(width: 10.sp),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: color,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.all(16.sp),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _vDivider() => Container(width: 1, height: 30.sp, color: Colors.white.withOpacity(0.1));

  Color _getSeverityColor() {
    switch (deviceAlert.severity) {
      case AlertSeverity.critical: return Colors.redAccent;
      case AlertSeverity.high: return Colors.orangeAccent;
      case AlertSeverity.medium: return Colors.yellowAccent;
      case AlertSeverity.low: return Colors.blueAccent;
    }
  }
}
