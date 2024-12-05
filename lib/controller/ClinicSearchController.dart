import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectalpha/models/nclinics_model.dart';
import 'package:projectalpha/services/dio_helper.dart';

class ClinicSearchController extends GetxController {
  RxList<Clinic> clinics = <Clinic>[].obs;
  RxList<Clinic> filteredClinics = <Clinic>[].obs;
  RxBool isLoading = false.obs;

  RxString selectedSpecialization = ''.obs;
  RxString selectedLocation = ''.obs;
  RxList<String> specializations = <String>[].obs;
  RxList<String> locations = <String>[].obs;

  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getClinics();
    searchController.addListener(() {
      applyFilters();
    });
  }

  Future<void> getClinics() async {
    try {
      isLoading(true);
      final response = await DioHelper.getData(url: 'clinics');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        clinics.value = data.map((json) => Clinic.fromJson(json)).toList();

        Set<String> uniqueSpecializations = {};
        Set<String> uniqueLocations = {};

        for (var clinic in clinics) {
          uniqueSpecializations.add(clinic.major.name);
          uniqueLocations.add(clinic.location.split(',').last.trim());
        }

        specializations.value = uniqueSpecializations.toList();
        locations.value = uniqueLocations.toList();

        filteredClinics.value = clinics;
      }
    } catch (e) {
      print('Error fetching clinics: $e');
    } finally {
      isLoading(false);
    }
  }

  void applyFilters() {
    filteredClinics.value = clinics.where((clinic) {
      bool matchesSearch = true;
      bool matchesSpecialization = true;
      bool matchesLocation = true;

      // فلترة البحث
      if (searchController.text.isNotEmpty) {
        matchesSearch = clinic.user.name.toLowerCase().contains(searchController.text.toLowerCase()) ||
            clinic.location.toLowerCase().contains(searchController.text.toLowerCase());
      }

      // فلترة التخصص
      if (selectedSpecialization.isNotEmpty) {
        matchesSpecialization = clinic.major.name == selectedSpecialization.value;
      }

      // فلترة المحافظة
      if (selectedLocation.isNotEmpty) {
        matchesLocation = clinic.location.split(',').last.trim() == selectedLocation.value;
      }

      return matchesSearch && matchesSpecialization && matchesLocation;
    }).toList();
  }

  void setSpecialization(String? specialization) {
    selectedSpecialization.value = specialization ?? '';
    applyFilters();
  }

  void setLocation(String? location) {
    selectedLocation.value = location ?? '';
    applyFilters();
  }

  void resetFilters() {
    selectedSpecialization.value = '';
    selectedLocation.value = '';
    searchController.clear();
    filteredClinics.value = clinics;
  }
}