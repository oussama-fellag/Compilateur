
//membre 1: Oussama Fellag (22313908)
//membre 1: Hadjer AZIRI (22312699)



grammar Rationnel;

@header {
    import java.util.HashMap;
    import java.util.Stack;
}

@parser::members {
    HashMap<String, String> tablesSymboles = new HashMap<String, String>();
    Stack<String> resultStack = new Stack<String>();
  int labelCount = 0;

// Add this helper function to generate unique labels
String generateLabel() {
    return "L" + (++labelCount);
}}

// Entry rule: calcul
calcul returns [String code]
    @init{ $code = new String(); }
    @after{ System.out.println($code); }
    : (decl { $code += $decl.code; })*
      NEWLINE*
      (statement { $code += $statement.code; })*
      (printResult { $code += $printResult.code; })*
      { $code += " HALT\n"; }
    ;

finInstruction
    : (NEWLINE | ';')+
    ;

decl returns [String code]
    : TYPE IDENTIFIANT finInstruction
    {
       
        $code = "DECLARE " + $IDENTIFIANT.text + " " + $TYPE.text;
        if ($TYPE.text.equals("int")) {
            $code += " 0"; // valeur par defaut
        } else if ($TYPE.text.equals("rat")) {
            $code += " 0/1"; // valeur par defaut
        } else if ($TYPE.text.equals("bool")) {
            $code += " false"; // valeur par defaut
        }
        $code += "\n";
    }
    ;


block returns [String code]
    : IDENTIFIANT '=' expression 
    {
        
        $code = "STORE " + $IDENTIFIANT.text + "\n" + $expression.code;
    }
    ;
conditionalStatement returns [String code]
    : '(' cond = expression ')' '?' '('trueBlock= block ')' ( ':' '('falseBlock = block')' )? ';' 
    {
         
        $code = $cond.code +
                "JUMPIFFALSE elseLabel\n" + // sauter sur elseLabel si la condition est fausse
                $trueBlock.code +
                "JUMP endLabel\n" +          // sauter sur endLabel
                "elseLabel:\n";
        if ($falseBlock.code != null) {
            $code += $falseBlock.code;
        }
        $code += "endLabel:\n";
    }
    ;
conditional returns [String code]
    :  cond = expression  '?' trueBlock= block ( ':' falseBlock = block )? ';' 
    {
         
        $code = $cond.code +
                "JUMPIFFALSE elseLabel\n" + // sauter sur elseLabel si la condition est fausse
                $trueBlock.code +
                "JUMP endLabel\n" +          // sauter sur endLabel
                "elseLabel:\n";
        if ($falseBlock.code != null) {
            $code += $falseBlock.code;
        }
        $code += "endLabel:\n";
    }
    ;


    
iterativeStatement returns [String code]
    : 'repeter' '('stat = block ')''jusque' condition=expression ';'
    {
    
         
        $code = "repeatLabel:\n" +
                $stat.code +           
                $condition.code +       
                "JUMPIFTRUE repeatLabel\n"; 
   
    }
    ;
iterative returns [String code]
    : 'repeter' stat = block 'jusque' condition=expression ';'
    {
    
         
        $code = "repeatLabel:\n" +
                $stat.code +           
                $condition.code +       
                "JUMPIFTRUE repeatLabel\n"; 
   
    }
    ;


