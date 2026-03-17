import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/device/device_alert_model.dart';
import '../models/citizen/response/alert_details_response.dart';
import 'package:intl/intl.dart';
import '../bloc/details_bloc/alert_details_bloc.dart';
import '../bloc/details_bloc/alert_details_event.dart';
import '../bloc/details_bloc/alert_details_state.dart';
import 'widgets/video_player_screen.dart';
import '../../../../widgets/shimmer_widgets.dart';

class AlertDetailsScreen extends StatefulWidget {
  final String alertId;
  final String? category;

  const AlertDetailsScreen({
    super.key,
    required this.alertId,
    this.category,
  });

  @override
  State<AlertDetailsScreen> createState() => _AlertDetailsScreenState();
}

class _AlertDetailsScreenState extends State<AlertDetailsScreen> {
  final TextEditingController _noteController = TextEditingController();
  String? _selectedStatus;
  String _selectedInvestigationBasis = "Site Inspection Completed";

  @override
  void initState() {
    super.initState();

    /// 🔥 Always fetch citizen alert
    context.read<AlertDetailsBloc>().add(
      FetchAlertDetails(widget.alertId),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      /// 🔥 APP BAR SAME
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,

        /// 🔥 Title only from API
        title: BlocBuilder<AlertDetailsBloc, AlertDetailsState>(
          builder: (context, state) {
            String title = "Case Details";

            if (state is AlertDetailsLoaded) {
              title = state.alert.title ?? "Case Details";
            }

            return Text(
              title.toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            );
          },
        ),
      ),

      /// 🔥 BODY SAME
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.4,
            colors: [Color(0xFF1E3A8A), Color(0xFF0F172A), Color(0xFF020617)],
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<AlertDetailsBloc, AlertDetailsState>(
            listener: (context, state) {
              if (state is AlertStatusUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );

                _noteController.clear();

                Navigator.pop(context, state.newStatus);
              }

              if (state is AlertDetailsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },

            builder: (context, state) {
              if (state is AlertDetailsLoading) {
                return ShimmerWidgets.alertDetailsShimmer();
              }

              if (state is AlertDetailsError &&
                  state is! AlertDetailsLoaded) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message,
                          style: const TextStyle(color: Colors.white)),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AlertDetailsBloc>().add(
                                FetchAlertDetails(widget.alertId),
                              );
                        },
                        child: const Text("Retry"),
                      )
                    ],
                  ),
                );
              }

              if (state is AlertDetailsLoaded ||
                  state is AlertStatusUpdating) {
                final alertDetails = state is AlertDetailsLoaded
                    ? state.alert
                    : (state as AlertStatusUpdating).alert;

                final allowedStatuses = state is AlertDetailsLoaded
                    ? state.allowedStatuses
                    : (state as AlertStatusUpdating).allowedStatuses;

                final basisTypes = state is AlertDetailsLoaded
                    ? state.basisTypes
                    : (state as AlertStatusUpdating).basisTypes;

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<AlertDetailsBloc>().add(
                          FetchAlertDetails(widget.alertId),
                        );
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.sp, vertical: 12.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(
                          alertDetails.title ?? "Case Details",
                          alertDetails,
                        ),

                        SizedBox(height: 20.sp),

                        _buildLocationCard(alertDetails),

                        SizedBox(height: 20.sp),

                        _sectionTitle("CASE DESCRIPTION"),
                        SizedBox(height: 10.sp),

                        _glassCard(
                          child: Text(
                            alertDetails.message ??
                                "No description available",
                            style: GoogleFonts.poppins(
                              color: Colors.grey[300],
                              fontSize: 15.sp,
                            ),
                          ),
                        ),

                        SizedBox(height: 20.sp),

                        _sectionTitle("EVIDENCE / MEDIA"),
                        SizedBox(height: 12.sp),

                        _buildMedia(alertDetails),

                        SizedBox(height: 24.sp),

                        _sectionTitle("CASE STATUS TIMELINE"),
                        SizedBox(height: 14.sp),

                        _timeline(alertDetails),

                        SizedBox(height: 30.sp),

                        _updateStatusSection(
                          alertDetails,
                          allowedStatuses,
                          basisTypes,
                        ),

                        SizedBox(height: 30.sp),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }


  /// HEADER

  Widget _buildHeader(String title, AlertDetails alertDetails) {
    String priority = alertDetails.priority ?? "HIGH PRIORITY";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 6.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors:
                  priority.toUpperCase() == "HIGH" ||
                      priority.toUpperCase() == "HIGH PRIORITY"
                  ? [const Color(0xFFFF4D4D), const Color(0xFFB91C1C)]
                  : [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)],
            ),
          ),
          child: Text(
            priority.toUpperCase(),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

Widget _buildLocationCard(AlertDetails alertDetails) {
  String locationText = "Location not available";
  double? lat;
  double? lng;

  /// ✅ 1. Metadata location (UI display ke liye)
  if (alertDetails.metadata?.data?['location'] != null &&
      alertDetails.metadata!.data!['location'].toString().isNotEmpty) {
    locationText =
        alertDetails.metadata!.data!['location'].toString();
  }

  /// ✅ 2. Coordinates (maps ke liye)
  if (alertDetails.location?.coordinates != null &&
      alertDetails.location!.coordinates!.length == 2) {
    lng = alertDetails.location!.coordinates![0];
    lat = alertDetails.location!.coordinates![1];
  }

  /// ✅ Map launcher function
  Future<void> openMap() async {
  if (lat != null && lng != null) {
    final url = Uri.parse("https://www.google.com/maps?q=$lat,$lng");

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
}

  return _glassCard(
    child: Row(
      children: [
        Icon(Icons.location_on, color: Colors.blueAccent, size: 18.sp),
        SizedBox(width: 10.sp),

        /// 🔥 LOCATION TEXT (human readable)
        Expanded(
          child: Text(
            locationText,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ),

        /// 🔥 OPEN MAP BUTTON
        ElevatedButton(
          onPressed: (lat != null && lng != null) ? openMap : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            padding: EdgeInsets.symmetric(
                horizontal: 14.sp, vertical: 8.sp),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Open Maps",
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
  /// MEDIA
 Widget _buildMedia(AlertDetails alertDetails) {
  final media = alertDetails.mediaUrls ?? [];

  if (media.isEmpty) {
    return Text(
      "No media available",
      style: GoogleFonts.poppins(color: Colors.grey),
    );
  }

  return SizedBox(
    height: 20.h,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: media.length,
      separatorBuilder: (_, __) => SizedBox(width: 12.sp),
      itemBuilder: (context, index) {
        final url = media[index];

        final isVideo =
            url.endsWith(".mp4") ||
            url.endsWith(".webm") ||
            url.contains("video");

        if (isVideo) {
          return _videoCard(url);
        } else {
          return _imageCard(url);
        }
      },
    ),
  );
}

Widget _imageCard(String url) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          child: InteractiveViewer(
            child: Image.network(url, fit: BoxFit.contain),
          ),
        ),
      );
    },
    child: Container(
      width: 40.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}
Widget _videoCard(String url) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoPlayerScreen(videoUrl: url),
        ),
      );
    },
    child: Container(
      width: 40.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.videocam, color: Colors.white54, size: 40),
          const Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
        ],
      ),
    ),
  );
}

  Widget _timeline(AlertDetails alertDetails) {
    if (alertDetails.timeline == null || alertDetails.timeline!.isEmpty) {
      return Column(
        children: [
          _timelineItem(
            "Reported",
            "Case reported by citizen",
            "Citizen",
            alertDetails.createdAt ?? "Just now",
          ),
        ],
      );
    }

    return Column(
      children: alertDetails.timeline!.map((item) {
        return _timelineItem(
          item.status ?? "Status",
          item.note ?? "Update provided",
          item.updatedByName ?? item.updatedBy ?? "System",
          item.timestamp ?? "",
        );
      }).toList(),
    );
  }

  Widget _timelineItem(
    String title,
    String subtitle,
    String updatedBy,
    String timestamp,
  ) {
    String formattedTime = "";
    try {
      if (timestamp.isNotEmpty) {
        DateTime dt = DateTime.parse(timestamp);
        formattedTime = DateFormat('dd MMM yyyy • h:mm a').format(dt);
      }
    } catch (e) {
      formattedTime = timestamp;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 16.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.blue, size: 18.sp),
          SizedBox(width: 10.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (formattedTime.isNotEmpty)
                      Text(
                        formattedTime,
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 13.sp,
                        ),
                      ),
                  ],
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  "Updated by: $updatedBy",
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// UPDATE STATUS SECTION (IMAGE MATCH)
  Widget _updateStatusSection(
    AlertDetails alert,
    List<String> allowedStatuses,
    List<String> basisTypes,
  ) {
    final currentStatus = alert.status ?? "";


    if (currentStatus.toLowerCase() == 'resolved') {
      return _glassCard(
        child: Center(
          child: Column(
            children: [
              Icon(Icons.check_circle, color: const Color(0xFF10B981), size: 40.sp),
              SizedBox(height: 12.sp),
              Text(
                "CASE RESOLVED",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF10B981),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Only allowed statuses (exclude current status)
    final List<String> allStatuses = allowedStatuses.where((e) => e.isNotEmpty && e != currentStatus).toList();

    if (_selectedStatus == null || !allStatuses.contains(_selectedStatus)) {
      _selectedStatus = allStatuses.isNotEmpty ? allStatuses.first : null;
    }

    final List<String> effectiveBasisTypes = basisTypes.isNotEmpty
        ? basisTypes

        : [
            "Site Inspection Completed",
            "CCTV Evidence",
            "Witness Statement",
            "Police Investigation",
          ];

    if (_selectedInvestigationBasis.isEmpty ||
        !effectiveBasisTypes.contains(_selectedInvestigationBasis)) {
      _selectedInvestigationBasis = effectiveBasisTypes.first;
    }

    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("UPDATE STATUS"),
          SizedBox(height: 10.sp),
          _dropdownContainer(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: const Color(0xFF0F172A),
                value: _selectedStatus,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
                isExpanded: true,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
                items: allStatuses.map((statusName) {
                  return DropdownMenuItem<String>(
                    value: statusName,
                    child: Text(statusName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20.sp),
        _sectionTitle("INVESTIGATION BASIS"),
SizedBox(height: 10.sp),

_dropdownContainer(
  child: DropdownButtonHideUnderline(
    child: Builder(
      builder: (context) {

        final currentBasis =
            alert.timeline?.isNotEmpty == true
                ? alert.timeline!.last.basisType
                : null;

        final List<String> allBasisTypes = {
            if (currentBasis != null) currentBasis,
            ...basisTypes,
        }.toList();


        if (_selectedInvestigationBasis.isEmpty &&
            allBasisTypes.isNotEmpty) {
          _selectedInvestigationBasis = allBasisTypes.first;
        }

        return DropdownButton<String>(
          dropdownColor: const Color(0xFF0F172A),
          value: _selectedInvestigationBasis,
          isExpanded: true,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16.sp,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
          items: allBasisTypes.map((basis) {
            return DropdownMenuItem(
              value: basis,
              child: Text(basis),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedInvestigationBasis = value!;
            });
          },
        );
      },
    ),
  ),
),
          SizedBox(height: 20.sp),
          _sectionTitle("ADDITIONAL NOTES"),
          SizedBox(height: 10.sp),
          _noteInput(),
          SizedBox(height: 24.sp),
          _gradientSubmitButton(),
        ],
      ),
    );
  }


  Widget _noteInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: _noteController,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 15.sp),
        maxLines: 3,
        decoration: InputDecoration(
          hintText: "Enter investigation notes here...",
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey[500],
            fontSize: 14.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(12.sp),
        ),
      ),
    );
  }

  /// DROPDOWN CONTAINER
  Widget _dropdownContainer({required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withOpacity(0.06),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: child,
    );
  }

  /// BUTTON
  Widget _gradientSubmitButton() {
    return BlocBuilder<AlertDetailsBloc, AlertDetailsState>(
      builder: (context, state) {
        final isUpdating = state is AlertStatusUpdating;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isUpdating
                ? null
                : () {
                    final currentAllowedStatuses = state is AlertDetailsLoaded ? state.allowedStatuses : [];
                    if (_selectedStatus != null || currentAllowedStatuses.isNotEmpty) {
                        context.read<AlertDetailsBloc>().add(
                          UpdateStatus(
                            alertId: widget.alertId,
                            status: _selectedStatus!,
                            basisType: _selectedInvestigationBasis,
                            note: _noteController.text.isEmpty
                                ? null
                                : _noteController.text,
                          ),
                        );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 16.sp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isUpdating
                ? SizedBox(
                    height: 20.sp,
                    width: 20.sp,
                    child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    "SUBMIT UPDATE",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
          ),
        );
      },
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: Colors.grey[400],
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  /// GLASS CARD
  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: EdgeInsets.all(16.sp),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
