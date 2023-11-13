# lab6 report

## algorithm

The project I choose in lab6 is A, which means to implement a simple LC-3 assembler (to translate LC-3 assembly to machine code), the step I take is:

1. pre-process the code, to remove all comments and empty lines, then trim the code and make them to lower case (except .stringz command)
2. parse the code, get all labels, make a symbol table
3. translate the code to machine code, judge the type of command first (whether it is a pseudo command or a real command), then translate it to machine code

## code

### pre-process

In this step, I use map command and filter command to remove all comments and empty lines, then trim the code and make them to lower case (except .stringz command)

```ts
function preProcessText() {
  text = text
    .map((s) => s.trim())
    .filter((s) => {
      // remove comments and empty lines
    })
    .map((line: string) => {
      // trim the code
      // make all to lower case except .stringz command
    });
}
```

### make symbol table

In this step, I use map command to get all labels, make a symbol table

```ts
function getSymbolTable(): void {
  let cur_pc = 0x0;

  // ignore the code before the ".orig" instruction
  while (i < text.length && !text[i].startsWith(".orig")) i++;
  cur_pc = parseInt(text[i].slice(6).trim().slice(1), 16);
  for (; i < text.length && !text[i].startsWith(".end"); i++, cur_pc++) {
    // if the line is .stringz or .blkw, the pc should add with the length of the string or the number of the blkw
    if (line.startsWith(".stringz")) {
    } else if (line.startsWith(".blkw")) {
    }

    if (isLabel(line)) {
      // maybe the persudo instruction have a label, so we should check the next line
      // ...
    }
  }
}
```

### translate to machine code

In this step, we first judge the type of command (whether it is a pseudo command or a real command), then translate it to machine code

```ts
// this function is used to parse a single LC3 statement (which maybe instruction, or persudo instruction), then return the 16-bits binary code
// the input is a instruction have been pre-processed(like trim, toLowerCase, delete started label)
function parseLC3Stmt(instruction: string): string {
  if (isPersudoInstruction(instruction))
    return parsePersudoInstruction(instruction);
  else if (isInstruction(instruction)) return parseInstruction(instruction);
  return "";
}
```

If the instruction is a persudo instruction, we should parse it like this:

```ts
function parsePersudoInstruction(persudoInstr: string): string {
  // persudo code have four types: .orig, .fill, .blkw, .stringz

  switch (firstWord) {
    case ".orig": {
      // like this: .orig x3000
      const hex: number = parseInt(words[1].slice(1), 16);
      pc = hex;
      return hex.toString(2).padStart(16, "0");
    }
    case ".fill": {
      // like this: .fill x1234
      pc += 1;
      return parseImm(words[1], 16);
    }
    case ".blkw": {
      // like this: .blkw #10
      const num: number = parseInt(words[1].slice(1));
      pc += num;
      const arr = new Array(num).fill("0111011101110111");
      return arr.join("\n");
    }
    case ".stringz": {
      // like this: .stringz "hello world"
      const str = words[1].slice(1, -1);
      pc += str.length + 1;
      const arr = Array.from(str).map((char: string) => {
        return char.charCodeAt(0).toString(2).padStart(16, "0");
      });
      arr.push("0000000000000000");
      return arr.join("\n");
    }
    case ".end": {
      return "";
    }
  }
  return "";
}
```

If the instruction is a real instruction, we should parse it like this:

We first classify the instruction to some types, such as add, they all have `cmd rx, ry, rz` and `cmd rx, ry, imm` two types, so we can use switch to classify them, then parse them. Same as others.

```ts
function parseInstruction(instruction: string): string {
  const opcode = InstructionTypeMap.get(arr[0]);
  switch (arr[0]) {
    case "add":
    case "and": {
      // oper have two cases, one is and, the other is and with immediate
    }
    case "not": {
      // not only have one case, just two registers
    }
    case "ldr":
    case "str": {
      // oper reg, reg, imm6
    }
    case "ld":
    case "ldi":
    case "lea":
    case "st":
    case "sti": {
      // oper reg, off9
    }
    case "trap": {
      // trap vect8
    }
    case "getc":
    case "out":
    case "puts":
    case "in":
    case "putsp":
    case "halt": {
    }
    case "br":
    case "brn":
    case "brz":
    case "brp":
    case "brnz":
    case "brnp":
    case "brzp":
    case "brnzp": {
      // br cond, off9
    }
    case "jmp": {
      // jmp reg
    }
    case "ret": {
    }
    case "jsr": {
      // jsr off11
    }
    case "jsrr": {
      // jsrr reg
    }
    case "rti": {
    }
  }
  pc++;

  return res;
}
```
