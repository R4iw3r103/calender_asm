#include <stdio.h>

extern int monthlen(int, int);

int main(void) {
    int y = 2022;
    int m = 2;
    int len = monthlen(y, m);

    printf("%d\n", len);

    return 0;
}
