import 'package:flutter/material.dart';

class Back extends StatelessWidget {
 const Back({super.key , required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Image.asset('assets/icons/Arrow-Right.png'),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF24252C),
            fontSize: 16,
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
      ],
    );
  }
}
