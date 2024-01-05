import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:tic_tac_toe/MyHomePage.dart';

class enterPlayer extends StatefulWidget {
  const enterPlayer({super.key});

  @override
  State<enterPlayer> createState() => _enterPlayerState();
}

class _enterPlayerState extends State<enterPlayer> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController player1Controller = TextEditingController();
  TextEditingController player2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: player2Controller,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Required!'),
                      MaxLengthValidator(16, errorText: 'Too long!'),
                    ]),
                    decoration: InputDecoration(
                      labelText: 'Player 1',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: player1Controller,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Required!'),
                      MaxLengthValidator(16, errorText: 'Too long!')
                    ]),
                    decoration: InputDecoration(
                      labelText: 'Player 2',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            MyHomePage(player1: player1Controller.text, player2: player2Controller.text)));
                        }
                      },
                      child: const Text("Let's Go"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
