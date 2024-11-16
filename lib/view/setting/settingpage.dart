import 'package:flutter/material.dart';

class Settingpage extends StatelessWidget {
  const Settingpage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          height: screenSize.height * 0.1,
        ),
        Padding(
            padding: EdgeInsets.only(
                left: screenSize.width * 0.04, right: screenSize.width * 0.04),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'عام',
                style: TextStyle(fontSize: screenSize.height * 0.02),
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: screenSize.width*0.1,),
            Align(alignment: Alignment.centerRight,
              child: Icon(Icons.ac_unit_rounded),
            ),
            SizedBox(width: screenSize.width*0.55,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'عام',
                    style: TextStyle(fontSize: screenSize.height * 0.02),
                  ),
                ),
                SizedBox(width: screenSize.width*0.05,),
            Icon(Icons.abc),
            SizedBox(width: screenSize.width*0.1,),

              
          ],
        ),
        
      ],
    );
  }
}
