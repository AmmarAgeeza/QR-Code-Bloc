import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'layout/home_page.dart';
import 'shared/cubit/bloc_observer.dart';
import 'shared/network/google_sheets/api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  AttendeeSheetApi.init();
// AttendeeSheetApi.getById(1).then((value) => print(value));
  // AttendeeSheetApi.getByName('ammar2 dff').then((value) => print(value!.email)).catchError((e){print(e.toString());});
  // List<Attendee> att=await AttendeeSheetApi.getAttendees();
  // print(att[1].isAttendee);
  //  AttendeeSheetApi.getById(3).then((value)
  //  {
  //    if(value!=null)
  //      {
  //        print(value.isAttendee);}
  //    else{
  //      print('User not Found');
  //    }
  // });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Code Murf',
      home: MyHomePage(),
    );
  }
}
