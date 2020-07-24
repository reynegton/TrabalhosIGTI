import 'dart:convert';
import 'dart:io';

//-------classes que serao usadas-------------------------------------------------------------------------------------------------
class Conta {
  int id;
  int agencia;
  int conta;
  String name;
  int balance;
}

class Agencia {
  int agencia;
  int saldo;
}

//------funcoes auxiliadoras-------------------------------------------------------------------------------------------------------

Future<String> executaRequest() async {
  const link = "https://igti-film.herokuapp.com/api/accounts";
  var result = new StringBuffer();
  String textJson = "";
  var request = await HttpClient().getUrl(Uri.parse(link));
  var response = await request.close();
  await for (var contents in response.transform(utf8.decoder)) {
    result.write(contents);
  }
  textJson += result.toString();
  return textJson;
}

int retornarSaldoTotal(List<Conta> contas, int agencia) {
  var contasaux;
  if (contas.length != 0) {
    if (agencia != null) {
      contasaux = contas.where((item) => item.agencia == agencia);
    } else {
      contasaux = contas;
    }
  }
  return (contasaux.length > 0)
      ? contasaux.map((item) => item.balance).reduce((a, b) => a + b)
      : 0;
}

List<Conta> retornaContasAgencia(List<Conta> contas, int agencia) {
  List<Conta> arrayAux = new List();
  arrayAux = contas.where((item) => item.agencia == agencia).toList();
  return arrayAux;
}

List retornaListaAgencias(List<Conta> contas) {
  var arrayAux = [];
  for (int i = 0; i < contas.length; i++) {
    if (arrayAux.indexOf(contas[i].agencia) == -1) {
      arrayAux.add(contas[i].agencia);
    }
  }
  return arrayAux;
}

int retornaMaiorSaldoAgencia(List<Conta> contas, int agencia) {
  List<Conta> contasAgencia =
      contas.where((item) => item.agencia == agencia).toList();
  contasAgencia.sort((a, b) => b.balance - a.balance);
  return (contasAgencia.length > 0) ? contasAgencia.first.balance : 0;
}

Future<List<Conta>> retornaContas() async {
  var listJson = jsonDecode(await executaRequest());
  List<Conta> contasAux = new List();

  //for (int i = 0; i < contasJson.length; i++) {
  for (var item in listJson) {
    Conta conta = new Conta();
    conta.id = item["id"];
    conta.agencia = item["agencia"];
    conta.conta = item["conta"];
    conta.name = item["name"];
    conta.balance = item["balance"];

    contasAux.add(conta);
  }
  return contasAux;
}

//-------------------------Questoes----------------------------------------------------------------
void questao1(List<Conta> contas) {
  print("Questão 1 - Saldo total contas: " +
      retornarSaldoTotal(contas, null).toString());
}

void questao2(List<Conta> contas) {
  var contasaux = contas.where((item) => item.balance > 100);
  print("Questão 2 - Quantidade de contas saldo maior que 100: " +
      contasaux.length.toString());
}

void questao3(List<Conta> contas) {
  var contasAux =
      contas.where((item) => item.balance > 100 && item.agencia == 33).toList();
  print("Questão 3 - Quantidade de contas saldo maior que 100 na agencia 33: " +
      contasAux.length.toString());
}

void questao4e5(List<Conta> contas) {
  var listaAgencias = retornaListaAgencias(contas);
  List<Agencia> array4e5 = new List();

  for (int i = 0; i < listaAgencias.length; i++) {
    Agencia agencia = new Agencia();
    agencia.agencia = listaAgencias[i];
    agencia.saldo = retornarSaldoTotal(contas, listaAgencias[i]);
    array4e5.add(agencia);
  }
  array4e5.sort((a, b) => b.saldo - a.saldo);
  print("Questão 4 - Agencia com maior saldo: " +
      array4e5.first.agencia.toString());
  print("Questão 5 - Agencia com menor saldo: " +
      array4e5.last.agencia.toString());
}

void questao6(List<Conta> contas) {
  var listaAgencias = retornaListaAgencias(contas);
  List maioresSaldos = new List();
  for (int i = 0; i < listaAgencias.length; i++) {
    maioresSaldos.add(retornaMaiorSaldoAgencia(contas, listaAgencias[i]));
  }
  print("Questão 6 - Somatoria do maior saldo das agencias: " +
      maioresSaldos.reduce((a, b) => a + b).toString());
}

void questao7(List<Conta> contas) {
  var contasAux = retornaContasAgencia(contas, 10);
  contasAux.sort((a, b) => b.balance - a.balance);
  print("Questão 7 - Maior saldo na agencia 10: " + contasAux.first.name);
}

void questao8e9e10e11(List<Conta> contas) {
  var contasAux = retornaContasAgencia(contas, 47);
  contasAux.sort((a, b) => a.balance - b.balance);
  print("Questão 8 - Menor saldo na agencia 47: " + contasAux.first.name);
  print("Questão 9 - Os tres menores saldos da agencia 47: " +
      contasAux.map((a) => a.name).take(3).join());
  print("Questão 10 - Quantidade de clientes na agencia 47: " +
      contasAux.length.toString());
  print("Questão 11 - Quantidade de 'Maria' na agencia 47: " +
      contasAux.where((a) => a.name.contains("Maria")).length.toString());
}

void questao12(List<Conta> contas) {
  List<Conta> contasAux = new List();
  contasAux = contas;
  contasAux.sort((a, b) => b.id - a.id);
  var proximoid = contasAux.first.id;
  proximoid++;
  print("Questão 12 - Ultimo id: " + proximoid.toString());
}

//------------------main-----------------------------------------------------------------------------------------------------------
void main(List<String> args) async {
  List<Conta> contas = new List();
  contas = await retornaContas();
  questao1(contas);
  questao2(contas);
  questao3(contas);
  questao4e5(contas);
  questao6(contas);
  questao7(contas);
  questao8e9e10e11(contas);
  questao12(contas);
}
