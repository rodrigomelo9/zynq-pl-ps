#include "xil_printf.h"
#include "xtime_l.h"
#include "xil_io.h"


#include "shared.h"

/*****************************************************************************
*
* This function is used to print a float value.
*
* @param	fvar: float value to print.
*
* @return	None.
*
* @note		xil_printf do not supports %f.
*
*****************************************************************************/
void print_float(float fvar) {
   int whole, thousandths;
   whole = fvar;
   thousandths = (fvar - whole) * 100;
   xil_printf("%2d.%2d", whole, thousandths);
}

/*****************************************************************************
*
* This function is used to clear the content of the data matrix.
*
* @param	data: data to clear.
*
* @return	None.
*
* @note		None.
*
*****************************************************************************/
void clear_data(int data[ROWS][COLS]) {
   int row, col;
   for (row=0; row<ROWS; row++)
       for (col=0; col<COLS; col++)
           data[row][col] = 0;
}

/*****************************************************************************
*
* This function is where stats about the data are calculated.
*
* @param	data: data to analyze.
* @param	DEBUG - specify what to print (
*				0 - Normal output,
*				1 - LaTeX output
*				2 - DEBUG output
*			)
*
* @return	None.
*
* @note		None.
*
*****************************************************************************/
void stats(int data[ROWS][COLS], XTime tStart[ROWS], XTime tEnd[ROWS], int DEBUG) {
   int row, col;
   int min[ROWS], avg[ROWS], max[ROWS];
   int pl_min, pl_avg, pl_max;
   int ps_min, ps_avg, ps_max;
   int adjust;
   int diff, beat_cnt, form_cnt;
   //
   // Check data
   //
   if (DEBUG == 2) xil_printf("Checking data\n");
   for (row=0; row<ROWS ; row++) {
       if (DEBUG == 2) xil_printf("* ROW %d\n", row);
       for (col=0; col<COLS ; col++) {
           if ( (row == 0) & (col == 0) )
              diff = 9999;
           else if (col == 0)
              diff = data[row][0]-data[row-1][col-1];
           else // if (col > 0)
              diff = data[row][col]-data[row][col-1];
           if (DEBUG == 2) xil_printf("%06d ", data[row][col]);
           if (diff==0) xil_printf("[diff=0] ");
           if (diff<0)  xil_printf("[diff<0] ");
           if ( (DEBUG == 2) & (col % 16 == 15)) xil_printf("\n");
       }
       if (DEBUG == 2) xil_printf("\n");
   }
   //
   // Cycles between data
   //
   for (row=0; row<ROWS ; row++) {
       avg[row] = max[row] = 0;
       min[row] = data[row][1]-data[row][0];
       for (col=1; col<COLS ; col++) {
           diff = data[row][col]-data[row][col-1];
           avg[row] += diff;
           if (diff < min[row]) min[row] = diff;
           if (diff > max[row]) max[row] = diff;
       }
       avg[row] = avg[row]/(COLS-1);
       if (DEBUG == 2) xil_printf("ROW %02d -> %d < %d < %d\n", row, min[row], avg[row], max[row]);
   }
   for (row=1; row<ROWS ; row++) {
       if (min[row] < min[0]) min[0] = min[row];
       if (max[row] > max[0]) max[0] = max[row];
       avg[0] += avg[row];
   }
   avg[0] = avg[0]/ROWS;
   if (DEBUG == 0) xil_printf("Cycles between data -> %d < %d < %d\n", min[0], avg[0], max[0]);
   if (DEBUG == 1) xil_printf(" & %2d & %2d & %2d", min[0], avg[0], max[0]);
   adjust = avg[0];
   //
   // Cycles per row
   //
   pl_max = ps_max = 0;
   pl_avg = pl_min = data[0][COLS-1]-data[0][0]+adjust;
   ps_avg = ps_min = 2 * (tEnd[0]-tStart[0]);
   for (row=1; row<ROWS ; row++) {
       diff = data[row][COLS-1]-data[row][0]+adjust;
       pl_avg += diff;
       if (diff < pl_min) pl_min = diff;
       if (diff > pl_max) pl_max = diff;
       diff = 2 * (tEnd[row]-tStart[row]);
       ps_avg += diff;
       if (diff < ps_min) ps_min = diff;
       if (diff > ps_max) ps_max = diff;
   }
   pl_avg = pl_avg/ROWS;
   ps_avg = ps_avg/ROWS;
   if (DEBUG == 0) {
      xil_printf("Cycles per row (PL) -> %4d < %4d < %4d\n", pl_min, pl_avg, pl_max);
      xil_printf("Cycles per row (PS) -> %4d < %4d < %4d\n", ps_min, ps_avg, ps_max);
   }
   //
   // Total Cycles
   //
   if (DEBUG == 0) {
      xil_printf("Cycles in PS -> %d (", ps_avg);
      print_float((float)PS_MHZ*COLS*4/ps_avg);
      xil_printf(" MB/s)\n");
      xil_printf("Cycles in PL -> %d (", pl_avg);
      print_float((float)PL_MHZ*COLS*4/pl_avg);
      xil_printf(" MB/s)\n");
      xil_printf("PS/PL -> ");
      print_float((pl_avg) ? (float)ps_avg/pl_avg : 0);
      xil_printf("\n");
   }
   if (DEBUG == 1) {
      xil_printf(" & %d (", ps_avg);
      print_float((float)PS_MHZ*COLS*4/ps_avg);
      xil_printf(" MB/s)");
      xil_printf(" & %d (", pl_avg);
      print_float((float)PL_MHZ*COLS*4/pl_avg);
      xil_printf(" MB/s)");
      xil_printf(" & ");
      print_float((pl_avg) ? (float)ps_avg/pl_avg : 0);
      xil_printf(" \\\\ \\hline\n");
   }
   //
   // Waveform
   //
   if (DEBUG == 0) xil_printf("Waveform -> ");
   beat_cnt = 1;
   form_cnt = 0;
   diff     = 9999;
   for (col=1; col<COLS ; col++) {
       if (form_cnt < 5) {
          diff = data[0][col]-data[0][col-1];
          if (diff == 1) {
             beat_cnt++;
          } else {
             if (DEBUG == 0) xil_printf("%d __%d__ ", beat_cnt, diff);
             beat_cnt = 1;
             form_cnt++;
          }
       }
   }
   if (DEBUG == 0) xil_printf("\n");
}

