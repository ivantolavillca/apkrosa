class SaludModel {
  final int edad;
  final int genero;
  final double peso;
  final double estatura;

  SaludModel({required this.edad,required this.genero, required this.peso, required this.estatura});

  Map<String, dynamic> toJson() {
    return {
      'edad': edad,
      'genero': genero,
      'peso': peso,
      'estatura': estatura,
    };
  }
}