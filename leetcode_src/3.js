const readline = require("readline");

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

/**
 * @param {string} s
 * @return {number}
 */
var lengthOfLongestSubstring = function (s) {
  let max_len = 0;
  let l = 0;
  let r = 0;
  const set = new Set();

  while (r < s.length) {
    if (!set.has(s[r])) {
      set.add(s[r]);
      r++;
      max_len = Math.max(max_len, r - l);
    } else {
      set.delete(s[l]);
      l++;
    }
  }

  return max_len
};

rl.on("line", (line) => {
  const str = line;
  console.log(lengthOfLongestSubstring(str));
});
