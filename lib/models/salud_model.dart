class SaludModel {
  final int edad;
  final int genero;
  final double peso;
  final double estatura;
  final int antecedentes_familiares;
  final int condiciones_medicas;
  final int consumo_medicamentos;
  final int estres_ansiedad;
  final int actividades_fisicas;
  final int comida_diaria;
  final int consumo_comida_rapida;
  SaludModel({required this.edad,required this.genero, required this.peso, required this.estatura, required this.antecedentes_familiares, required this.condiciones_medicas, required this.consumo_medicamentos, required this.estres_ansiedad, required this.actividades_fisicas, required this.comida_diaria, required this.consumo_comida_rapida});

  Map<String, dynamic> toJson() {
    return {
      'edad': edad,
      'genero': genero,
      'peso': peso,
      'estatura': estatura,
      'antecedentes_familiares': antecedentes_familiares,
      'condiciones_medicas': condiciones_medicas,
      'consumo_medicamentos': consumo_medicamentos,
      'estres_ansiedad': estres_ansiedad,
      'actividades_fisicas': actividades_fisicas,
      'comida_diaria': comida_diaria,
      'consumo_comida_rapida': consumo_comida_rapida,
    };
  }
}