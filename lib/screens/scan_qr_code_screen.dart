import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../models/attendee.dart';
import '../shared/network/google_sheets/api.dart';

class ScanQrCode extends StatefulWidget {
  const ScanQrCode({Key? key}) : super(key: key);

  @override
  State<ScanQrCode> createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;

  @override
  void reassemble() async {
    // TODO: implement reassemble
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
      setState(() {});
    }
    controller!.resumeCamera();
  }

  Attendee? attendee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  controller!.resumeCamera();
                });
              },
              icon: const Icon(Icons.document_scanner_outlined))
        ],
        title: Text(barcode != null ? '${barcode!.code}' : 'scan'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 500,
            width: double.infinity,
            child: QRView(
              key: qrKey,
              onQRViewCreated: (QRViewController controller) {
                setState(() => this.controller = controller);
                controller.scannedDataStream.listen((barcode) {
                  setState(() {
                    this.barcode = barcode;
                    print(barcode);
                  });
                });
              },
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blueAccent,
                borderLength: 20,
                borderRadius: 10,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 50,
            width: 120,
            child: ElevatedButton(
                onPressed: () async {
                  String? data = barcode!.code;
                  print(data);
                  AttendeeSheetApi.getById(int.parse(data ?? '1'))
                      .then((value) async {
                    if (value != null) {
                      attendee = value;
                      if (attendee!.isAttendee == '1') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('User Existed Before')));
                      } else {
                        await AttendeeSheetApi.updateCell(
                            id: attendee!.id, key: 'isAttendee', value: 1);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Done')));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User not Found')));
                    }
                  });
                },
                child: const Text('check')),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}
