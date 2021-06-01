class Mensagem {
  String nome;
  String mensagem;
  DateTime data;
  bool status;

  Mensagem({this.nome, this.mensagem, this.status = true});

  Mensagem.fromMap(Map<String, dynamic> map) {
    this.nome = map['nome'];
    this.mensagem = map['mensagem'];
    this.data = DateTime.fromMillisecondsSinceEpoch(map['data']);
  }
}
