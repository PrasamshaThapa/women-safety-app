import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_spaces.dart';
import '../../utils/app_bars/custom_app_bar.dart';
import '../../utils/buttons/custom_outline_button.dart';
import '../../utils/buttons/expanded_filled_button.dart';
import '../../utils/inputs/custom_date_input.dart';
import '../../utils/inputs/custom_input.dart';
import '../../utils/inputs/custom_multiline_input.dart';
import '../map/map_screen.dart';
import 'map_dialog.dart';

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
  List<double>? _specificAreaController;
  final _incidentDescriptionController = TextEditingController();

  @override
  void initState() {
    _reportedByController.text =
        context.read<AuthBloc>().state.user?.email ?? '';
    super.initState();
  }

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
                            readOnly: true,
                          ),
                          CustomInput(
                            controller: _locationController,
                            label: "Location",
                          ),
                          CustomOutlinedButton(
                            onTap:
                                () => showKycMapDialog(
                                  context,
                                  onDone: (googlePinLocation) {
                                    _specificAreaController = googlePinLocation;
                                  },
                                ),
                            // icon: Icon(Icons.map),
                            title: "Locate in Map",
                            radius: AppConstants.borderRadius,
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
                        addUnsafeArea(
                          _locationController.text,
                          _specificAreaController![0],
                          _specificAreaController![1],
                          _incidentDescriptionController.text,
                        );
                        final locationInput = _specificAreaController;
                        if (locationInput != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => MapPage(
                                    locationAddress: locationInput,
                                    locationName: _locationController.text,
                                  ),
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
        // bottomNavigationBar: CustomNavBar(),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _reportedByController.dispose();
    _locationController.dispose();
    _dateOfReportController.dispose();
    _incidentDateController.dispose();
    _incidentDescriptionController.dispose();
    super.dispose();
  }

  void showKycMapDialog(
    BuildContext context, {
    Function(List<double>)? onDone,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => MapDialog(
            onDone: (googlePinLocation) {
              log(
                ">>>>>>>>>>>>>>>>>>>>>>>>>> showKycMapDialog ${googlePinLocation.first} ${googlePinLocation.last}",
              );
              onDone!(googlePinLocation);
            },
          ),
    );
  }

  void addUnsafeArea(
    String name,
    double latitude,
    double longitude,
    String description,
  ) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore
        .collection("unsafe_areas")
        .add({
          "name": name,
          "latitude": latitude,
          "longitude": longitude,
          "description": description,
          "timestamp":
              FieldValue.serverTimestamp(), // Optional: Track when added
        })
        .then((value) {
          print("Unsafe area added successfully!");
        })
        .catchError((error) {
          print("Failed to add unsafe area: $error");
        });
  }
}
