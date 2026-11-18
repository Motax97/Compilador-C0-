
%wrapper "basic"
-- interface básica
-- alexScanTokens :: String -> [Token]

-- regexp definitions
$white = [\ \t\n\r]
$digit = [0-9]

tokens :-  

$white+                                 ;  -- skip whitespace

\/\/.*                                  ;  -- skip comments one line

"/*"(\*$white|(\*[^\/])|[^\*]|$white)*"*/"       ; -- skip comments multiple lines


"int"                           { \s -> TOK_INTDEC }
"bool"                          { \s -> TOK_BOOLDEC }
"string"                        { \s -> TOK_STRINGDEC }
"true"                          { \s -> TOK_TRUE }
"false"                         { \s -> TOK_FALSE }
"if"                            { \s -> TOK_IF }
"else"                          { \s -> TOK_ELSE }
"while"                         { \s -> TOK_WHILE }
"for"                           { \s -> TOK_FOR }
"return"                        { \s -> TOK_RETURN }
"print_int"                     { \s -> TOK_PRINTI }
"print_str"                     { \s -> TOK_PRINTS }
"scan_int"                      { \s -> TOK_SCAN }
"++"                            { \s -> TOK_INCR }
"--"                            { \s -> TOK_DECR }
"+"                             { \s -> TOK_PLUS }
"-"                             { \s -> TOK_MINUS }
"*"                             { \s -> TOK_MULT }
"/"                             { \s -> TOK_DIV }
"%"                             { \s -> TOK_MOD }
"("                             { \s -> TOK_LPAREN }
")"                             { \s -> TOK_RPAREN }
"{"                             { \s -> TOK_LBRACKET }
"}"                             { \s -> TOK_RBRACKET }
"["                             { \s -> TOK_LBRACKET2 }
"]"                             { \s -> TOK_RBRACKET2 }
";"                             { \s -> TOK_SEMIC }
","                             { \s -> TOK_COMMA }
"="                             { \s -> TOK_ASSIGN }
"=="                            { \s -> TOK_EQUAL }
"!="                            { \s -> TOK_DIFFERENT }
"!"                             { \s -> TOK_NOT }
"||"                            { \s -> TOK_OR }
"&&"                            { \s -> TOK_AND }
"<"                             { \s -> TOK_LESS }
"<="                            { \s -> TOK_LESSEQ }
">"                             { \s -> TOK_GREATER }
">="                            { \s -> TOK_GREATEREQ }
\"[^\"]*\"                      { \s -> TOK_STRING (init (tail s)) }
[A-Za-z_][A-Za-z0-9_]*          { \s -> TOK_ID s }
$digit+                         { \s -> TOK_NUM (read s) }

{
 -- the token type
data Token = TOK_NUM Int
           | TOK_PLUS
           | TOK_MINUS
           | TOK_MULT
           | TOK_DIV
           | TOK_MOD
           | TOK_LPAREN
           | TOK_RPAREN
           | TOK_SEMIC
           | TOK_COMMA
           | TOK_INTDEC
           | TOK_BOOLDEC
           | TOK_ASSIGN
           | TOK_TRUE
           | TOK_FALSE
           | TOK_ID String
           | TOK_IF
           | TOK_ELSE
           | TOK_WHILE
           | TOK_EQUAL
           | TOK_DIFFERENT
           | TOK_LESS
           | TOK_LESSEQ
           | TOK_GREATER
           | TOK_GREATEREQ
           | TOK_LBRACKET
           | TOK_RBRACKET
           | TOK_RETURN
           | TOK_NOT
           | TOK_OR
           | TOK_AND
           | TOK_PRINTI
           | TOK_PRINTS
           | TOK_SCAN
           | TOK_INCR
           | TOK_DECR
           | TOK_STRING String
           | TOK_STRINGDEC
           | TOK_FOR
           | TOK_LBRACKET2
           | TOK_RBRACKET2
           deriving (Eq, Show)
  
}