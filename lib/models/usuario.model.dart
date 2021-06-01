class Usuario {
  String nome;
  String email;

  Usuario({this.nome, this.email});

  Usuario.fromMap(Map<String, dynamic> map) {
    this.nome = map['nome'];
    this.email = map['email'];
  }
}
