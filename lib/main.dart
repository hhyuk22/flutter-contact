import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; //유저 앱권한 패키지
import 'package:contacts_service/contacts_service.dart'; //유저 연락처 패키지

void main() {
  runApp(
      MaterialApp( //기본테마. 밖으로 빼야 모달 작동함
      home: MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  getPermission() async { //앱 권한요청 함수
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
      var contacts = await ContactsService.getContacts(); //유저 연락처 저장
      name = contacts;
    } else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request();
    }
  }
  @override
  void initState() { //앱 처음 킬 때 바로 실행
    super.initState();
    getPermission(); //함수 실행
  }

  var name = []; //변수 타입 다이나믹

  addName(String newName) {
    setState(() {
      // Contact 객체 생성 후 리스트에 추가
      name.add(Contact(
        givenName: newName, // 이름
      ));
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold( //상중하단 구분 위젯
        appBar: AppBar( title: Text('내 친구 목록')),
        body: ListView.builder( //리스트 동적 반복
            itemCount: name.length,
            itemBuilder: (context, i){
              return ListTile( //리턴 뒤에 반복할 위젯
                leading: Icon(Icons.person),
                title: Text( name[i].givenName ?? '이름없음'), //null 체크
              );
            }
        ),
        floatingActionButton: FloatingActionButton( //버튼
            child: Icon(Icons.add),
            onPressed: (){
              showDialog( //모달 창
                  context: context,
                  builder: (context){
                    return DialogUI( addName: addName,);
                  });
            }),
    );
  }
}

class DialogUI extends StatelessWidget { //모달 커스텀 위젯
  DialogUI({Key? key, this.addName }) : super(key: key);
  final addName;
  var inputData = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        height: 200,
        padding: const EdgeInsets.all(16.0), // 모달 전체 여백 설정
        child: Column(
          children: [
            TextField(controller: inputData,),
            TextButton(
                child: Text('완료'),
                onPressed:(){
                  addName(inputData.text);
                } ),
            TextButton(
                child: Text('취소'),
                onPressed:(){ Navigator.pop(context); })
          ],
        ),
      ),
    );
  }
}
