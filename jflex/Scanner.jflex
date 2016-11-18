package Example;

import java_cup.runtime.SymbolFactory;
import java.lang.StringBuffer;
%%
%cup
%class Scanner
%{
	public Scanner(java.io.InputStream r, SymbolFactory sf){
		this(r);
		this.sf=sf;
		string = new StringBuffer();
	}
	private SymbolFactory sf;
	private StringBuffer string; //used to buffer characters from string literals
%}
%state STRING
%eofval{
    return sf.newSymbol("EOF",sym.EOF);
%eofval}

%%
<STRING> {
      \"                             { yybegin(YYINITIAL); // end the string literal read and return it
                                       return sf.newSymbol("An string literal",sym.STRING, string.toString()); }
      \\u[0-9a-fA-F]{4}              { string.append((char) Integer.parseInt(yytext().substring(2),16)); }
      \\t                            { string.append('\t'); }
      \\n                            { string.append('\n'); }
      \\b                            { string.append('\b'); }
      \\f                            { string.append('\f'); }
      \\\\                           { string.append('\\'); }
      \\\/                           { string.append('/'); }
      \\r                            { string.append('\r'); }
      \\\"                           { string.append('\"'); }
      \\                             { System.err.println("Illegal character: "+yytext()); }
      .                              { string.append( yytext() ); }
}
\"  { string.setLength(0); yybegin(STRING);/*start to read an string literal*/ }
"," { return sf.newSymbol("Comma",sym.COMMA); }
"[" { return sf.newSymbol("Left Square Bracket",sym.LSQBRACKET); }
"]" { return sf.newSymbol("Right Square Bracket",sym.RSQBRACKET); }
"-" { return sf.newSymbol("Unary minus",sym.MINUS); }
0 | [1-9][0-9]* { return sf.newSymbol("An integer literal",sym.DIGITS, yytext()); }
\.[0-9]+ { return sf.newSymbol("A frac part of a real number",sym.FRAC, yytext()); }
[eE][\+-]?[0-9]+ { return sf.newSymbol("The exponent part of a real number in cientific notation",sym.EXP, yytext()); }
[1-9] { return sf.newSymbol("A digit other than zero",sym.DIGIT1_9, new Character(yytext())); }
"true" { return sf.newSymbol("True boolean value",sym.BOOLEAN, new Boolean(true)); }
"false" { return sf.newSymbol("False boolean value",sym.BOOLEAN, new Boolean(false)); }
"null"  { return sf.newSymbol("Null value",sym.NULL, null); }
[ \t\r\n\f] { /* ignore white space. */ }
. { System.err.println("Illegal character: "+yytext()); }
