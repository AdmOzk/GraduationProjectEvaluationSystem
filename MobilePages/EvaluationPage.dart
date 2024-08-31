import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evaluation_project/View/pages/EvaluateList.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:evaluation_project/view/components/BottomNavigationBarComponent.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class EvaluationPage extends StatefulWidget {
  final String studentId; // Add studentId as a required parameter
  final String titleProject;
  const EvaluationPage({super.key, required this.studentId, required this.titleProject});

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  bool _alertShown = false;
  /// CheckBox Start
  bool isChecked1 = false,
      isChecked2 = false,
      isChecked3 = false,
      isChecked4 = false,
      isChecked5 = false,
      isChecked6 = false,
      isChecked7 = false,
      isChecked8 = false,
      isChecked9 = false,
      isChecked10 = false,
      isChecked11 = false,
      isChecked12 = false,
      isChecked13 = false,
      isChecked14 = false,
      isChecked15 = false,
      isChecked16 = false,
      isChecked17 = false,
      isChecked18 = false,
      isChecked19 = false,
      isChecked20 = false,
      isChecked21 = false,
      isChecked22 = false,
      isChecked23 = false;
  bool status = false;
  /// CheckBox End

  /// Percent Controller Start
  // Manuel input Start
  TextEditingController percentController_1 = TextEditingController();
  TextEditingController percentController_2 = TextEditingController();
  TextEditingController percentController_3 = TextEditingController();
  TextEditingController percentController_4 = TextEditingController();
  TextEditingController percentController_5 = TextEditingController();
  TextEditingController percentController_6 = TextEditingController();

  // Manuel input End
  // Auth input Start
  int defaultPercentController1 = 15,
      defaultPercentController2 = 40,
      defaultPercentController3 = 15,
      defaultPercentController4 = 10,
      defaultPercentController5 = 10,
      defaultPercentController6 = 10,
      totalGradeToPercent = 0;

  // Auth input End
  /// Percent Controller End

  /// Text Controller Start
  TextEditingController textController_1 = TextEditingController();
  TextEditingController textController_2 = TextEditingController();
  TextEditingController textController_3 = TextEditingController();
  TextEditingController textController_4 = TextEditingController();
  TextEditingController textController_5 = TextEditingController();
  TextEditingController textController_6 = TextEditingController();
  TextEditingController textController_7 = TextEditingController();
  TextEditingController textController_8 = TextEditingController();
  TextEditingController textController_9 = TextEditingController();
  TextEditingController textController_10 = TextEditingController();
  TextEditingController textController_11 = TextEditingController();
  TextEditingController textController_12 = TextEditingController();
  TextEditingController textController_13 = TextEditingController();
  TextEditingController textController_14 = TextEditingController();
  TextEditingController textController_15 = TextEditingController();
  TextEditingController textController_16 = TextEditingController();
  TextEditingController textController_17 = TextEditingController();
  TextEditingController textController_18 = TextEditingController();
  TextEditingController textController_19 = TextEditingController();
  TextEditingController textController_20 = TextEditingController();
  TextEditingController textController_21 = TextEditingController();
  TextEditingController textController_22 = TextEditingController();

  /// Text Controller End

  /// Professor Informations Start
  String professorEmail = "";
  int professorID = 333;
  String professorName = "";
  String professorSurname = "";

  /// Professor Informations End

  /// Databse Access Point Start
  final _firestore = FirebaseFirestore.instance;

  /// Databse Access Point End


  String? _downloadUrl;
  Future<void> _downloadFile(BuildContext context) async {
    await fetchFileUrl();

    if (_downloadUrl != null) {
      try {
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final fileName = _downloadUrl!.split('/').last;
        final filePath = '${appDocDir.path}/$fileName';
        final file = File(filePath);

        // İndirme işlemini başlat
        final downloadTask = FirebaseStorage.instance.refFromURL(_downloadUrl!).writeToFile(file);

        // İndirme işlemi tamamlandıysa
        await downloadTask.whenComplete(() {
          // Dosya indirme geribildirimi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dosya başarıyla indirildi: $filePath')),
          );
          // Linki panoya kopyalama
          Clipboard.setData(ClipboardData(text: _downloadUrl!)); // Linki panoya kopyala
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('İndirme linki kopyalandı: $_downloadUrl')),
          );
        });

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dosya indirilirken hata oluştu: $e')),
        );
      }
    } else {
      // _downloadUrl null ise, kullanıcıya uyarı mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('İndirme linki bulunamadı.')),
      );
    }
  }

  Future<void> fetchFileUrl() async {
    try {
      DocumentReference studentRef = _firestore.collection('0').doc("Project").collection("Projects").doc(widget.studentId);
      DocumentSnapshot documentSnapshot = await studentRef.get();

      if (documentSnapshot.exists) {
        setState(() {
          _downloadUrl = documentSnapshot.get('FileUrl');
          print("Link: ");
          print(_downloadUrl);
        });
      } else {
        setState(() {
          _downloadUrl = 'Document does not exist';
        });
      }
    } catch (e) {
      setState(() {
        _downloadUrl = 'Error fetching FileUrl: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Database Access Point Start

    CollectionReference evaluationProjectRef =
        _firestore.collection("0");
    DocumentReference professorRef = evaluationProjectRef.doc("Professor");
    DocumentReference studentRef = evaluationProjectRef.doc("student");
    CollectionReference academicianRef = professorRef.collection("Academician");
    CollectionReference studentListRef = studentRef.collection("studentList");
    DocumentReference academicianRef_1 = academicianRef.doc("");
    DocumentReference studentRef_1 = studentListRef.doc(widget.studentId);
    DocumentReference evaluationRef = evaluationProjectRef.doc("Evaluation");

    DocumentReference projectStatusRef = _firestore.collection("0").doc("Project").collection("Projects").doc(widget.studentId);


    /// Database Access Point End

    String formattedDateDMY = DateFormat('dd/MM/yyyy').format(DateTime.now());
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: HexColor("#B2CFD1"),
        appBar: AppBar(
          title: const Center(
            child: Text(
              "Evaluation Page",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: HexColor("#988484"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EvaluateList()),
              );
            },
          ),
        ),
        body: Expanded(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(children: [
                // Cardvisit Part
                Container(
                  height: deviceHeight / 4,
                  width: deviceWidth,
                  decoration: BoxDecoration(
                      color: HexColor("#B1ABAB"),
                      borderRadius: BorderRadius.circular(80)),
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Image(
                            image: AssetImage(
                              "lib/assets/images/image-1.png",
                            ),
                            width: 200,
                            height: 200,
                          ),
                          StreamBuilder<DocumentSnapshot>(
                            stream: studentRef_1.snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot asynSnapshot) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${asynSnapshot.data.data()["FirstName"]} ${asynSnapshot.data.data()["LastName"]}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      "${asynSnapshot.data.data()["StudentID"]}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      widget.titleProject,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          )
                        ]),
                  ),
                ),
                // Download Part
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: HexColor("7F3CB4"),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => _downloadFile(context),
                    icon: const Icon(
                      Icons.download,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Download Project',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        HexColor("7F3CB4"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: HexColor("#342E2E"),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Criteria",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                          width: double.infinity,
                          child: Container(
                            color: Colors.yellow,
                          ),
                        ),
                        const Text(
                          "Information of the Instructor",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Name: ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Surname: ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StreamBuilder<DocumentSnapshot>(
                              stream: academicianRef_1.snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot asynSnapshot) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: HexColor("#D9D9D9"),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                    child: Text(
                                      "${asynSnapshot.data.data()["Name"]}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            StreamBuilder<DocumentSnapshot>(
                              stream: academicianRef_1.snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot asynSnapshot) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: HexColor("#D9D9D9"),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                    child: Text(
                                      "${asynSnapshot.data.data()["LastName"]}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(90, 0, 70, 8),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Date: ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  " ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(45, 0, 25, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: HexColor("#D9D9D9"),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                    child: Text(
                                      "${formattedDateDMY}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  child: Checkbox(
                                    value: isChecked1,
                                    onChanged: (val) => {
                                      setState(() {
                                        isChecked1 = val!;
                                      })
                                    },
                                    activeColor: Colors.yellow,
                                    checkColor: Colors.black,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Container(
                                  child: const Text(
                                    "Commitment to impartial evaluation",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Part I
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          height: 2,
                          width: double.infinity,
                          child: Container(
                            color: Colors.yellow,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                          "Part I - Graduation Project Evaluation Form",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 8, 10),
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Checkbox(
                                          value: isChecked2,
                                          onChanged: (val) => {
                                                setState(() {
                                                  isChecked2 = val!;
                                                })
                                              }),
                                    ),
                                    const Text(
                                      "Technical merits %15",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 90,
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: TextFormField(
                                        controller: percentController_1,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: '%15',
                                          hintStyle: const TextStyle(
                                              color: Colors.black),
                                          fillColor: HexColor("#D9D9D9"),
                                          filled: true,
                                        ),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_1,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked3,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked3 = val!;
                                              })
                                            }),
                                    const Flexible(
                                      flex: 8,
                                      child: Text(
                                        "Project design and implementation (realization ratio with respect to its definition) %40",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: TextFormField(
                                        controller: percentController_2,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: '%40',
                                          hintStyle: const TextStyle(
                                              color: Colors.black),
                                          fillColor: HexColor("#D9D9D9"),
                                          filled: true,
                                        ),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_2,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked4,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked4 = val!;
                                              })
                                            }),
                                    const Flexible(
                                      flex: 8,
                                      child: Text(
                                        "Report (completeness and content) %15",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: TextFormField(
                                        controller: percentController_3,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: '%15',
                                          hintStyle: const TextStyle(
                                              color: Colors.black),
                                          fillColor: HexColor("#D9D9D9"),
                                          filled: true,
                                        ),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_3,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked5,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked5 = val!;
                                              })
                                            }),
                                    const Text(
                                      "Presentation %10",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 105,
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: TextFormField(
                                        controller: percentController_4,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: '%10',
                                          hintStyle: const TextStyle(
                                              color: Colors.black),
                                          fillColor: HexColor("#D9D9D9"),
                                          filled: true,
                                        ),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_4,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked6,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked6 = val!;
                                              })
                                            }),
                                    const Text(
                                      "Demo %10",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 160,
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: TextFormField(
                                        controller: percentController_5,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: '%10',
                                          hintStyle: const TextStyle(
                                              color: Colors.black),
                                          fillColor: HexColor("#D9D9D9"),
                                          filled: true,
                                        ),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_5,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked7,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked7 = val!;
                                              })
                                            }),
                                    const Text(
                                      "Papers",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 190,
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: TextFormField(
                                        controller: percentController_6,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: '%10',
                                          hintStyle: const TextStyle(
                                              color: Colors.black),
                                          fillColor: HexColor("#D9D9D9"),
                                          filled: true,
                                        ),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_6,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Part II
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          height: 2,
                          width: double.infinity,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                          "Part II - Graduation Project Checklist",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 8, 10),
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked8,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked8 = val!;
                                              })
                                            }),
                                    const Flexible(
                                      child: Text(
                                        "1. The project contains all the parts that Computer Engineering Department requires (usually Abstract, Acknowledgments, Table of Contents, Introduction, Related Works,..etc. Conclusion, References, any Appendices). Some variation is possible. You may not need a separate chapter for Materials and Methods, for example, and not all projects need Appendices.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_7,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked9,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked9 = val!;
                                              })
                                            }),
                                    const Flexible(
                                      flex: 8,
                                      child: Text(
                                        "2. The Abstract (written last) defines the problem you worked on, clearly states its importance and the method(s) you used to solve it, puts your work into the context of previous work in your field, clearly identifies your findings and their importance, and suggests possible applications. Your unique contribution is clearly delineated. The Abstract literally abstracts the important points in your thesis. It does not merely state what the thesis is about; instead, it summarizes the contents. Finally, your abstract must not exceed the word limit (150 words minimum)",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_8,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked10,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked10 = val!;
                                              })
                                            }),
                                    const Flexible(
                                      child: Text(
                                        "3. You can write the Acknowledgments any time, but most people write them after the bulk of the thesis has been completed so that you know who has been helpful. Gratitude and diplomacy both demand that you start by thanking your thesis committee, naming your advisor first. Then move either to other faculty who were helpful or to the team members or students you worked with before embarking on this solo thesis project. Then thank friends, if you wish, and end by expressing your most heartfelt gratitude to your family, especially to a long-suffering spouse or partner. This section is the only one in which you express much emotion, and it is acceptable here, but don’t overdo it",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_9,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked11,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked11 = val!;
                                              })
                                            }),
                                    const Flexible(
                                      child: Text(
                                        "4. The page numbers in the Table of Contents and List of Tables or Figures are accurate. The titles are specific enough to signal what is included. Check the accuracy of your List of Symbols, Acronyms, and Definitions if you have included any of those.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_10,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked12,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked12 = val!;
                                              })
                                            }),
                                    const Flexible(
                                      child: Text(
                                        "5. The Introduction and Conclusion (written after finishing the chapters detailing your research) expand on the Abstract, going into greater detail than is possible in the short Abstract. The first line of the Introduction states the problem and your contribution to solving it. The Introduction gives an overall picture of the contents of the thesis and usually ends with a brief listing of each chapter’s contents. The Conclusion summarizes your findings and discusses their implications; it often ends by suggesting future work. Anyone who reads the Introduction and the Conclusion has an expanded version of the Abstract and a complete summary of the thesis’s contents.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_11,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked13,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked13 = val!;
                                              })
                                            }),
                                    const Flexible(
                                      child: Text(
                                        "6. The Related Work / State of Art situates your work within the larger context of your field. This chapter explains how your work grew out of earlier, related research and, in doing so, details the major developments and contrasting approaches in your specific field. You make clear what was the seminal work and then explain both chronologically and thematically the important findings that preceded and motivated your research project. You identify key contributions, issues, and disagreements, and you show the “links” between the research findings of others. Throughout the chapter, you indicate clearly why we are reading about a specific reference and how it relates to your own research. This tightly argued chapter forms the basis for understanding and validating the importance of your work. It illustrates your skill as a scholar who can identify key papers in your field and then evaluate them. If your thesis relies heavily on your own previously published papers, you may want to incorporate the Literature Review in the body chapters for each of the papers, so that you have a separate Lit Review for each paper. In any case, however, the Literature Review should be in much greater depth in your thesis than is possible in a short paper written for publication.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_12,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked14,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked14 = val!;
                                              })
                                            }),
                                    const Flexible(
                                      child: Text(
                                        "7. The ongoing chapters contains sufficient details so that someone else could replicate your work. All chronology is clear.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_13,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked15,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked15 = val!;
                                              })
                                            }),
                                    const Flexible(
                                      child: Text(
                                        "8. The body chapters detail your research. The level of detail is sufficient so that your outside reader, who is not intimately familiar with your field, can understand your argument: • What did you do? • Why did you do it? • How did you do it? • What was the result? • Why should we care about what you did? Why is the work important? Those questions must be answered no matter what field you are in. For example, you cannot just string together a bunch of equations and let your reader figure things out. Don’t merely state; explain! You must lead your reader through your reasoning and your actions to your results. You must clearly identify your contributions, including equipment or procedures you designed, as well as your research results.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_14,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked16,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked16 = val!;
                                              })
                                            }),
                                    const Flexible(
                                      child: Text(
                                        "9. Your Bibliography/References (or Works Cited) follows the format acceptable to your field. The Bibliography contains ALL the works cited in your thesis, including visuals, and nothing that is not actually cited. Proofread it for accuracy and consistency.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_15,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked17,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked17 = val!;
                                              })
                                            }),
                                    const Flexible(
                                      child: Text(
                                        "10. You have checked your sentences, paragraphs, sections, and chapters to see if meaning is clear and logically sequential, not to you, but to your outside reader. If you sense that something isn’t clear, believe that it isn’t, and fix it. Ask someone else to read it and note any unclear sentences or sections.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_16,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked18,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked18 = val!;
                                              })
                                            }),
                                    const Flexible(
                                      child: Text(
                                        "11. You have checked for logical flow from sentence to sentence, paragraph to paragraph, section to section, chapter to chapter. You have topic sentences that signal a paragraph’s content. Your introductions to each section and chapter signal their contents to the reader",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_17,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked19,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked19 = val!;
                                              })
                                            }),
                                    const Flexible(
                                      child: Text(
                                        "12. Table and Figures appear within a page after they are mentioned in the text and not before they are mentioned. Titles are sufficiently detailed; the caption clearly tells the reader what to notice so that it is not necessary to refer to the text in order to understand the illustration. Similarly, the explanation in the text is clear enough to understand without referring to the visual. The visual should complement the text.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_18,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked20,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked20 = val!;
                                              })
                                            }),
                                    const Flexible(
                                      child: Text(
                                        "13. You have proofread for spelling and grammatical errors. If you added words to your dictionary every time you introduced a new one, spellchecking will be far easier. Even so, you will need to proofread to see if you have used the right word. Do not rely on a grammar check program, which misses many errors and sometimes even suggests an incorrect usage.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_19,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked21,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked21 = val!;
                                              })
                                            }),
                                    const Flexible(
                                      child: Text(
                                        "14. Headings, sub-headings, lists, and captions are consistent in style and provide useful content. Font size and style, placement of figure and table titles, and margins all meet university requirements and are consistent. If you set up a style sheet when you first started writing, you will have many fewer problems when you are preparing the final draft. If you use the required margins from the time you began writing, too, you won’t now have trouble with graphs, tables, and equations wrapping.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_20,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked22,
                                        onChanged: (val) => {
                                              setState(() {
                                                isChecked22 = val!;
                                              })
                                            }),
                                    const Flexible(
                                      child: Text(
                                        "15. Make certain you have given author citations for all quotations, paraphrases, and borrowed or adapted visuals. Plagiarism is an academic crime.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_21,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                const Row(
                                  children: [
                                    Flexible(
                                      child: Center(
                                        child: Text(
                                          "General Rating",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: textController_22,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Write your thoughts...',
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                        fillColor: HexColor("#D9D9D9"),
                                        filled: true,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: isChecked23,
                                      onChanged: (val) => {
                                        setState(() {
                                          isChecked23 = val!;
                                        })
                                      },
                                      activeColor: Colors.yellow,
                                      checkColor: Colors.black,
                                    ),
                                    const Text(
                                      "Do you confirm ?",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    MaterialButton(
                                      onPressed: () async {
                                        if (isChecked23 == false ||
                                            isChecked1 == false ||
                                            (percentController_1
                                                    .text.isNotEmpty &&
                                                int.parse(percentController_1.text) >
                                                    defaultPercentController1) ||
                                            (percentController_2
                                                    .text.isNotEmpty &&
                                                int.parse(percentController_2.text) >
                                                    defaultPercentController2) ||
                                            (percentController_3
                                                    .text.isNotEmpty &&
                                                int.parse(percentController_3
                                                        .text) >
                                                    defaultPercentController3) ||
                                            (percentController_4
                                                    .text.isNotEmpty &&
                                                int.parse(percentController_4
                                                        .text) >
                                                    defaultPercentController4) ||
                                            (percentController_5
                                                    .text.isNotEmpty &&
                                                int.parse(percentController_5
                                                        .text) >
                                                    defaultPercentController5) ||
                                            (percentController_6
                                                    .text.isNotEmpty &&
                                                int.parse(
                                                        percentController_6.text) >
                                                    defaultPercentController6)) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Alert"),
                                                content: const Text(
                                                    "You must meet all conditions!"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Ok"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {

                                          print(
                                              "====================================== Professor Infırmations ======================================");
                                          var profInfo =
                                              await academicianRef_1.get();
                                          var rawData = profInfo.data()
                                              as Map<String, dynamic>?;
                                          if (rawData != null) {
                                            print(rawData["email"]);
                                            print(rawData["Name"]);
                                            print(rawData["LastName"]);
                                            professorEmail = rawData["email"];
                                            professorName =
                                                rawData["Name"];
                                            professorSurname =
                                                rawData["LastName"];
                                          } else {
                                            print(
                                                "Problem came out! ----ProfessorInformations----");
                                          }

                                          allOkay();

                                          String percent1 =
                                              percentController_1.text.isEmpty
                                                  ? defaultPercentController1
                                                      .toString()
                                                  : percentController_1.text;
                                          String percent2 =
                                              percentController_2.text.isEmpty
                                                  ? defaultPercentController2
                                                      .toString()
                                                  : percentController_2.text;
                                          String percent3 =
                                              percentController_3.text.isEmpty
                                                  ? defaultPercentController3
                                                      .toString()
                                                  : percentController_3.text;
                                          String percent4 =
                                              percentController_4.text.isEmpty
                                                  ? defaultPercentController4
                                                      .toString()
                                                  : percentController_4.text;
                                          String percent5 =
                                              percentController_5.text.isEmpty
                                                  ? defaultPercentController5
                                                      .toString()
                                                  : percentController_5.text;
                                          String percent6 =
                                              percentController_6.text.isEmpty
                                                  ? defaultPercentController6
                                                      .toString()
                                                  : percentController_6.text;
                                          totalGradeToPercent =
                                              int.parse(percent1) +
                                                  int.parse(percent2) +
                                                  int.parse(percent3) +
                                                  int.parse(percent4) +
                                                  int.parse(percent5) +
                                                  int.parse(percent6);

                                          if (!_alertShown) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Full Mark?"),
                                                  content: Text("Please note that you give full marks to the student."),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Ok"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            _alertShown = true;
                                          }

                                          String text1 = textController_1.text;
                                          String text2 = textController_2.text;
                                          String text3 = textController_3.text;
                                          String text4 = textController_4.text;
                                          String text5 = textController_5.text;
                                          String text6 = textController_6.text;
                                          String text7 = textController_7.text;
                                          String text8 = textController_8.text;
                                          String text9 = textController_9.text;
                                          String text10 =
                                              textController_10.text;
                                          String text11 =
                                              textController_11.text;
                                          String text12 =
                                              textController_12.text;
                                          String text13 =
                                              textController_13.text;
                                          String text14 =
                                              textController_14.text;
                                          String text15 =
                                              textController_15.text;
                                          String text16 =
                                              textController_16.text;
                                          String text17 =
                                              textController_17.text;
                                          String text18 =
                                              textController_18.text;
                                          String text19 =
                                              textController_19.text;
                                          String text20 =
                                              textController_20.text;
                                          String text21 =
                                              textController_21.text;
                                          String text22 =
                                              textController_22.text;

                                          status = true;
                                          projectStatusRef.update({
                                            "status": status,
                                          }).then((value) {
                                            print("status Data updated.");
                                          }).catchError((error) {
                                            print("status Something went wrong!: $error");
                                          });

                                          // Saves Firestore
                                          evaluationRef
                                              .collection("results")
                                              .doc(widget.studentId)
                                              .set({
                                            "percent1": percent1,
                                            "percent2": percent2,
                                            "percent3": percent3,
                                            "percent4": percent4,
                                            "percent5": percent5,
                                            "percent6": percent6,
                                            "text1": text1,
                                            "text2": text2,
                                            "text3": text3,
                                            "text4": text4,
                                            "text5": text5,
                                            "text6": text6,
                                            "text7": text7,
                                            "text8": text8,
                                            "text9": text9,
                                            "text10": text10,
                                            "text11": text11,
                                            "text12": text12,
                                            "text13": text13,
                                            "text14": text14,
                                            "text15": text15,
                                            "text16": text16,
                                            "text17": text17,
                                            "text18": text18,
                                            "text19": text19,
                                            "text20": text20,
                                            "text21": text21,
                                            "text22": text22,
                                            "isChecked1": isChecked1,
                                            "isChecked2": isChecked2,
                                            "isChecked3": isChecked3,
                                            "isChecked4": isChecked4,
                                            "isChecked5": isChecked5,
                                            "isChecked6": isChecked6,
                                            "isChecked7": isChecked7,
                                            "isChecked8": isChecked8,
                                            "isChecked9": isChecked9,
                                            "isChecked10": isChecked10,
                                            "isChecked11": isChecked11,
                                            "isChecked12": isChecked12,
                                            "isChecked13": isChecked13,
                                            "isChecked14": isChecked14,
                                            "isChecked15": isChecked15,
                                            "isChecked16": isChecked16,
                                            "isChecked17": isChecked17,
                                            "isChecked18": isChecked18,
                                            "isChecked19": isChecked19,
                                            "isChecked20": isChecked20,
                                            "isChecked21": isChecked21,
                                            "isChecked22": isChecked22,
                                            "isChecked23": isChecked23,
                                            "prefossorEmail": professorEmail,
                                            "prefossorID": professorID,
                                            "prefossorName": professorName,
                                            "prefossorSurname":
                                                professorSurname,
                                            "dateOfEvaluate": formattedDateDMY,
                                            "totalGrateToPercent":
                                                totalGradeToPercent,
                                          }).then((value) {
                                            print("Datas saved.");
                                          }).catchError((error) {
                                            print(
                                                "Something went wrong!: $error");
                                          });
                                        }
                                      },
                                      color: HexColor("#00C2FF"),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: const Row(children: [
                                        Text(
                                          "Submit",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.send,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ]),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBarComponent(),
      ),
    );
  }
  void allOkay() {
    print(
        "=================================== Text Controller Area ============================================");

    print(textController_1.text);
    print(textController_2.text);
    print(textController_3.text);
    print(textController_4.text);
    print(textController_5.text);
    print(textController_6.text);
    print(textController_7.text);
    print(textController_8.text);
    print(textController_9.text);
    print(textController_10.text);
    print(textController_11.text);
    print(textController_12.text);
    print(textController_13.text);
    print(textController_14.text);
    print(textController_15.text);
    print(textController_16.text);
    print(textController_17.text);
    print(textController_18.text);
    print(textController_19.text);
    print(textController_20.text);
    print(textController_21.text);
    print(textController_22.text);

    print(
        "====================================== isChecked Area ==================================");

    print("isChecked1: $isChecked1");
    print("isChecked2: $isChecked2");
    print("isChecked3: $isChecked3");
    print("isChecked4: $isChecked4");
    print("isChecked5: $isChecked5");
    print("isChecked6: $isChecked6");
    print("isChecked7: $isChecked7");
    print("isChecked8: $isChecked8");
    print("isChecked9: $isChecked9");
    print("isChecked10: $isChecked10");
    print("isChecked11: $isChecked11");
    print("isChecked12: $isChecked12");
    print("isChecked13: $isChecked13");
    print("isChecked14: $isChecked14");
    print("isChecked15: $isChecked15");
    print("isChecked16: $isChecked16");
    print("isChecked17: $isChecked17");
    print("isChecked18: $isChecked18");
    print("isChecked19: $isChecked19");
    print("isChecked20: $isChecked20");
    print("isChecked21: $isChecked21");
    print("isChecked22: $isChecked22");
    print("isChecked23: $isChecked23");

    print(
        "====================================== Percent Area ==================================");

    if (percentController_1
        .text.isEmpty) {
      print("Default Percent 1: " +
          defaultPercentController1
              .toString());
    } else {
      print("Percent 1: " +
          percentController_1.text
              .toString());
    }

    if (percentController_2
        .text.isEmpty) {
      print("Default Percent 2: " +
          defaultPercentController2
              .toString());
    } else {
      print("Percent 2: " +
          percentController_2.text
              .toString());
    }

    if (percentController_3
        .text.isEmpty) {
      print("Default Percent 3: " +
          defaultPercentController3
              .toString());
    } else {
      print("Percent 3: " +
          percentController_3.text
              .toString());
    }

    if (percentController_4
        .text.isEmpty) {
      print("Default Percent 4: " +
          defaultPercentController4
              .toString());
    } else {
      print("Percent 4: " +
          percentController_4.text
              .toString());
    }

    if (percentController_5
        .text.isEmpty) {
      print("Default Percent 5: " +
          defaultPercentController1
              .toString());
    } else {
      print("Percent 5: " +
          percentController_5.text
              .toString());
    }

    if (percentController_6
        .text.isEmpty) {
      print("Default Yüzdelik 6: " +
          defaultPercentController6
              .toString());
    } else {
      print("Yüzdelik 6: " +
          percentController_6.text
              .toString());
    }
  }
}
