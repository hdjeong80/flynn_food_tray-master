import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_tray/Contants/Enums.dart';
import 'package:food_tray/Contants/colors.dart';
import 'package:food_tray/Screens/QA/QAScreen.dart';
import 'package:food_tray/Screens/modal/UserModal.dart';
import 'package:food_tray/Widgets/BottomBar.dart';
import 'package:food_tray/Widgets/PriceCard.dart';
import 'package:food_tray/Widgets/TextWidget.dart';
import 'package:hand_signature/signature.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_tray/Screens/modal/UserModal.dart';

import '../../Contants/colors.dart';
import '../../Widgets/TextWidget.dart';
import 'package:intl/intl.dart';

var bankOptions = [
  '기업',
  '국민',
  '외환',
  '수협',
  '농협',
  '우리',
  'SC제일',
  '씨티',
  '광주',
  '제주',
  '전북',
  '경남',
  '새마을',
  '신협',
  '우체국',
  '하나',
  '신한',
  '대구',
  '부산',
  '카카오',
];

var cardOptions = [
  'BC카드',
  'KB카드',
  'NH카드',
  '수협카드',
  '한미카드',
  '우리카드',
  '씨티카드',
  '외환카드',
  '제주카드',
  '광주은행',
  '전북카드',
  '산은캐피탈',
  '주택비자',
  '하나SK카드',
  '삼성카드',
  '신한카드',
  '현대카드',
  '롯데카드',
  '해외VISA',
  '해외MASTER',
  '해외JCB',
  '신세계한미',
  '해외다이너스',
  '해외아멕스',
  '신협체크',
];

class SubscribeScreen extends StatefulWidget {
  final bool cms;
  final UserModal userModal;
  SubscribeScreen(this.cms, this.userModal);

  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  bool cms;

  bool _loading = false;
  String secondRadioVal = "";

  final ScrollController _scrollController = ScrollController();

  final _handSignatureControl = HandSignatureControl(
    threshold: 1.0,
    smoothRatio: 1,
    velocityRange: 1.0,
  );

  bool showSignpad = false;
  bool isSigning = false;

  @override
  void initState() {
    _isAgree = false;
    cms = widget.cms;
    showSignpad = false;
    isSigning = false;
  }

  final formKey = GlobalKey<FormBuilderState>();
  final globalKey = GlobalKey();
  firebase_storage.UploadTask uploadTask;
  List<firebase_storage.UploadTask> _uploadTasks = [];

  bool _isAgree = false;

