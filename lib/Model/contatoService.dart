import 'package:agenda_contatos/Model/contato.dart';

class ContatoService {
  static List<Contato> contatos = [];

  String cadastrarContato(Contato contato) {
    contatos.add(contato);
    return "Novo contato: ${contato.nome} ${contato.sobrenome}";
  }

  List<Contato> listarContato() {
    return contatos;
  }

  void atualizarContato(Contato contatoAtualizado) {
    for (int i = 0; i < contatos.length; i++) {
      if (contatos[i].id == contatoAtualizado.id) {
        contatos[i] = contatoAtualizado; // Atualiza o contato
        break;
      }
    }
  }

  String excluirContato(int id) {
    try {
      Contato contatoParaExcluir =
          contatos.firstWhere((contato) => contato.id == id);

      contatos.remove(contatoParaExcluir);
      return "Contato excluído: ${contatoParaExcluir.nome} ${contatoParaExcluir.sobrenome}";
    } catch (e) {
      return "Contato não encontrado.";
    }
  }
}
