#include "xil_printf.h"
#include "xaxidma.h"
#include "xtime_l.h"

#include "shared.h"

#define DEBUG 0

static int data[ROWS][COLS] __attribute__ ((aligned (8)));

XAxiDma dma_acp, dma_gp0, dma_hp0;

void read_dma(UINTPTR addr, int device_id, XAxiDma *dma, int FLUSH) {
   int row;
   XTime tStart[ROWS], tEnd[ROWS];
   int status;
   XAxiDma_Config *cfg;
   Xil_Out32(addr+REG_CONTROL, DISABLE);
   Xil_Out32(addr+REG_LENGTH, COLS);
   // Init and Config DMA
   cfg = XAxiDma_LookupConfig(device_id);
   if (!cfg) {
      xil_printf("No configuration found for AXI DMA with device ID %d\n", device_id);
      return;
   }
   status = XAxiDma_CfgInitialize(dma, cfg);
   if (status != XST_SUCCESS) {
      xil_printf("ERROR: DMA configuration failed\n");
      return;
   }
   //
   clear_data(data);
   if (FLUSH)
      Xil_DCacheFlushRange((UINTPTR)data, ROWS*COLS*4);
   Xil_Out32(addr+REG_CONTROL, ENABLE);
   for (row=0; row<ROWS; row++) {
       XTime_GetTime(&tStart[row]);
       status = XAxiDma_SimpleTransfer(dma, (UINTPTR)data[row], COLS*4, XAXIDMA_DEVICE_TO_DMA);
       if (status != XST_SUCCESS) {
          xil_printf("DMA RX SimpleTransfer failed\n");
          return;
       }
       while (XAxiDma_Busy(dma,XAXIDMA_DEVICE_TO_DMA));
       XTime_GetTime(&tEnd[row]);
   }
   Xil_Out32(addr+REG_CONTROL, DISABLE);
   stats(data, tStart, tEnd, DEBUG);
}

int main() {

   if (1) {
      xil_printf("* AXI ACP with DMA\n");
      prepare_sniffer();
      read_dma(XPAR_MASTER_ACP_AXI4_STREAM_0_AXIL_BASEADDR, XPAR_MASTER_ACP_AXI_DMA_0_DEVICE_ID, &dma_acp, NO_FLUSH);
      print_sniffer(SLOT1, WRIT_CH);
   }

   if (1) {
      xil_printf("* AXI GP with DMA\n");
      prepare_sniffer();
      read_dma(XPAR_MASTER_GP0_AXI4_STREAM_0_AXIL_BASEADDR, XPAR_MASTER_GP0_AXI_DMA_0_DEVICE_ID, &dma_gp0, DO_FLUSH);
      print_sniffer(SLOT2, WRIT_CH);
   }

   if (1) {
      xil_printf("* AXI HP with DMA\n");
      prepare_sniffer();
      read_dma(XPAR_MASTER_HP0_AXI4_STREAM_0_AXIL_BASEADDR, XPAR_MASTER_HP0_AXI_DMA_0_DEVICE_ID, &dma_hp0, DO_FLUSH);
      print_sniffer(SLOT3, WRIT_CH);
   }

}
