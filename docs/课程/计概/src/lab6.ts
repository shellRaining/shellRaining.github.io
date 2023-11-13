import * as readline from 'readline';
import { stdin as input, stdout as output } from 'process';

const rl = readline.createInterface({ input, output });

const InstructionTypeMap = new Map<string, string>([
  ['add', '0001'],
  ['and', '0101'],
  ['not', '1001'],
  ['ld', '0010'],
  ['ldr', '0110'],
  ['ldi', '1010'],
  ['lea', '1110'],
  ['st', '0011'],
  ['str', '0111'],
  ['sti', '1011'],
  ['trap', '1111'],
  ['getc', '1111'],
  ['out', '1111'],
  ['puts', '1111'],
  ['in', '1111'],
  ['putsp', '1111'],
  ['halt', '1111'],
  ['br', '0000'],
  ['brn', '0000'],
  ['brz', '0000'],
  ['brp', '0000'],
  ['brnz', '0000'],
  ['brnp', '0000'],
  ['brzp', '0000'],
  ['brnzp', '0000'],
  ['jmp', '1100'],
  ['ret', '1100'],
  ['jsr', '0100'],
  ['jsrr', '0100'],
  ['rti', '1000'],
]);
const RegisterMap = new Map<string, string>([
  ['r0', '000'],
  ['r1', '001'],
  ['r2', '010'],
  ['r3', '011'],
  ['r4', '100'],
  ['r5', '101'],
  ['r6', '110'],
  ['r7', '111'],
]);
const BranchMap = new Map<string, string>([
  ['br', '111'],
  ['brn', '100'],
  ['brz', '010'],
  ['brp', '001'],
  ['brnz', '110'],
  ['brnp', '101'],
  ['brzp', '011'],
  ['brnzp', '111'],
]);
const TrapMap = new Map<string, string>([
  ['getc', parseImm('x20', 8)],
  ['out', parseImm('x21', 8)],
  ['puts', parseImm('x22', 8)],
  ['in', parseImm('x23', 8)],
  ['putsp', parseImm('x24', 8)],
  ['halt', parseImm('x25', 8)],
]);

let text: string[] = new Array();
let pc = 0x0;
const symbolTable = new Map<string, number>();

function isPersudoInstruction(line: string) {
  return line.trim().startsWith('.');
}

function isInstruction(line: string) {
  return InstructionTypeMap.has(line.trim().split(' ')[0].toLowerCase());
}

function isLabel(line: string) {
  return !isInstruction(line) && !isPersudoInstruction(line);
}

