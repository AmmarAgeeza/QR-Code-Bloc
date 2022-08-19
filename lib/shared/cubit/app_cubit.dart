import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_murf/shared/cubit/app_states.dart';
import 'package:screenshot/screenshot.dart';

import '../../screens/create_qr_code_screen.dart';
import '../../screens/scan_qr_code_screen.dart';
import '../network/google_sheets/api.dart';
import '../widgets/snack_bar.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppStates());

  //get object from class
  static AppCubit get(context) => BlocProvider.of(context);

  //home page logic
  int currentIndex = 0;
  List<Widget> screens = [const CreateQrCode(), const ScanQrCode()];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  //create qr code page logic
  TextEditingController dataConverted = TextEditingController();
  String idGenerated = '';
  String nameOfAttendee = '';

  void changeName(String name) {
    nameOfAttendee = name;
    emit(ChangeNameState());
    print(name);
  }

  void convertTextToQRImage(BuildContext context) {
    if (dataConverted.text != '') {
      emit(ConvertTextToQRImageState());
      showSnackBar(message: 'Text Converted To QR Code', context: context);
    } else {
      showSnackBar(message: 'Please Enter Data ', context: context);
    }
  }

  Random random = Random();

  void putGeneratedIDToQRCode() {
    idGenerated = generateRandomNumber();
    emit(PutGeneratedIDToQRCodeState());
  }

  String generateRandomNumber() {
    emit(GenerateRandomIdState());
    return '${random.nextInt(1000)}${random.nextInt(1000)}${random.nextInt(1000)}${random.nextInt(1000)}';
  }

  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? imageToSave;

  void createQRCode(BuildContext context) {
    try {

      if (idGenerated != '' && nameOfAttendee != '') {
        AttendeeSheetApi.getByName(nameOfAttendee).then((value) {
          if (value != null) {
            showSnackBar(message: 'Attendee Existed Before', context: context);
            emit(AttendeeExistedWhenCreateQRCodeState());
          } else {
            AttendeeSheetApi.updateCellByName(
                name: nameOfAttendee, key: 'id', value: idGenerated);
            showSnackBar(
                message: 'Created QR Code Successfully', context: context);
            AttendeeSheetApi.insertData(
                name: nameOfAttendee, id: int.parse(idGenerated));
            emit(InsertAttendeeToGSheetsState());
            emit(CreateQRCodeState());
            saveImageToDevice(context);
            emit(SaveQRCodeImageSuccessfullyState());
          }
        });
      } else if (nameOfAttendee == '' && idGenerated == '') {
        showSnackBar(
            message: 'Please Write Name & Generate ID', context: context);
        emit(AttendeeNameIDIsEmptyState());
      } else if (nameOfAttendee == '') {
        showSnackBar(message: 'Please Enter Name', context: context);
        emit(AttendeeNameIsEmptyState());
      } else if (idGenerated == '') {
        showSnackBar(message: 'Please Generate ID', context: context);
        emit(AttendeeIDIsEmptyState());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  saveImageToDevice(BuildContext context) async {
    await [Permission.storage].request();
    if (dataConverted.text != '') {
      screenshotController.capture().then((value) {
        imageToSave = value;
        if (imageToSave != null) {
          saveImage(imageToSave!).then((value) {
            emit(ImageSavedSuccessfullyState());
            showSnackBar(context: context, message: 'Image DownLoaded');
          }).catchError((e) {
            emit(ImageSavedWithErrorState());
            final snackBar = SnackBar(
              content: Text(e.toString()),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
        } else {
          emit(ImageEqualsNullState());
          SnackBar snackBar = const SnackBar(
            content: Text('Enter your Data'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } else {
      showSnackBar(
          message: 'Please Write Name & Generate ID', context: context);
    }
  }

  Future<String> saveImage(Uint8List pic) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll(".", '-')
        .replaceAll(":", "-");
    final name = 'QR_pic_$time';
    final res = await ImageGallerySaver.saveImage(pic, name: name);
    emit(ConvertImageToUnitState());
    return res['filePath'];
  }
}
