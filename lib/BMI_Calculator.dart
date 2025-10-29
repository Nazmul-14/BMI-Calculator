
import 'package:flutter/material.dart';

enum Heighttype {cm, feetInch}

class BmiCalculator extends StatefulWidget {
  const BmiCalculator({super.key});

  @override
  State<BmiCalculator> createState() => _BmiCalculatorState();
}

class _BmiCalculatorState extends State<BmiCalculator> {
  Heighttype heighttype= Heighttype.cm;
  bool iskg=true;
  int? selectedbutton1;
  int? selectedbutton2;

  final weightctr= TextEditingController();
  final cmctr= TextEditingController();
  final feetctr= TextEditingController();
  final inchctr= TextEditingController();

  String _bmiresult='';
  String? catagory;


  String catagoryresult(double bmi){
    if(bmi<18.5){
      return "Underweight";
    }
    else if(bmi>18.5 && bmi<24.9){
      return "Healthy Weight";
    }
    else if(bmi>24.9 && bmi<29.9){
      return "Overweight";
    }
    else if(bmi>29.9 && bmi<34.9){
      return "Obese (Class I)";
    }
    else if(bmi>34.9 && bmi<39.9){
      return "Obese (Class II)";
    }else{
      return "Obese (Class III)";
    }
  }

  final Map<String, Color> catagorycolor={
    'Underweight' : Colors.blue,
    'Healthy Weight' : Colors.green,
    'Overweight' : Colors.orange,
    'Obese (Class I)' : Colors.red,
    'Obese (Class II)' : Colors.red,
    'Obese (Class III)' : Colors.red,
  };

  double? cmtom() {
    final cm = double.tryParse(cmctr.text.trim());
    if(cm == null || cm<=0){
      return null;
    }
    return cm/100.0;
  }

  double? lbtokg(){
      final lb=double.tryParse(weightctr.text.trim());
      if(lb == null || lb<=0  || lb>1500){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid input')));
        return null;
      }
      return lb*0.453592;
  }
  double? kgtokg(){
    final kg=double.tryParse(weightctr.text.trim());
    if(kg == null || kg<=0 || kg>700){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid input')));
      return null;
    }
    return kg;
  }

  double? feetinctom(){
    var feet = double.tryParse(feetctr.text.trim());
    var inch = double.tryParse(inchctr.text.trim());

    if(feet == null || feet<=0 || inch == null ||inch<=0){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid input')));
      return null;
    }
    if(inch>=12){
      feet= feet+ inch/12;
      inch= inch%12;
    }

    final totalinch =feet*12+inch;
    if(totalinch <=0 ){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid input')));
      return null;
    }
    return totalinch*0.0254;
  }

  void  _calculator(){

    final w=iskg? kgtokg():lbtokg();

    final m= heighttype == Heighttype.cm ? cmtom():feetinctom();
    if(w==null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid input')));

    }
    if(m==null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid input')));

    }

    final bmi=w! / (m!*m);
    final cat= catagoryresult(bmi);
    setState(() {
      _bmiresult = bmi.toStringAsFixed(1);
      catagory = cat;

      weightctr.clear();
      cmctr.clear();
      feetctr.clear();
      inchctr.clear();

    });
  }


  void dispose(){
    weightctr.dispose();
    cmctr.dispose();
    feetctr.dispose();
    inchctr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.deepPurple[300],
        centerTitle: true,
      ),

      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Stack(
          //   children:[
          //     Card(
          //       child: Column(
          //         children: [
          //          Text('What is your sex?',
          //          style: TextStyle(
          //          fontWeight: FontWeight.bold,
          //          fontSize: 30,
          //         ),
          //      ),
          //    Row(
          //    children: [
          //       Card(
          //           child: Column(
          //             children: [
          //               Image(image: AssetImage('accets/woman.png'),),
          //             ],
          //           ),
          //       ),
          //     ],
          //     ),
          //    ],
          //    ),),
          //   ] ,
          //   ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding:  EdgeInsets.all(18.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('How much do you weigh?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16,),
                    TextField(
                      controller: weightctr,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        suffixIcon: Container(
                          alignment: Alignment.center,
                          width: 50,
                          // decoration: BoxDecoration(
                          //   color: Colors.grey.shade100,
                          //   borderRadius: BorderRadius.only(
                          //     topRight: Radius.circular(5),
                          //     bottomRight: Radius.circular(5),
                          //   ),
                          // ),
                          child: Text(
                            iskg?'Kg':'LB',
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _bmiresult = '';
                          catagory = null;
                        });
                      },
                    ),

