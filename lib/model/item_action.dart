import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wewish/model/item_user.dart';

class ActionItem {
  UserItem actionUser;
  DateTime actionDate;
  ActionStatus actionStatus; //

  ActionItem(this.actionUser, this.actionDate, this.actionStatus);

  ActionItem.fromJson(Map<String, dynamic> json)
      : actionUser = json['actionUser'] == null ? UserItem() : UserItem.fromJson(json['actionUser']),
        actionDate = json['actionDate'] == null
            ? DateTime.now()
            : (json['actionDate'] as Timestamp).toDate(),
        actionStatus = json['actionStatus'] == null
            ? ActionStatus.none
            : ActionStatus.from(json['actionStatus'] as String);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'actionUser': actionUser.toJson(),
    'actionDate': actionDate,
    'actionStatus': actionStatus.name,
  };

}

enum ActionStatus {
  none, book, present, bookCancel, presentCancel, given;

  String get label {
    switch (this) {
      case none : return '예약';
      case ActionStatus.book:
        return '예약';
      case ActionStatus.present:
        return '선물';
      case ActionStatus.given:
        return '선물완료';
      case ActionStatus.bookCancel:
        return '예약취소';
      case ActionStatus.presentCancel:
        return '선물취소';
    }
  }

  static ActionStatus from(String name) {
    for (ActionStatus status in ActionStatus.values) {
      if (status.name == name) {
        return status;
      }
    }
    return ActionStatus.none;
  }

}