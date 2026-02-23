import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: AnalisadorCombustivel()));

class AnalisadorCombustivel extends StatefulWidget {
  const AnalisadorCombustivel({super.key});

  @override
  _AnalisadorCombustivelState createState() => _AnalisadorCombustivelState();
}

class _AnalisadorCombustivelState extends State<AnalisadorCombustivel> {
  final _precoGasolinaController = TextEditingController();
  final _precoAlcoolController = TextEditingController();

  String _nivelFidelidade = 'Basico';
  String _resultado = 'Informe os valores';
  bool? _compensa;

  void _analisar() {
    double precoGasolina =
        double.tryParse(_precoGasolinaController.text) ?? 0.0;
    double precoAlcool = double.tryParse(_precoAlcoolController.text) ?? 0.0;

    double valorComDesconto;
    switch (_nivelFidelidade) {
      case 'Prata':
        valorComDesconto = 0.98;
        break;
      case 'Ouro':
        valorComDesconto = 0.95;
        break;
      default:
        valorComDesconto = 1;
    }

    setState(() {
      if (precoAlcool <= 0 || precoGasolina <= 0) {
        _resultado = 'Valores inválidos';
        _compensa = null;
      } else {
        _compensa = (precoAlcool <= precoGasolina * 0.7) ? true : false;
        _resultado = _compensa!
            ? 'O alcool compensa mais com um preço final de R\$ ${(precoAlcool * valorComDesconto).toStringAsFixed(2)}'
            : 'A gasolina compensa mais com um preço final de R\$ ${(precoGasolina * valorComDesconto).toStringAsFixed(2)}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Posto de Combutível Inteligente')),
      //body: SingleChildScrollView( // Para evitar overflow quando o teclado aparecer )
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Dropdown para mudar o tipo (que afetará o Switch)
            DropdownButton<String>(
              value: _nivelFidelidade,
              isExpanded: true,
              onChanged: (String? novoValor) {
                setState(() => _nivelFidelidade = novoValor!);
              },
              items: ['Basico', 'Prata', 'Ouro']
                  .map(
                    (String valor) =>
                        DropdownMenuItem(value: valor, child: Text(valor)),
                  )
                  .toList(),
            ),
            TextField(
              controller: _precoGasolinaController,
              decoration: const InputDecoration(labelText: 'Preço da gasolina'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _precoAlcoolController,
              decoration: const InputDecoration(labelText: 'Preço do alcool'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _analisar, child: const Text('Analisar')),
            const SizedBox(height: 20),

            // 3. TERNÁRIO na Interface (UI)
            Icon(
              _compensa == null
                  ? Icons.info
                  : (_compensa! ? Icons.check_circle : Icons.cancel),
              color: _compensa == null
                  ? Colors.grey
                  : (_compensa! ? Colors.green : Colors.red),
              size: 60,
            ),
            Text(
              _resultado,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
