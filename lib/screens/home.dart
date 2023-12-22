import 'package:flutter/material.dart';
import 'package:work_port/screens/login_screen/login_screen.dart';
import 'package:work_port/screens/mainpage.dart';
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(

      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            right: -100,
            top: 70,
            child: Container(
              height: h*0.2,
              width: w*0.5,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  shape: BoxShape.circle
              ),
            ),
          ),
          Positioned(
            top: 530,left: -100,
            child: Container(
              height: h*0.2,
              width: w*0.5,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  shape: BoxShape.circle
              ),
            ),
          ),
          Column(

            children: [

              Padding(
                padding: const EdgeInsets.only(left: 40,top: 70),
                child: Row(
                  children: [
                    RotatedBox(
                      quarterTurns: 3,
                      child: RichText(
                        text: TextSpan(text: 'Planto.Shop',style: TextStyle(color: Colors.black,fontSize:20))
                      ),
                    ),SizedBox(width: 10,),
                    Container(
                      height: h*0.150,
                      width: w*0.002,
                      color: Colors.black45,
                    ),SizedBox(width: 20,),
                    Container(
                        width: w*0.4,
                        height: h*0.170,
                        child: Text('Plant a  tree for life',textAlign: TextAlign.start,style: TextStyle(fontSize: 30),))

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  height: h*0.4,
                  width: w*0.8,
                  child: Image.asset('assets/images/plant1.png',height: h*0.8,width: w*0.6,),
                ),
              ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: w*0.7,
                      child: Text('Worldwide delivery within 10-15 days',textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
                    ),
                  ],
                ),SizedBox(height: 40,),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text('GO',style: TextStyle(color: Colors.white),),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(CircleBorder()),
                  padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                  backgroundColor: MaterialStateProperty.all(Color(0xEA86BD8F)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
