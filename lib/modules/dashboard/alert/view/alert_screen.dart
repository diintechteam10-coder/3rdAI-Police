import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../repository/get_all_assigned_citizen_alerts_repo.dart';
import '../bloc/citizen bloc/citizen_alert_bloc.dart';
import '../bloc/citizen bloc/citizen_alert_state.dart';
import '../bloc/citizen bloc/citizen_alert_event.dart';
import '../models/citizen/response/all_assigned_citizen_alerts.dart';
import '../models/citizen/citizen_filter_model.dart';
import '../models/device/device_alert_model.dart';
import 'alert_details_screen.dart';
import 'device_alert_details_screen.dart';
import '../bloc/details_bloc/alert_details_bloc.dart';
import '../bloc/details_bloc/alert_details_event.dart';
import '../repository/alert_details_repo.dart';
import '../repository/update_alert_status_repo.dart';
import 'common_filter_screen.dart';
import '../models/citizen/citizen_alert_types.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CitizenAlertBloc(repository: GetAlertsRepository())
            ..add(LoadCitizenAlerts()),
      child: Builder(
        // 👈 ADD THIS
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0B1E3A), Color(0xFF1F3F66)],
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors
                  .transparent, // Ensures Scaffold doesn't block background
              body: SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<CitizenAlertBloc>().add(LoadCitizenAlerts());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16),
                          const HeaderSection(),
                          const SizedBox(height: 18),
                          TabSwitcher(
                            selectedIndex: _selectedTab,
                            onTabChanged: (index) {
                              setState(() {
                                _selectedTab = index;
                              });
                            },
                          ),
                          const SizedBox(height: 18),
                          if (_selectedTab == 0)
                            const DeviceAlertCard()
                          else
                            BlocBuilder<CitizenAlertBloc, CitizenAlertState>(
                              builder: (context, state) {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    CitizenStatusChips(
                                      selectedStatus: state.selectedStatus,
                                      onStatusSelected: (status) {
                                        context.read<CitizenAlertBloc>().add(
                                          ChangeCitizenStatusFilter(status),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 18),
                                    if (state.isLoading)
                                      _buildShimmerList()
                                    else if (state.visibleAlerts.isEmpty)
                                      const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(24.0),
                                          child: Text(
                                            "No alerts found for this status.",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: state.visibleAlerts.length,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 12),
                                        itemBuilder: (context, index) {
                                          return CitizenReportCard(
                                            alert: state.visibleAlerts[index],
                                          );
                                        },
                                      ),
                                  ],
                                );
                              },
                            ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.1),
      highlightColor: Colors.white.withOpacity(0.2),
      child: Column(
        children: List.generate(
          5,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Alert Command Center',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CommonFilterScreen<CitizenAlertType>(
                  title: "Citizen Filters",
                  categories: CitizenAlertType.values,
                  subTypeMap: citizenSubTypeMap,
                  initialSubTypes: context
                      .read<CitizenAlertBloc>()
                      .state
                      .filter
                      .subTypes,
                  onApply: (subTypes) {
                    context.read<CitizenAlertBloc>().add(
                      ApplyCitizenFilter(
                        CitizenAlertFilter(subTypes: subTypes),
                      ),
                    );
                  },
                ),
              ),
            );
          },
          child: const Icon(
            Icons.filter_list,
            color: Color(0xFFFFFFFF),
            size: 24,
          ),
        ),
      ],
    );
  }
}