  @override
  Widget build(BuildContext context) {
    bool isSangDangPlace = (widget.userModal.place == '2') ? true : false;
    print(widget.userModal.Email);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomBar(
          containerHeight: height * 0.10,
          textHeight: height * 0.03,
          text: '신청서 전송하기',
          onPressedFunction: () async {
            if (!_isAgree) {
              String _msg = '모든 내용을 읽었음에 동의 체크가 필요합니다.';
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('알림'),
                      content: Text(_msg),
                      actions: [
                        TextButton(
                          child: Text(
                            '확인',
                            style:
                                TextStyle(color: greenColor, letterSpacing: 2),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  });
            } else if ((!showSignpad) || (!_handSignatureControl.isFilled)) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('알림'),
                      content: Text('확인 서명이 필요합니다.'),
                      actions: [
                        TextButton(
                          child: Text(
                            '확인',
                            style:
                                TextStyle(color: greenColor, letterSpacing: 2),
                          ),
                          onPressed: () {
                            setState(() {
                              showSignpad = true;
                            });
                            Future.delayed(Duration(milliseconds: 300)).then(
                              (value) => _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              ),
                            );
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  });
            } else {
              formKey.currentState.save();
              if (await formKey.currentState.validate()) {
                await saveNotice(formKey.currentState.value);
              }
            }
          },
        ),
        appBar: AppBar(
          centerTitle: true,
          title: TextWidget(
            text: 'CMS 가입신청서 작성',
            style: TextStyle(
              color: lightBlackColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: blackColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: isSigning
                ? NeverScrollableScrollPhysics()
                : AlwaysScrollableScrollPhysics(),
            child: RepaintBoundary(
              key: globalKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.08,
                      right: width * 0.08,
                      top: width * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: '서비스 월 이용료',
                          style: TextStyle(
                            color: blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Divider(color: grayColor),
                        PriceCard(),
                      ],
                    ),
                  ),
                  Divider(
                    color: grayColor,
                    thickness: 1.5,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            cms = true;
                          });
                        },
                        child: TextWidget(
                          text: 'CMS 자동이체',
                          style: TextStyle(
                            color: cms == false ? grayColor : blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            cms = false;
                          });
                        },
                        child: TextWidget(
                          text: widget.userModal.place == '1' ? '가상계좌' : '카드결제',
                          style: TextStyle(
                            color: cms ? grayColor : blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.08,
                      right: width * 0.08,
                    ),
                    child: FormBuilder(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: '정보, 입력사항 모두 꼼꼼히 기재하여 주시기 바랍니다.',
                            style: TextStyle(
                              color: blackColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 10,
                            ),
                            left: 0.0,
                            right: 0.0,
                          ),
                          Divider(color: grayColor),
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: formField(
                                    '년 / 월 / 일', '신청일', true, "date", true,
                                    readOnly: true,
                                    initialValue: DateFormat("yyyy.MM.dd")
                                        .format(DateTime.now())),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                flex: 3,
                                child: formField(
                                    '월', '무료체험', true, "date1", false),
                              ),
                            ],
                          ),
                          TextWidget(
                            text: '어린이집 / 반 / 이름',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: lightBlackColor,
                            ),
                          ),
                          formField('어린이집 명을 입력해 주세요', 'textHeading', false,
                              "txt1", true),
                          formField(
                              '반을 입력해 주세요', 'textHeading', false, "txt2", true),
                          formField('자녀의 이름을 입력해 주세요', 'textHeading', false,
                              "txt3", true),
                          FormBuilderRadioGroup(
                            controlAffinity: ControlAffinity.trailing,
                            activeColor: greenColor,
                            name: 'radio1',
                            validator: FormBuilderValidators.required(context),
                            options: [
                              '신입생',
                              '재원생',
                            ]
                                .map((lang) =>
                                    FormBuilderFieldOption(value: lang))
                                .toList(growable: false),
                          ),
                          TextWidget(
                            text: '원내 다자녀 여부',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: lightBlackColor,
                            ),
                            left: 0.0,
                          ),
                          FormBuilderRadioGroup(
                            onChanged: (e) {
                              print(e);
                              setState(() {
                                secondRadioVal = e;
                              });
                            },
                            controlAffinity: ControlAffinity.trailing,
                            activeColor: greenColor,
                            name: 'radio2',
                            validator: FormBuilderValidators.required(context),
                            options: [
                              '있음',
                              '없음',
                            ]
                                .map((lang) =>
                                    FormBuilderFieldOption(value: lang))
                                .toList(growable: false),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if ("없음" != secondRadioVal)
                            Column(
                              children: [
                                formField('반을 입력해 주세요', 'textHeading', false,
                                    "txt6", "없음" != secondRadioVal),
                                formField('자녀의 이름을 입력해 주세요', 'textHeading',
                                    false, "txt7", "없음" != secondRadioVal),
                              ],
                            ),
                          formField(
                              '신청인의 성명을 입력해 주세요', '신청인 성명', true, "name", true),
                          formField(
                              '휴대폰 번호를 입력해 주세요', '휴대폰 번호', true, "phone", true),
                          if (cms || (isSangDangPlace))
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // formField(
                                //     '은행명을 입력해 주세요', '은행명', true, "bank", cms),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: isSangDangPlace ? '카드사' : '은행명',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: lightBlackColor,
                                      ),
                                    ),
                                    FormBuilderDropdown(
                                      // initialValue: '',
                                      name: 'bank',
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                          color: grayColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        border: OutlineInputBorder(),
                                        labelText: isSangDangPlace
                                            ? '카드사를 선택해 주세요'
                                            : '은행을 선택해 주세요',
                                      ),
                                      allowClear: true,
                                      validator: FormBuilderValidators.compose(
                                        [
                                          true
                                              ? FormBuilderValidators.required(
                                                  context,
                                                  errorText: '이 필드는 필수입니다')
                                              : FormBuilderValidators.notEqual(
                                                  context, "~~~~~~~~~~~~~~~~"),

                                          // FormBuilderValidators.(context),
                                        ],
                                      ),
                                      items: (isSangDangPlace
                                              ? cardOptions
                                              : bankOptions)
                                          .map((bank) => DropdownMenuItem(
                                                value: bank,
                                                child: Text('$bank'),
                                              ))
                                          .toList(),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),

                                formField(
                                    isSangDangPlace
                                        ? '카드번호를 입력해 주세요'
                                        : '계좌번호를 입력해 주세요',
                                    isSangDangPlace ? '카드번호' : '자동이체 계좌번호',
                                    true,
                                    "accountnumber",
                                    cms),
                                formField(
                                    isSangDangPlace
                                        ? '카드 소유주 이름을 입력해 주세요'
                                        : '예금주 명을 입력해 주세요',
                                    isSangDangPlace ? '카드 소유주' : '예금주',
                                    true,
                                    "accountowner",
                                    cms),
                                formFieldDate(
                                    isSangDangPlace
                                        ? '카드 유효기간을 입력해 주세요'
                                        : '예금주의 생년월일을 입력해 주세요',
                                    isSangDangPlace ? '카드 유효기간' : '예금주 생년월일',
                                    true,
                                    "birth",
                                    true),
                                if (!isSangDangPlace)
                                  TextWidget(
                                    text: '증권계좌, 산업은행 계좌는 CMS 업체에 등록이 불가합니다.',
                                    style: TextStyle(
                                      color: blackColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          Divider(color: grayColor, thickness: 2.5),
                          // TextWidget(
                          // TextWidget(
                          //   text:
                          //       '코로나19로 인해 긴급보육시 15일미만 등원은 일할계산됩니다. 15일 이상 등원은 정상결제됩니다.',
                          //   style: TextStyle(
                          //     color: blackColor,
                          //     fontSize: 12,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          TextWidget(
                            text: '결제금액 및 결제일',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: lightBlackColor,
                            ),
                            left: 0.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: '결제금액 : 월 ',
                                  style: TextStyle(
                                    color: blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '10,000원',
                                      style: TextStyle(
                                        color: greenColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              if (cms)
                                RichText(
                                  text: TextSpan(
                                    text: '결제일 : 매달 ',
                                    style: TextStyle(
                                      color: blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '3일',
                                        style: TextStyle(
                                          color: greenColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 25),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            color: Color.fromRGBO(245, 245, 245, 1),
                            child: Column(
                              children: [
                                TextWidget(
                                  text:
                                      ' · 결제(자동이체) 서비스를 통한 요금수납, 관련 민원처리 및 상담요청 응답을 위하여 개인정보 취급 업무를 나이스페이먼츠(주)에 위탁운영하고 있습니다.',
                                  style: TextStyle(
                                    color: Color.fromRGBO(138, 138, 138, 1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                TextWidget(
                                  text:
                                      ' · 자동이체 동의 및 처리결과 안내(휴대폰 문자전송) 송부에동의합니다.',
                                  style: TextStyle(
                                    color: Color.fromRGBO(138, 138, 138, 1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                TextWidget(
                                  text:
                                      ' · 이용요금은 연간 총 등원일수를 기준으로 12개월 평균산출 하였으므로, 월 등원일수와 관계없이 12개월 월별 이용료는 동일합니다. (월정액제)',
                                  style: TextStyle(
                                    color: Color.fromRGBO(138, 138, 138, 1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                TextWidget(
                                  text: ' · 퇴소 및 신청취소시 연락주시면 즉시 철회(환불) 가능합니다.',
                                  style: TextStyle(
                                    color: Color.fromRGBO(138, 138, 138, 1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                TextWidget(
                                  text:
                                      ' · 본 서비스 내용은 해당원과 무관하므로 모든 문의는 식판스토리로 연락 바랍니다.',
                                  style: TextStyle(
                                    color: Color.fromRGBO(138, 138, 138, 1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                TextWidget(
                                  text:
                                      ' · 코로나19로 인해 긴급보육시 15일미만 등원은 일할계산됩니다. 15일 이상 등원은 정상결제됩니다.',
                                  style: TextStyle(
                                    color: Color.fromRGBO(138, 138, 138, 1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                      text: '모든 내용을 읽어보았으며, 동의합니다.',
                                      style: TextStyle(
                                        color: greenColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Checkbox(
                                      activeColor: greenColor,
                                      value: _isAgree,
                                      onChanged: (value) {
                                        setState(() {
                                          _isAgree = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Visibility(
                                  visible: showSignpad,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        width: width,
                                        height: width / 2,
                                        child: HandSignaturePainterView(
                                          onPointerDown: () {
                                            isSigning = true;
                                            setState(() {});
                                          },
                                          onPointerUp: () {
                                            isSigning = false;
                                            setState(() {});
                                          },
                                          control: _handSignatureControl,
                                          color: Colors.black,
                                          width: 1.5,
                                          maxWidth: 3,
                                          type: SignatureDrawType.shape,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.undo),
                                        onPressed: () =>
                                            _handSignatureControl.stepBack(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget formFieldDate(
    String label,
    String textHeading,
    bool text,
    String name,
    bool required,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text)
          TextWidget(
            text: textHeading,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: lightBlackColor,
            ),
          ),
        Theme(
          data: ThemeData.light().copyWith(
            primaryColor: greenColor,
            accentColor: greenColor,
            colorScheme: ColorScheme.light(primary: greenColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: FormBuilderDateTimePicker(
            locale: const Locale('ko', 'KO'),
            name: name,
            inputType: InputType.date,
            format: DateFormat("yyyy.MM.dd"),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: grayColor,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              border: OutlineInputBorder(),
              labelText: label,
            ),
            validator: required
                ? FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: '이 필드는 필수입니다')
                    // FormBuilderValidators.(context),
                  ])
                : FormBuilderValidators.compose([]),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget formField(
      String label, String textHeading, bool text, String name, bool required,
      {bool readOnly, String initialValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text)
          TextWidget(
            text: textHeading,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: lightBlackColor,
            ),
          ),
        FormBuilderTextField(
          initialValue: initialValue ?? "",
          readOnly: readOnly ?? false,
          name: name,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: grayColor,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            border: OutlineInputBorder(),
            labelText: label,
          ),
          validator: FormBuilderValidators.compose([
            required
                ? FormBuilderValidators.required(context,
                    errorText: '이 필드는 필수입니다')
                : FormBuilderValidators.notEqual(context, "~~~~~~~~~~~~~~~~"),

            // FormBuilderValidators.(context),
          ]),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  saveNotice(data) async {
    setState(() {
      _loading = true;
    });

    String Url = await _capturePng();

    Map mp = {
      "Email": widget.userModal.Email,
      "place": widget.userModal.plceEnum == Place.one ? "흥덕/서원/세종" : "상당/청원/충북",
      "cms":
          cms ? "CMS 자동이체" : (widget.userModal.place == '1' ? "가상계좌" : "카드결제"),
      "datetime": DateTime.now(),
      "img": Url,
      "index": await getCurrIndex()
    };
    mp.addAll(data);
    print(widget.userModal.Email);

    await FirebaseFirestore.instance
        .collection("subscription")
        .add(Map.from(mp));
    setState(() {
      _loading = false;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      // formKey.currentState.dispose();
      Navigator.pop(context);
    });
  }

  Future<String> _capturePng() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 2);
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    Image.network(pngBytes.toString());

    String url = await uploadFile(pngBytes, context, widget.userModal.Email);
    print(url);

    return url;
    // FirebaseStorage.instance.app.
  }

  /// The user selects a file, and the task is added to the list.
  ///
  ///

  Future<String> uploadFile(Uint8List file, context, email) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));
      return null;
    }

    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = getStorageRef(email);

    final metadata = firebase_storage.SettableMetadata(
      contentType: 'image/jpeg',
    );

    uploadTask = ref.putData(file, metadata);

    Stream<TaskSnapshot> stream = uploadTask.asStream();

    stream.forEach((element) async {
      double percentTransfer =
          (element.bytesTransferred * 100) / element.bytesTransferred;

      print(percentTransfer.toString());
      if (percentTransfer == 100) {}
    });

    String url;
    await uploadTask.whenComplete(() async {
      url = await uploadTask.snapshot.ref.getDownloadURL();
    });

    return url;
  }

  getStorageRef(email) {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('subscription')
        .child(email)
        .child('/${DateTime.now().millisecondsSinceEpoch}image.jpg');
    return ref;
  }

  Future<int> getCurrIndex() async {
    QuerySnapshot doclst =
        await FirebaseFirestore.instance.collection("subscription").get();

    int max = 0;
    doclst.docs.forEach((element) {
      int index = element.data()["index"] ?? 0;

      print(max);

      if (max <= index) max = index + 1;
    });

    print(max);
    return max;
  }
}
