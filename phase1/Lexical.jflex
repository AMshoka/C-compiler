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


%{
    HashMap<String, Integer> symbolTable = new HashMap<>();
    ArrayList Sym_table = new ArrayList();
    BufferedWriter writer,TokenOutput;
    // Iterator i = Sym_table.iterator();
    int flag,i,it;
    {
    try{
        writer = new BufferedWriter(new FileWriter("TokenResult.txt"));
        TokenOutput = new BufferedWriter(new FileWriter("SimbolTable.txt"));
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
                break;
            case ">=":
                word = "GE";
                Sym_table.add("GE");
                Sym_table.add("258");
                break;
            case "==":
                word = "EQ";
                Sym_table.add("EQ");
                Sym_table.add("259");     
                break;
            case "!=":
                word = "NE";
                Sym_table.add("NE");
                Sym_table.add("260");
                break;
            case "||":
                word = "OR";
                Sym_table.add("OR");
                Sym_table.add("261");
                break;
            case "&&":
                word = "AND";
                Sym_table.add("AND");
                Sym_table.add("262");
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
            
}
{KW} {
        
        String w=yytext();
        switch (w) {
            case "if":
                Sym_table.add("IF");
                Sym_table.add("263");
                break;
            case "else":
                Sym_table.add("ELSE");
                Sym_table.add("264");
                break;
            case "while":
                Sym_table.add("WHILE");
                Sym_table.add("265");
                break;
            case "for":
                Sym_table.add("FOR");
                Sym_table.add("266");
                break;
            case "return":
                Sym_table.add("RETURN");
                Sym_table.add("267");
                break;
            case  "break":
                Sym_table.add("BREAK");
                Sym_table.add("268");
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
                break;
            case "size":
                Sym_table.add("SIZE");
                Sym_table.add("270");
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
            break;
        case "bool":
            Sym_table.add("BOOL");
            Sym_table.add("272");
            break;
        case "int":  
            Sym_table.add("INT");
            Sym_table.add("273");
            break;        
        case "float":
            Sym_table.add("FLOAT");
            Sym_table.add("274");
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
}


