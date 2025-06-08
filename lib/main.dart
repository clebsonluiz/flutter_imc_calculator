// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de ImC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [IMCCalculatorPage(), AboutPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculadora de IMC')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'IMC',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Sobre',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}

class IMCCalculatorPage extends StatefulWidget {
  const IMCCalculatorPage({super.key});

  @override
  State<IMCCalculatorPage> createState() => _IMCCalculatorPageState();
}

class _IMCCalculatorPageState extends State<IMCCalculatorPage> {
  String _selectedGender = 'masculino';
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _result = '';

  @override
  void initState() {
    super.initState();
    _heightController.addListener(_calculateIMC);
    _weightController.addListener(_calculateIMC);
  }

  @override
  void dispose() {
    _heightController.removeListener(_calculateIMC);
    _weightController.removeListener(_calculateIMC);
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateIMC() {
    final double? height = double.tryParse(_heightController.text) != null
        ? double.parse(_heightController.text) / 100
        : null;
    final double? weight = double.tryParse(_weightController.text);

    if (height == null || weight == null) {
      setState(() {
        _result = '';
      });
      return;
    }

    final imc = weight / (height * height);
    String classification;

    if (_selectedGender == 'masculino') {
      if (imc < 18.5) {
        classification = 'Abaixo do peso';
      } else if (imc < 25)
        classification = 'Peso normal';
      else if (imc < 30)
        classification = 'Sobrepeso';
      else
        classification = 'Obesidade';
    } else {
      if (imc < 18.0) {
        classification = 'Abaixo do peso';
      } else if (imc < 24)
        classification = 'Peso normal';
      else if (imc < 29)
        classification = 'Sobrepeso';
      else
        classification = 'Obesidade';
    }

    setState(() {
      _result = 'Seu IMC é ${imc.toStringAsFixed(2)}: $classification';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sexo:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: Row(
                    children: [Icon(Icons.male, color: Colors.teal, size: 60)],
                  ),
                  value: 'masculino',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                      _calculateIMC(); // recalcular ao mudar sexo
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: Row(
                    children: [
                      Icon(Icons.female, color: Colors.pinkAccent, size: 60),
                    ],
                  ),
                  value: 'feminino',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                      _calculateIMC(); // recalcular ao mudar sexo
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                children: [
                  TextField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.height, size: 32),
                      labelText: 'Altura (cm)',
                      labelStyle: TextStyle(fontSize: 24, color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange, width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange,
                          width: 2.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.line_weight, size: 32),
                      labelText: 'Peso (kg)',
                      labelStyle: TextStyle(fontSize: 24, color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange, width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange,
                          width: 2.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),
          if (_result.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _result,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite, size: 80, color: Colors.teal),
              SizedBox(height: 20),
              Text(
                'Calculadora de IMC',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                'Este aplicativo calcula seu IMC com base na sua altura, peso e sexo. '
                'A interpretação do resultado leva em conta diferenças fisiológicas entre homens e mulheres, '
                'para oferecer uma classificação mais precisa.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                '🧠 Como o app diferencia homem e mulher?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                'Embora a fórmula do IMC (peso / altura²) seja a mesma para todos, '
                'os limites das faixas de classificação são ajustados no app. '
                'Por exemplo, mulheres geralmente possuem menor massa muscular que homens, '
                'então o intervalo de "peso normal" é ligeiramente diferente.\n\n'
                '📊 Exemplo:\n'
                'Para um IMC de 24.5:\n'
                '- Homem: considerado "Peso normal"\n'
                '- Mulher: considerado "Sobrepeso"',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '💡 Exemplos de faixas ideais de peso:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Faixa de Peso Ideal por Altura',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Homem',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Altura',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Mulher',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(),
                  _buildRow('51-61 kg', '160 cm', '50-56 kg'),
                  _buildRow('61-67 kg', '170 cm', '56-64 kg'),
                  _buildRow('66-72 kg', '176 cm', '61-68 kg'),
                  _buildRow('73-82 kg', '186 cm', '67-76 kg'),
                  _buildRow('76-87 kg', '190 cm', '69-79 kg'),
                  SizedBox(height: 20),
                  Text(
                    'Essas faixas são aproximadas com base no IMC considerado saudável (18,5 a 24,9). '
                    'Pode haver variações, especialmente em pessoas com maior massa muscular, pois '
                    'músculos são mais densos que gordura.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                '📌 Importante: o IMC não diferencia massa muscular de gordura corporal. '
                'Pessoas com muita massa muscular (como atletas) podem ter IMC alto, '
                'mesmo estando saudáveis.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 24),
              Text(
                'Desenvolvido com Flutter ❤️',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função auxiliar para criar cada linha
  Widget _buildRow(String maleWeight, String height, String femaleWeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(maleWeight),
          Text(height, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(femaleWeight),
        ],
      ),
    );
  }
}
