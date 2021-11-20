import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class NonVegRecipies extends StatelessWidget {
  const NonVegRecipies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore pagination example'),
        centerTitle: true,
      ),
      body: PaginateFirestore(
        // Use SliverAppBar in header to make it sticky
        header: SliverToBoxAdapter(child: Text('HEADER')),
        //footer: SliverToBoxAdapter(child: Text('Loading....')),
        // item builder type is compulsory.
        itemBuilderType:
            PaginateBuilderType.gridView, //Change types accordingly
        itemBuilder: (index, context, documentSnapshot) {
          final data = documentSnapshot.data() as Map?;
          
          return ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: data == null ? Text('Error in data') : Text(data['rName']),
            subtitle: Text(data!['Protine'].toString()),
          );
        },
        // orderBy is compulsory to enable pagination
        query: FirebaseFirestore.instance
            .collection('rData')
            .where("Protine", isGreaterThan: 30)
            .orderBy('Protine'),
        // to fetch real-time data
        isLive: false,
      ),
    );
  }
}
