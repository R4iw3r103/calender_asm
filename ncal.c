#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// ツェラーの公式で計算するところ
int
monthwoffset(int y, int m, int d)
{
    int rv;
    int e;

    // 1月と2月の場合は13月、14月として計算
    if(m==1 || m==2) {
        y--;
        m += 12;
    }
    // ツェラーの公式
    e = y+y/4-y/100+y/400+((13*m+8))/5 + d;
    rv = e % 7;

    return rv;
}

int
monthlen(int y, int m)
{
    int q;
    int rv;

    // 閏年の計算
    q = (y%4==0) - (y%100==0) + (y%400==0);

    if(m==2) {
        if(q) { rv = 29; }
        else  { rv = 28; }
    }
    //  月毎の最終日の定義
    else {
        switch(m) {
        case  1:
        case  3:
        case  5:
        case  7:
        case  8:
        case 10:
        case 12:
            rv = 31;
            break;
        default:
            rv = 30;
            break;
        }
    }

    return rv;
}

/*
 *  columns: 3 char. x 7 days in row = 21 char.
 *  rows:    worst case uses 6 rows
 *
 *          columns
 *          123456789012345678901
 *          ---------------------
 *               July 2023
 *          Su Mo Tu We Th Fr Sa
 *                             1 |1 rows
 *           2  3  4  5  6  7  8 |2
 *           9 10 11 12 13 14 15 |3
 *          16 17 18 19 20 21 22 |4
 *          23 24 25 26 27 28 29 |5
 *          30 31                |6
 *
 */
#define IW          (7) // 1 week
#define CW          (3) // 1日分の表示にとる文字数(1日で3文字分確保する)
#define OW          (21)// Width（3文字*7日)
#define OH          (6) // Height(月始まりが土曜に来ると縦は最大6行になる)
#define MAX_CANVAS  (OW*OH) // 最大で必要なマス数

char canvas[MAX_CANVAS];

int
mk1cal(int y, int m)
{
    int  d;
    int  dlen;
    int  woff;
    int  c, r;
    int  b;

    dlen = monthlen(y, m);
    woff = monthwoffset(y, m, 1);

    r = 0;
    for(d=1;d<=dlen;d++) {
        c = (woff+d-1+7)%IW;
        b = r*OW+c*CW;
        if(d>=10) {
            canvas[b] = d/10 + '0';
        }
        b++;
        canvas[b] = d%10 + '0';
        if(c>=IW-1) {
            r++;
        }
    }
    return 0;
}

void
printcal(void)
{
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

int
main(int argc, char *argv[])
{
    int y;
    int m;

    if(argc==3) {
        y = atoi(argv[1]);
        m = atoi(argv[2]);
    }
    else {
        printf("usage: %s y m              - one month\n",
            argv[0]);
        exit(9);
    }

    memset(canvas, ' ', sizeof(canvas));
    mk1cal(y, m);
    printcal();
    exit(0);
}
