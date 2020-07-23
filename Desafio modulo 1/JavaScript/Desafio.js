//---------------------Funções Aux--------------------------------------------------
function retornarSaldoTotal(contas,agencia){
  if (contas.length!==0)
  {
    if(agencia !== null){
      contasaux = contas.filter(item=>item.agencia==agencia);
    }
    else
    {
      contasaux = contas;
    };
  }
  return (contasaux.length>0)?contasaux.map(item=>item.balance).reduce((a,b)=>a+b):0;
};
function retornaContasAgencia(contas,agencia){
  return contas.filter(item=>item.agencia==agencia);
};
function retornaValoresAtributoAccounts(contas,parametro){
  var arrayAux=[];
  for (i=0;i<contas.length;i++)
  {
    if (arrayAux.indexOf(contas[i][parametro]) === -1)
    {
     arrayAux.push(contas[i][parametro]);
    }
  }
  return arrayAux;
};
function retornaMaiorSaldoAgencia(contas,agencia){
  contasAgencia = retornaContasAgencia(contas,agencia);
  contasAgencia = contasAgencia.sort((a,b)=>b.balance-a.balance); 
  return (contasAgencia.length>0)?contasAgencia[0].balance:0;
};
//----------------------------------Questoes------------------------------------------
function questao1(contas)
{
  console.info("Questão 1 - Saldo total contas: "+retornarSaldoTotal(contas,null));
}
function questao2(contas)
{
  var contasaux = contas.filter(item=>item.balance>100);
  console.info("Questão 2 - Quantidade de contas saldo maior que 100: "+contasaux.length);
}
function questao3(contas)
{
  contasAux = contas.filter(item=>item.balance>100&item.agencia===33);
  console.info("Questão 3 - Quantidade de contas saldo maior que 100 na agencia 33: "+contasAux.length);
}
function questao4e5(contas)
{
  //console.info("Dados para questões 4 e 5");
  ListaAgencias = retornaValoresAtributoAccounts(contas,"agencia");
  var Array4e5=[];
  var agencia
  for (i=0;i<ListaAgencias.length;i++)
  {
    agencia = {agencia:ListaAgencias[i],
               saldo:retornarSaldoTotal(contas,ListaAgencias[i])};
    Array4e5.push(agencia);
    //console.info("Agencia: "+ListaAgencias[i]+" Saldo Valor Total Agencia: "+retornarSaldoTotal(contas,ListaAgencias[i]));
  };
  console.info("Questão 4 - Agencia com maior saldo: "+Array4e5.sort((a,b)=>b.saldo-a.saldo)[0].agencia);
  console.info("Questão 5 - Agencia com menor saldo: "+Array4e5.sort((a,b)=>a.saldo-b.saldo)[0].agencia);
}
function questao6(contas)
{
  //console.info("Dados para questao 6");
  ListaAgencias = retornaValoresAtributoAccounts(contas,"agencia");
  /*for (i=0;i<ListaAgencias.length;i++)
  {
    console.info("Agencia: "+ListaAgencias[i]+" Maior saldo agencia : "+retornaMaiorSaldoAgencia(contas,ListaAgencias[i]));
  };*/
  var maioresSaldos=[];
  for (i=0;i<ListaAgencias.length;i++)
  {
    maioresSaldos.push(retornaMaiorSaldoAgencia(contas,ListaAgencias[i]));
  }
  console.info("Questão 6 - Somatoria do maior saldo das agencias: "+maioresSaldos.reduce((a,b)=>a+b) );
}
function questao7(contas)
{
  var contasAux = retornaContasAgencia(contas,10);
  contasAux.sort((a,b)=>b.balance-a.balance)
  console.info("Questão 7 - Maior saldo na agencia 10: "+contasAux[0].name);
}
function questao8e9e10e11(contas)
{
  var contasAux = retornaContasAgencia(contas,47);
  contasAux.sort((a,b)=>a.balance-b.balance);
  console.info("Questão 8 - Menor saldo na agencia 47: "+contasAux[0].name);
  console.info("Questão 9 - Os tres menores saldos da agencia 47: "+contasAux.map((a)=>a.name).slice(0,3).join());
  console.info("Questão 10 - Quantidade de clientes na agencia 47: "+contasAux.length);
  console.info("Questão 11 - Quantidade de 'Maria' na agencia 47: "+contasAux.filter((a)=>a.name.includes("Maria")).length);
}
function questao12(contas)
{
  var proximoid = contas.sort((a,b)=>b.id-a.id)[0].id;
  proximoid++;
  console.info("Questão 12 - Ultimo id: "+proximoid);
}
const executaFetch = async (path) =>
{
  const response = await fetch(path).catch(reason=>console.info("erro: "+reason));
  response.json().then(contas=>
  {
    questao1(contas);
    questao2(contas);
    questao3(contas);
    questao4e5(contas);
    questao6(contas);
    questao7(contas);
    questao8e9e10e11(contas);
    questao12(contas);
  });
};
//------------Main--------------------------------------------------------------------
var path = "https://igti-film.herokuapp.com/api/accounts";
//var path = "http://localhost:3090/api/accounts";
executaFetch(path);