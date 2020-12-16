import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import '../main.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  String token;
  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    token = await _fcm.getToken();

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        waitingListBloc.refetchWaitingList();
      },
      onLaunch: (Map<String, dynamic> message) async {
        waitingListBloc.refetchWaitingList();
      },
      onResume: (Map<String, dynamic> message) async {
        waitingListBloc.refetchWaitingList();
      },
    );
  }
}
