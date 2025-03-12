import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget{

  final IconData icon;
  final String title;
  final String value;

  const InfoTile({
    required this.icon,
    required this.title,
    required this.value,
    super.key,});

  @override
  Widget build(BuildContext context){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.teal.shade700, size: 26),
            ),
            SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.indigo.shade900),
                  ),
                  SizedBox(height: 6),
                  Text(
                    value,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }