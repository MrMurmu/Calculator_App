import 'package:calculator_app/calculator_button.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final List<String> scientificButtons = ['e', 'μ', 'sin', 'deg'];
  final List<String> mainButtons = [
    'Ac',
    '⌫',
    '/',
    '7',
    '8',
    '9',
    '4',
    '5',
    '6',
    '1',
    '2',
    '3',
  ];
  final List<String> operators1 = ['*', '-'];
  final List<String> operators2 = ['+', '='];

  String _expression = '0';
  String _result = '';
  bool _isResultShown = false;

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'Ac') {
        _expression = '0';
        _result = '';
        _isResultShown = false;
      } else if (value == '⌫') {
        if (_expression.length > 1) {
          _expression = _expression.substring(0, _expression.length - 1);
        } else {
          _expression = '0';
        }
      } else if (value == '=') {
        try {
          final exp = _expression.replaceAll('×', '*').replaceAll('÷', '/');
          final parsed = _parseExpression(exp);

          // Format result: if integer, don't show .0

          if (parsed == parsed.toInt()) {
            _result = parsed.toInt().toString();
          } else {
            _result = parsed.toString();
          }
          _isResultShown = true;
        } catch (e) {
          _result = 'Error';
        }
      } else {
        if (_isResultShown) {
          if (['+', '-', '*', '/'].contains(value)) {
            _expression = _result + value;
          } else {
            _expression = value;
          }
          _result = '';
          _isResultShown = false;
        } else {
          if (_expression == '0' && RegExp(r'\d').hasMatch(value)) {
            _expression = value;
          } else {
            if (_expression.isNotEmpty &&
                [
                  '+',
                  '-',
                  '*',
                  '/',
                ].contains(_expression[_expression.length - 1]) &&
                ['+', '-', '*', '/'].contains(value)) {
              // Replace the last operator with the new one
              _expression =
                  _expression.substring(0, _expression.length - 1) + value;
            } else {
              _expression += value;
            }
          }
        }
      }
    });
  }

  double _parseExpression(String exp) {
    Parser p = Parser();
    Expression expression = p.parse(exp);
    ContextModel cm = ContextModel();
    return expression.evaluate(EvaluationType.REAL, cm);
  }
  // work flow
  // Parser → Expression → ContextModel → evaluate()

  // Parser
  // Converts a string math expression (like "3+5*2") into an actual Expression object that can be evaluated.

  // Expression
  // Represents a mathematical expression tree. It supports constants, variables, binary operations, and functions (like sin, cos, etc.).
  // Expression expression = p.parse("3+5*2");

  // ContextModel
  // Holds values for variables (if any). It's needed for evaluating expressions with variables like x + 2.

  // EvaluationType.REAL
  //  Indicates the result should be evaluated as a real number (as opposed to complex or vector math).

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                // Display --------------------------------------------------------------
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _expression,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _result.isNotEmpty ? '$_result' : '',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //  ---------------------------------Buttons-----------------------------
                
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      // --------------------scientificButtons------------------
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:
                              scientificButtons.map((btn) {
                                return Expanded(
                                  child: CalculatorButton(
                                    label: btn,
                                    onTap: () {},
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  // ---------------------number button -------------------
                                  Expanded(
                                    flex: 4,
                                    child: GridView.builder(
                                      padding: EdgeInsets.all(4),
                                      itemCount: mainButtons.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 1,
                                            crossAxisSpacing: 4,
                                            mainAxisSpacing: 4,
                                          ),
                                      itemBuilder: (context, index) {
                                        return CalculatorButton(
                                          label: mainButtons[index],
                                          onTap:
                                              () => onButtonPressed(
                                                mainButtons[index],
                                              ),
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        // -----------------------------------0 button -------------------
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                            ),
                                            child: CalculatorButton(
                                              label: '0',
                                              onTap: () => onButtonPressed('0'),
                                            ),
                                          ),
                                        ),
                                        // ------------------ point button -------------------
                                        Expanded(
                                          child: CalculatorButton(
                                            label: '.',
                                            onTap: () => onButtonPressed('.'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  // ---------------------------- operator 1 ------------------------
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Column(
                                        children:
                                            operators1.map((op) {
                                              return Expanded(
                                                child: CalculatorButton(
                                                  label: op,
                                                  onTap:
                                                      () => onButtonPressed(op),
                                                  isOperator: true,
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                  ),
                                  // ------------------------------operator 2 -----------------------
                                  Expanded(
                                    flex: 7,
                                    child: Column(
                                      children:
                                          operators2.map((op) {
                                            return Expanded(
                                              child: CalculatorButton(
                                                label: op,
                                                onTap:
                                                    () => onButtonPressed(op),
                                                isOperator: true,
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
