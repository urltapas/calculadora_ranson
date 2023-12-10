import 'package:flutter/material.dart';

void main() => runApp(MeuApp());

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Critérios de Ranson',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FormularioRanson(),
    );
  }
}

class FormularioRanson extends StatefulWidget {
  @override
  _EstadoFormularioRanson createState() => _EstadoFormularioRanson();
}

class _EstadoFormularioRanson extends State<FormularioRanson> {
  final TextEditingController controladorNome = TextEditingController();
  final TextEditingController controladorIdade = TextEditingController();
  final TextEditingController controladorLeucocitos = TextEditingController();
  final TextEditingController controladorGlicemia = TextEditingController();
  final TextEditingController controladorAST = TextEditingController();
  final TextEditingController controladorLDH = TextEditingController();

  bool possuiLitaseBiliar = false;
  int pontuacao = 0;
  String mortalidade = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Critérios de Ranson'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            construirCampoDeTexto(controladorNome, 'Nome'),
            SizedBox(height: 10),
            construirCampoDeTexto(controladorIdade, 'Idade', TextInputType.number),
            SizedBox(height: 10),
            construirCampoDeTexto(controladorLeucocitos, 'Leucócitos', TextInputType.number),
            SizedBox(height: 10),
            construirCampoDeTexto(controladorGlicemia, 'Glicemia', TextInputType.number),
            SizedBox(height: 10),
            construirCampoDeTexto(controladorAST, 'AST/TGO', TextInputType.number),
            SizedBox(height: 10),
            construirCampoDeTexto(controladorLDH, 'LDH', TextInputType.number),

            SizedBox(height: 20),

            CheckboxListTile(
              title: Text('Pancreatite com Litíase Biliar'),
              value: possuiLitaseBiliar,
              onChanged: (bool? valor) {
                if (valor != null) {
                  setState(() {
                    possuiLitaseBiliar = valor;
                  });
                }
              },
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => calcularPontuacaoRanson(),
              child: Text('Calcular'),
            ),

            SizedBox(height: 20),

            Visibility(
              visible: pontuacao > 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Pontuação: $pontuacao',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Mortalidade: $mortalidade',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget construirCampoDeTexto(TextEditingController controlador, String rotulo, [TextInputType tipoTeclado = TextInputType.text]) {
    return TextFormField(
      controller: controlador,
      decoration: InputDecoration(
        labelText: rotulo,
        border: OutlineInputBorder(),
      ),
      keyboardType: tipoTeclado,
    );
  }

  void calcularPontuacaoRanson() {
    pontuacao = 0;

    final int idade = int.tryParse(controladorIdade.text) ?? 0;
    final int leucocitos = int.tryParse(controladorLeucocitos.text) ?? 0;
    final double glicemia = double.tryParse(controladorGlicemia.text) ?? 0.0;
    final double ast = double.tryParse(controladorAST.text) ?? 0.0;
    final double ldh = double.tryParse(controladorLDH.text) ?? 0.0;

    if (!possuiLitaseBiliar) {
      if (idade > 55) pontuacao++;
      if (leucocitos > 16000) pontuacao++;
      if (glicemia > 11) pontuacao++;
      if (ast > 250) pontuacao++;
      if (ldh > 350) pontuacao++;
    } else {
      if (idade > 70) pontuacao++;
      if (leucocitos > 18000) pontuacao++;
      if (glicemia > 12.2) pontuacao++;
      if (ast > 250) pontuacao++;
      if (ldh > 400) pontuacao++;
    }

    mortalidade = (pontuacao >= 3) ? 'Pancreatite Grave' : 'Pancreatite Não Grave';

    setState(() {
      this.pontuacao = pontuacao;
      this.mortalidade = mortalidade;
    });
  }
}
