#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define IW          (7) // 1 week
#define CW          (3) // 1日分の表示にとる文字数(1日で3文字分確保する)
#define OW          (21)// Width（3文字*7日+余白1マス*3ヶ月分)
#define OH          (6) // Height(月始まりが土曜に来ると縦は最大6行になる+年月と曜日の枠で2行)

extern int mk1cal(int, int, char[], int);
extern int pdec(int);
extern char pch(int);

void printcal(int y, int m, char *canvas, int MAX_CANVAS) {
    int i, j;

    for(i=0;i<MAX_CANVAS;i++) {
        if(canvas[i]) {
            printf("%c", canvas[i]);
        }
        if(i%OW==OW-1) {
            printf("\n");
        }
    }
}

int main(int argc, char *argv[])
{
    int MAX_CANVAS = OW * OH * atoi(argv[3]);
    int y;
    int m;
    int n;
    char canvas[MAX_CANVAS];

    if(argc==4) {
        y = atoi(argv[1]);
        m = atoi(argv[2]);
        n = atoi(argv[3]);
    } else {
        printf("usage: %s y m              - one month\n",
            argv[0]);
        exit(9);
    }

    memset(canvas, ' ', sizeof(canvas));
    mk1cal(y, m, canvas, n);
    printcal(y, m, canvas, MAX_CANVAS);
    exit(0);
}
