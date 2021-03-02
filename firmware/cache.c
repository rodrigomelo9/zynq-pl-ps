#include "xil_printf.h"
#include "xil_io.h"
#include "xtime_l.h"
#include "xil_cache.h"
#include "xil_mmu.h"
#include "xscugic.h"
#include "xdmaps.h"

#include "shared.h"

#define DEBUG 2

#define PS_DMA_CHANNEL 0

static int data[ROWS][COLS];

void read_slave(int data[ROWS][COLS], UINTPTR addr, int func_to_use, int FLUSH) {
   int row, col;
   XTime tStart[ROWS], tEnd[ROWS];
   clear_data(data);
   if (FLUSH == DO_FLUSH) Xil_SetTlbAttributes(addr, 0x15de6);
   Xil_Out32(XPAR_AXI4_SLAVES_0_S_AXIL_BASEADDR+REG_CONTROL, DISABLE);
   Xil_Out32(XPAR_AXI4_SLAVES_0_S_AXIL_BASEADDR+REG_CONTROL, ENABLE);
   for (row=0; row<ROWS; row++) {
       if (FLUSH == DO_FLUSH) Xil_DCacheFlushRange(addr,COLS*4);
       XTime_GetTime(&tStart[row]);
       if (func_to_use == USE_XIL_IN) {
          for (col=0; col<COLS ; col++) {
              data[row][col] = Xil_In32(addr+col*4);
          }
       } else {
          memcpy(data[row],(UINTPTR *)addr,COLS*4);
       }
       XTime_GetTime(&tEnd[row]);
   }
   stats(data, tStart, tEnd, DEBUG);
}

int psdma_interrupt_enable(XScuGic *GicPtr, XDmaPs *DmaPtr) {
   int status;
   XScuGic_Config *GicConfig;

   GicConfig = XScuGic_LookupConfig(XPAR_SCUGIC_SINGLE_DEVICE_ID);
   if (NULL == GicConfig) {
      return XST_FAILURE;
   }
   status = XScuGic_CfgInitialize(GicPtr, GicConfig, GicConfig->CpuBaseAddress);
   if (status != XST_SUCCESS) {
      return XST_FAILURE;
   }
   Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler, GicPtr);
   status = XScuGic_Connect(GicPtr, XPAR_XDMAPS_0_DONE_INTR_0, (Xil_InterruptHandler)XDmaPs_DoneISR_0, (void *)DmaPtr);
   if (status != XST_SUCCESS)
      return XST_FAILURE;
   XScuGic_Enable(GicPtr, XPAR_XDMAPS_0_DONE_INTR_0);
   Xil_ExceptionEnable();

   return XST_SUCCESS;
}

void read_ps_dma(int data[ROWS][COLS]) {
   int row;
   XTime tStart[ROWS], tEnd[ROWS];
   // Init and configure PS DMA
   int status;
   XDmaPs_Config *dma_cfg;
   XDmaPs_Cmd dma_cmd;
   XDmaPs dma_ptr;
   XScuGic gic_ptr;

   memset(&dma_cmd, 0, sizeof(XDmaPs_Cmd));

   dma_cmd.ChanCtrl.SrcBurstSize = 4;
   dma_cmd.ChanCtrl.SrcBurstLen = 16;
   dma_cmd.ChanCtrl.SrcInc = 1;
   dma_cmd.ChanCtrl.DstBurstSize = 4;
   dma_cmd.ChanCtrl.DstBurstLen = 16;
   dma_cmd.ChanCtrl.DstInc = 1;
   dma_cmd.BD.SrcAddr = (u32) XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR; //XPAR_AXI4_SLAVES_0_S_AXIF_BASEADDR;
   dma_cmd.BD.Length = COLS * sizeof(int);

   dma_cfg = XDmaPs_LookupConfig(XPAR_XDMAPS_1_DEVICE_ID);
   if (dma_cfg == NULL) {
      xil_printf("No configuration found for PS DMA device ID %d\n", XPAR_XDMAPS_1_DEVICE_ID);
      return;
   }
   status = XDmaPs_CfgInitialize(&dma_ptr, dma_cfg, dma_cfg->BaseAddress);
   if (status != XST_SUCCESS) {
      xil_printf("ERROR: PS DMA configuration failed\n");
      return;
   }
   status = psdma_interrupt_enable(&gic_ptr, &dma_ptr);
   if (status != XST_SUCCESS) {
      xil_printf("ERROR: PS DMA interrupts enable failed\n");
      return;
   }
   // Read
   Xil_Out32(XPAR_AXI4_SLAVES_0_S_AXIL_BASEADDR+REG_CONTROL, DISABLE);
   Xil_Out32(XPAR_AXI4_SLAVES_0_S_AXIL_BASEADDR+REG_CONTROL, ENABLE);
   for (row=0; row<ROWS; row++) {
       dma_cmd.BD.DstAddr = (u32) data[row];
       XTime_GetTime(&tStart[row]);
       XDmaPs_Start(&dma_ptr, PS_DMA_CHANNEL, &dma_cmd, 0);
       while (XDmaPs_IsActive(&dma_ptr, PS_DMA_CHANNEL));
       XTime_GetTime(&tEnd[row]);
   }
   stats(data, tStart, tEnd, DEBUG);
}

int main() {

   xil_printf("\n### AXI GP with PS DMA ###\n");
   xil_printf("* AXI GP using PS DMA\n");
   prepare_sniffer();
   read_ps_dma(data);
   print_sniffer(SLOT0, READ_CH);

   xil_printf("\n### BRAM Non-cached ###\n");
   xil_printf("* AXI GP Full with BRAMC (XilIn)\n");
   prepare_sniffer();
   read_slave(data, XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR, USE_XIL_IN, 0);
   print_sniffer(SLOT0, READ_CH);
   xil_printf("* AXI GP Full with BRAMC (memcpy)\n");
   prepare_sniffer();
   read_slave(data, XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR, USE_OTHER, 0);
   print_sniffer(SLOT0, READ_CH);

   xil_printf("\n### BRAM  with Cache ###\n");
   xil_printf("* AXI GP Full with BRAMC (XilIn)\n");
   prepare_sniffer();
   read_slave(data, XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR, USE_XIL_IN, 1);
   print_sniffer(SLOT0, READ_CH);
   xil_printf("* AXI GP Full with BRAMC (memcpy)\n");
   prepare_sniffer();
   read_slave(data, XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR, USE_OTHER, 1);
   print_sniffer(SLOT0, READ_CH);
   xil_printf("* AXI GP Lite (XilIn)\n");
   prepare_sniffer();
   read_slave(data, XPAR_AXI4_SLAVES_0_S_AXIL_BASEADDR, USE_XIL_IN, 1);
   print_sniffer(SLOT0, READ_CH);
   xil_printf("* AXI GP Lite (memcpy)\n");
   prepare_sniffer();
   read_slave(data, XPAR_AXI4_SLAVES_0_S_AXIL_BASEADDR, USE_OTHER, 1);
   print_sniffer(SLOT0, READ_CH);
   //xil_printf("* AXI GP Full (XilIn)\n");
   //prepare_sniffer();
   //read_slave(data, XPAR_AXI4_SLAVES_0_S_AXIF_BASEADDR, USE_XIL_IN, 1);
   //print_sniffer(SLOT0, READ_CH);
   //xil_printf("* AXI GP Full (memcpy)\n");
   //prepare_sniffer();
   //read_slave(data, XPAR_AXI4_SLAVES_0_S_AXIF_BASEADDR, USE_OTHER, 1);
   //print_sniffer(SLOT0, READ_CH);

   return 0;
}
