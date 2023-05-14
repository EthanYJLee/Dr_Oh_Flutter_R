import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_oh_app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static Future<UserModel?> loginUserByUid(String uid) async {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();

    if (data.size == 0) {
      return null;
    } else {
      return UserModel.fromJson(data.docs.first.data());
    }
  }

  static Future<bool> signup(UserModel user) async {
    try {
      await FirebaseFirestore.instance.collection('users').add(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<UserModel?> loginUserById(String id, String pw) async {
    final prefs = await SharedPreferences.getInstance();
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .where('password', isEqualTo: pw)
        .get();

    // Document id 가져오기
    // data.docs.first.id;

    if (data.size == 0) {
      return null;
    } else {
      prefs.setString('id', id);
      return UserModel.fromJson(data.docs.first.data());
    }
  }

  static Future<UserModel?> checkId(String id) async {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .get();

    if (data.size == 0) {
      return null;
    } else {
      return UserModel.fromJson(data.docs.first.data());
    }
  }

  // Desc: 사용자 정보 가져오기
  // Date: 2023-01-12

  
  Future<UserModel> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String id = (prefs.getString('id') ?? "");
    var user = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .get();
    var data = user.docs.first.data();

    return UserModel.fromJson(data);
  }

  // Desc: 사용자 정보 수정
  // Date: 2023-01-12
  // Date: 2023-03-12

  updateUser(String name, String pw, String email, String birthdate) async {
    final prefs = await SharedPreferences.getInstance();
    String id = (prefs.getString('id')!);
    var docs1 = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .get();
    var docs2 = docs1.docs.first.id;

    FirebaseFirestore.instance
        .collection('users')
        .doc(docs2)
        .update({'password': pw, 'birthdate': birthdate, 'email': email});
  }

  //Desc: 사용자 신체 정보 수정
  //Date: 2023-01-12
  addAction(String height, String weight) async {
    final prefs = await SharedPreferences.getInstance();
    String id = (prefs.getString('id') ?? "");
    var docs1 = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .get();
    var docs2 = docs1.docs.first.id;
    FirebaseFirestore.instance
        .collection('users')
        .doc(docs2)
        .update({'height': height, 'weight': weight});
  }

  // Desc: 회원 탈퇴
  // Date: 2023-01-12
  deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    String id = (prefs.getString('id') ?? "");
    var docs1 = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .get();
    var docs2 = docs1.docs.first.id;

    FirebaseFirestore.instance.collection('users').doc(docs2).delete();
  }
}
