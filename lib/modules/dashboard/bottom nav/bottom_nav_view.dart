import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../ai police/view/ai_police_screen.dart';
import '../alert/view/alert_screen.dart';
import '../home/view/home_screen.dart';
import '../profile/view/profile_screen.dart';
import '../requests/view/request_screen.dart';
import 'bottom nav bloc/bottom_nav_bloc.dart';
import 'bottom nav bloc/bottom_nav_event.dart';
import 'bottom nav bloc/bottom_nav_state.dart';

class BottomNavView extends StatefulWidget {
  const BottomNavView({super.key});

  @override
  State<BottomNavView> createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      const AlertScreen(),
      const AiPoliceScreen(),
      const RequestScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBloc, BottomNavState>(
      builder: (context, state) {
        final padding = MediaQuery.of(context).padding;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: IndexedStack(index: state.currentIndex, children: _pages),

          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(bottom: padding.bottom),
            child: Container(
              height: 80, // 🔥 increased height
              decoration: BoxDecoration(color: Color(0xFF031733)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(
                    context,
                    iconAsset: 'assets/icons/home.png',
                    activeIconAsset: 'assets/icons/ahome.png',
                    label: "Home",
                    index: 0,
                    currentIndex: state.currentIndex,
                  ),
            
                  /// Alerts
                  _navItem(
                    context,
                    icon: Icons.notifications_none,
                    activeIcon: Icons.notifications,
                    label: "Alerts",
                    index: 1,
                    currentIndex: state.currentIndex,
                  ),
                  _navItem(
                    context,
                    iconAsset: 'assets/icons/ri_ai (1).png',
                    activeIconAsset: 'assets/icons/ri_ai.png',
                    label: "Police",
                    index: 2,
                    currentIndex: state.currentIndex,
                  ),
            
                  /// Requests
                  _navItem(
                    context,
                    icon: Icons.assignment_outlined,
                    activeIcon: Icons.assignment,
                    label: "Requests",
                    index: 3,
                    currentIndex: state.currentIndex,
                  ),
            
                  /// Profile
                  _navItem(
                    context,
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: "Profile",
                    index: 4,
                    currentIndex: state.currentIndex,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _navItem(
    BuildContext context, {
    IconData? icon,
    IconData? activeIcon,
    String? iconAsset,
    String? activeIconAsset,
    required String label,
    required int index,
    required int currentIndex,
  }) {
    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () {
        context.read<BottomNavBloc>().add(BottomNavTabChanged(index));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFA24C) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            if (iconAsset != null && activeIconAsset != null)
              Image.asset(
                isSelected ? activeIconAsset : iconAsset,
                color: isSelected ? Colors.white : Colors.white54,
                width: 22,
                height: 22,
              )
            else if (icon != null && activeIcon != null)
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? Colors.white : Colors.white54,
                size: 22,
              ),

            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
