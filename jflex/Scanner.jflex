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
/* I need to define this state to trate string literals */
<STRING> {
      \"                             { yybegin(YYINITIAL); // end the string literal read and return it
                                       return sf.newSymbol("An string literal",sym.STRING, string.toString()); }
      \\u[0-9a-fA-F]{4}              { string.append((char) Integer.parseInt(yytext().substring(2),16)); } //from the hexadecimal code
      \\t                            { string.append('\t'); }
      \\n                            { string.append('\n'); }
      \\b                            { string.append('\b'); }
      \\f                            { string.append('\f'); }
      \\\\                           { string.append('\\'); }
      \\\/                           { string.append('/'); }
      \\r                            { string.append('\r'); }
      \\\"                           { string.append('\"'); }
      \\                             { System.err.println("Illegal character: "+yytext()); } // If this character is not followed by any of the specifieds earlier, then it is not allowed
      .                              { string.append( yytext() ); } // any other character is allowed into the string
}
/* Here is the code for the default state */
\"  { string.setLength(0); yybegin(STRING); }//start to read an string literal
"," { return sf.newSymbol("Comma",sym.COMMA); }//used to separate elements into an array or pairs into an objects
//JSON array delimiters
"[" { return sf.newSymbol("Begin of an array",sym.ARRAY_BEGIN); }
"]" { return sf.newSymbol("End of an array",sym.ARRAY_END); }
//JSON object delimiters
"{" { return sf.newSymbol("Begin of an object",sym.OBJ_BEGIN); }
"}" { return sf.newSymbol("End of an object",sym.OBJ_END); }
//used to separate key and value into a pair
":" { return sf.newSymbol("Separator of a key-value pair",sym.PAIR_SEPARATOR); }
//used for JSON number value
"-" { return sf.newSymbol("Unary minus",sym.MINUS); }
0 | [1-9][0-9]* (\.[0-9]+)? ([eE][\+-]?[0-9]+)? { return sf.newSymbol("The number absolute value",sym.NUMBER, new Double(yytext())); }
//JSON boolean values
"true" { return sf.newSymbol("True boolean value",sym.BOOLEAN, new Boolean(true)); }
"false" { return sf.newSymbol("False boolean value",sym.BOOLEAN, new Boolean(false)); }
//JSON generic null value
"null"  { return sf.newSymbol("Null value",sym.NULL, null); }
[ \t\r\n\f] { /* ignore white space. */ }
. { System.err.println("Illegal character: "+yytext()); } //all other character is illegal
