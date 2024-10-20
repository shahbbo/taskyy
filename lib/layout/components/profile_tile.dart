import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: ShapeDecoration(
        color: const Color(0xFFF5F5F5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0x662F2F2F),
                fontSize: 12,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w500,
                height: 0,
                letterSpacing: 0.20,
              ),
            ),
          ),
          const SizedBox(height: 7),
          SizedBox(
            width: double.infinity,
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0x992F2F2F),
                fontSize: 18,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: 0.20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
