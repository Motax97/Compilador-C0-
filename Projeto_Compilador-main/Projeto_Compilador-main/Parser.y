{- Example Happy parser for simple arithmetic expressions.
   Semantic actions compute the value of the expressions.
   Pedro Vasconcelos, 2021
-}

{
module Parser where
import Lexer
import AST
}

%name parser
%tokentype { Token }
%error { parseError }

%token

num             { TOK_NUM $$ }
'+'             { TOK_PLUS }
'-'             { TOK_MINUS }
'*'             { TOK_MULT }
'/'             { TOK_DIV }
'%'             { TOK_MOD }
'('             { TOK_LPAREN }
')'             { TOK_RPAREN }
'{'             { TOK_LBRACKET }
'}'             { TOK_RBRACKET }
'['             { TOK_LBRACKET2 }
']'             { TOK_RBRACKET2 }
';'             { TOK_SEMIC }
','             { TOK_COMMA }
'='             { TOK_ASSIGN }
"=="            { TOK_EQUAL }
"!="            { TOK_DIFFERENT }
"<"             { TOK_LESS }
"<="            { TOK_LESSEQ }
">"             { TOK_GREATER }
">="            { TOK_GREATER }
"!"             { TOK_NOT }
"||"            { TOK_OR }
"&&"            { TOK_AND }
"++"            { TOK_INCR }
"--"            { TOK_DECR }
"int"           { TOK_INTDEC }
"bool"          { TOK_BOOLDEC }
"string"        { TOK_STRINGDEC }
"true"          { TOK_TRUE }
"false"         { TOK_FALSE }
"if"            { TOK_IF }
"else"          { TOK_ELSE }
"while"         { TOK_WHILE }
"for"           { TOK_FOR }
"return"        { TOK_RETURN }
"print_int"     { TOK_PRINTI }
"print_str"     { TOK_PRINTS }
"scan_int"      { TOK_SCAN }
string          { TOK_STRING $$}
id              { TOK_ID $$ }

%nonassoc "==" "!=" "<" "<=" ">" ">=" "||" "&&"
%left '+' '-'
%left '*' '/' '%'

%%

Start : Func                                                { Program $1 }

Func : Types id '(' Funcarg ')' Block Func              { Func $1 $2 $4 $6 : $7 }
     | Types id '(' Funcarg ')' Block                   { [Func $1 $2 $4 $6] }

Funcarg : FuncargAux              { Args $1 }

FuncargAux : Types id ',' FuncargAux                        { Arg $1 $2 : $4 }
           | Types id                                       { [Arg $1 $2] }
           | Types id '[' num ']' ',' FuncargAux            { ArgArr $1 $2 $4 : $7 }
           | Types id '[' num ']'                           { [ArgArr $1 $2 $4] }
           |                                                { [] }

Block : '{' Bldecl Blstm '}'                              { Block $2 $3 }

Bldecl : VDecl Bldecl                                     { $1 : $2 }
       |                                                  { [] }

Blstm : Stm Blstm                                         { $1 : $2 }
      |                                                   { [] }

Stm : Block                                             { $1 }
    | Exp ';'                                           { $1 }
    | Assi ';'                                          { $1 }
    | Iff                                               { $1 }
    | Wh                                                { $1 }
    | For                                               { $1 }
    | "return" Exp ';'                                  { Return $2 }
    | "print_int" '(' Exp ')' ';'                       { PrintI $3 }
    | "print_str" '(' Exp ')' ';'                       { PrintS $3 }

Types : "int"                                           { TyInt }
      | "bool"                                          { TyBool }
      | "string"                                        { TyString }

VDecl : Types VDeclaux                                  { Decl $1 $2 }

VDeclaux : id ';'                                       { [Var $1] }
         | id ',' VDeclaux                              { Var $1 : $3 }
         | id '[' Exp ']' ';'                           { [Array $1 $3] }
         | id '[' Exp ']' ',' VDeclaux                  { Array $1 $3 : $6 }                         

Iff : "if" '(' Exp ')' Stm                              { If $3 $5 }
    | "if" '(' Exp ')' Stm "else" Stm                   { IfElse $3 $5 $7 }

Wh : "while" '(' Exp ')' Stm                            { While $3 $5 }

For : "for" '(' Assi ';' Exp ';' Assi ')' Stm           { For $3 $5 $7 $9 }

Exp   : Term                    { $1 }
      | Exp '+' Exp             { Add $1 $3 }
      | Exp '-' Exp             { Sub $1 $3 }
      | Exp '*' Exp             { Mult $1 $3 }
      | Exp '/' Exp             { Div $1 $3 }
      | Exp '%' Exp             { Mod $1 $3 }
      | Exp "==" Exp            { Equal $1 $3 }
      | Exp "!=" Exp            { Diff $1 $3 }
      | Exp "<" Exp             { Less $1 $3 }
      | Exp "<=" Exp            { LessEq $1 $3 }
      | Exp ">" Exp             { Greater $1 $3 }
      | Exp ">=" Exp            { GreaterEq $1 $3 }
      | Exp "||" Exp            { Or $1 $3 }
      | Exp "&&" Exp            { And $1 $3 }
      | "!" Term                { Not $2}
      | id '(' FCallArgs ')'    { FuncCall $1 $3 }
      | id '(' ')'              { FuncCallNoArg $1 }
      | "scan_int" '(' ')'      { Scan }

FCallArgs : Exp ',' FCallArgs       { $1 : $3 }
          | Exp                     { [$1]}

Assi : V '=' Exp               { Assign $1 $3 }
     | Term "++"               { Incr $1 }
     | Term "--"               { Decr $1 }

V : id                          { Var $1 }
  | id '[' Exp ']'             { Array $1 $3 }

Term    : num                   { Num $1 }
        | id                    { Var $1 }
        | string                { String $1 }
        | id '[' Exp ']'        { Array $1 $3 }
        | "true"                { Bool True }
        | "false"               { Bool False }
        | '(' Exp ')'           { $2 }

{
parseError :: [Token] -> a
parseError toks = error "parse error"
}  