statement returns [String code]
    : IDENTIFIANT '=' expression ';'
    {
        
        $code = $expression.code + "WRITE\n";
        
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
    }
    | assignation ';'
    {
      
        $code = $assignation.code;
    }
    | obtainNumerator ';'
    {
        
        $code = $obtainNumerator.code + "WRITE\n";
      
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
    }
    | obtainDenominator ';'
    {
       
        $code = $obtainDenominator.code + "WRITE\n";
       
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
    }
     | ppcm ';'
    {
        
        $code = $ppcm.code + "WRITE\n";
        
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
    }
     | pgcd ';'
    {
        
        $code = $pgcd.code + "WRITE\n";
      
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
    }
    | simplify ';'
    {
        
        $code = $simplify.code + "WRITE\n";
       
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
    }
    | round ';'
    {
       
        $code = $round.code + "WRITE\n";
       
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
    }
    | floor ';'
    {
        
        $code = $floor.code + "WRITE\n";
        
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
    }
    | ceiling ';'
    {
        
        $code = $ceiling.code + "WRITE\n";
        
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
    }
    | percntage ';' 
    {
        
        $code = $percntage.code + "WRITE\n";
       
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
    }
     | boolExpression ';' 
    {
      
        $code = $boolExpression.code + "WRITE\n";
        
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
    }
   
    | output finInstruction
    {
      
        $code = $output.code;
    }
     | input_int finInstruction
    {
        
        $code = $input_int.code;
    }
    | input_int1 finInstruction
    {
        
        $code = $input_int1.code;
    }
    | input_int2 finInstruction
    {
        
        $code = $input_int2.code;
    }
    | input_rat1 finInstruction
    {
        
        $code = $input_rat1.code;
    }
    | input_rat2 finInstruction
    {
        
        $code = $input_rat2.code;
    }
    | input_rat finInstruction
    {
        
        $code = $input_rat.code;
    }
    | conditionalStatement finInstruction 
    {
        $code = $conditionalStatement.code;
    }
     | conditional finInstruction 
    {
        $code = $conditional.code;
    }
    | iterativeStatement finInstruction 
    {
        $code = $iterativeStatement.code;
    }
     | iterative finInstruction 
    {
        $code = $iterative.code;
    }
    | finInstruction
    {
        $code = "";
    }
    ;

assignation returns [String code]
    : IDENTIFIANT '=' expression 
    {
        
        $code = "STORE " + $IDENTIFIANT.text + "\n" + $expression.code;
    }
    ;

output returns [String code]
    : 'afficher' '(' expression ')' ';'
    {
     
        $code = $expression.code + "WRITE\n";
       
        $code += "DUP\nNUMERATOR\nWRITE\n";
        $code += "DUP\nDENOMINATOR\nWRITE\n";
       
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
    }
    ;
 
input_int returns [String code]
    : IDENTIFIANT '=' (term '**' |term '/') 'lire' '()'';'
    {
       
       
        $code = "PUSHI\nREAD\n";
        $code += "DUP\n";
        $code += "STORE " + $IDENTIFIANT.text + "\n";
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
        $code += "POP\n";
    }
    ;
input_int1 returns [String code]
    : (term '**' |term '/') 'lire' '()'';'
    {
       
       
        $code = "PUSHI\nREAD\n";
        $code += "DUP\n";
        $code += "STORE " +  "\n";
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
        $code += "POP\n";
    }
    ;
    input_int2 returns [String code]
    :  (term '**' |term '/') 'lire' '(' IDENTIFIANT  ')'';'
    {
       
       
        $code = "PUSHI\nREAD\n";
        $code += "DUP\n";
        $code += "STORE " + $IDENTIFIANT.text + "\n";
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
        $code += "POP\n";
    }
    ;
 
input_rat returns [String code]
    : IDENTIFIANT '=' term '+' 'lire' '()' ';'
    {
    
        $code = "PUSHI\n";
        // Add code for reading numerator and denominator
        $code = "DUP\nNUMERATOR\nREAD\n";
        $code += "DUP\nDENOMINATOR\nREAD\n";
        
        // Store the rational number in the specified identifier
        $code += "STORE " + $IDENTIFIANT.text + "\n";
        
        // Store the result on the result stack
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
        
        // Clear the stack
        $code += "POP\n";
    }
    ;
    
    
    
