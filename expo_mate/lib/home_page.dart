import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expo_mate/form_expo.dart';
//import 'package:expomate/form_expo.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de animais'),
      ),
      body: _body(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FormExpo()));
        },
        tooltip: 'Nova Exposição',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Column _body(context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('expos').snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  List<DocumentSnapshot> expos = snapshot.data.documents;
                  return ListView.builder(
                    itemCount: expos.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        trailing: IconButton(
                          onPressed: () async{
                            int ultimo=index;                          
                            
                            CollectionReference expos1 =
                                await Firestore.instance.collection('expos');
                            await expos1
                                .document(expos[ultimo].documentID)
                                .delete();
                                
                          },
                          icon: Icon(Icons.delete),
                        ),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(expos[index].data['foto']),
                        ),
                        title: Text(expos[index].data['nome']),
                        //subtitle: Text(expos[index].data['cidade']+ '\n' + widget.document['teste']),
                        subtitle: Text(expos[index].data['forte'] +
                            '\n' +
                            expos[index].data['raça'] + '\n'+expos[index].data['sexo']),
                      );
                    },
                  );
              }
            },
          ),
        ),
      ],
    );
  }
}
