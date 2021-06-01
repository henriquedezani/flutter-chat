class Mensagem {
  String nome;
  String mensagem;

  Mensagem({this.nome, this.mensagem});

  Mensagem.fromMap(Map<String, dynamic> map) {
    this.nome = map['nome'];
    this.mensagem = map['email'];
  }
}