input_rat1 returns [String code]
    :  term '+' 'lire' '()' ';'
    {
    
        $code = "PUSHI\n";
        // Add code for reading numerator and denominator
        $code = "DUP\nNUMERATOR\nREAD\n";
        $code += "DUP\nDENOMINATOR\nREAD\n";
        
        // Store the rational number in the specified identifier
        $code += "STORE " +  "\n";
        
        // Store the result on the result stack
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
        
        // Clear the stack
        $code += "POP\n";
    }
    ;

input_rat2 returns [String code]
    :   term '+' 'lire' '(' IDENTIFIANT ')' ';'
    {
    
        $code = "PUSHI\n";
        // Add code for reading numerator and denominator
        $code = "DUP\nNUMERATOR\nREAD\n";
        $code += "DUP\nDENOMINATOR\nREAD\n";
        
        // Store the rational number in the specified identifier
        $code += "STORE " + $IDENTIFIANT.text + "\n";
        
        // Store the result on the result stack
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
        
        // Clear the stack
        $code += "POP\n";
    }
    ;


   


round returns [String code]
    : '[' expression ']' 
    {
        // Add code for rounding the expression to the nearest integer
        $code = $expression.code + "WRITEn";
        
        // Store the result on the result stack
        $code += "DUP\n";
        $code += "NUMERATOR\n";
        $code += "SWAP\n";
        $code += "DUP\n";
        $code += "DENOMINATOR\n";
        $code += "SWAP\n";
        
        // Calculate the remainder (numerator % denominator)
        $code += "MOD\n";
        
        // Duplicate the denominator and divide the remainder by it
        $code += "DUP\n";
        $code += "SWAP\n";
        $code += "DIV\n";
        
        // Duplicate the denominator and compare the result with 1/2
        $code += "DUP\n";
        $code += "PUSHI 1\n";
        $code += "DIV\n";
        $code += "PUSH 2\n";
        $code += "EQUAL\n";
        
        // Jump to round up if the result is equal to 1/2
        $code += "JUMPIFTRUE roundUp\n";
        
        // Round the result to the nearest integer
        $code += "ROUND\n";
        
        // Jump to skip rounding up
        $code += "JUMP skipRoundUp\n";
        
        // Label to round up
        $code += "roundUp:\n";
        
        // Duplicate the result and increment it
        $code += "DUP\n";
        $code += "PUSHI 1\n";
        $code += "ADD\n";
        
        // Round the result to the nearest integer
        $code += "ROUND\n";
        
        // Label to skip rounding up
        $code += "skipRoundUp:\n";
        
        // Store the rounded result on the result stack
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
    }
    ;



floor returns [String code]
    : '[-' expression '-]'
    {
        // Add code for flooring the expression to the nearest integer
        $code = $expression.code + "WRITE\n";
        
        // Store the result on the result stack
        $code += "DUP\n";
        $code += "NUMERATOR\n";
        $code += "SWAP\n";
        $code += "DUP\n";
        $code += "DENOMINATOR\n";
        $code += "SWAP\n";
        
        // Calculate the remainder (numerator % denominator)
        $code += "MOD\n";
        
        // Duplicate the denominator and divide the remainder by it
        $code += "DUP\n";
        $code += "SWAP\n";
        $code += "DIV\n";
        
        // If the remainder is not zero, decrement the result
        $code += "PUSHI 0\n";
        $code += "EQUAL\n";
        $code += "JUMPIFTRUE skipFloor\n";
        $code += "PUSHI 1\n";
        $code += "SUB\n";
        
        // Label to skip decrementing the result
        $code += "skipFloor:\n";
        
        // Round the result to the nearest integer
        $code += "ROUND\n";
        
        // Store the rounded result on the result stack
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
    }
    ;


