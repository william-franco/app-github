import 'package:app_github/models/user_model.dart';
import 'package:app_github/widgets/custom_appbar.dart';
import 'package:app_github/widgets/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterUserPage extends StatefulWidget {
  final UserModel userSearch;
  FilterUserPage({Key key, this.userSearch}) : super(key: key);

  @override
  _FilterUserPageState createState() => new _FilterUserPageState();
}

class _FilterUserPageState extends State<FilterUserPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final FocusNode _nomeFocus = FocusNode();

  UserModel userSearch = new UserModel(
    name: '', 
  );

  @override
  void initState() {
    super.initState();

    userSearch = widget.userSearch;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: getAppAbar(context, 'Filtro', isSearch: true),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            margin:
                EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: CustomScrollView(slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate([
                  //NOME
                  CustomWidgets.getInputLabel('Nome'),
                  Container(
                    decoration: CustomWidgets.decorationCircular(),
                    child: TextFormField(
                      initialValue: userSearch.name,
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      cursorColor: Colors.black,
                      focusNode: _nomeFocus,
                      onFieldSubmitted: (term) {
                        _nomeFocus.unfocus();
                      },
                      onChanged: (val) => setState(() {
                        userSearch.name = val;
                      }),
                    ),
                  ),

                  Container(
                      margin: EdgeInsets.only(top: 40.0, bottom: 40.0),
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      child: RaisedButton(
                        child: Text(
                          'Pesquisar',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        onPressed: () {
                          Navigator.pop(context, userSearch);
                        },
                      )),
                ]))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
