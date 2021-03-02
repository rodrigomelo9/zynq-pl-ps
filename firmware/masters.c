#include "xil_printf.h"
#include "xil_io.h"
#include "xtime_l.h"
#include "xil_cache.h"
#include "xil_mmu.h"

#include "shared.h"

#define DEBUG 0

int data[ROWS][COLS] __attribute__ ((aligned (32)));
// 8 bytes alignment must be enough but fails (also with 16).

void read_master(int data[ROWS][COLS], UINTPTR Addr, int TYPE, int FLUSH) {
   int row;
   XTime tStart[ROWS], tEnd[ROWS];
   clear_data(data);
   Xil_Out32(Addr+REG_CONTROL, DISABLE);
   Xil_Out32(Addr+REG_LENGTH, COLS);
   if (FLUSH)
      Xil_DCacheFlushRange((UINTPTR)data,ROWS*COLS*4);
   for (row=0; row<ROWS; row++) {
       XTime_GetTime(&tStart[row]);
       Xil_Out32(Addr+REG_ADDRESS, (UINTPTR)data[row]);
       Xil_Out32(Addr+REG_CONTROL, ENABLE);
       if (TYPE == LITE)
          Xil_Out32(Addr+REG_CONTROL, ENA_LITE);
       else
          Xil_Out32(Addr+REG_CONTROL, ENA_FULL);
       while(Xil_In32(Addr)); // busy
       if (TYPE == LITE)
          Xil_Out32(Addr+REG_CONTROL, DIS_LITE);
       else
          Xil_Out32(Addr+REG_CONTROL, DIS_FULL);
       XTime_GetTime(&tEnd[row]);
   }
   stats(data, tStart, tEnd, DEBUG);
}

int main() {

   xil_printf("\n### AXI Masters ###\n");
   xil_printf("* AXI ACP and AXI4 Lite\n");
   prepare_sniffer();
   read_master(data, XPAR_AXI4_MASTERS_0_S_AXIL_BASEADDR, LITE, DO_FLUSH);
   print_sniffer(SLOT1, WRIT_CH);
   xil_printf("* AXI ACP and AXI4 Full\n");
   prepare_sniffer();
   read_master(data, XPAR_AXI4_MASTERS_0_S_AXIL_BASEADDR, FULL, NO_FLUSH);
   print_sniffer(SLOT1, WRIT_CH);
   xil_printf("* AXI GP and AXI4 Lite\n");
   prepare_sniffer();
   read_master(data, XPAR_AXI4_MASTERS_1_S_AXIL_BASEADDR, LITE, DO_FLUSH);
   print_sniffer(SLOT2, WRIT_CH);
   xil_printf("* AXI GP and AXI4 Full\n");
   prepare_sniffer();
   read_master(data, XPAR_AXI4_MASTERS_1_S_AXIL_BASEADDR, FULL, DO_FLUSH);
   print_sniffer(SLOT2, WRIT_CH);
   xil_printf("* AXI HP and AXI4 Lite\n");
   prepare_sniffer();
   read_master(data, XPAR_AXI4_MASTERS_2_S_AXIL_BASEADDR, LITE, DO_FLUSH);
   print_sniffer(SLOT3, WRIT_CH);
   xil_printf("* AXI HP and AXI4 Full\n");
   prepare_sniffer();
   read_master(data, XPAR_AXI4_MASTERS_2_S_AXIL_BASEADDR, FULL, DO_FLUSH);
   print_sniffer(SLOT3, WRIT_CH);

   return 0;
}