ceiling returns [String code]
    : '[+' expression '+]' 
    {
        // Add code for ceiling function
        $code = $expression.code + "WRITE\n";
        
        // Store the result on the result stack
        $code += "DUP\n";
        $code += "NUMERATOR\n";
        $code += "SWAP\n";
        $code += "DUP\n";
        $code += "DENOMINATOR\n";
        $code += "SWAP\n";
        
        // Calculate the remainder (numerator % denominator)
        $code += "MOD\n";
        
        // Duplicate the denominator and divide the remainder by it
        $code += "DUP\n";
        $code += "SWAP\n";
        $code += "DIV\n";
        
        // If the remainder is not zero, increment the result
        $code += "PUSHI 0\n";
        $code += "EQUAL\n";
        $code += "JUMPIFTRUE skipCeil\n";
        $code += "PUSHI 1\n";
        $code += "ADD\n";
        
        // Label to skip incrementing the result
        $code += "skipCeil:\n";
        
        // Round the result to the nearest integer
        $code += "ROUND\n";
        
        // Store the rounded result on the result stack
        $code += "PUSH resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
    }
    ;


percntage returns [String code]
    :  IDENTIFIANT '=' expression '%' 
    {
        // Add code for percntage calculation
        $code = $expression.code + "PUSHI 100 \n MUL\n";
        // Store the result on the result stack
        $code += "DUP\n";
        $code += "NUMERATOR\n";
        $code += "SWAP\n";
        $code += "DUP\n";
        $code += "DENOMINATOR\n";
        $code += "SWAP\n";
        
        // Calculate the remainder (numerator % denominator)
        $code += "MOD\n";
        
        // Duplicate the denominator and divide the remainder by it
        $code += "DUP\n";
        $code += "SWAP\n";
        $code += "DIV\n";
        
        // Duplicate the denominator and compare the result with 1/2
        $code += "DUP\n";
        $code += "PUSHI 1\n";
        $code += "DIV\n";
        $code += "PUSH 2\n";
        $code += "EQUAL\n";
        
        // Jump to round up if the result is equal to 1/2
        $code += "JUMPIFTRUE roundUp\n";
        
        // Round the result to the nearest integer
        $code += "ROUND\n";
        
        // Jump to skip rounding up
        $code += "JUMP skipRoundUp\n";
        
        // Label to round up
        $code += "roundUp:\n";
        
        // Duplicate the result and increment it
        $code += "DUP\n";
        $code += "PUSHI 1\n";
        $code += "ADD\n";
        
        // Round the result to the nearest integer
        $code += "ROUND\n";
        
        // Label to skip rounding up
        $code += "skipRoundUp:\n";
        
        // Store the rounded result on the result stack
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
    }
    ;


boolExpression returns [String code]
    : IDENTIFIANT '=' e1=boolexp 'et' e2=boolexp 
    {
       
        $code = $e1.code +
                "DUP\n" + // Duplicate the result of e1
                "JUMPIFFALSE skipAnd\n" + // Jump to skipAnd if e1 is false
                $e2.code + "AND\n "+
                "skipAnd:\n";
    }
    | IDENTIFIANT '=' e1=boolexp 'ou' e2=boolexp
    {
        
        $code = $e1.code +
                "DUP\n" + // Duplicate the result of e1
                "JUMPIFTRUE skipOr\n" + // Jump to skipOr if e1 is true
                $e2.code +"OR\n"+
                "skipOr:\n"  ;
    };
    
    

obtainNumerator returns [String code]
    : IDENTIFIANT '=' 'num' '(' expression ')' 
    {
        
        $code = "NUMERATOR " + $IDENTIFIANT.text + "\n";
    }
    ;

obtainDenominator returns [String code]
    : IDENTIFIANT '=' 'denum' '(' expression')' 
    {
        
        $code = "DENOMINATOR " + $IDENTIFIANT.text + "\n";
    }
    ;
