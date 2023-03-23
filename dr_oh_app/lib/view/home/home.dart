import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_oh_app/components/logout_btn.dart';
import 'package:dr_oh_app/components/news_api.dart';
import 'package:dr_oh_app/model/body_info_model.dart';
import 'package:dr_oh_app/model/name_model.dart';
import 'package:dr_oh_app/model/news_model.dart';
import 'package:dr_oh_app/model/user.dart';
import 'package:dr_oh_app/repository/localdata/user_repository.dart';
import 'package:dr_oh_app/view/home/all_checkup_history.dart';
import 'package:dr_oh_app/view/home/body_info.dart';
import 'package:dr_oh_app/view/home/checkup_history.dart';
import 'package:dr_oh_app/view/home/hospital_visit.dart';
import 'package:dr_oh_app/view/home/medication.dart';
import 'package:dr_oh_app/view/mypage/edit_member_info.dart';
import 'package:dr_oh_app/viewmodel/checkup_history_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //** News API
  List<NewsModel> news = [];
  bool isLoading = true;
  NewsAPI newsAPI = NewsAPI();
  late String hasBodyInfo = '입력하러 가기';
  Future initNews() async {
    news = await newsAPI.getNews();
  }
  // News API */

  CheckupHistoryViewModel _checkupHistoryViewModel = CheckupHistoryViewModel();
  late String id = '';

  // Desc: shared preferences 받기
  // Date: 2023-01-10
  _initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();

    _initSharedPreferences();
    initNews().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  // Desc: Calendar Date Picker
  // 검진기록이 있는 날짜 선택, 조회용
  // 2023-01-07, youngjin lee
  Widget _calendar() {
    DateTime selectedDate = DateTime.now();
    return Column(
      children: [
        Column(
          children: [
            SizedBox(
              height: 300,
              child: CalendarDatePicker(
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                onDateChanged: ((value) {
                  selectedDate = value;
                }),
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            Get.to(
              () => CheckupHistory(),
              arguments: selectedDate,
            );
          },
          child: const Text(
            '검진기록 조회',
          ),
        )
      ],
    );
  }

  // Desc: 홈화면 섹션 구분 박스
  // 2023-01-07, youngjin lee
  BoxDecoration _borderBox() {
    return BoxDecoration(
      border: Border.all(
        style: BorderStyle.solid,
        width: 0.3,
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
    );
  }

  Widget _sizedBox() {
    return const SizedBox(
      height: 20,
    );
  }

  // Desc: 각 박스 타이틀
  // Date: 2023-01-09
  Widget _head(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffAACB73),
          borderRadius: BorderRadius.circular(5),
        ),
        width: Get.width / 2.2,
        height: 30,
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _newsHead(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffAACB73),
          borderRadius: BorderRadius.circular(5),
        ),
        width: Get.width / 1.1,
        height: 30,
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Desc: 버튼 style
  Widget _button(dynamic path, String title) {
    return ElevatedButton(
      onPressed: () {
        Get.to(path);
      },
      child: Text(
        title,
      ),
    );
  }

  // Desc: Health 카테고리 기사 헤드라인 (NewsAPI)
  // Date: 2023-01-09
  Widget _news() {
    return Container(
      decoration: _borderBox(),
      height: 120,
      width: Get.width / 1.1,
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [CircularProgressIndicator()],
            )
          : Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: news.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 200,
                          width: 150,
                          padding: const EdgeInsets.all(5),
                          child: Card(
                            elevation: 2,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AlertDialog(
                                          scrollable: true,
                                          title: Text(news[index].title),
                                          content:
                                              Text(news[index].description),
                                        ),
                                      ],
                                    );
                                  }),
                                );
                              },
                              child: Column(
                                children: [
                                  Text(
                                    news[index].title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    maxLines: 5,
                                  ),
                                  Text(
                                    news[index].description,
                                    maxLines: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
    );
  }

  // Desc: welcome 위젯 이름
  // Date: 2023-01-10
  Widget _getName(DocumentSnapshot doc) {
    final user = NameModel(name: doc['name']);
    return ListTile(
        title: Text(
      '${user.name}님 건강한 하루 되세요',
    ));
  }

  // Desc: 신체정보 받아오기
  // Date: 2023-01-11
  Widget _getBodyinfo(DocumentSnapshot doc) {
    final bodyinfo = doc.data().toString().contains('height')
        ? BodyInfoModel(
            id: doc['id'],
            height: doc['height'],
            weight: doc['weight'],
          )
        : BodyInfoModel(id: '', height: '', weight: '');
    return ListTile(
      title: bodyinfo.height.toString().isNotEmpty
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '키 : ${bodyinfo.height}cm',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '몸무게 : ${bodyinfo.weight}kg',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: const [
                Text(
                  '입력된 신체정보가 없습니다.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E0FF),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('HOME'),
        elevation: 1,
        actions: const [LogoutBtn()],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: _borderBox(),
                  width: 350,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 60,
                        width: 250,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('id', isEqualTo: id)
                              .snapshots(),
                          builder: ((context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final documents = snapshot.data!.docs;

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: documents
                                      .map((e) => _getName(e))
                                      .toList(),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 30,
                          width: 20,
                          child: TextButton(
                            onPressed: () async {
                              UserRepository userRep = UserRepository();
                              UserModel user = await userRep.getUserInfo();
                              Get.to(EditMemberInfo(user: user));
                            },
                            child: Row(
                              children: const [
                                Text('수정하기'),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _sizedBox(),
              Container(
                decoration: _borderBox(),
                height: 40,
                width: 350,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StreamBuilder(
                      stream: _checkupHistoryViewModel.stream,
                      builder: (context, snapshot) {
                        return Text(
                          // '마지막 검진일은 ${_checkupHistoryViewModel.date.toString().substring(0, 10)} 입니다.',
                          '최근 검진기록이 없습니다',

                          style: const TextStyle(fontSize: 14),
                        );
                      },
                    ),
                    TextButton(
                        onPressed: () {
                          Get.to(const AllCheckupHistory());
                        },
                        child: const Text(
                          '전체기록 보기',
                          style: TextStyle(color: Colors.black),
                        )),
                  ],
                ),
              ),
              _sizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      _head('나의 신체정보'),
                      const SizedBox(height: 3),
                      Container(
                        decoration: _borderBox(),
                        height: 200,
                        width: Get.width / 2.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .where('id', isEqualTo: id)
                                    .snapshots(),
                                builder: ((context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    final documents = snapshot.data!.docs;
                                    hasBodyInfo = '정보 수정';

                                    return ListView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: documents
                                          .map((e) => _getBodyinfo(e))
                                          .toList(),
                                    );
                                  }
                                }),
                              ),
                            ),
                            _button(const BodyInfo(), hasBodyInfo),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      _head('이력조회'),
                      const SizedBox(height: 3),
                      Container(
                        decoration: _borderBox(),
                        height: 100,
                        width: Get.width / 2.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '최근 내원이력',
                              style: TextStyle(fontSize: 20),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Get.to(HospitalVisit());
                              },
                              child: const Text(
                                '조회',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: _borderBox(),
                        height: 100,
                        width: Get.width / 2.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '최근 투약이력',
                              style: TextStyle(fontSize: 20),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Get.to(Medication());
                              },
                              child: const Text(
                                '조회',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _sizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      _newsHead('뉴스'),
                      const SizedBox(
                        height: 3,
                      ),
                      _news(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