                    SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(onPressed: (){
                          setState(() {
                            selectedbutton1=1;
                            if(!iskg){
                              final lb= double.tryParse(weightctr.text.trim());
                              if(lb!=null){
                                final kg=(lb*0.453592);
                                weightctr.text=kg.toStringAsFixed(2);
                              }
                            }
                            iskg=true;
                          });
                        },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedbutton1 == 1 ? Colors.deepPurpleAccent[300] : Colors.grey[100],
                              foregroundColor: selectedbutton1 == 1 ? Colors.black : Colors.black,
                              side: BorderSide(
                                color: selectedbutton1 == 1 ? Colors.deepPurpleAccent : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Text('Kg')),
                        ElevatedButton(onPressed: (){
                          setState(() {
                            selectedbutton1=2;
                            if(iskg){
                              final kg=double.tryParse(weightctr.text.trim());
                              if(kg!=null){
                                final lb=(kg/0.453592);
                                weightctr.text=lb.toStringAsFixed(2);
                              }
                            }
                            iskg=false;
                          });
                        },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedbutton1 == 2 ? Colors.deepPurpleAccent[300] : Colors.grey[100],
                              foregroundColor: selectedbutton1 == 2 ? Colors.black : Colors.black,
                              side: BorderSide(
                                color: selectedbutton1 == 2 ? Colors.deepPurpleAccent : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Text('Lb')),
                      ],
                    )
                  ],
                ),
              ),

            ),
          ),
          
          Padding(
              padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                  padding: EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Text('How tall you are?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16,),

                    if(heighttype==Heighttype.cm)...[
                      SizedBox(height: 16,),
                      TextField(
                        controller: cmctr,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          suffixIcon: Container(
                            alignment: Alignment.center,
                            width: 50,
                            // decoration: BoxDecoration(
                            //   color: Colors.grey.shade200,
                            //   borderRadius: BorderRadius.only(
                            //     topRight: Radius.circular(5),
                            //     bottomRight: Radius.circular(5),
                            //   ),
                            // ),
                            child: Text(
                              'cm',
                            ),
                          ),
                        ),
                      ),
                    ]else...[
                      SizedBox(height: 16,),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: feetctr,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                suffixIcon: Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  // decoration: BoxDecoration(
                                  //   color: Colors.grey.shade200,
                                  //   borderRadius: BorderRadius.only(
                                  //     topRight: Radius.circular(5),
                                  //     bottomRight: Radius.circular(5),
                                  //   ),
                                  // ),
                                  child: Text(
                                    'ft',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: TextField(
                              controller: inchctr,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                suffixIcon: Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  // decoration: BoxDecoration(
                                  //   color: Colors.grey.shade200,
                                  //   borderRadius: BorderRadius.only(
                                  //     topRight: Radius.circular(5),
                                  //     bottomRight: Radius.circular(5),
                                  //   ),
                                  // ),
                                  child: Text(
                                    'in',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                    SizedBox(height: 16,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(onPressed: (){
                          setState(() {
                            selectedbutton2=1;
                            heighttype = Heighttype.cm;
                          });
                        },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedbutton2 == 1 ? Colors.deepPurpleAccent[300] : Colors.grey[100],
                              foregroundColor: selectedbutton2 == 1 ? Colors.black : Colors.black,
                              side: BorderSide(
                                color: selectedbutton2 == 1 ? Colors.deepPurpleAccent : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Text('Cm')),
                        ElevatedButton(onPressed: (){
                          setState(() {
                            selectedbutton2=2;
                            heighttype = Heighttype.feetInch;
                          });
                        },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedbutton2 == 2 ? Colors.deepPurpleAccent[300] : Colors.grey[100],
                              foregroundColor: selectedbutton2 == 2 ? Colors.black : Colors.black,
                              side: BorderSide(
                                color: selectedbutton2 == 2 ? Colors.deepPurpleAccent : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Text('Ft/In')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // SegmentedButton<Heighttype>(segments: [
          //   ButtonSegment<Heighttype>(value: Heighttype.cm, label: Text('CM')),
          //   ButtonSegment<Heighttype>(value: Heighttype.feetInch, label: Text('Feet/Inch')),
          // ],
          //     selected: {heighttype},
          //   onSelectionChanged: (value)=> setState(()
          //     => heighttype= value.first
          //   ),
          // ),
          // if(heighttype==Heighttype.cm)...[
          //   SizedBox(height: 16,),
          //   TextField(
          //     controller: cmctr,
          //     decoration: InputDecoration(
          //       labelText: 'Height(cm)',
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(10),
          //         borderSide: BorderSide(
          //           color: Colors.black,
          //           width: 2,
          //         ),
          //       ),
          //     ),
          //   ),
          // ]else...[
          //   SizedBox(height: 16,),
          //   Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           controller: feetctr,
          //           decoration: InputDecoration(
          //             labelText: "Feet(')",
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(10),
          //               borderSide: BorderSide(
          //                 color: Colors.black,
          //                 width: 2,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: TextField(
          //           controller: inchctr,
          //           decoration: InputDecoration(
          //             labelText: 'Inch(")',
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(10),
          //               borderSide: BorderSide(
          //                 color: Colors.black,
          //                 width: 2,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   )
          // ],

          SizedBox(height: 16,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
                onPressed: _calculator,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
               ),
                child: Text('Calculate BMI',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent[300],
              ),
            )),

          ),
          SizedBox(height: 16,),

          if (_bmiresult.isNotEmpty) ...[
            Center(
              child: Column(
                children: [
                  Text(
                    'Your BMI: $_bmiresult',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Chip(
                    label: Text(
                      catagory ?? '',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: catagorycolor[catagory] ?? Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ],
              ),
            ),
          ]

        ],
      ),
    );
  }
}
