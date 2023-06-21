import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class BillingCarousel extends StatefulWidget {
  const BillingCarousel({Key? key}) : super(key: key);

  @override
  _BillingCarouselState createState() => _BillingCarouselState();
}

class _BillingCarouselState extends State<BillingCarousel> {
  final List<DateTime> _months =
      List<DateTime>.generate(12, (i) => DateTime(DateTime.now().year, i + 1));
  final Map<String, FocusNode> focusNodes = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Future<DocumentSnapshot>? document;

  late final PageController _pageController;

  final Map<String, TextEditingController> developmentControllers = {};
  final Map<String, TextEditingController> hoursControllers = {};

  @override
  void initState() {
    super.initState();

    user = _auth.currentUser;
    document = _firestore.collection('billing').doc('sharedData').get();

    _pageController = PageController(
      initialPage: DateTime.now().month - 1,
    );
  }

  Widget _buildBillingCardCarousel() {
    return SizedBox(
      height: 600,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (BuildContext context, int index) {
          return _buildBillingCard(_months[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _buildBillingCardCarousel()),
    );
  }

  void _saveDataToFirestore() {
    developmentControllers.forEach((dateFormatted, controller) {
      _updateDevelopment(dateFormatted, controller.text.trim(), 1);
    });

    hoursControllers.forEach((dateFormatted, controller) {
      _updateHours(dateFormatted, controller.text.trim(), 1);
    });
  }

  void _updateDevelopment(String dateFormatted, String value, int descIndex) {
    _firestore.collection('billing').doc('sharedData').set({
      dateFormatted: {
        '$descIndex': {
          'development': value,
        }
      }
    }, SetOptions(merge: true)).then((_) {
      print('Development updated successfully');
    }).catchError((error) {
      print('Failed to update development: $error');
    });
  }

  void _updateHours(String dateFormatted, String hours, int descIndex) {
    double? hoursAsDouble = double.tryParse(hours);
    if (hoursAsDouble != null) {
      _firestore.collection('billing').doc('sharedData').set({
        dateFormatted: {
          '$descIndex': {
            'hours': hoursAsDouble,
          }
        }
      }, SetOptions(merge: true)).then((_) {
        print('Hours updated successfully');
      }).catchError((error) {
        print('Failed to update hours: $error');
      });
    }
  }

  Widget _buildBillingCard(DateTime month) {
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    Stream<DocumentSnapshot> document =
        _firestore.collection('billing').doc('sharedData').snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: document,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SpinKitSpinningCircle(
              color: Color.fromARGB(255, 8, 19, 174));
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<String, dynamic>? data =
                snapshot.data?.data() as Map<String, dynamic>?;
            print('Fetched data: $data');
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMMM').format(month),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: daysInMonth,
                          itemBuilder: (BuildContext context, int index) {
                            DateTime day =
                                DateTime(month.year, month.month, index + 1);
                            String dateFormatted =
                                DateFormat('yyyy-MM-dd').format(day);

                            bool isCurrentDate =
                                DateTime.now().year == day.year &&
                                    DateTime.now().month == day.month &&
                                    DateTime.now().day == day.day;

                            dynamic dailyDataRaw = data?[dateFormatted];
                            Map<String, dynamic> dailyData =
                                dailyDataRaw != null &&
                                        dailyDataRaw is Map<String, dynamic>
                                    ? dailyDataRaw[
                                        '1'] // or whichever index is relevant
                                    : {'development': '', 'hours': ''};

                            String development = dailyData['development'] ?? '';
                            if (!developmentControllers
                                .containsKey(dateFormatted)) {
                              TextEditingController controller =
                                  TextEditingController();
                              controller.text = development; // set initial text
                              developmentControllers[dateFormatted] =
                                  controller;
                            } else {
                              if (developmentControllers[dateFormatted]
                                      ?.value
                                      .text !=
                                  development) {
                                developmentControllers[dateFormatted]?.value =
                                    developmentControllers[dateFormatted]!
                                        .value
                                        .copyWith(
                                            text: development,
                                            selection: TextSelection.collapsed(
                                                offset: development.length),
                                            composing: TextRange.empty);
                              }
                            }

                            String hours = dailyData['hours']?.toString() ?? '';
                            if (!hoursControllers.containsKey(dateFormatted)) {
                              TextEditingController controller =
                                  TextEditingController();
                              controller.text = hours; // set initial text
                              hoursControllers[dateFormatted] = controller;
                            } else {
                              if (hoursControllers[dateFormatted]?.value.text !=
                                  hours) {
                                hoursControllers[dateFormatted]?.value =
                                    hoursControllers[dateFormatted]!
                                        .value
                                        .copyWith(
                                            text: hours,
                                            selection: TextSelection.collapsed(
                                                offset: hours.length),
                                            composing: TextRange.empty);
                              }
                            }

                            return Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: isCurrentDate
                                          ? const Color.fromARGB(255, 5, 5, 165)
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 12,
                                  child: TextFormField(
                                    controller:
                                        developmentControllers[dateFormatted],
                                    decoration: const InputDecoration(
                                      hintText: 'Development',
                                    ),
                                    onChanged: (value) {
                                      if (value.trim().isEmpty) {
                                        _deleteDevelopment(dateFormatted, 1);
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                      _updateDevelopment(
                                          dateFormatted, value.trim(), 1);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: _buildCustomNumericKeyboard(
                                      dateFormatted),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }

  Widget _buildCustomNumericKeyboard(String dateFormatted) {
    if (!focusNodes.containsKey(dateFormatted)) {
      focusNodes[dateFormatted] = FocusNode();
    }

    return SizedBox(
      height: 75, // Adjust this value as needed.
      child: KeyboardActions(
        config: KeyboardActionsConfig(
          keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
          nextFocus: false,
          actions: [
            KeyboardActionsItem(
              focusNode: focusNodes[dateFormatted]!,
              toolbarButtons: [
                (node) {
                  return GestureDetector(
                    onTap: () {
                      _updateHours(dateFormatted,
                          hoursControllers[dateFormatted]!.text.trim(), 1);
                      focusNodes[dateFormatted]!.unfocus(); // Close keyboard
                    },
                    child: Container(
                      // color: Colors.black,
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        "DONE",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                  );
                }
              ],
            ),
          ],
        ),
        child: TextField(
          focusNode: focusNodes[dateFormatted],
          controller: hoursControllers[dateFormatted],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            hintText: 'Hours',
          ),
          onChanged: (value) {
            if (value.trim().isEmpty) {
              _deleteHours(dateFormatted, 1);
            }
          },
          onEditingComplete: () {
            _updateHours(
                dateFormatted, hoursControllers[dateFormatted]!.text.trim(), 1);
            focusNodes[dateFormatted]!.unfocus();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    developmentControllers.forEach((_, controller) => controller.dispose());
    hoursControllers.forEach((_, controller) => controller.dispose());
    focusNodes.forEach((_, node) => node.dispose());
  }

  void _deleteDevelopment(String dateFormatted, int descIndex) {
    _firestore.collection('billing').doc('sharedData').update({
      '$dateFormatted.$descIndex.development': FieldValue.delete(),
    }).then((_) {
      print('Development deleted successfully');
    }).catchError((error) {
      print('Failed to delete development: $error');
    });
  }

  void _deleteHours(String dateFormatted, int descIndex) {
    _firestore.collection('billing').doc('sharedData').update({
      '$dateFormatted.$descIndex.hours': FieldValue.delete(),
    }).then((_) {
      print('Hours deleted successfully');
    }).catchError((error) {
      print('Failed to delete hours: $error');
    });
  }
}
