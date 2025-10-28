
import 'package:flutter/material.dart';

enum Heighttype {cm, feetInch}

class BmiCalculator extends StatefulWidget {
  const BmiCalculator({super.key});

  @override
  State<BmiCalculator> createState() => _BmiCalculatorState();
}

class _BmiCalculatorState extends State<BmiCalculator> {
  Heighttype heighttype= Heighttype.cm;

  final weightctr= TextEditingController();
  final cmctr= TextEditingController();
  final feetctr= TextEditingController();
  final inchctr= TextEditingController();

  String _bmiresult='';
  String? catagory;

  String catagoryresult(double bmi){
    if(bmi<18.5){
      return "Unerweight";
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

  double? cmtom() {
    final cm = double.tryParse(cmctr.text.trim());
    if(cm == null || cm<=0){
      return null;
    }
    return cm/100.0;
  }

  double? feetinctom(){
    final feet = double.tryParse(feetctr.text.trim());
    final inch = double.tryParse(inchctr.text.trim());

    if(feet == null || feet<=0 || inch == null ||inch<=0){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid input')));
      return null;
    }

    final totalinch =feet*12+inch;
    if(totalinch <=0 ){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid input')));
      return null;
    }
    return totalinch*0.0254;
  }

  void  _calculator(){
    final weight = double.tryParse(weightctr.text.trim());
    if(weight == null || weight<=0){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid input')));
    }

    final m= heighttype == Heighttype.cm ? cmtom():feetinctom();
    if(m==null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid input')));

    }

    final bmi=weight! / (m!*m);
    final cat= catagoryresult(bmi);
    setState(() {
      _bmiresult = bmi.toStringAsFixed(1);
      catagory = cat;
    });
    //Navigator.pop(context);
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
        backgroundColor: Color(0xFFB4E560),
        centerTitle: true,
      ),

      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: weightctr,
            decoration: InputDecoration(
              labelText: 'Weight(Kg)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: 16,),
          Text('Height Unit',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16,),
          SegmentedButton<Heighttype>(segments: [
            ButtonSegment<Heighttype>(value: Heighttype.cm, label: Text('CM')),
            ButtonSegment<Heighttype>(value: Heighttype.feetInch, label: Text('Feet/Inch')),
          ],
              selected: {heighttype},
            onSelectionChanged: (value)=> setState(()
              => heighttype= value.first
            ),
          ),
          if(heighttype==Heighttype.cm)...[
            SizedBox(height: 16,),
            TextField(
              controller: cmctr,
              decoration: InputDecoration(
                labelText: 'Height(cm)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
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
                      labelText: "Feet(')",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: inchctr,
                    decoration: InputDecoration(
                      labelText: 'Inch(")',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],


          SizedBox(height: 16,),
          ElevatedButton(
              onPressed: _calculator, child: Text('Show Result')),
          SizedBox(height: 16,),
          Center(child: Text('Result: $_bmiresult')),
          Center(child: Text('Catagory: $catagory')),
          SizedBox(height: 16,),
        ],
      ),
    );
  }
}