void prepare_sniffer() {
   Xil_Out32(XPAR_AXI3_BURSTSNIFFER_0_S_AXIL_BASEADDR, ENABLE);
}

void print_wave(int data, int dir) {
   int i;
   for (i = 24; i >= 0; i--) {
	   if (dir == READ_CH && i>4 && i<7)
		  xil_printf("X");
	   else
          xil_printf("%d", data & (1 << i) ? 1 : 0);
       if (i == 23) xil_printf(" | ");
       if (i == 19) xil_printf(" | ");
       if (i == 17) xil_printf(" | ");
       if (i == 14) xil_printf(" | ");
       if (i == 10) xil_printf(" | ");
       if (i ==  7) xil_printf(" || ");
       if (i ==  6) xil_printf(" ");
       if (i ==  5) xil_printf(" | ");
       if (i ==  4) xil_printf(" | ");
       if (i ==  3) xil_printf(" ");
       if (i ==  2) xil_printf(" | ");
       if (i ==  1) xil_printf(" ");
   }
   xil_printf("\n");
}

void print_sniffer(int slot, int dir) {
   int i, samples[256];
   Xil_Out32(XPAR_AXI3_BURSTSNIFFER_0_S_AXIL_BASEADDR+4,slot);
   xil_printf("Sniffer SLOT%d\n");
   for (i = 0; i < 256; i++) {
       samples[i] = Xil_In32(XPAR_AXI3_BURSTSNIFFER_0_S_AXIL_BASEADDR + i*4);
       if (dir == WRIT_CH && (i>=1 && i <= 128))
          print_wave(samples[i], dir);
       if (dir == READ_CH && (i>=129 && i <= 255))
          print_wave(samples[i], dir);
   }
}
