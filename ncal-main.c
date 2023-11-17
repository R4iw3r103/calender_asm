#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define IW          (7) // 1 week
#define CW          (3) // 1日分の表示にとる文字数(1日で3文字分確保する)
#define OW          (66)// Width（3文字*7日+余白1マス*3ヶ月分)
#define OH          (6) // Height(月始まりが土曜に来ると縦は最大6行になる+年月と曜日の枠で2行)
#define MAX_CANVAS  (OW*OH) // 最大で必要なマス数

char canvas[MAX_CANVAS];
extern int mk1cal(int, int, char[]);
extern int pdec(int);
extern char pch(int);

void printday() {
    // 曜日の表示
    pch('M');pch('o');pch(' ');pch('T');pch('u');pch(' ');pch('W');pch('e');
    pch(' ');pch('T');pch('h');pch(' ');pch('F');pch('r');pch(' ');
    pch('S');pch('a');pch(' ');pch('S');pch('u');pch('\n');
}

void printcal(int y, int m) {
    int i, j;
    // 年月の表示
    for(i=0; i<=6; i++){
        pch(' ');
   }
    pdec(y);
    pch(' ');
    pdec(m);
    pch('\n');
    printday();
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
    int y;
    int m;

    if(argc==3) {
        y = atoi(argv[1]);
        m = atoi(argv[2]);
    } else {
        printf("usage: %s y m              - one month\n",
            argv[0]);
        exit(9);
    }

    memset(canvas, ' ', sizeof(canvas));
    mk1cal(y, m, canvas);
    printcal(y, m);
    exit(0);
}
