import 'package:gsheets/gsheets.dart';

import '../../../models/attendee.dart';

class AttendeeSheetApi {
  static const _spreadSheetId = '1yOY7WfKDKb3PkfY31qz5kksLZbrp_QdeOUWC2mRPuoI';
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "gsheets-357722",
  "private_key_id": "15394ac6a0be7005f3ccbffaa3c935f49e4859c0",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC16stFgMKwZDcJ\nu3kkdL2/DFaNwYVk9jF1lKk05ma5ymUtkDy8zAIkKO/r847c25cb8ixbBbnuwaLq\nu5XvMtXcLtMncpi/loc6EBBBp0US0j2eBqmNmqOKzjls0kYR8D/l0izw+5NWmrvF\ndeLkVZAWuo4QH6tXDxLLRyQt+a7o8Q3NGp0EW9A8Z63un58RLXmvq6dwNJ/UcyWl\nB06Z79Df7LHAUjQw92GI6GO7CAg5f4YiaRLkBOKQoL+yKLY3HeMeIQz/BaQ1PXoQ\ny8UwfwddY0qKtQG39OR5bUNDjq+r0C0m9fLqTCWmlVDBJngIX8xQHyUrmGu5kt5S\nisB4AW2PAgMBAAECggEABnP/+KmOR5iQwvWw4Mivprjv9xLrZmOqxHuBdxe3Od75\nefw47sZtAeBeKvqfv2IML/1hlv3b8EYu48wMtHZKHNDEsgx2+6xLFrpDAV3HACK0\nYv8tpdo28/GjiJBWZrJb15+QYPxRVcLsHh9qo9GfMal+6HaDtBnS2uuUV54GlyaY\nIEcAwxeOILiBEdlHR3AcvII+O1PLAoEsuy9Axl3+DD1Bjk8pg57MJzcbhXepLqAa\n68MwS9cHutPyvvIMVNRIy60krZ6m3bjimK//oxRy09CK8FzSGu3n/2GB6aENGZu7\nkXXmkFtYpTuKUkR0Bw9Q+dw1mxyZysh8o/hFle76KQKBgQD7/FSfy3Gec129fzEL\nTvhfOkuVpBv1qb72GfuvUqDIHaNgMuJ0TX++5z0OU1q8ocCQJKJJZT8VffzdTPmF\nIFh0SXoX1Tj8RoMTjMXF3YK6QIcLZF/tawdAeBnROYszDs6oIk3p2lmkZPRaaWA6\nOZW33dG3KSJ4NarUDMOQ3BY82QKBgQC40LRBgCRJ7wHMPxFTLKPo5GhZW63gWeyM\nQQ5REOeeln0w2SRaqMeVAcn9tiu3rlnySRW+LGx65r0Z3e9xRQQJbKsicp8lwX9F\ngP4am+XK2JP9S0eZ7qaLTKFSR1poRWr6J30MKBSwNn6JZQ16i0noJN6LgmcQgTWS\nRc2vRpgcpwKBgQD79XDAXvJ61ywyII3vmsTqoyWUuQVj/Jj/BzgMNHij4E7OD9Mz\nK5LCVgFM47fkyW/8MUU8UkpjuRgwR5lvrcoEbLvyPLfAONkzoRzYHgdrKL5fe7wX\nb19O7UgTVpCDOxkUMUjqvfPIV1GlXZxkW9QCh3/8vtrCjBcF9MVPgWGS8QKBgQCG\n1VS8+MUA34tbPKPiH45RydnLX5SCOnjWdlwAjqm8zKP3MGRSdBJvxodcPzyz3FKo\n7eMcBIL8QzyxE3auF6DzU0GjdyZewEWfKpW4SgajL9EAGZzaU/9TX4vOYFo3+nUq\nngagCNnXGVrF2GC2B8rav5NRCskwhGPWHHEMMB+nvwKBgQD6T0E6ZG3AK03q0W0a\nRLOYzUHuleFPd3pmTu6hVvyuAa0EMayPsxw1ym6yFwGatigO+V6Y9yZpr9lg+m5f\nTa4Impd5ZUSO+vnFtNkEctCd4dZFeb8h3PGRnwPUYHEPgLy+vZA3NFhuxIl1nFb8\nGSHg1oc56eEzKjQtiok0+eHxog==\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@gsheets-357722.iam.gserviceaccount.com",
  "client_id": "107428718794115462172",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40gsheets-357722.iam.gserviceaccount.com"
}
  ''';
  static final _gSheets = GSheets(_credentials);
  static Worksheet? _attendeeSheets;

  static Future init() async {
    final spreadSheet = await _gSheets.spreadsheet(_spreadSheetId);
    _attendeeSheets = await _getWorkSheet(spreadSheet, title: 'Attendees');
    // final firstRow = AttendeeFields.getFields();
    // _attendeeSheets!.values.insertRow(3, ['2','ahmed','ahmed@gmail.com','01021570316','1'],);
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future<Attendee?> getById(int id) async {
    final spreadSheet = await _gSheets.spreadsheet(_spreadSheetId);
    _attendeeSheets = await _getWorkSheet(spreadSheet, title: 'Users');
    if (_attendeeSheets == null) return null;
    final json = await _attendeeSheets!.values.map.rowByKey(id, fromColumn: 1);

    return json == null ? null : Attendee.fromJson(json);
  }

  static Future<Attendee?> getByName(String id) async {
    final spreadSheet = await _gSheets.spreadsheet(_spreadSheetId);
    _attendeeSheets = await _getWorkSheet(spreadSheet, title: 'Attendees');
    // print(2);
    if (_attendeeSheets == null) return null;
    final json = await _attendeeSheets!.values.map.rowByKey(id, fromColumn: 1);
    // print(3);

    return json == null ? null : Attendee.fromJson(json);
  }

  static Future<List<Attendee>> getAttendees() async {
    final spreadSheet = await _gSheets.spreadsheet(_spreadSheetId);
    _attendeeSheets = await _getWorkSheet(spreadSheet, title: 'Attendees');
    if (_attendeeSheets == null) {
      print('null=>>>>>');
      return <Attendee>[];
    }
    final attendees = await _attendeeSheets!.values.map.allRows();
    print(attendees);
    return attendees!.map(Attendee.fromJson).toList();
  }

  static Future<bool> updateCell(
      {required int id, required String key, required dynamic value}) async {
    final spreadSheet = await _gSheets.spreadsheet(_spreadSheetId);
    _attendeeSheets = await _getWorkSheet(spreadSheet, title: 'Users');
    if (_attendeeSheets == null) return false;
    return _attendeeSheets!.values
        .insertValueByKeys(value, columnKey: key, rowKey: id);
  }

  static Future<bool> updateCellByName(
      {required String name,
      required String key,
      required dynamic value}) async {
    final spreadSheet = await _gSheets.spreadsheet(_spreadSheetId);
    _attendeeSheets = await _getWorkSheet(spreadSheet, title: 'Attendees');
    if (_attendeeSheets == null) return false;
    return _attendeeSheets!.values
        .insertValueByKeys(value, columnKey: key, rowKey: name);
  }

  static Future<bool> insertData({required int id, required String name}) async {
    final spreadSheet = await _gSheets.spreadsheet(_spreadSheetId);
    _attendeeSheets = await _getWorkSheet(spreadSheet, title: 'Users');
    if (_attendeeSheets == null) return false;
    return _attendeeSheets!.values.appendRow([id, name]);
  }
}
