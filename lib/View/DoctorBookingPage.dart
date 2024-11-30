import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:projectalpha/Controller/authcontroller.dart';
import 'package:projectalpha/services/dio_helper.dart';
import 'package:projectalpha/services/constants.dart';

class DoctorBookingPage extends StatefulWidget {
  final dynamic doctor;
  final dynamic clinic;

  const DoctorBookingPage({
    Key? key,
    required this.doctor,
    required this.clinic,
  }) : super(key: key);

  @override
  _DoctorBookingPageState createState() => _DoctorBookingPageState();
}

class _DoctorBookingPageState extends State<DoctorBookingPage> {
  DateTime _selectedDay = DateTime.now().add(Duration(days: 1)); // Start from tomorrow
  String? _selectedTime;
  List<String> _availableTimes = [];
  bool _isLoading = false;
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _fetchAvailableSlots();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _fetchAvailableSlots() async {
    setState(() {
      _isLoading = true;
      _availableTimes = [];
    });

    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDay);
      final patientId = authController.getPatientId(); // Get patient ID from auth controller

      final response = await DioHelper.getData(
        url: 'reservations-slots',
        query: {
          'date': formattedDate,
          'doctor_id': widget.doctor.id.toString(),
          'patient_id': patientId.toString(), // Add patient_id
        },
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        setState(() {
          _availableTimes = List<String>.from(response.data['data']);
          _selectedTime = null;
        });

        if (_availableTimes.isEmpty) {
          Get.snackbar(
            'تنبيه',
            'عذراً، لديك حجز بالفعل في هذا اليوم',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'خطأ',
          response.data['message'] ?? 'فشل في جلب المواعيد المتاحة',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error fetching slots: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء جلب المواعيد المتاحة',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Book Appointment',
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDoctorInfo(),
          SizedBox(height: 16),
          _buildCalendar(),
          SizedBox(height: 16),
          _buildTimeSlots(),
          SizedBox(height: 16),
          _buildBookingForm(),
          SizedBox(height: 16),
          _buildBookButton(),
        ],
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: widget.doctor.photo != null
                ? NetworkImage('${AppConstants.baseURLPhoto}${widget.doctor.photo}')
                : AssetImage('assets/doctor_placeholder.png') as ImageProvider,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. ${widget.doctor.name}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.doctor.specialization,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  widget.clinic.user.name,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.now().add(Duration(days: 1)),
        lastDay: DateTime.now().add(Duration(days: 30)),
        focusedDay: _selectedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _selectedTime = null;
          });
          _fetchAvailableSlots();
        },
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Time Slots',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          _availableTimes.isEmpty
              ? Center(
            child: Text(
              'No available slots for this date',
              style: TextStyle(color: Colors.grey[600]),
            ),
          )
              : Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableTimes.map((time) {
              bool isSelected = time == _selectedTime;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTime = time;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingForm() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _reasonController,
            decoration: InputDecoration(
              labelText: 'Reason for Visit',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            maxLines: 2,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'Additional Notes',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton() {
    return Container(
      margin: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _selectedTime == null ? null : _createReservation,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Book Appointment',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _createReservation() async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDay);
      final patientId = authController.getPatientId();

      final reservationData = {
        'date': formattedDate,
        'time': _selectedTime?.split(' ')[0],
        'duration_minutes': widget.doctor.defaultTimeReservations,
        'notes': _notesController.text.trim(),
        'status': 'pending',
        'reason_for_visit': _reasonController.text.trim(),
        'patient_id': patientId,
        'doctor_id': widget.doctor.id,
        'nclinic_id': widget.clinic.id,
      };

      final response = await DioHelper.postData(
          url: 'reservations',
          data: reservationData
      );

      if (response.statusCode == 201) {
        Get.snackbar(
          'نجاح',
          'تم الحجز بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 3),
        );
        await Future.delayed(Duration(seconds: 2));
        Get.offAllNamed('mainhomepatient');
      } else {
        Get.snackbar(
          'تنبيه',
          response.data['message'] ?? 'فشل الحجز',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 3),
        );
        _fetchAvailableSlots();
      }
    } catch (e) {
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء إنشاء الحجز',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 3),
        );
    }
  }
}
