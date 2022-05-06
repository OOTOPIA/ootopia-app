import 'package:flutter/material.dart';

class LanguageSelectWidget extends StatelessWidget {
  const LanguageSelectWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Você quer ter acesso a conteúdos em outros idiomas?',
          style: TextStyle(
            color: Color(0xff707070),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Selecione os de sua preferência.',
              style: TextStyle(
                color: Color(0xff707070),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
