import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/request_bloc.dart';
import '../bloc/request_event.dart';
import '../models/request_type.dart';
import '../../../../core/routes/route_names.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RequestBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0B0F17),
        appBar: AppBar(
          backgroundColor: const Color(0xFF111827),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            "Control Requests",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              ModernRequestCard(type: RequestType.footage),
              SizedBox(height: 16),
              ModernRequestCard(type: RequestType.faceIdentify),
              SizedBox(height: 16),
              ModernRequestCard(type: RequestType.anpr),
            ],
          ),
        ),
      ),
    );
  }
}


class ModernRequestCard extends StatelessWidget {
  final RequestType type;

  const ModernRequestCard({super.key, required this.type});

  IconData getIcon() {
    switch (type) {
      case RequestType.footage:
        return Icons.video_camera_back;
      case RequestType.faceIdentify:
        return Icons.face_retouching_natural;
      case RequestType.anpr:
        return Icons.directions_car;
    }
  }

  String getSubtitle() {
    switch (type) {
      case RequestType.footage:
        return "Request CCTV footage from selected location";
      case RequestType.faceIdentify:
        return "Identify suspect using facial recognition";
      case RequestType.anpr:
        return "Automatic Number Plate Recognition search";
    }
  }

  Color getAccentColor() {
    switch (type) {
      case RequestType.footage:
        return const Color(0xFF2563EB);
      case RequestType.faceIdentify:
        return const Color(0xFF7C3AED);
      case RequestType.anpr:
        return const Color(0xFFF59E0B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<RequestBloc>().add(SelectRequest(type));

        if (type == RequestType.footage) {
          Navigator.pushNamed(context, RouteNames.footageRequestMap);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF1F2937),
              content: Text("${type.title} Selected"),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Badge
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: getAccentColor().withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(getIcon(), color: getAccentColor(), size: 28),
            ),

            const SizedBox(width: 16),

            // Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    getSubtitle(),
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),

            // Arrow
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white38,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