// the task of this function is
// 1. trim the line
// 2. clear the comment and empty line
// 3. toLowerCase except the .stringz persudo instr
function preProcessText() {
  text = text
    .map((s) => s.trim())
    .filter((s) => {
      if (s.length == 0 || s.startsWith(';')) return false;
      return true;
    })
    .map((line: string) => {
      const nl = line.toLowerCase();
      if (nl.startsWith('.stringz')) {
        const arr = line.split(/\s(?=(?:[^"]*"[^"]*")*[^"]*$)/).filter((word) => word !== '');
        arr[0] = arr[0].toLowerCase();
        return arr.join(' ');
      } else if (nl.indexOf('.stringz') != -1) {
        const arr = line.split(/\s(?=(?:[^"]*"[^"]*")*[^"]*$)/).filter((word) => word !== '');
        arr[0] = arr[0].toLowerCase();
        arr[1] = arr[1].toLowerCase();
        return arr.join(' ');
      } else {
        return nl;
      }
    });
  getSymbolTable();
}

function getSymbolTable(): void {
  let cur_pc = 0x0;
  let i = 0;

  // ignore the code before the ".orig" instruction
  while (i < text.length && !text[i].startsWith('.orig')) i++;
  cur_pc = parseInt(text[i].slice(6).trim().slice(1), 16);
  i++;
  for (; i < text.length && !text[i].startsWith('.end'); i++, cur_pc++) {
    const line = text[i];

    // if the line is .stringz or .blkw, the pc should add with the length of the string or the number of the blkw
    if (line.startsWith('.stringz')) {
      const str = line.slice(9).trim().slice(1, -1);
      cur_pc += str.length;
      continue;
    } else if (line.startsWith('.blkw')) {
      const num = parseInt(line.slice(6).trim().slice(1));
      cur_pc += num - 1;
      continue;
    }

    // console.log(cur_pc.toString(16), line);
    if (isLabel(line)) {
      const arr = line.split(/\s(?=(?:[^"]*"[^"]*")*[^"]*$)/).filter((word) => word !== '');
      const label = arr[0];
      symbolTable.set(label, cur_pc);
      // maybe the persudo instruction have a label, so we should check the next line
      if (arr[1] && arr[1].startsWith('.stringz')) {
        const str = arr[2].slice(1, -1);
        cur_pc += str.length;
      } else if (arr[1] && arr[1].startsWith('.blkw')) {
        const num = parseInt(arr[2].slice(1));
        cur_pc += num - 1;
      }
      text[i] = line.slice(label.length).trim();
    }
  }
}

// imm is a string that represents a integer, bits is the length of the binary string
// TODO: how it is work
function parseImm(imm: string, bits: number): string {
  let num = 0;
  if (imm[0] == '#') num = parseInt(imm.slice(1));
  else if (imm[0] == 'x') num = parseInt(imm.slice(1), 16);
  else num = parseInt(imm);
  let res = '';
  let mask = (1 << bits) - 1;
  num = num & mask;

  mask = 1 << (bits - 1);
  while (mask > 0) {
    res += num & mask ? '1' : '0';
    mask >>= 1;
  }

  return res;
}

function parseOff(offsetStr: string, bits: number) {
  if (!offsetStr) {
    return '';
  }
  if (symbolTable.has(offsetStr)) {
    const offset = symbolTable.get(offsetStr)! - pc - 1;
    // offset maybe negative, so we should use two's complement
    const res = parseImm('#' + offset.toString(), bits);
    return res;
  } else {
    return parseImm(offsetStr, bits);
  }
}

function parsePersudoInstruction(persudoInstr: string): string {
  // persudo code have four types: .orig, .fill, .blkw, .stringz
  const words = persudoInstr.split(/\s(?=(?:[^"]*"[^"]*")*[^"]*$)/).filter((word) => word !== '');
  const firstWord = words[0].toLowerCase();

  switch (firstWord) {
    case '.orig': {
      // like this: .orig x3000
      const hex: number = parseInt(words[1].slice(1), 16);
      pc = hex;
      return hex.toString(2).padStart(16, '0');
    }
    case '.fill': {
      // like this: .fill x1234
      pc += 1;
      return parseImm(words[1], 16);
    }
    case '.blkw': {
      // like this: .blkw #10
      const num: number = parseInt(words[1].slice(1));
      pc += num;
      const arr = new Array(num).fill('0111011101110111');
      return arr.join('\n');
    }
    case '.stringz': {
      // like this: .stringz "hello world"
      const str = words[1].slice(1, -1);
      pc += str.length + 1;
      const arr = Array.from(str).map((char: string) => {
        return char.charCodeAt(0).toString(2).padStart(16, '0');
      });
      arr.push('0000000000000000');
      return arr.join('\n');
    }
    case '.end': {
      return '';
    }
  }
  return '';
}

function parseInstruction(instruction: string): string {
  let res: string = '';
  const arr = instruction.split(/\s|,/).filter((word) => word !== '');
  const opcode = InstructionTypeMap.get(arr[0]);
  res += opcode;
  switch (arr[0]) {
    case 'add':
    case 'and': {
      // oper have two cases, one is and, the other is and with immediate
      res += RegisterMap.get(arr[1]);
      res += RegisterMap.get(arr[2]);
      if (RegisterMap.has(arr[3])) {
        res += '000';
        res += RegisterMap.get(arr[3]);
      } else {
        res += '1';
        res += parseImm(arr[3], 5);
      }
      break;
    }
    case 'not': {
      // not only have one case, just two registers
      res += RegisterMap.get(arr[1]);
      res += RegisterMap.get(arr[2]);
      res += '111111';
      break;
    }
    case 'ldr':
    case 'str': {
      // oper reg, reg, imm6
      res += RegisterMap.get(arr[1]);
      res += RegisterMap.get(arr[2]);
      res += parseImm(arr[3], 6);
      break;
    }
    case 'ld':
    case 'ldi':
    case 'lea':
    case 'st':
    case 'sti': {
      // oper reg, off9
      res += RegisterMap.get(arr[1]);
      res += parseOff(arr[2], 9);
      break;
    }
    case 'trap': {
      // trap vect8
      res += '0000';
      res += parseImm(arr[1], 8);
      break;
    }
    case 'getc':
    case 'out':
    case 'puts':
    case 'in':
    case 'putsp':
    case 'halt': {
      res += '0000';
      res += TrapMap.get(arr[0]);
      break;
    }
    case 'br':
    case 'brn':
    case 'brz':
    case 'brp':
    case 'brnz':
    case 'brnp':
    case 'brzp':
    case 'brnzp': {
      // br cond, off9
      res += BranchMap.get(arr[0]);
      res += parseOff(arr[1], 9);
      break;
    }
    case 'jmp': {
      // jmp reg
      res += '000';
      res += RegisterMap.get(arr[1]);
      res += '000000';
      break;
    }
    case 'ret': {
      res += '000111000000';
      break;
    }
    case 'jsr': {
      // jsr off11
      res += '1';
      res += parseOff(arr[1], 11);
      break;
    }
    case 'jsrr': {
      // jsrr reg
      res += '000';
      res += RegisterMap.get(arr[1]);
      res += '000000';
      break;
    }
    case 'rti': {
      res += '000000000000';
      break;
    }
  }
  pc++;

  return res;
}

// this function is used to parse a single LC3 statement (which maybe instruction, or persudo instruction), then return the 16-bits binary code
// the input is a instruction have been pre-processed(like trim, toLowerCase, delete started label)
function parseLC3Stmt(instruction: string): string {
  if (isPersudoInstruction(instruction)) return parsePersudoInstruction(instruction);
  else if (isInstruction(instruction)) return parseInstruction(instruction);
  return '';
}

rl.on('line', (line) => {
  text.push(line);
});
rl.on('close', () => {
  preProcessText();
  for (const stmt of text) {
    const binStmt = parseLC3Stmt(stmt);
    if (binStmt.length == 0) {
      continue;
    }
    console.log(binStmt);
  }
});
