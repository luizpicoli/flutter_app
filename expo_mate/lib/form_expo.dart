import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormExpo extends StatefulWidget {
  @override
  _FormExpoState createState() => _FormExpoState();
}

class _FormExpoState extends State<FormExpo> {
  var _edNome = TextEditingController();
  var _edRaca = TextEditingController();
  var _edSexo = TextEditingController();  
  var _edFoto = TextEditingController();
  var _edForte = TextEditingController();  
  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inclusão de Exposições'),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(
            context,
          );
        },
        tooltip: 'Voltar',
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  Container _body() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _edNome,
            keyboardType: TextInputType.text,
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: 'Nome: ',
            ),
          ),
           TextFormField(
            controller: _edRaca,
            keyboardType: TextInputType.text,
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: 'Raça: ',
            ),
          ),
           TextFormField(
            controller: _edForte,
            keyboardType: TextInputType.text,
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: 'Forte: ',
            ),
          ),
       
          TextFormField(
            controller: _edSexo,
            keyboardType: TextInputType.text,
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: 'Sexo:',
            ),
          ),
          Row(
            children: <Widget>[
              IconButton(
                color: Colors.blue,
                icon: Icon(Icons.photo_camera),
                onPressed: () {
                  _getImage();
                },
              ),
              Expanded(
                child: TextFormField(
                  controller: _edFoto,
                  keyboardType: TextInputType.url,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    labelText: 'URL da Foto',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: _image == null
                ? Text('Clique no botão da câmera para fotografar')
                : Image.file(
                    _image,
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FlatButton(
              onPressed: () {
                _gravaDados();
              },
              child: Text(
                'Cadastrar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _gravaDados() async {
    if (_edNome.text == '' || _edRaca.text == ''|| _edSexo.text == '' || _edFoto.text == ''|| _edForte.text =='') {
      showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("Atenção:"),
          content: new Text("Por favor, preencha todos os campos..."),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
      return;
    }

    await Firestore.instance.collection('expos').add({
      'nome': _edNome.text,
      'raça': _edRaca.text,
      'sexo': _edSexo.text,
      'foto': _edFoto.text,
      'forte': _edForte.text,
    });

    _edNome.text = '';
    _edRaca.text = ''; 
    _edSexo.text = '';
    _edFoto.text = '';
    _edForte.text = '';

    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text("Parabéns!!"),
        content: new Text("Exposição cadastrada com sucesso"),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _salvaFoto() async {
    if (_image != null) {
      final StorageUploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(
            DateTime.now().millisecondsSinceEpoch.toString(),
          )
          .putFile(_image);

      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      _edFoto.text = url;
    }
  }
}
