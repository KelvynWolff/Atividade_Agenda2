import 'package:agenda_contatos/Model/contato.dart';
import 'package:agenda_contatos/Model/contatoService.dart';
import 'package:agenda_contatos/View/busca.dart';
import 'package:agenda_contatos/View/recursos/navBar.dart';
import 'package:agenda_contatos/View/recursos/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Cadastro extends StatefulWidget {
  final Contato? contato; // Contato opcional para ser editado

  Cadastro({this.contato}); // Construtor para aceitar o contato opcional

  @override
  State createState() => new CadastroState();
}

class CadastroState extends State<Cadastro> {
  // Controladores dos campos Input
  final nome = new TextEditingController();
  final sobrenome = new TextEditingController();
  final email = new TextEditingController();
  final telefone = new TextEditingController();

  // Máscara de telefone
  var maskFormatter = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Se estamos editando um contato, preenche os campos com os dados
    if (widget.contato != null) {
      nome.text = widget.contato!.nome;
      sobrenome.text = widget.contato!.sobrenome;
      email.text = widget.contato!.email;
      telefone.text = widget.contato!.telefone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new NavBar(),
        drawer: new MenuDrawer(),
        body: new SingleChildScrollView(
            // Formulário
            child: new Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade800),
                child: new Form(
                  key: _formKey,
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Título
                        new Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(bottom: 15),
                            child: new Text(
                                widget.contato != null
                                    ? "Editar Contato"
                                    : "Cadastro de Contato", // Título muda para edição
                                style: new TextStyle(
                                    color: Colors.grey.shade300,
                                    fontSize: 24))),

                        // Inputs (campos do formulário)
                        campoInput("Nome", nome, "Informe o nome"),
                        campoInput("Sobrenome", sobrenome, null),

                        campoEmail("E-mail", email, "Informe um e-mail válido"),
                        campoTelefone(
                            "Telefone", telefone, "Informe um telefone válido"),

                        SizedBox(height: 15),

                        // Botões
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Botão Cadastrar ou Atualizar
                              new Builder(builder: (BuildContext context) {
                                return new ElevatedButton(
                                    child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 10),
                                        child: new Text(
                                            widget.contato != null
                                                ? "Atualizar"
                                                : "Cadastrar", // Muda o texto do botão se for para editar ou cadastrar
                                            style: new TextStyle(
                                                fontSize: 18,
                                                color: Colors.white))),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (widget.contato != null) {
                                          atualizar(); // Atualiza o contato se ele já existe
                                        } else {
                                          cadastrar(); // Cadastra um novo contato
                                        }
                                      }
                                    });
                              }),

                              // Botão Limpar
                              new Builder(builder: (BuildContext context) {
                                return new ElevatedButton(
                                    child: new Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 10),
                                        child: new Text("Limpar",
                                            style: new TextStyle(
                                                fontSize: 18,
                                                color: Colors.white))),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade600),
                                    onPressed: () {
                                      limpar();
                                    });
                              }),

                              // Botão Excluir (somente aparece se for edição)
                              widget.contato != null
                                  ? new Builder(
                                      builder: (BuildContext context) {
                                      return new ElevatedButton(
                                          child: new Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25, vertical: 10),
                                              child: new Text("Excluir",
                                                  style: new TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white))),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.redAccent),
                                          onPressed: () {
                                            excluir();
                                          });
                                    })
                                  : Container(),
                            ])
                      ]),
                ))));
  }

  // Retorna a estrutura do campo input
  Container campoInput(String nomeCampo, TextEditingController controlador,
      String? validationMessage) {
    return new Container(
        margin: EdgeInsets.only(bottom: 10),
        child: new TextFormField(
            controller: controlador,
            validator: (value) {
              if (validationMessage != null &&
                  (value == null || value.isEmpty)) {
                return validationMessage;
              }
              return null;
            },
            decoration: new InputDecoration(
                labelText: nomeCampo,
                labelStyle:
                    new TextStyle(color: Colors.grey.shade300, fontSize: 18),

                // Borda do Input
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)),

                // Borda selecionada
                focusedBorder: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.orange)))));
  }

  // Campo de telefone com máscara
  Container campoTelefone(String nomeCampo, TextEditingController controlador,
      String? validationMessage) {
    return new Container(
        margin: EdgeInsets.only(bottom: 10),
        child: new TextFormField(
            controller: controlador,
            inputFormatters: [maskFormatter],
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty || value.length != 15) {
                return validationMessage;
              }
              return null;
            },
            decoration: new InputDecoration(
                labelText: nomeCampo,
                labelStyle:
                    new TextStyle(color: Colors.grey.shade300, fontSize: 18),

                // Borda do Input
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)),

                // Borda selecionada
                focusedBorder: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.orange)))));
  }

  // Campo de e-mail com validação
  Container campoEmail(String nomeCampo, TextEditingController controlador,
      String validationMessage) {
    return new Container(
        margin: EdgeInsets.only(bottom: 10),
        child: new TextFormField(
            controller: controlador,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return validationMessage;
              }
              return null;
            },
            decoration: new InputDecoration(
                labelText: nomeCampo,
                labelStyle:
                    new TextStyle(color: Colors.grey.shade300, fontSize: 18),

                // Borda do Input
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)),

                // Borda selecionada
                focusedBorder: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.orange)))));
  }

  // Função para cadastrar um novo contato
  void cadastrar() {
    ContatoService service = new ContatoService();

    // Guarda o último ID cadastrado
    int ultimoID = service.listarContato().length;

    Contato contato = new Contato(
      id: ultimoID + 1,
      nome: nome.text,
      sobrenome: sobrenome.text,
      email: email.text,
      telefone: telefone.text,
    );

    // Envia o objeto preenchido para adicionar na lista
    String mensagem = service.cadastrarContato(contato);

    if (mounted) {
      // Mostra a mensagem com SnackBar
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: new Text(mensagem,
            textAlign: TextAlign.center,
            style: new TextStyle(color: Colors.grey.shade300)),
        duration: Duration(milliseconds: 2000),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey.shade800,
      ));

      // Redireciona para a tela de Busca
      Future.delayed(Duration(milliseconds: 2500), () {
        if (mounted) {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new Busca()));
        }
      });
    }
  }

  // Função para atualizar o contato existente
  void atualizar() {
    ContatoService service = new ContatoService();

    Contato contatoAtualizado = new Contato(
      id: widget.contato!.id,
      nome: nome.text,
      sobrenome: sobrenome.text,
      email: email.text,
      telefone: telefone.text,
    );

    // Atualiza o contato na lista
    service.atualizarContato(contatoAtualizado);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: new Text("Contato atualizado com sucesso!",
            textAlign: TextAlign.center,
            style: new TextStyle(color: Colors.grey.shade300)),
        duration: Duration(milliseconds: 2000),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey.shade800,
      ));

      // Redireciona para a tela de Busca
      Future.delayed(Duration(milliseconds: 2500), () {
        if (mounted) {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new Busca()));
        }
      });
    }
  }

  // Função para excluir um contato
  void excluir() {
    ContatoService service = new ContatoService();

    try {
      // Exclui o contato da lista
      String mensagem = service.excluirContato(widget.contato!.id);

      // Mostra a mensagem com SnackBar
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: new Text(mensagem,
            textAlign: TextAlign.center,
            style: new TextStyle(color: Colors.grey.shade300)),
        duration: Duration(milliseconds: 2000),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey.shade800,
      ));

      // Redireciona para a tela de Busca
      Future.delayed(Duration(milliseconds: 2500), () {
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => new Busca()));
      });
    } catch (e) {
      // Mostra mensagem de erro se o contato não for encontrado
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: new Text("Contato não encontrado.",
            textAlign: TextAlign.center,
            style: new TextStyle(color: Colors.grey.shade300)),
        duration: Duration(milliseconds: 2000),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  // Limpar campos
  void limpar() {
    this.nome.text = "";
    this.sobrenome.text = "";
    this.email.text = "";
    this.telefone.text = "";
  }
}