ppcm returns [String code]
    : 'ppcm' '('e1 = expression1',' e2 = expression1')' 
    {
      
        $code = $e1.code + $e2.code +
               
                "DUP\n" +
                "PUSHI resultStack\n" +
                "SWAP\n" +
                "STORE\n" +
                "DUP\n" +
                "PUSHI resultStack\n" +
                "SWAP\n" +
                "STORE\n" +
                // Calculate GCD (greatest common divisor)
                "PUSHI 0\n" +  
                "DUP\n" +
                "SWAP\n" +
                "NEQJMP GCD_LOOP_END\n" +
                "DUP\n" +
                "SWAP\n" +
                "DIV\n" +
                "SWAP\n" +
                "POP\n" +
                "JMP GCD_LOOP\n" +
                "GCD_LOOP_END:\n" +
                // Calculate LCM (least common multiple)
                "PUSHI resultStack\n" +
                "SWAP\n" +
                "LOAD\n" +
                "PUSHI resultStack\n" +
                "SWAP\n" +
                "LOAD\n" +
                "MUL\n" +
                "SWAP\n" +
                "DIV\n" +
                // Store the result on the result stack
                "PUSHI resultStack\n" +
                "SWAP\n" +
                "STORE\n";
    }
    ;
    
pgcd returns [String code]
    : 'pgcd' '(' e1 = expression1 ',' e2 = expression1')' 
    {
      
        $code = $e1.code + $e2.code +
                // Initialize variables
                "DUP\n" +
                "SWAP\n" +
                "NEQJMP GCD_LOOP_END\n" +
                "DUP\n" +
                "SWAP\n" +
                "MOD\n" +
                "SWAP\n" +
                "POP\n" +
                "JMP GCD_LOOP\n" +
                "GCD_LOOP_END:\n" +
                // Store the result on the result stack
                "PUSHI resultStack\n" +
                "SWAP\n" +
                "STORE\n";
    }
    ;
simplify returns [String code]
    : 'sim' '(' expression ')'  
    {
       
        $code = $expression.code + "sim\n";

        // Check if the result is a rational number (n1/n2)
        $code += "DUP\n";
        $code += "NUMERATOR\n";
        $code += "SWAP\n";
        $code += "DUP\n";
        $code += "DENOMINATOR\n";

        // Compare the denominator with 1, if true, it's already simplified
        $code += "PUSHI 1\n";
        $code += "EQUAL\n";
        $code += "JUMPIFTRUE skipSimplify\n";

        // Simplify the rational number using the GCD (Euclidean algorithm)
        $code += "GCD_LOOP:\n";
        $code += "DUP\n";
        $code += "SWAP\n";
        $code += "NEQJMP GCD_LOOP_END\n";
        $code += "DUP\n";
        $code += "SWAP\n";
        $code += "MOD\n";
        $code += "SWAP\n";
        $code += "POP\n";
        $code += "JMP GCD_LOOP\n";
        $code += "GCD_LOOP_END:\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";

        // Label to skip the simplification if the denominator is 1
        $code += "skipSimplify:\n";
    }
    ;



expression returns [String code]
    : term {$code = $term.code;} ( ('+' term { $code += $term.code + " ADD\n"; } | '-' term { $code += $term.code + " SUB\n"; }  |'non' term { $code += $term.code + " NOT\n"; }|'<' term { $code += $term.code + " INF\n"; }|'>' term { $code += $term.code + " SUP\n"; }|'<=' term { $code += $term.code + " INFEQ\n"; }|'>=' term { $code += $term.code + " SUPEQ\n"; }|'==' term { $code += $term.code + " EQUAL\n"; }|'<>' term { $code += $term.code + " NEQ\n"; } )*  )
    ;
    
boolexp returns [String code]
    : term {$code = $term.code;} ( ('et' term { $code += $term.code +  "AND\n"; } | 'ou' term { $code += $term.code +  "OR\n"; }  )*  )
    ;
