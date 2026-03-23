import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/utils/snackbar_util.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/select client bloc/select_client_bloc.dart';
import '../models/get_client_response_model.dart';

class SelectClientScreen extends StatefulWidget {
  const SelectClientScreen({super.key});

  @override
  State<SelectClientScreen> createState() => _SelectClientScreenState();
}

class _SelectClientScreenState extends State<SelectClientScreen> {
  OrganizationData? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: BlocConsumer<SelectClientBloc, SelectClientState>(
        listener: (context, state) {
          if (state is SelectClientSuccess) {
            Navigator.pushReplacementNamed(context, RouteNames.signinMethodsScreen);
          }
          if (state is SelectClientError) {
            SnackbarUtil.showError(context: context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is SelectClientLoading) {
            return _buildShimmerLoading();
          }
          if (state is SelectClientLoaded) {
            return _buildBody(context, state.organizations);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<OrganizationData> orgs) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48),

            // ── Header ──────────────────────────────────────
            Text(
              'Select\nOrganization',
              style: GoogleFonts.dmSans(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFF0EEF8),
                height: 1.15,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose your organization to continue',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: const Color(0xFF6E6E8A),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 44),

            // ── Label ────────────────────────────────────────
            Text(
              'CLIENT ID',
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF9090A8),
                letterSpacing: 0.9,
              ),
            ),
            const SizedBox(height: 10),

            // ── Dropdown ─────────────────────────────────────
            _StyledDropdown(
              orgs: orgs,
              selected: _selected,
              onChanged: (val) => setState(() => _selected = val),
            ),

            const SizedBox(height: 32),

            // ── Continue Button ───────────────────────────────
            _ContinueButton(
              enabled: _selected != null,
              onPressed: () => context
                  .read<SelectClientBloc>()
                  .add(SelectOrganization(_selected!)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Shimmer.fromColors(
          baseColor: const Color(0xFF13131F),
          highlightColor: const Color(0xFF2A2A40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Container(
                width: 200,
                height: 35,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              ),
              const SizedBox(height: 8),
              Container(
                width: 250,
                height: 20,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
              ),
              const SizedBox(height: 44),

              // ── Label Placeholder ────────────────────────────────────────
              Container(
                width: 80,
                height: 14,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(height: 10),

              // ── Dropdown Placeholder ─────────────────────────────────────
              Container(
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              const SizedBox(height: 32),

              // ── Continue Button Placeholder ───────────────────────────────
              Container(
                height: 54,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Dropdown ──────────────────────────────────────────────────────────────────

class _StyledDropdown extends StatelessWidget {
  const _StyledDropdown({
    required this.orgs,
    required this.selected,
    required this.onChanged,
  });

  final List<OrganizationData> orgs;
  final OrganizationData? selected;
  final ValueChanged<OrganizationData?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF13131F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected != null
              ? const Color(0xFF7C6FFF)
              : const Color(0xFF2A2A40),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<OrganizationData>(
          isExpanded: true,
          value: selected,
          dropdownColor: const Color(0xFF13131F),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF9090A8),
          ),
          hint: Text(
            'Select Client ID',
            style: GoogleFonts.dmSans(
              fontSize: 15,
              color: const Color(0xFF4A4A62),
            ),
          ),
          items: orgs.map((org) {
            return DropdownMenuItem(
              value: org,
              child: Text(
                '${org.organizationName} (${org.clientId})',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFF0EEF8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ── Continue Button ───────────────────────────────────────────────────────────

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  colors: [Color(0xFF7C6FFF), Color(0xFF5B4EE8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: enabled ? null : const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: enabled ? onPressed : null,
          child: Text(
            'Continue',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: enabled ? Colors.white : const Color(0xFF3A3A56),
            ),
          ),
        ),
      ),
    );
  }
}