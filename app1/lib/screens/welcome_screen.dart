import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.screen.dart';

class WelcomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(top: 100, bottom: 40),
        decoration:BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage("images/bg.png"),
            fit: BoxFit.cover,
            opacity: 0.6,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Coffe shop",style: GoogleFonts.pacifico(
              fontSize: 50,
                color: Colors.white,
            ),),
            Column(children: [
              Text("Feeling Low? Take a Sip of Coffe", style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
              ),
              SizedBox(height: 80),
              Material(
                color: Color(0xFFE57734),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  splashColor: Colors.black,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=> HomeScreen(),
                    ));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                    child: Text("Get Started", style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing:1,
                    ),),
                  ),
                ),
              ),
            ],),
          ],
        ),
      ),
    );
  }

}