const readline = require("readline");

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

/**
 * @param {number[]} time
 * @return {number}
 */
var numPairsDivisibleBy60 = function (time) {
  let cnt = 0;
  for (let i = 0; i < time.length; i++) {
    for (let j = i + 1; j < time.length; j++) {
      if ((time[i] + time[j]) % 60 === 0) {
        cnt++;
      }
    }
  }

  return cnt;
};

rl.on("line", (line) => {
  const arr = line.split(" ").map((el) => parseInt(el));
  console.log(numPairsDivisibleBy60(arr));
});
