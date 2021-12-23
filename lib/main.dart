import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:partner_details/partner.dart';
import 'package:partner_details/partner_details.dart';
import 'package:partner_details/provider_json.dart';

void main(List<String> args) {
  runApp(const PartnerDetailsApp());
}

class PartnerDetailsApp extends StatefulWidget {
  const PartnerDetailsApp({Key? key}) : super(key: key);

  @override
  _PartnerDetailsAppState createState() => _PartnerDetailsAppState();
}

class _PartnerDetailsAppState extends State<PartnerDetailsApp> {
  @override
  Widget build(BuildContext context) {
    var jsonObject = jsonDecode(json);
    return MaterialApp(
      theme: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(fontFamily: "Poppins")),
      home: PartnerDetails(
        partner: Partner.fromJson(jsonObject),
      ),
    );
  }
}
