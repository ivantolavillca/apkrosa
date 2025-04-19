import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/salud_model.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _edadController = TextEditingController();
  final _generoController = TextEditingController();
  final _pesoController = TextEditingController();
  final _estaturaController = TextEditingController();
  final _comidasDiariasController = TextEditingController();
  int _antecedentesFamiliares = 1;
  int _condicionesMedicas = 1;
  int _estresAnsiedad = 1;
  int _consumoMedicamentos = 1;
  int _actividadesFisicas = 1;
  int _consumoComidaRapida = 1;
  int? _estadoFisico;
  String? _recomendaciones;
  String? _imagenUrl;

  void _realizarPrediccion() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      final saludModel = SaludModel(
        edad: int.parse(_edadController.text),
        genero: int.parse(_generoController.text),
        peso: double.parse(_pesoController.text.replaceAll(',', '.')),
        estatura: double.parse(_estaturaController.text.replaceAll(',', '.')),
        antecedentes_familiares: int.parse(_generoController.text),
        condiciones_medicas: _condicionesMedicas,
        consumo_medicamentos: _consumoMedicamentos,
        estres_ansiedad: _estresAnsiedad,
        actividades_fisicas: _actividadesFisicas,
        comida_diaria: int.parse(_comidasDiariasController.text),
        consumo_comida_rapida: _consumoComidaRapida,
      );
      showDialog(
        context: context,
        barrierDismissible:
            false, // Evita que se cierre al tocar fuera del diálogo
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      try {
        final response = await Provider.of<ApiService>(context, listen: false)
            .realizarPrediccion(saludModel);
        Navigator.of(context).pop();
        setState(() {
          _estadoFisico = response['prediccion'];
          switch (_estadoFisico) {
            case 1:
              _imagenUrl = 'assets/imagesn/peso1.png';
              _recomendaciones =
                  'Consulta a un médico para asegurarte de que estás en buen estado de salud.';
              break;
            case 2:
              _imagenUrl = 'assets/imagesn/peso2.png';
              _recomendaciones = 'Sigue con tu estilo de vida saludable.';
              break;
            case 3:
              _imagenUrl = 'assets/imagesn/peso3.png';
              _recomendaciones =
                  'Mantén una dieta saludable y ejercicio regular.';
              break;
            case 4:
              _imagenUrl = 'assets/imagesn/peso4.png';
              _recomendaciones =
                  'Considera cambios en tu estilo de vida para mejorar tu salud.';
              break;
            case 5:
              _imagenUrl = 'assets/imagesn/peso5.png';
              _recomendaciones =
                  'Se recomienda una dieta balanceada y ejercicio regular.';
              break;
            case 6:
              _imagenUrl = 'assets/imagesn/peso6.png';
              _recomendaciones =
                  'Es importante buscar ayuda médica para un plan de pérdida de peso.';
              break;
            default:
              _imagenUrl = null;
              _recomendaciones = 'Estado físico desconocido.';
          }
        });
        FocusScope.of(context).unfocus();
      } catch (e) {
        Navigator.of(context).pop();

        // Manejar error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Ocurrió un error al realizar la predicción.')),
        );
      }
    }
  }

  String _obtenerDescripcionEstado(int? estado) {
    if (estado == 6) {
      return 'Obesidad III';
    } else if (estado == 5) {
      return 'Obesidad II';
    } else if (estado == 4) {
      return 'Obesidad I';
    } else if (estado == 3) {
      return 'Sobrepeso';
    } else if (estado == 2) {
      return 'Normal';
    } else if (estado == 1) {
      return 'Bajo';
    } else {
      return 'Estado físico desconocido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Verifica tu estado físico',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/fondo.png'), // Asegúrate de tener esta imagen en tu carpeta assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField<int?>(
                          value: null,
                          decoration: InputDecoration(
                            labelText: 'Edad',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('[SELECCIONE UNA OPCIÓN]'),
                            ),
                            ...List.generate(6, (index) => index + 13)
                                .map((age) => DropdownMenuItem(
                                      value: age,
                                      child: Text(age.toString()),
                                    ))
                          ].toList(),
                          onChanged: (value) {
                            setState(() {
                              _edadController.text = value?.toString() ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor selecciona una edad válida';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String?>(
                          value:
                              null, // Asegúrate de que el valor inicial sea null
                          decoration: InputDecoration(
                            labelText: 'Género',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: null,
                              child: Text('[SELECCIONE UNA OPCIÓN]'),
                            ),
                            DropdownMenuItem(
                              value: '1',
                              child: Text('Masculino'),
                            ),
                            DropdownMenuItem(
                              value: '2',
                              child: Text('Femenino'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _generoController.text = value?.toString() ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor selecciona un género válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _pesoController,
                          decoration: InputDecoration(
                            labelText: 'Peso (kg)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa un peso válido';
                            } else {
                              final peso = double.tryParse(value);
                              if (peso == null || peso <= 0 || peso > 150) {
                                return 'Por favor ingresa un peso válido (mayor a 0 y menor a 150)';
                              }
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _estaturaController,
                          decoration: InputDecoration(
                            labelText: 'Estatura (mts)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa una estatura válida';
                            } else {
                              final estatura = double.tryParse(value);
                              if (estatura == null ||
                                  estatura <= 0 ||
                                  estatura > 2.5) {
                                return 'Por favor ingresa una estatura válida (mayor a 0 y menor o igual a 2.5)';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CheckboxListTile(
                          title: const Text(
                              '¿En tu familia tienen antecedentes de obesidad?'),
                          value: _antecedentesFamiliares == 2,
                          onChanged: (value) {
                            setState(() {
                              _antecedentesFamiliares = value! ? 2 : 1;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text(
                              '¿Sufre de condiciones médicas de obesidad?'),
                          value: _condicionesMedicas == 2,
                          onChanged: (value) {
                            setState(() {
                              _condicionesMedicas = value! ? 2 : 1;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('¿Sufre de estrés o ansiedad?'),
                          value: _estresAnsiedad == 2,
                          onChanged: (value) {
                            setState(() {
                              _estresAnsiedad = value! ? 2 : 1;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text(
                              '¿Consume medicamentos que puedan alterar el peso?'),
                          value: _consumoMedicamentos == 2,
                          onChanged: (value) {
                            setState(() {
                              _consumoMedicamentos = value! ? 2 : 1;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('¿Realiza actividad física?'),
                          value: _actividadesFisicas == 2,
                          onChanged: (value) {
                            setState(() {
                              _actividadesFisicas = value! ? 2 : 1;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text(
                              '¿Consume comida rápida frecuentemente?'),
                          value: _consumoComidaRapida == 2,
                          onChanged: (value) {
                            setState(() {
                              _consumoComidaRapida = value! ? 2 : 1;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _comidasDiariasController,
                          decoration: InputDecoration(
                            labelText: '¿Cuántas veces come al día?',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa un número válido';
                            } else {
                              final comida = double.tryParse(value);
                              if (comida == null ||
                                  comida <= 0 ||
                                  comida > 5) {
                                return 'Por favor ingresa un número válido (mayor a 0 y menor a 5)';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _realizarPrediccion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[300],
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Realizar predicción'),
                        ),
                        const SizedBox(height: 20),
                        if (_estadoFisico != null) ...[
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Tu estado físico es: ${_obtenerDescripcionEstado(_estadoFisico)}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _recomendaciones ?? '',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                if (_imagenUrl != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Image.asset(_imagenUrl!,
                                        height: 250, width: 250),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
