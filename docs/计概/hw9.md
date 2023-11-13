## Q1

> Using the format of Figure 10.6, please draw the stack usage procedure during the
> computation of (51-49)*(172+205)-(17*2) . The stack pointer is x4000 initially. Hint: you may
> refer the whole process sequence in Page 396 of textbook.

sp: x4000

| Stack Pointer | Stack Content |
| ------------- | ------------- |
| x3FFE         |               |
| x3FFF         |               |
| x4000         | 51            |

sp: x3FFF

| Stack Pointer | Stack Content |
| ------------- | ------------- |
| x3FFE         |               |
| x3FFF         | 49            |
| x4000         | 51            |

sp: x4000

| Stack Pointer | Stack Content |
| ------------- | ------------- |
| x3FFE         |               |
| x3FFF         | 49            |
| x4000         | 2             |

sp: x3FFE

| Stack Pointer | Stack Content |
| ------------- | ------------- |
| x3FFE         | 205           |
| x3FFF         | 172           |
| x4000         | 2             |

sp: x3FFF

| Stack Pointer | Stack Content |
| ------------- | ------------- |
| x3FFE         | 205           |
| x3FFF         | 377           |
| x4000         | 2             |

sp: x4000

| Stack Pointer | Stack Content |
| ------------- | ------------- |
| x3FFE         | 205           |
| x3FFF         | 377           |
| x4000         | 754           |

sp: x3FFF

| Stack Pointer | Stack Content |
| ------------- | ------------- |
| x3FFE         | 2             |
| x3FFF         | 17            |
| x4000         | 754           |

sp: x3FFE

| Stack Pointer | Stack Content |
| ------------- | ------------- |
| x3FFE         | 2             |
| x3FFF         | 34            |
| x4000         | 754           |

sp: x4000

| Stack Pointer | Stack Content |
| ------------- | ------------- |
| x3FFE         | 2             |
| x3FFF         | 34            |
| x4000         | 720           |

## Q2

> There is a 4-dimensional array A[M][N][P][Q] in the memory. in which M = 3, N = 5, P = 7, Q = 9. each element is a 16-bit integer. the first A[0][0][0][0] is store at x4000, what is the address of A[2][4][3][5]

```
A[2][4][3][5] = 2 * 5 * 7 * 9 + 4 * 7 * 9 + 3 * 9 + 5 = 914 = x39A
so the result is x39A + x4000 = x439A
```