expression1 returns [String code]
    : term {$code = $term.code;} ( ('non' term { $code += $term.code + " NOT\n"; }|'<' term { $code += $term.code + " INF\n"; }|'>' term { $code += $term.code + " SUP\n"; }|'<=' term { $code += $term.code + " INFEQ\n"; }|'>=' term { $code += $term.code + " SUPEQ\n"; }|'==' term { $code += $term.code + " EQUAL\n"; }|'<>' term { $code += $term.code + " NEQ\n"; } )*  )
    ;
term returns [String code]
    : factor {$code = $factor.code;} ( ('*' factor { $code += $factor.code + " MUL\n"; } | ('/'| ':') factor { $code += $factor.code + " DIV\n"; } | POW factor { $code += $factor.code + " POW\n"; } | 'et' factor { $code += $factor.code + "DUP\nJUMPIFFALSE skipAnd\nAND\nskipAnd:\n"; } | 'ou' factor { $code += $factor.code + "DUP\nJUMPIFTRUE skipOr\nOR\nskipOr:\n"; })* )
    ;

factor returns [String code]
    : IDENTIFIANT { $code = "PUSHI " + $IDENTIFIANT.text + "\n"; }
    | INTEGER { $code = "PUSHI " + $INTEGER.text + "\n"; }
    | '(' expression ')' { $code = $expression.code; }
    | BOOLEAN { $code = "PUSHI " + $BOOLEAN.text + "\n"; }
    | rationnel { $code = $rationnel.code; }
    | ppcm { $code = $ppcm.code; }
    | pgcd { $code = $pgcd.code; }
    | simplify { $code = $simplify.code; }
    | round { $code = $round.code; } 
    | floor { $code = $floor.code; } 
    | ceiling { $code = $ceiling.code; }
    | percntage { $code = $percntage.code; }
 
    
    | unaryExpression { $code = $unaryExpression.code; } // Add this line for unary expression
    ;

unaryExpression returns [String code]
    : '+' operand {$code = $operand.code +$operand.code +"ADD\n";} // Unary plus
    | '-' operand {$code = $operand.code +$operand.code + "SUB\n";} 
    | '*' operand {$code = $operand.code +$operand.code + "MUL\n";} 
    | 'non' operand {$code = $operand.code + "NOT\n";} // Unary minus
    ;
    
operand returns [String code]
    : INTEGER {$code = "PUSHI " + $INTEGER.text + "\n";} // Operand is an integer
    | IDENTIFIANT {$code = "PUSHI " + $IDENTIFIANT.text +  "\n";} // Operand is an identifier
    | '(' expression ')' {$code = $expression.code;} // Operand is an expression within parentheses
    | unaryExpression {$code = $unaryExpression.code;} // Operand is a unary expression
    ;
rationnel returns [String code]
    : n1=INTEGER '/' n2=INTEGER { $code = "PUSHI " + $n1.text + "\nPUSHI " + $n2.text + "\nDIV\n"; }
    ;

// Print result statement
printResult returns [String code]
    : 'afficher' '(' IDENTIFIANT ')' ';'
    {
       
        $code = "PUSHI " + $IDENTIFIANT.text + "\n";
        // Add code for output statement
       
        // Split the output for a rational expression
        $code += "DUP\nNUMERATOR\nWRITE\n";
        $code += "DUP\nDENOMINATOR\nWRITE\n";
        // Store the result on the result stack
        $code += "DUP\n";
        $code += "PUSHI resultStack\n";
        $code += "SWAP\n";
        $code += "STORE\n";
        $code += "WRITE\n";
    }
    ;

// lexer
NEWLINE : '\r'? '\n' | '\r';
TYPE : 'int' | 'rat' | 'bool'; 
IDENTIFIANT : [a-zA-Z_] [a-zA-Z_0-9]*;
INTEGER : ('-'? [0-9]+);
BOOLEAN : ('true'|'false') ;
POW : '**';
OTHER : [a-zA-Z_] [a-zA-Z_0-9]*;
WHITESPACE : [\t ]+ -> skip;




// il faut pas laisser une ligne vide dans le debut de ligne de test 

