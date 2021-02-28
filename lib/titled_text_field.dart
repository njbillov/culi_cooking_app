import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

class TitledTextField<T extends ChangeNotifier> extends StatefulWidget {
  final String title;
  final bool hidden;
  final String Function(String) validator;
  final Function(String) Function(T) fieldUpdater;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final List<String> hints;

  TitledTextField(this.title,
      {Key key,
      this.hidden = false,
      @required this.validator,
      @required this.fieldUpdater,
      this.textInputType = TextInputType.text,
      this.textInputAction = TextInputAction.next,
      this.hints = const [AutofillHints.name]})
      : super(key: key);

  @override
  _TitledTextFieldState<T> createState() => _TitledTextFieldState();
}

class _TitledTextFieldState<T extends ChangeNotifier>
    extends State<TitledTextField<T>> {
  final _textController = TextEditingController();
  String bottomText = "";

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(fontSize: 13.5)),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Culi.backgroundWhite,
                borderRadius: BorderRadius.all(Radius.circular(41)),
                border: Border.all(width: 3),
              ),
              child: Consumer<T>(
                builder: (context, t, child) => TextFormField(
                  textInputAction: widget.textInputAction,
                  autofillHints: widget.hints,
                  keyboardType: widget.textInputType,
                  // autofocus: true,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                    errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    errorStyle: TextStyle(fontSize: 0, height: 0),
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
                  onChanged: (str) {
                    setState(() {
                      bottomText = widget.validator(str) ?? "";
                    });
                    return widget.fieldUpdater(t)(str);
                  },
                  validator: widget.validator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 4),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(bottomText,
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(fontSize: 13.5, color: Colors.red)),
              ),
            ),
          ],
        ));
  }
}

class ValidatedEntryForm extends StatefulWidget {
  final List<Widget> fields;
  final String text;
  final Function onPressed;

  const ValidatedEntryForm({Key key, this.fields, this.text, this.onPressed})
      : super(key: key);

  @override
  _ValidatedEntryFormState createState() => _ValidatedEntryFormState();
}

class _ValidatedEntryFormState extends State<ValidatedEntryForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            ...widget.fields,
            Container(
              height: 0.025 * size.height,
            ),
            CuliButton(
              widget.text,
              height: 75,
              width: size.width * 0.9,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  widget.onPressed();
                }
              },
            )
          ]),
        ));
  }
}
