class CheckupHistoryModel {
  final DateTime checkupDate;
  final String diseaseName;
  final int result;

  CheckupHistoryModel(
      {required this.checkupDate,
      required this.diseaseName,
      required this.result});

  DateTime get date => checkupDate;
  String get name => diseaseName;
  // int get result => result;
}