class TabSwitcher extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const TabSwitcher({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2445),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A4C86)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: selectedIndex == 0
                      ? const Color(0xFF2A4C86)
                      : Colors.transparent,
                  borderRadius: selectedIndex == 0
                      ? BorderRadius.circular(8)
                      : BorderRadius.zero,
                ),
                alignment: Alignment.center,
                child: Text(
                  'Device Alert',
                  style: TextStyle(
                    color: selectedIndex == 0
                        ? const Color(0xFFFFFFFF)
                        : const Color(0xFFB0C4DE),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: selectedIndex == 1
                      ? const Color(0xFF2A4C86)
                      : Colors.transparent,
                  borderRadius: selectedIndex == 1
                      ? BorderRadius.circular(8)
                      : BorderRadius.zero,
                ),
                alignment: Alignment.center,
                child: Text(
                  'Citizen Reports',
                  style: TextStyle(
                    color: selectedIndex == 1
                        ? const Color(0xFFFFFFFF)
                        : const Color(0xFFB0C4DE),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeviceAlertCard extends StatelessWidget {
  const DeviceAlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE6D6CF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 3,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.black12,
              child: Image.network(
                'https://images.unsplash.com/photo-1555616654-21952e464c23?q=80&w=200&auto=format&fit=crop',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.videocam_off, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Camera Offline',
                      style: TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD6D6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Critical',
                        style: TextStyle(
                          color: Color(0xFFFF3B30),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Connectivity • 2 min ago',
                  style: TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.location_on,
                          color: Color(0xFFFF3B30),
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Hazratganj',
                          style: TextStyle(
                            color: Color(0xFF555555),
                            fontSize: 13,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeviceAlertDetailsScreen(
                              deviceAlert: DeviceAlert(
                                id: '1',
                                type: DeviceAlertType.connectivity,
                                subType: 'Camera Offline',
                                severity: AlertSeverity.critical,
                                createdAt: DateTime.now(),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'View Details',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Color(0xFF666666),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CitizenStatusChips extends StatelessWidget {
  final String selectedStatus;
  final Function(String) onStatusSelected;

  const CitizenStatusChips({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildClickableChip('Reported', 'Reported'),
          const SizedBox(width: 10),
          _buildClickableChip('Under Review', 'Under Review'),
          const SizedBox(width: 10),
          _buildClickableChip('Verified', 'Verified'),
          const SizedBox(width: 10),
          _buildClickableChip('Action Taken', 'Action Taken'),
          const SizedBox(width: 10),
          _buildClickableChip('Resolved', 'Resolved'),
        ],
      ),
    );
  }

  Widget _buildClickableChip(String label, String status) {
    final isSelected = selectedStatus.toLowerCase() == status.toLowerCase();
    return GestureDetector(
      onTap: () => onStatusSelected(status),
      child: _buildChip(
        label,
        isSelected ? const Color(0xFFFFFFFF) : const Color(0xFFBDBDBD),
        isSelected ? const Color(0xFFFF6F00) : const Color(0xFFFFFFFF),
        isSelected ? FontWeight.w500 : FontWeight.normal,
      ),
    );
  }

  Widget _buildChip(
    String label,
    Color bgColor,
    Color textColor,
    FontWeight weight,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: weight,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

class CitizenReportCard extends StatelessWidget {
  final AlertModel alert;

  const CitizenReportCard({super.key, required this.alert});

  Color _getStatusThemeColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'reported':
        return const Color(0xFFFF4D4F);

      case 'under review':
        return const Color(0xFFFF9800);

      case 'verified':
        return const Color(0xFF2196F3);

      case 'action taken':
        return const Color(0xFF4CAF50);

      case 'resolved': // 👈 NEW
        return const Color(0xFF10B981); // nice teal-green

      default:
        return const Color(0xFFFF4D4F);
    }
  }

  String _getStatusText(String? status) {
    return status ?? 'Reported';
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final isToday =
        time.day == now.day && time.month == now.month && time.year == now.year;

    // Simple 12 hr format
    int hour = time.hour > 12 ? time.hour - 12 : time.hour;
    if (hour == 0) hour = 12;
    final ampm = time.hour >= 12 ? 'PM' : 'AM';
    final min = time.minute.toString().padLeft(2, '0');
    final timeStr = "$hour:$min $ampm";

    if (isToday) return "Today $timeStr";
    return "${time.day}/${time.month} $timeStr";
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getStatusThemeColor(alert.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE7DED5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 3,
            height: 60,
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        alert.title ?? 'No Title',
                        style: const TextStyle(
                          color: Color(0xFF222222),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: themeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.history, color: themeColor, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            _getStatusText(alert.status),
                            style: TextStyle(
                              color: themeColor,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  alert.metadata?.data?['location']?.toString() ??
                      'Assigned Area',
                  style: const TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatTime(
                        DateTime.tryParse(alert.createdAt ?? '') ??
                            DateTime.now(),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF777777),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("alertId: ${alert.id}");
                        print(
                          "category Type: ${alert.metadata?.data?['type']?.toString()}",
                        );
                        final bloc = context.read<CitizenAlertBloc>();
                        Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(value: bloc),
                                BlocProvider(
                                  create: (context) => AlertDetailsBloc(
                                    detailsRepo:
                                        GetPartnerAlertDetailsRepository(),
                                    updateRepo: UpdateAlertStatusRepository(),
                                  )..add(FetchAlertDetails(alert.id!)),
                                ),
                              ],
                              child: AlertDetailsScreen(
                                alertId: alert.id!,
                                category: alert.metadata?.data?['type']
                                    ?.toString(),
                              ),
                            ),
                          ),
                        ).then((newStatus) {
                          if (newStatus != null && newStatus.isNotEmpty) {
                            bloc.add(ChangeCitizenStatusFilter(newStatus));
                          }
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'View',
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Color(0xFF333333),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
