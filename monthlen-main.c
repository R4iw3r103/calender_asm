#include <stdio.h>

extern int monthlen(int, int);

int main(void) {
    int y = 2023;
    int m = 11;
    int len = monthlen(y, m);

    printf("%d\n", len);

    return 0;
}
