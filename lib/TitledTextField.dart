

import 'package:flutter/material.dart';

import 'Theme.dart';

class TitledTextField extends StatefulWidget {
  final String title;
  final Function(String) fieldUpdater;
  final String Function(String) validator;
  final bool hidden;

  const TitledTextField({this.title, this.fieldUpdater, this.validator, this.hidden : false});

  @override
  _TitledTextFieldState createState() => _TitledTextFieldState();
}

class _TitledTextFieldState extends State<TitledTextField> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(widget.title, style: Theme.of(context).textTheme.headline6),
          ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Salus.backgroundWhite,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusColor: Colors.black,
              // labelText: widget.title,
              // labelStyle: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black12),
            ),
            obscureText: widget.hidden,
            // textAlignVertical: TextAlignVertical.center,
            cursorColor: Colors.black,
            controller: _textController,
            onChanged: (String str) =>  { widget.fieldUpdater(str) },
            validator: widget.validator,
          ),
        ),
          SizedBox(
            height: 0.05 * MediaQuery.of(context).size.height,
          ),
        ],
      )
    );
  }
}

class ValidatedEntryForm extends StatefulWidget {
  final List<Widget> fields;
  final String submitButtonText;
  final Widget Function() successPath;

  const ValidatedEntryForm({Key key, this.fields, this.submitButtonText, this.successPath}) : super(key: key);

  @override
  _ValidatedEntryFormState createState() => _ValidatedEntryFormState();
}

class _ValidatedEntryFormState extends State<ValidatedEntryForm> {
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for(var field in widget.fields) field,
          SizedBox(
            height: 0.05 * MediaQuery.of(context).size.height,
          ),
          Container(
              width: 229,
              height: 48,
              child: FlatButton(
                color: Salus.green,
                onPressed: () {
                  if(_formKey.currentState.validate())
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => widget.successPath(),
                      )
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Salus.green, style: BorderStyle.solid),
                ),
                child: Text(widget.submitButtonText,  style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.white)),
              )
          )
        ]
      )
    );
  }

}

