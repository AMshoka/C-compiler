import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Iterator;

%%
%class MyC
%standalone
%column
%line
%byaccj

single_multiline_Comment = \/\*[^\*]*\*\/|\/\/[^\n]*\n
OneChar = [\(\)\{\}\,\;\+\-\*\/\%\<\>\=\!\[\]]
TwoChar = \<\=|\>\=|\=\=|\!\=|\|\||\&\&
KW = if|else|while|for|return|break
ArrayOp = new|size
DataType = void|bool|int|float
BoolValue = true|false
FloatNum = \d+\.\d+
IntegerNum = \d+
Id = [a-zA-Z\_][a-zA-Z\_0-9]*
WhiteSpace = [\t\n ]+
EndOfFile = \z
ErrNum = \d+\.+|\d+\.\d+\.[\d\.]*|\d+\.\.[\d+\.]*
ErrIdent = [0-9]+[a-zA-Z][a-zA-Z\_0-9]*

%{
    // Parser yyparser;
    private Parser yyparser = new Parser();

    public MyC(java.io.Reader r, Parser yyparser) {
        this(r);
        this.yyparser = yyparser;
    }

    HashMap<String, Integer> symbolTable = new HashMap<>();
    ArrayList Sym_table = new ArrayList();
    BufferedWriter writer,TokenOutput;
    // Iterator i = Sym_table.iterator();
    int flag,i,it;
    {
    try{
        writer = new BufferedWriter(new FileWriter("TokenResult.txt"));
        TokenOutput = new BufferedWriter(new FileWriter("SimbolTable.txt"));
         error = new BufferedWriter(new FileWriter("Error.txt"));
    } catch(IOException e) {
        e.printStackTrace();
    }
    }
%}

%eof{
    flag=0;
    i=0;
    it=1;
    try{
        TokenOutput.append(String.valueOf(it)+"\t");
        while(i<Sym_table.size()){
            TokenOutput.append(String.valueOf(Sym_table.get(i))+"\t ");
            // System.out.println(String.valueOf(Sym_table.get(i)));
            TokenOutput.flush();
            flag++;
            if(flag==2){
                 flag=0;
                 it++;
                 TokenOutput.newLine();
                 TokenOutput.append(String.valueOf(it)+"\t");
                 TokenOutput.flush();
            
            }
            i++;
        }
        writer.close();
        TokenOutput.close();
        
    } catch(IOException e){
        e.printStackTrace();
    }
%eof}


