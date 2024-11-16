import 'package:get/get.dart';

class Filtercontroller extends GetxController{
  bool isenable = false ;


  int? selectedOption1;
  int? selectedOption2;

  List<String> options = ['1', '2', '3'];

  void changevalueofoption1(int? value){
  selectedOption1 = value;
  update();

  }

  void changevalueofoption2(int? value){
  selectedOption2 = value;
  update();

  }

  void changeEnable (){
    isenable = !isenable;
    update();
  }
}