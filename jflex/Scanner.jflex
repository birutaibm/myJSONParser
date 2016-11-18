package Example;

import java_cup.runtime.SymbolFactory;
%%
%cup
%class Scanner
%{
	public Scanner(java.io.InputStream r, SymbolFactory sf){
		this(r);
		this.sf=sf;
	}
	private SymbolFactory sf;
%}
%eofval{
    return sf.newSymbol("EOF",sym.EOF);
%eofval}

%%
"," { return sf.newSymbol("Comma",sym.COMMA); }
"[" { return sf.newSymbol("Left Square Bracket",sym.LSQBRACKET); }
"]" { return sf.newSymbol("Right Square Bracket",sym.RSQBRACKET); }
"-" { return sf.newSymbol("Unary minus",sym.MINUS); }
\.  { return sf.newSymbol("Decimal separator",sym.DECIMAL_SEPARATOR); }
[0-9]+ { return sf.newSymbol("Integral Number",sym.NUMBER, new Integer(yytext())); }
"true" { return sf.newSymbol("True boolean value",sym.BOOLEAN, new Boolean(true)); }
"false" { return sf.newSymbol("False boolean value",sym.BOOLEAN, new Boolean(false)); }
"null"  { return sf.newSymbol("Null value",sym.NULL, null); }
[ \t\r\n\f] { /* ignore white space. */ }
. { System.err.println("Illegal character: "+yytext()); }
