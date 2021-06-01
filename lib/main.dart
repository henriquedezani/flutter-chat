import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/usuario.model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('mensagens').snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError) return Text(snapshot.error.toString());

          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (_, index) {
              // var doc = snapshot.data.docs[index];
              var usuario = Usuario.fromMap(snapshot.data.docs[index].data());
              return ListTile(
                title: Text(usuario.nome),
                subtitle: Text(usuario.email),
              );
              // return ListTile(
              //   title: Text(doc['nome']),
              //   subtitle: Text(doc['email']),
              // );
            },
          );
        },
      ),
    );
  }
}
