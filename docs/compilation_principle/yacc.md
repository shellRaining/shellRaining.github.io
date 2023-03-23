---
title: yacc 使用方法
tag:
  - 编译原理
description: 学习编译原理时候遇到了工具 yacc，暂作记录
---

# yacc/bison 使用方法

## 起点和目标

起点记为 S，目标记为 T，从 S -> T 我们需要会经历如下的步骤

1. 什么是 yacc
2. yacc 使用初体验
3. yacc 文件结构
4. 对 yacc 结构每部分详解
5. 细枝末节
6. 写代码时遇到的小问题
7. 写代码时遇到的错误

目标为完成完成三次编译原理作业

```
生成如下文法表示的表达式对应的计算器

exp -> (exp + exp) | (exp - exp) | (exp * exp) | (exp / exp)
        | (exp ^ exp) | (-exp) | (exp) | NUM

对于输入的中缀表达式，要给出结果。如3+（4*5）结果应为23。
要求能连续处理若干个数学表达式，直到输入结束或文件结束
```

## 什么是 yacc

yacc 是一个可以用来生成编译器的编译器（维基百科如是说）。

yacc 的输入文件是一个包含上下文无关文法（CFG）的文件，它的扩展名通常是 `.y`。

yacc 的输出文件是一个 C 语言程序，它实现了一个语法解析器。yacc 还可以生成一个叫做 `y.output` 的文件，它包含了一些调试信息，如状态转换表、冲突信息等。如果使用 `-d` 参数运行 yacc 命令，yacc 还会生成一个叫做 `y.tab.h` 的文件，它包含了一些符号定义。

:::info
yacc 和 bison 的区别是，bison 是 yacc 的 GNU 版本，它们的使用方法基本相同，但是 bison 有一些额外的功能和优化，例如 bison 支持 GLR（Generalized LR）算法，可以处理一些 yacc 无法处理的语法。bison 还有一些其他的特性，如位置追踪、错误恢复、符号表等。
:::

## yacc 初体验

首先创建一个 yacc 文件

```c
/* calc.y */
%{
#include <stdio.h>
#include "y.tab.h"

extern int yylex(void);

int yyerror(char* s) {
  fprintf(stderr, "%s\n", s);
  return 0;
}
%}

%token INTEGER
%left '+' '-'
%left '*' '/'

%%
program:
     program expr '\n' { printf("%d\n", $2); }
     |
     ;

expr:
   INTEGER        { $$ = $1;         }
   | expr '+' expr  { $$ = $1 + $3;    }
   | expr '-' expr  { $$ = $1 - $3;    }
   ;
%%

int main(void) {
  yyparse();
  return 0;
}
```

然后创建一个 lex 文件

```c
/* calc.l */
%{
#include "y.tab.h"
extern int yyerror(char* s);
%}

%%
[0-9]+ { yylval = atoi(yytext); return INTEGER; }
[\+\-\*\/\(\)\n] { return *yytext; }
[ \t] {}
. { yyerror("invalid char."); }
%%

int yywrap() { return 1; }
```

然后对 yacc 文件进行处理，`yacc calc.y -d`，同时生成 `y.tab.c` 和 `y.tab.h`，对 lex 文件进行编译 `flex calc.l`，最后对生成的 c 文件进行联合编译 `gcc lex.yy.c y.tab.c -o calc`

:::warning
最后进行编译时，如果文件会报错 `error: implicit declaration of function 'yylex' is invalid in C99`，这样的错误，直接使用 `-w` flag 进行忽视即可
:::

运行生成程序，可以输入一个表达式，然后他会计算，当然他现在只会简单的加减法

## yacc 文件结构

yacc 和 lex 一样，包含三部分，定义，规则，用户子程序，我们只讲出现的不同的地方

首先是定义部分，我们可以在这里定义我们将会使用的符号，还有规定运算符的优先级等，代码如下

```
%token INTEGER
%left '+' '-'
%left '*' '/'
```

`%token` 是我们定义的会使用到的符号，相当于 yacc 和 lex 之间的接口。将 yacc 文件编译生成头文件以后，在 lex 中引入然后即可对分析出的特定单词指定为该 token

`%left` 意思为左结合，同理还有右结合 `%right`，在左结合的情况下，最后定义的那部分优先级最高，通过这样的小技巧可以减少一些文法冲突

## lex 每个部分详解

## 细枝末节

## 小错误和小提示

## 代码结果

此处为 calc.y 的代码

```c
 // calc.y
%{
#include <stdio.h>
#include "y.tab.h"

extern int yylex(void);

int yyerror(char* s) {
  fprintf(stderr, "%s\n", s);
  return 0;
}

int mypow(int a, int b) {
  if (b == 0) {
    return 1;
  }

  if (b < 0) {
    return 1 / mypow(a, -b);
  }

  if (b % 2 == 0) {
    return mypow(a * a, b / 2);
  }
  else {
    return a * mypow(a * a, b / 2);
  }
}
%}

%token INTEGER
%left '+' '-'
%left '*' '/'
%left '^'

%%
program:
     program expr '\n' { printf("%d\n", $2); }
     |
     ;

expr:
   INTEGER        { $$ = $1;         }
   | expr '+' expr  { $$ = $1 + $3;  }
   | expr '-' expr  { $$ = $1 - $3;  }
   | expr '*' expr  { $$ = $1 * $3;  }
   | expr '/' expr  { $$ = $1 / $3;  }
   | expr '^' expr  { $$ = mypow($1, $3);  }
   | '-' expr  { $$ = -1 * $2;  }
   | '(' expr ')'  { $$ = $2;  }
   ;
%%

int main(void) {
  yyparse();
  return 0;
}
```

此处为 calc.l 的代码

```c
 /* calc.l */
%{
#include "y.tab.h"
extern int yyerror(char* s);
%}

%%
[0-9]+ { yylval = atoi(yytext); return INTEGER; }
[\+\-\*\/\(\)\^\n] { return *yytext; }
[ \t] {}
. { yyerror("invalid char."); }
%%

int yywrap() { return 1; }
```
