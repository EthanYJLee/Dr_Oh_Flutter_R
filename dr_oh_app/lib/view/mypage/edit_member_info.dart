import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_oh_app/app.dart';
import 'package:dr_oh_app/components/logout_btn.dart';
import 'package:dr_oh_app/components/message_popup.dart';
import 'package:dr_oh_app/model/user.dart';
import 'package:dr_oh_app/repository/localdata/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditMemberInfo extends StatefulWidget {
  final UserModel user;
  const EditMemberInfo({super.key, required this.user});

  @override
  State<EditMemberInfo> createState() => _EditMemberInfoState();
}

class _EditMemberInfoState extends State<EditMemberInfo> {
  late List<String> _dropdownList = [
    'naver.com',
    'gmail.com',
    'daum.net',
    '직접 입력'
  ];
  late String _selectedDropdown = 'naver.com';
  RegExp idpwReg = RegExp(r"^[0-9a-z]{8,}$");
  RegExp emailReg = RegExp(r"^[0-9a-z]+$");

  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  late String id = '';
  late bool correctpw = true;
  late bool pwcheck = true;
  late bool correctEmail = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSharedPreferences();
    // Desc: home에서 받은 유저 정보 화면에 표시
    // Date: 2023-03-12
    // youngjin
    idController.text = widget.user.id.toString();
    dateController.text = widget.user.birthdate.toString();
    emailController.text = widget.user.email.toString();
    nameController.text = widget.user.name.toString();
  }

  _initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = (prefs.getString('id')!);
    });
  }

// -------------------------Widget-------------------------

// Desc: 회원정보 수정 항목 + 텍스트필드 조인
// Date: 2023-01-09
  Widget _joinText(String txt, dynamic tf) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          txt,
          style: const TextStyle(fontSize: 18),
        ),
        tf,
      ],
    );
  }

// Desc: 이름 TextField (수정 불가)
// Date: 2023-01-10
// Date: 2023-03-12
  Widget _editName(String hint) {
    return SizedBox(
        height: 70,
        width: Get.width / 2.5,
        child: TextField(
          controller: nameController,
          readOnly: true,
          textAlign: TextAlign.center,
          decoration: InputDecoration(hintText: hint),
          onChanged: (value) {},
        ));
  }

// Desc: 아이디 TextField (수정 불가)
// Date: 2023-01-10
// Date: 2023-03-12
  Widget _editID(String hint) {
    return SizedBox(
      height: 70,
      width: Get.width / 2.5,
      child: TextField(
        controller: idController,
        readOnly: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }

// Desc: 비밀번호 수정 TextField
// Date: 2023-01-10
  Widget _editPW(String hint) {
    return SizedBox(
      height: 70,
      width: Get.width / 2.5,
      child: TextField(
        controller: passwordController1,
        onChanged: (value) {
          if (idpwReg.hasMatch(value.trim())) {
            setState(() {
              correctpw = true;
            });
          } else {
            setState(() {
              correctpw = false;
            });
          }
          if (value.trim().isNotEmpty) {
            setState(() {
              correctpw = true;
            });
          }
        },
        obscureText: true,
        textAlign: TextAlign.center,
      ),
    );
  }

// Desc: 비밀번호 확인 TextField
// Date: 2023-01-10
  Widget _confirmPW(String hint) {
    return SizedBox(
      height: 70,
      width: Get.width / 2.5,
      child: TextField(
        controller: passwordController2,
        onChanged: (value) {
          if (value == passwordController1.text.trim()) {
            setState(() {
              pwcheck = true;
            });
          } else {
            setState(() {
              pwcheck = false;
            });
          }
        },
        obscureText: true,
        textAlign: TextAlign.center,
      ),
    );
  }

// Desc: 생년월일 수정 TextField
// Date: 2023-01-10
  Widget _editBirthday(String hint) {
    return SizedBox(
      height: 70,
      width: Get.width / 2.5,
      child: TextField(
        controller: dateController,
        readOnly: true,
        onTap: () {
          _showDatePickerPop(hint);
        },
        textAlign: TextAlign.center,
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }

  // Desc: 생년월일 DatePickerDialog
  // Date: 2023-01-10
  void _showDatePickerPop(String hint) async {
    Future<DateTime?> selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.parse(hint), //초기값
      firstDate: DateTime(1950), //시작일
      lastDate: DateTime(2023), //마지막일
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(), //다크 테마
          child: child!,
        );
      },
    );

    selectedDate.then((dateTime) {
      setState(() {
        dateController.text = dateTime.toString().substring(0, 10);
      });
    });
  }

// Desc: 이메일 수정 TextField
// Date: 2023-01-10
  Widget _editEmail(String hint) {
    return SizedBox(
      height: 70,
      width: Get.width / 2,
      child: TextField(
        controller: emailController,
        onChanged: (value) {
          if (emailController.text.trim().isEmail) {
            setState(() {
              correctEmail = true;
            });
          } else {
            setState(() {
              correctEmail = false;
            });
          }
        },
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.center,
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('회원정보 수정'),
          elevation: 1,
          actions: const [LogoutBtn()],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Container(
                  width: 350,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            _joinText(
                                '이름', _editName(widget.user.name.toString())),
                            _joinText(
                                '아이디', _editID(widget.user.id.toString())),
                            _joinText('새 비밀번호', _editPW('')),
                            _joinText('비밀번호 확인', _confirmPW('')),
                            _joinText(
                                '생년월일',
                                _editBirthday(widget.user.birthdate
                                    .toString()
                                    .substring(0, 10))),
                            _joinText('이메일',
                                _editEmail(widget.user.email.toString())),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          (correctpw && pwcheck && correctEmail)
                              ? _dialog()
                              : _errorDialog();
                        });
                      },
                      child: const Text('수정')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Desc: Dialog
  //Date: 2023-01-12
  _dialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => MessagePopup(
        title: '시스템',
        message: '회원정보를 수정하시겠습니까?',
        okCallback: () {
          UserRepository userRep = UserRepository();
          userRep.updateUser(nameController.text, passwordController1.text,
              emailController.text, dateController.text);

          setState(() {
            showDialog(
                context: context,
                builder: (context) => MessagePopup(
                    title: '수정완료',
                    message: '회원정보가 수정되었습니다',
                    okCallback: () {
                      Get.to(const App());
                    }));
          });
        },
        cancelCallback: () {
          Get.back();
        },
      ),
    );
  }

  _errorDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => MessagePopup(
        title: '정보 확인',
        message: '입력하신 정보를 확인해주세요',
        okCallback: () {
          UserRepository usrr = UserRepository();
          usrr.updateUser(nameController.text, passwordController1.text,
              emailController.text, dateController.text);
          Get.back();
        },
        cancelCallback: () {
          Get.back();
        },
      ),
    );
  }
}
