import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_murf/shared/cubit/app_cubit.dart';
import 'package:qr_code_murf/shared/cubit/app_states.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';



class CreateQrCode extends StatefulWidget {
  const CreateQrCode({Key? key}) : super(key: key);

  @override
  State<CreateQrCode> createState() => _CreateQrCodeState();
}

class _CreateQrCodeState extends State<CreateQrCode> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Screenshot(
                    controller: AppCubit.get(context).screenshotController,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromARGB(150, 50, 50, 50),
                                offset: Offset(1, 2),
                                blurRadius: 15,
                                spreadRadius: 2)
                          ]),
                      child: Column(
                        children: [
                          Text(
                            AppCubit.get(context).nameOfAttendee == ''
                                ? ''
                                : 'Name: ${AppCubit.get(context).nameOfAttendee}',
                          ),
                          QrImage(
                            backgroundColor: Colors.white,
                            data: AppCubit.get(context).idGenerated,
                            size: 200,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // QrImage(
                  //   data: AppCubit.get(context).dataConverted.text,
                  //   backgroundColor: Colors.white,
                  //   size: 100,
                  // ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Name'),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller: AppCubit.get(context).dataConverted,
                          onChanged: (data) {
                            AppCubit.get(context).changeName(data);
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            // suffixIcon: IconButton(
                            //   icon: const Icon(Icons.send),
                            //   onPressed: () {
                            //     AppCubit.get(context)
                            //         .convertTextToQRImage(context);
                            //   },
                            // ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('ID       '),
                      SizedBox(child: Text(AppCubit.get(context).idGenerated)),
                      IconButton(
                          onPressed: () {
                            AppCubit.get(context).putGeneratedIDToQRCode();
                          },
                          icon: const Icon(Icons.create))
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            AppCubit.get(context).createQRCode(context);
                          },
                          child: const Text('Create QR Code & Save QR Code Image')),

                    ],
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
