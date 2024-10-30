import 'package:agenda_contatos/Model/contato.dart';
import 'package:agenda_contatos/Model/contatoService.dart';
import 'package:agenda_contatos/View/cadastro.dart';
import 'package:agenda_contatos/View/recursos/navBar.dart';
import 'package:agenda_contatos/View/recursos/menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Busca extends StatefulWidget {
  @override
  State createState() => new BuscaState();
}

class BuscaState extends State<Busca> {
  // Objeto de Model
  ContatoService service = new ContatoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Barra de Título
        appBar: new NavBar(),

        // Menu (hambúrguer)
        drawer: new MenuDrawer(),

        // Corpo do App
        body: ListView.builder(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 75),
            itemCount:
                service.listarContato().length, // Número de itens na lista
            itemBuilder: (BuildContext context, int index) {
              // Guarda o retorno da lista no objeto da classe
              Contato contato = service.listarContato().elementAt(
                  index); // Certifique-se de que `contato` está sendo definido aqui

              return Container(
                  color: Colors.grey.shade800,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: ListTile(
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Nome e Fone
                            new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  new Text(
                                      contato.nome + " " + contato.sobrenome,
                                      style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 24)),
                                  SizedBox(height: 10),
                                  new Text(contato.telefone)
                                ]),

                            SizedBox(width: 15)
                          ]),
                      trailing: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.circleChevronRight,
                            color: Colors.grey,
                            size: 32,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new Cadastro(
                                        contato:
                                            contato))); // Passando o contato correto
                          })));
            }),

        // Botão flutuante (Cadastro)
        floatingActionButton: FloatingActionButton(
            child: FaIcon(FontAwesomeIcons.plus, size: 32),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new Cadastro()));
            }));
  }
}
