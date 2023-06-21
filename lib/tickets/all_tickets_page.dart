import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllTicketsPage extends StatefulWidget {
  const AllTicketsPage({Key? key}) : super(key: key);

  @override
  State<AllTicketsPage> createState() => _AllTicketsPageState();
}

class _AllTicketsPageState extends State<AllTicketsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tickets'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tickets').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var ticket = snapshot.data?.docs[index];

              return Card(
                child: ListTile(
                  title: Text('Ticket ID: ${ticket?.id}'),
                  subtitle: Text('Data: ${ticket?.data().toString()}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
