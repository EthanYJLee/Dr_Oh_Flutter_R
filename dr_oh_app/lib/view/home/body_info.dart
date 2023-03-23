import 'package:dr_oh_app/components/logout_btn.dart';
import 'package:dr_oh_app/repository/localdata/user_repository.dart';
import 'package:flutter/material.dart';

class BodyInfo extends StatefulWidget {
  const BodyInfo({super.key});

  @override
  State<BodyInfo> createState() => _BodyInfoState();
}

class _BodyInfoState extends State<BodyInfo> {
  // TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  // bool correctAge = false;
  bool correctheight = false;
  bool correctweight = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('신체정보 입력'),
          elevation: 1,
          actions: const [LogoutBtn()],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Desc: 나이를 생년월일로 대체
              // Date: 2023-03-12
              // Padding(
              //   padding: const EdgeInsets.only(left: 100, right: 100),
              //   child: TextField(
              //     controller: ageController,
              //     keyboardType:
              //         const TextInputType.numberWithOptions(decimal: true),
              //     decoration: InputDecoration(
              //       hintText: '나이',
              //       labelText: correctAge ? '' : '나이를 입력하세요',
              //     ),
              //     onChanged: (value) {
              //       if (value.isNotEmpty) {
              //         setState(() {
              //           correctAge = true;
              //         });
              //       } else {
              //         setState(() {
              //           correctAge = false;
              //         });
              //       }
              //     },
              //   ),
              // ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 100, right: 100),
                    child: TextField(
                      controller: heightController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: '키(cm)',
                        labelText: correctheight ? '' : '키를 입력하세요',
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            correctheight = true;
                          });
                        } else {
                          setState(() {
                            correctheight = false;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 100, right: 100),
                    child: TextField(
                      controller: weightController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: '몸무게(kg)',
                        labelText: correctweight ? '' : '몸무게를 입력하세요',
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            correctweight = true;
                          });
                        } else {
                          setState(() {
                            correctweight = false;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  ElevatedButton(
                      onPressed: (correctheight && correctweight)
                          ? () {
                              UserRepository usrr = UserRepository();
                              usrr.addAction(heightController.text.trim(),
                                  weightController.text.trim());
                              _showDialog(context);
                            }
                          : null,
                      child: const Text('저장'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: const Text('입력 결과'),
            content: const Text(
              '입력이 완료되었습니다.',
            ),
            actions: [
              TextButton(
                onPressed: (() {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                }),
                child: const Text(
                  'OK',
                ),
              ),
            ],
          );
        }));
  }
}
