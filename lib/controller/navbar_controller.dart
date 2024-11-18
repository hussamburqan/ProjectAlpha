import 'package:get/get_state_manager/get_state_manager.dart';

class Navbarcontroller extends GetxController{
  int pagenumber = 0 ; 

  int GetPageNum(){
    return pagenumber;
  }

  void ChangeNumber(int num) {
    pagenumber = num;
    update();
  }
}