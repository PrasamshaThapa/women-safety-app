import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_spaces.dart';
import '../../utils/app_bars/custom_app_bar.dart';
import '../../utils/buttons/expanded_filled_button.dart';
import '../../utils/inputs/custom_date_input.dart';
import '../../utils/inputs/custom_input.dart';
import '../../utils/inputs/custom_multiline_input.dart';
import '../map/map_screen.dart';

class IncidentReportScreen extends StatefulWidget {
  const IncidentReportScreen({super.key});

  @override
  State<IncidentReportScreen> createState() => _IncidentReportScreenState();
}

class _IncidentReportScreenState extends State<IncidentReportScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  // Controllers for text fields
  final _reportedByController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateOfReportController = TextEditingController();
  final _incidentDateController = TextEditingController();
  final _specificAreaController = TextEditingController();
  final _incidentDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "Incident Report"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.screenPadding),
          child: Form(
            // Wrap with Form widget
            key: _formKey,
            child: SingleChildScrollView(
              //added for scrollable
              child: Column(
                spacing: AppSpaces.largeSpace,
                children: [
                  Card(
                    color: AppColors.lightBackground, // Light purple
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSpaces.smallSpace,
                        children: [
                          CustomInput(
                            controller: _reportedByController,
                            label: "Reported By",
                          ),
                          CustomInput(
                            controller: _locationController,
                            label: "Location",
                          ),
                          CustomDateInput(
                            controller: _dateOfReportController,
                            label: "Date Of Report",
                          ),
                          CustomDateInput(
                            controller: _incidentDateController,
                            showPastAndHideFuture: false,
                            label: "Incident Date",
                          ),
                          CustomInput(
                            controller: _specificAreaController,
                            label: "Specific Area",
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: AppColors.lightBackground, // Light purple
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: CustomMultiLineInput(
                        label: "Incident Description",
                        controller: _incidentDescriptionController,
                      ),
                    ),
                  ),

                  ExpandedFilledButton(
                    title: "Submit",
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        String locationInput = _locationController.text;
                        if (locationInput.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      MapPage(locationAddress: locationInput),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: CustomNavBar(),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _reportedByController.dispose();
    _locationController.dispose();
    _dateOfReportController.dispose();
    _incidentDateController.dispose();
    _specificAreaController.dispose();
    _incidentDescriptionController.dispose();
    super.dispose();
  }
}
