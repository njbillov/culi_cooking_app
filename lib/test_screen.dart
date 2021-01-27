import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/sign_up.dart';
import 'theme.dart';
import 'utilities.dart';

class TestScreen extends StatelessWidget {
  final SignUp signUp = SignUp();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => signUp,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: CuliButton("Next screen",
                onPressed: () => Utils.changeScreens(
                      context: context,
                      nextWidget: () => TestScreen2(),
                      value: signUp,
                    )),
          ),
        ),
      ),
    );
  }
}

class TestScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Culi",
            style:
                Theme.of(context).textTheme.headline1.copyWith(fontSize: 27)),
        shadowColor: Colors.white,
      ),
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(width: size.width, child: ContainerClass(level: 1)),
              Container(width: size.width, child: ContainerClass(level: 2)),
              Consumer<SignUp>(
                builder: (context, signup, child) => Text("${signup.level}"),
              ),
              CuliButton("Next screen",
                  onPressed: () => Utils.changeScreens(
                        context: context,
                        nextWidget: () => TestScreen3(),
                        value: context.read<SignUp>(),
                      )),
            ]),
      ),
    );
  }
}

class TestScreen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Culi",
            style:
                Theme.of(context).textTheme.headline1.copyWith(fontSize: 27)),
        shadowColor: Colors.white,
      ),
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(width: size.width, child: ContainerClass(level: 1)),
              Container(width: size.width, child: ContainerClass(level: 2)),
              Consumer<SignUp>(
                builder: (context, signup, child) => Text("${signup.level}"),
              )
            ]),
      ),
    );
  }
}

class ContainerClass extends StatelessWidget {
  final int level;

  const ContainerClass({Key key, this.level}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<SignUp>(
        builder: (context, signup, child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: CuliCheckbox("Afraid of my kitchen",
                  selected: signup.level == level,
                  onPressed: () => context.read<SignUp>().level = level),
            ));
  }
}
