import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TopWayCarousel extends StatefulWidget {
  final int carouselIndex;

  const TopWayCarousel({required this.carouselIndex, Key? key})
      : super(key: key);

  @override
  _TopWayCarouselState createState() => _TopWayCarouselState();
}

class _TopWayCarouselState extends State<TopWayCarousel> {
  final List<List<TextEditingController>> _controllers = List.generate(
    5,
    (index) => List.generate(
      7,
      (index) => TextEditingController(),
    ),
  );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _initData();
  }

  Future<void> _initData() async {
    for (var j = 0; j < 3; j++) {
      for (var i = 0; i < _controllers[j].length; i++) {
        DocumentSnapshot doc = await _firestore
            .collection('featureRequests${j + 1}')
            .doc('request$i')
            .get();

        var data = doc.data() as Map<String, dynamic>?;

        _controllers[j][i].text =
            doc.exists && data != null && data['text'] != null
                ? data['text']
                : '';
      }
    }
    if (mounted) {
      // Add this check
      setState(() {});
    }
  }

  Widget _buildTopWayCarousel(int carouselIndex) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _controllers[carouselIndex].length,
      itemBuilder: (BuildContext context, int index) {
        return _buildTopWayItem(
            _controllers[carouselIndex][index], index, carouselIndex);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _buildTopWayCarousel(widget.carouselIndex)),
    );
  }

  Widget _buildTopWayItem(
      TextEditingController controller, int index, int carouselIndex) {
    var collection = 'featureRequests${carouselIndex + 1}';
    var document = 'request$index';
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: controller,
                      maxLines: 5,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.send,
                      onEditingComplete: () {
                        _firestore.collection(collection).doc(document).set(
                            {'text': controller.text}, SetOptions(merge: true));
                        FocusScope.of(context).unfocus();
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter feature or bug.',
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                        stream: _firestore
                            .collection(collection)
                            .doc(document)
                            .snapshots(),
                        builder: (context, snapshot) {
                          int likeCount = 0;

                          if (snapshot.hasData) {
                            var data =
                                snapshot.data!.data() as Map<String, dynamic>?;

                            if (data != null && data.containsKey('votes')) {
                              likeCount =
                                  (data['votes'] as Map<String, dynamic>)
                                      .values
                                      .where((v) => v == true)
                                      .length;
                            }
                          }
                          return Text('$likeCount');
                        }),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_up_outlined),
                      color: const Color.fromARGB(255, 0, 138, 5),
                      onPressed: () async {
                        DocumentSnapshot doc = await _firestore
                            .collection(collection)
                            .doc(document)
                            .get();
                        Map<String, dynamic>? docData =
                            doc.data() as Map<String, dynamic>?;

                        Map<String, bool?> votes =
                            docData != null && docData.containsKey('votes')
                                ? Map<String, bool?>.from(docData['votes'])
                                : {};
                        String uid = FirebaseAuth.instance.currentUser!.uid;
                        votes[uid] = (votes[uid] == true ? null : true);
                        _firestore
                            .collection(collection)
                            .doc(document)
                            .set({'votes': votes}, SetOptions(merge: true));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down_outlined),
                      color: const Color.fromARGB(255, 178, 0, 0),
                      onPressed: () async {
                        DocumentSnapshot doc = await _firestore
                            .collection(collection)
                            .doc(document)
                            .get();
                        Map<String, dynamic>? docData =
                            doc.data() as Map<String, dynamic>?;
                        Map<String, bool?> votes =
                            docData != null && docData.containsKey('votes')
                                ? Map<String, bool?>.from(docData['votes'])
                                : {};
                        String uid = FirebaseAuth.instance.currentUser!.uid;
                        votes[uid] = (votes[uid] == false ? null : false);
                        _firestore
                            .collection(collection)
                            .doc(document)
                            .set({'votes': votes}, SetOptions(merge: true));
                      },
                    ),
                    StreamBuilder<DocumentSnapshot>(
                        stream: _firestore
                            .collection(collection)
                            .doc(document)
                            .snapshots(),
                        builder: (context, snapshot) {
                          int dislikeCount = 0;
                          if (snapshot.hasData) {
                            var data =
                                snapshot.data!.data() as Map<String, dynamic>?;

                            if (data != null && data.containsKey('votes')) {
                              dislikeCount =
                                  (data['votes'] as Map<String, dynamic>)
                                      .values
                                      .where((v) => v == false)
                                      .length;
                            }
                          }
                          return Text('$dislikeCount');
                        }),
                  ],
                )
              ]),
            )));
  }
}
