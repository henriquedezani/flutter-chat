import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/mensagem.model.dart';

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
  final txtMessageCtrl = TextEditingController();

  Future sendMessage() async {
    await _firestore.collection('mensagens').add(
      {
        'nome': 'Usuário',
        'mensagem': txtMessageCtrl.text,
        'data': DateTime.now().millisecondsSinceEpoch,
        'status': true,
      },
    );

    txtMessageCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
      ),
      body: Column(
        children: [
          ListaMensagens(),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 30, 20, 30),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: txtMessageCtrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                      minLines: 1),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ListaMensagens extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;

  Future delete(String id) async {
    await _firestore.collection('mensagens').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore
          .collection('mensagens')
          .where('status', isEqualTo: true)
          .orderBy('data', descending: true)
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text(snapshot.error.toString());

        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return Flexible(
          child: ListView.builder(
            reverse: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (_, index) {
              var mensagem = Mensagem.fromMap(snapshot.data.docs[index].data());
              return Dismissible(
                key: Key(snapshot.data.docs[index].id),
                background: Container(color: Colors.red),
                onDismissed: (_) => delete(snapshot.data.docs[index].id),
                child: ListTile(
                  title: Text(mensagem.nome),
                  subtitle: Text(mensagem.mensagem),
                  trailing:
                      Text("${mensagem.data.month}/${mensagem.data.year}"),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
