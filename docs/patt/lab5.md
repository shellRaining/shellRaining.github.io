---
title: lab5
tag:
  - patt
description: report of lab5
---

# {{ $frontmatter.title }}

## algorithm

this lab is same as [this question in leetcode](https://leetcode.cn/problems/longest-increasing-path-in-a-matrix/), so I just write this code in typescript first, then translate to LC-3 assemble

```ts
function longestIncreasingPath(matrix: number[][]): number {
  let res = 0;
  const row = matrix.length;
  const col = matrix[0].length;
  const cache = Array.from({ length: row }, () => new Array(col).fill(0));

  function lip(x: number, y: number): number {
    // this function from matrix[x][y], to search the longest increasing path
    if (cache[x][y] != 0) return cache[x][y];

    const direction = [
      [1, 0],
      [0, 1],
      [-1, 0],
      [0, -1],
    ];

    // to check whether exist a place that value lower than this
    for (const item of direction) {
      const nx = x + item[0];
      const ny = y + item[1];
      if (nx >= row || nx < 0 || ny >= col || ny < 0) continue;
      if (matrix[nx][ny] < matrix[x][y]) {
        cache[x][y] = Math.max(cache[x][y], lip(nx, ny) + 1);
      }
    }

    return cache[x][y];
  }

  for (let i = 0; i < row; i++) {
    for (let j = 0; j < col; j++) {
      const cur_path = lip(i, j);
      if (cur_path > res) res = cur_path;
    }
  }

  return res + 1;
}
```

## code

the core code I think is how to handle recursive function and matrix, I will put this below

```asm
outerLoop ; to deal with the outer loop, need reset the counter j every time
	ld r1, i
	add r1, r1, #-1
	st r1, i
	brn done

innerLoop ; to deal with the innerLoop, need reset the counter i every time, because after the function call, reg that stored i will be changed
	ld r2, j
	add r2, r2, #-1
	st r2, j
	brn endInnerLoop

	and r3, r3, #0
	add r3, r3, #1

	; r1 = i, r2 = j, r3 = step(1) and let r0 = lip(1, i, j) in the end
	add r6, r6, #-1 ; push j
	str r2, r6, #0
	add r6, r6, #-1 ; push i
	ld r1, i
	str r1, r6, #0
	add r6, r6, #-1 ; push step
	str r3, r6, #0
	jsr lip
	ldr r0, r6, 0 ; get return value
	add r6, r6, #4 ; pop parameters and return value

	; res = t > res ? t : res
	ld r1, res
	add r2, r0, #0
	add r3, r1, #0
	not r3, r3
	add r3, r3, #1
	add r3, r2, r3
	brnz notUpdateRes
	st r0, res
notUpdateRes
	brnzp innerLoop

endInnerLoop
	ldi r2, n
	st r2, j
	brnzp outerLoop
```

## Q&A

1. how to write recursive function in LC-3 assemble?

   to write recursive function, we should know the stack structure of function call, it like this

   ```txt
    -----------------   high address
    | parameters    |
    | return value  |
    | return address|
    | old fp        |
    | local var     |
    | ...           |
   ```

   so the process like this

   1. caller push parameters
   2. use jsr to call function
   3. callee push return value and return address
   4. save old fp and set new fp to sp - 1
   5. set sp, need reserve space for local var

   after call this function, we just need restore the stack, and return to caller

   1. callee pop local var
   2. restore old fp
   3. restore return address, store it to r7, then call ret
   4. caller pop return value and parameters

2. how many mem will cost if the matrix have 50 item?

   the recursive function have three parameters, and have two local var, add return value, old fp and return address, so the stack will cost 8 \* 50 = 400 words
