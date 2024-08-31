import 'package:evaluation_project/View/Components/BottomNavigationBarComponent.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupPage extends StatelessWidget {
  final String groupName;
  final Map<String, dynamic>? groupData;

  GroupPage(this.groupName, this.groupData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '$groupName Grades',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: groupData != null
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Evaluation')),
                        DataColumn(label: Text('Grades')),
                      ],
                      rows: [
                        DataRow(
                          cells: [
                            DataCell(Text('Evaluating Teacher')),
                            DataCell(Text('${groupData!['prefossorEmail']}')),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text('Technical Merits (%15)')),
                            DataCell(Text(
                                '${groupData!['percent1']}')),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text('Project Design and Implementation (%40)')),
                            DataCell(Text('${groupData!['percent2']}')),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text('Report(completeness and content) (%15)')),
                            DataCell(Text('${groupData!['percent3']}')),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text('Presentation (%10)')),
                            DataCell(Text('${groupData!['percent4']}')),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text('Demo (%10)')),
                            DataCell(Text('${groupData!['percent5']}')),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text('Papers (%10)')),
                            DataCell(Text('${groupData!['percent6']}')),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text('Total Score (%100)')),
                            DataCell(Text('${groupData!['totalGrateToPercent']}')),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'General Rating: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${groupData!['text22']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
      bottomNavigationBar: const BottomNavigationBarComponent(),
    );
  }
}

class ResultOfEvaluation extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('').doc("Evaluation").collection("results").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final List<DocumentSnapshot> documents = snapshot.data!.docs;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Select Group',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.lightBlueAccent,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: documents.map((doc) {
                final groupName = doc.id;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          DocumentSnapshot documentSnapshot = await _firestore
                              .collection('0').doc("Evaluation").collection("results")
                              .doc(groupName)
                              .get();

                          if (documentSnapshot.exists) {
                            Map<String, dynamic>? groupData = documentSnapshot
                                .data() as Map<String, dynamic>?;

                            // Check if groupData is not null
                            if (groupData != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GroupPage(groupName, groupData),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Group data for $groupName not found!'),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Group data for $groupName not found!'),
                              ),
                            );
                          }
                        } catch (e) {
                          print('Error getting group data: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'An error occurred while getting group data!'),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.lightBlueAccent),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          groupName.toUpperCase(),
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          bottomNavigationBar: const BottomNavigationBarComponent(),
        );
      },
    );
  }
}
