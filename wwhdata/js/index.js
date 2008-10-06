function  WWHBookData_AddIndexEntries(P)
{
var A=P.fA("B",null,null,"002");
var B=A.fA("Becoming a registered user",new Array("1"));
A=P.fA("O",null,null,"002");
B=A.fA("Online help");
var C=B.fA("locating topics of interest",new Array("1#1089533"));
C=B.fA("printing",new Array("1#1089553"));
B=A.fA("Online help, using",new Array("1"));
A=P.fA("R",null,null,"002");
B=A.fA("Registration",new Array("1"));
A=P.fA("U",null,null,"002");
B=A.fA("Using online help",new Array("1"));
}

function  WWHBookData_MaxIndexLevel()
{
  return 3;
}
