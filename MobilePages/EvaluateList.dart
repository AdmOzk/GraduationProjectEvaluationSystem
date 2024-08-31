import 'package:evaluation_project/View/Components/BottomNavigationBarComponent.dart';
import 'package:evaluation_project/service/UserAuthService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evaluation_project/View/pages/EvaluationPage.dart';

class EvaluateList extends StatefulWidget {
  const EvaluateList({Key? key}) : super(key: key);

  @override
  State<EvaluateList> createState() => _EvaluateListState();
}

class _EvaluateListState extends State<EvaluateList> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _projectStream;

  @override
  void initState() {
    super.initState();
    _projectStream = FirebaseFirestore.instance
        .collection('').doc('Project').collection("Projects")
        .snapshots();
    String? username = UsernameService.usernameValue;
    if (username != null) {
      print("Kullanıcı adı: $username");
    } else {
      print("Kullanıcı adı henüz ayarlanmadı.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Projects'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _projectStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No project data found'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                // Access individual student data from the list
                Map<String, dynamic> studentData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                String studentId = studentData['User'] ?? ''; // Assuming 'id' is the student ID field
                String projectDate = studentData['TimeFrom'] ?? ''; // Assuming 'date' is the project date field
                String titleProject = studentData['Title'] ?? ''; // Assuming 'date' is the project date field
                bool isCompleted = studentData['status'] ?? false;

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('lib/assets/images/user.png'),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Project Owner: $studentId'),
                              Text('Date: $projectDate'),
                              Text(
                                'Status: ${isCompleted ? 'Completed' : 'Not Completed'}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isCompleted ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(height: 8.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EvaluationPage(studentId: studentId, titleProject: titleProject),
                                  ),
                                );
                              },
                              child: const Text('Evaluate'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: const BottomNavigationBarComponent(),
      ),
    );
  }
}