%%
{single_multiline_Comment} {
    // System.out.print(yytext());
}
{TwoChar} {
        String word = "Null";
        String input = yytext();
        switch (input){
            case "<=":
                word = "LE";
                Sym_table.add("LE");
                Sym_table.add("257");
                return Parser.LE;
                break;
            case ">=":
                word = "GE";
                Sym_table.add("GE");
                Sym_table.add("258");
                return Parser.GE;
                break;
            case "==":
                word = "EQ";
                Sym_table.add("EQ");
                Sym_table.add("259");
                return Parser.EQ;     
                break;
            case "!=":
                word = "NE";
                Sym_table.add("NE");
                Sym_table.add("260");
                return Parser.NE;
                break;
            case "||":
                word = "OR";
                Sym_table.add("OR");
                Sym_table.add("261");
                return Parser.OR;
                break;
            case "&&":
                word = "AND";
                Sym_table.add("AND");
                Sym_table.add("262");
                return Parser.AND;
                break;
        }

        try {

            writer.append("<DoubleChar, " + word+">");
            writer.flush();

        }catch (IOException e){
            e.printStackTrace();
        }
        
}
{OneChar} {
             Sym_table.add("SingleChar");
             Sym_table.add(Integer.valueOf((int) yytext().toCharArray()[0]));
            try {

                writer.append("<SingleChar, " + Integer.valueOf((int) yytext().toCharArray()[0]) + ">");
                writer.flush();


            } catch (IOException e){
                e.printStackTrace();
            }
            return (int) yycharat(0);
}
{KW} {
        
        String w=yytext();
        switch (w) {
            case "if":
                Sym_table.add("IF");
                Sym_table.add("263");
                return Parser.IF;
                break;
            case "else":
                Sym_table.add("ELSE");
                Sym_table.add("264");
                return Parser.ELSE;
                break;
            case "while":
                Sym_table.add("WHILE");
                Sym_table.add("265");
                 return Parser.WHILE;
                break;
            case "for":
                Sym_table.add("FOR");
                Sym_table.add("266");
                 return Parser.FOR;
                break;
            case "return":
                Sym_table.add("RETURN");
                Sym_table.add("267");
                 return Parser.RETURN;
                break;
            case  "break":
                Sym_table.add("BREAK");
                Sym_table.add("268");
                 return Parser.BREAK;
                break;                    
        }
        try{
                writer.append("<KW, " + yytext().toUpperCase()+">");
                writer.flush();
        } catch (IOException e){
            e.printStackTrace();
        }
}
{ArrayOp} {
        String AO =yytext();
         switch (AO) {
            case "new":
                Sym_table.add("NEW");
                Sym_table.add("269");
                 return Parser.NEW;
                break;
            case "size":
                Sym_table.add("SIZE");
                Sym_table.add("270");
                 return Parser.SIZE;
                break;
            }    
        try{
                writer.append("<AO, " + yytext().toUpperCase()+">");
                writer.flush();
        } catch (IOException e){
            e.printStackTrace();
        }
}
{DataType} {
    String DT=yytext();
    switch (DT){
        case "void":
            Sym_table.add("VOID");
            Sym_table.add("271");
             return Parser.VOID;
            break;
        case "bool":
            Sym_table.add("BOOL");
            Sym_table.add("272");
            return Parser.BOOL;
            break;
        case "int":  
            Sym_table.add("INT");
            Sym_table.add("273");
            return Parser.INT;
            break;        
        case "float":
            Sym_table.add("FLOAT");
            Sym_table.add("274");
            return Parser.FLOAT;
            break;        
    }
    try{
        writer.append("<DT, " + yytext().toUpperCase()+">");
        writer.flush();
    } catch (IOException e){
        e.printStackTrace();
    }
}
{BoolValue} {
        String BOOL_LIT=yytext();
        Sym_table.add("BOOL_LIT");
        switch (BOOL_LIT){
            case "true":
              Sym_table.add("275");
              break;
            case "false":
              Sym_table.add("276");
              break;             
        }
        try{
                writer.append("<BOOL_LIT, " + yytext().toUpperCase()+">");
                writer.flush();
        } catch (IOException e){
            e.printStackTrace();
        }
        yyparser.yyval = new ParserVal(Boolean.parseBoolean(yytext()));
        return Parser.BOOL_LIT;
}
{FloatNum} {
        Sym_table.add("Float_LIT");
        Sym_table.add("278");
        try{
                writer.append("<Float_LIT, " + yytext() + ">");
                writer.flush();
        } catch (IOException e){
            e.printStackTrace();
        }
        yyparser.yyval = new ParserVal(Float.parseFloat(yytext()));
        return Parser.FLOAT_LIT;
}
{IntegerNum} {
        Sym_table.add("INT_LIT");
        Sym_table.add("279");
        try{
                writer.append("<INT_LIT, " + yytext().toUpperCase()+">");
                writer.flush();
        } catch (IOException e){
            e.printStackTrace();
        }
        yyparser.yyval = new ParserVal(Integer.parseInt(yytext()));
        return Parser.INT_LIT;
}
{Id} {
        Sym_table.add("IDENT");
        Sym_table.add("280");
        int index = symbolTable.size();
        if (symbolTable.containsKey(yytext())) {
            index = symbolTable.get(yytext());
        } else {
            symbolTable.put(yytext(), index);
        }
        try {

            writer.append("<IDENT, " + index + ">");
            writer.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
        yyparser.yylval = new ParserVal(yytext());
        return Parser.IDENT;
}
{WhiteSpace} {}
{EndOfFile} {
        Sym_table.add("EOF");
        Sym_table.add("0");
        try {
            writer.append("<EOF, " + 0 + ">");
            writer.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return Parser.EOF;
}
{ErrNum} {
    try{
        error.append("Lex error in line " + yyline + ". Wrong number : " + yytext());
        error.newLine();
        error.flush();
    } catch (IOException e) {
        e.printStackTrace();
    }
}
{ErrId} {
    try{
        error.append("Lex error in line " + yyline + ". Id starts with a num: " + yytext());
        error.newLine();
        error.flush();
    } catch (IOException e) {
        e.printStackTrace();
    }
}
.    {return (int) yycharat(0);}


