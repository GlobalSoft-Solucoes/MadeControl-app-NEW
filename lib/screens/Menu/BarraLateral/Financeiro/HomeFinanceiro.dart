import 'package:flutter/material.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Financeiro/widgets/menu/menu_app.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Financeiro/widgets/my_app_bar.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Financeiro/widgets/page_view/IndicadorCard.dart';
import 'package:madecontrol_desenvolvimento/screens/Menu/BarraLateral/Financeiro/widgets/page_view/page_view_app.dart';

class HomeFinances extends StatefulWidget {
  @override
  _HomeFinancesState createState() => _HomeFinancesState();
}

class _HomeFinancesState extends State<HomeFinances> {
  bool? _showMenu;
  int? _currentIndex;
  double?_yPosition;

  @override
  void initState() {
    super.initState();
    _showMenu = false;
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    double?_screenHeigth = MediaQuery.of(context).size.height;
    if (_yPosition == null) {
      _yPosition = _screenHeigth * .24;
    }
    return Scaffold(
      backgroundColor: Colors.green[100],
      extendBody: true,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "assets/images/financeiro/FundoDinheiro07.jpg"),
                  fit: BoxFit.cover),
            ),
          ),
          MyAppBar(
            showMenu: _showMenu,
            onTap: () {
              setState(
                () {
                  _showMenu = !_showMenu!;
                  _yPosition =
                      _showMenu! ? _screenHeigth * .75 : _screenHeigth * .24;
                },
              );
            },
          ),
          MenuApp(
            top: _screenHeigth * .20,
            showMenu: _showMenu,
          ),
          MyDotsApp(
            showMenu: _showMenu,
            top: _screenHeigth * .70,
            currentIndex: _currentIndex,
          ),
          SizedBox(
            height: 30,
          ),
          PageViewApp(
            showMenu: _showMenu,
            top: _yPosition,
            onChanged: (index) {
              setState(
                () {
                  _currentIndex = index;
                },
              );
            },
            onPanUpdate: (details) {
              double?positionBottomLimit = _screenHeigth * .75;
              double?positionTopLimit = _screenHeigth * .24;
              double?midlePosition = positionBottomLimit - positionTopLimit;
              midlePosition = midlePosition / 2;
              setState(
                () {
                  _yPosition =_yPosition! + details.delta.dy;

                  _yPosition = _yPosition! < positionTopLimit
                      ? positionTopLimit
                      : _yPosition;

                  _yPosition = _yPosition! > positionBottomLimit
                      ? positionBottomLimit
                      : _yPosition;

                  if (_yPosition != positionBottomLimit &&
                      details.delta.dy > 0) {
                    _yPosition =
                        _yPosition! > positionTopLimit + midlePosition! - 50
                            ? positionBottomLimit
                            : _yPosition;
                  }

                  if (_yPosition != positionTopLimit && details.delta.dy < 0) {
                    _yPosition =
                        _yPosition! < positionBottomLimit - midlePosition!
                            ? positionTopLimit
                            : _yPosition;
                  }

                  if (_yPosition == positionBottomLimit) {
                    _showMenu = true;
                  } else if (_yPosition == positionTopLimit) {
                    _showMenu = false;
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
