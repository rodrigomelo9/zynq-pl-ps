#ifndef SHARED_H
#define SHARED_H

#define ROWS        10
#define COLS        1024

#define PL_MHZ      150
#define PS_MHZ      XPAR_PS7_CORTEXA9_0_CPU_CLK_FREQ_HZ/1e6

#define USE_OTHER   0
#define USE_XIL_IN  1

#define LITE        0
#define FULL        1

#define NO_FLUSH    0
#define DO_FLUSH    1

#define REG_CONTROL 0x0
#define REG_LENGTH  0x4
#define REG_ADDRESS 0x8

#define DISABLE     0
#define ENABLE      1
#define ENA_LITE    3
#define ENA_FULL    5
#define DIS_LITE    ENABLE
#define DIS_FULL    ENABLE

void clear_data(int [ROWS][COLS]);
void stats(int [ROWS][COLS], XTime [ROWS], XTime [ROWS], int);

#define SLOT0       0
#define SLOT1       1
#define SLOT2       2
#define SLOT3       3

#define BOTH_CH     0
#define WRIT_CH     1
#define READ_CH     2

void prepare_sniffer();
void print_sniffer(int, int);

#endif // SHARED_H
