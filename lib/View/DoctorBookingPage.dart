import 'package:flutter/material.dart';
import 'package:projectalpha/Controller/authcontroller.dart';
import 'package:projectalpha/services/constants.dart';
import 'package:projectalpha/services/dio_helper.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  DateTime _selectedDay = DateTime.now();
  String? _selectedTime;
  List<String> _availableTimes = [];
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();


  @override
  void initState() {
    super.initState();
    _generateTimeSlots();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _generateTimeSlots() {
    // Parse clinic opening and closing times
    TimeOfDay opening = _parseTime(widget.clinic.openingTime);
    TimeOfDay closing = _parseTime(widget.clinic.closingTime);

    List<String> slots = [];
    DateTime now = DateTime.now();

    // Start time
    DateTime currentSlot = DateTime(
        now.year, now.month, now.day,
        opening.hour, opening.minute
    );

    // End time
    DateTime endTime = DateTime(
        now.year, now.month, now.day,
        closing.hour, closing.minute
    );

    // Generate 30-minute slots
    while (currentSlot.isBefore(endTime)) {
      slots.add(_formatTimeOfDay(TimeOfDay.fromDateTime(currentSlot)));
      // Add 30 minutes
      currentSlot = currentSlot.add(Duration(minutes: 30));
    }

    setState(() {
      _availableTimes = slots;
    });
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1].substring(0, 2))
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final hourIn12 = time.hour > 12 ? time.hour - 12 : time.hour;
    return '${hourIn12.toString().padLeft(2, '0')}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(-131587),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(screenSize),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Calendar
                    _buildCalendar(),

                    SizedBox(height: 20),

                    // Available Times
                    _buildAvailableTimes(),

                    SizedBox(height: 20),

                    // Description & Instructions Fields
                    _buildInputFields(),
                  ],
                ),
              ),
            ),

            // Confirm Button
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Size screenSize) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "د. ${widget.doctor.name}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      widget.doctor.specialization,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 30,
                  backgroundImage: widget.doctor.photo != null
                      ? NetworkImage('${AppConstants.baseURLPhoto}storage/${widget.doctor.photo}')
                      : AssetImage('assets/doctor_placeholder.jpg') as ImageProvider,
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
      ),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(Duration(days: 90)),
        focusedDay: _selectedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
          });
        },
        enabledDayPredicate: (day) {
          // Disable the current day
          return !isSameDay(day, DateTime.now());
        },
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        availableGestures: AvailableGestures.none,
      ),
    );
  }


  Widget _buildAvailableTimes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "الأوقات المتاحة",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _availableTimes.length,
            itemBuilder: (context, index) {
              final time = _availableTimes[index];
              final isSelected = time == _selectedTime;
              return _buildTimeSlot(time, isSelected);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlot(String time, bool isSelected) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTime = time;
          });
        },
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[700] : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Colors.blue[700]! : Colors.grey[300]!,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            time,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              hintText: 'سبب الزيارة',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _instructionsController,
            decoration: InputDecoration(
              hintText: 'تعليمات إضافية',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[700],
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _selectedTime != null ? _createReservation : null,
        child: Text(
          'تأكيد الحجز',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _createReservation() async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDay);
      final formattedTime = _selectedTime?.split(' ')[0];
      final patientId = authController.getPatientId();

      if (patientId == null) {
        Get.snackbar(
          'خطأ',
          'المريض غير مسجل. الرجاء تسجيل الدخول.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final reservationData = {
        'date': formattedDate,
        'time': formattedTime,
        'description': _descriptionController.text.trim(),
        'status': 'scheduled',
        'instructions': _instructionsController.text.trim(),
        'patient_id': patientId,
        'doctor_id': widget.doctor.id,
        'nclinic_id': widget.clinic.id,
      };

      print("Sending Reservation Data: $reservationData");

      final response = await DioHelper.postData(url: 'appointments', data: reservationData);

      print("Response Received: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 201) {
        print("Reservation Created Successfully: $reservationData");
        Get.snackbar(
          'نجاح',
          'تم إنشاء الحجز بنجاح.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await Future.delayed(Duration(seconds: 2));
        Get.offAllNamed('mainhome');
      } else if (response.statusCode == 422) {
        final errorMessages = response.data?['errors']?.values
            ?.map((errorList) => errorList.join('\n'))
            ?.join('\n\n') ?? 'البيانات المدخلة غير صحيحة.';
        print("Validation Errors: $errorMessages");
        Get.snackbar(
          'خطأ في البيانات',
          errorMessages,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        print("Unexpected Error: ${response.statusCode}");
        Get.snackbar(
          'خطأ غير متوقع',
          'حدث خطأ غير معروف. كود الحالة: ${response.statusCode}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء إرسال الطلب: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


}