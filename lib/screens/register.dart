import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay_list/components/input.dart';
import 'package:pay_list/models/local_file.dart';
import 'package:pay_list/screens/app.dart';

class Register extends StatelessWidget {
  final LocalFile _localFile = new LocalFile();
  final TextEditingController _inputController = new TextEditingController();

  Future<bool> _verifyFile(BuildContext context) async {
    dynamic file = await this._localFile.readFile();
    if (file != null) {
      return false;
    }
    return true;
  }

  Future<void> _saveOnFile(BuildContext context) async {
    String name = this._inputController.text;
    if (name.isNotEmpty) {
      Map<String, dynamic> data = {};
      data['name'] = name;
      data['balance'] = 0.0;
      data['payments'] = [];
      await this._localFile.saveFile(jsonEncode(data));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AppScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Widget buildRegister(context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Payments",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.karla(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Input(
                  controller: this._inputController,
                  text: 'First name',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(
          Icons.save,
          size: 24.0,
          color: Colors.white,
        ),
        label: Text(
          'SAVE',
          style: GoogleFonts.karla(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        onPressed: () => this._saveOnFile(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this._verifyFile(context),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.done:
            if (snapshot.data == true) {
              return this.buildRegister(context);
            }
            return AppScreen();
            break;
          default:
            return Container(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}