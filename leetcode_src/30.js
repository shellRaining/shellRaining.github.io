const readline = require("readline");
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

/**
 * @param {string} s
 * @param {string[]} words
 * @return {number[]}
 */
var findSubstring = function (s, words) {};

let s = "";
let words = [];

rl.on("line", function (line) {});
rl.on("close", function () {
  findSubstring(s, words);
});
