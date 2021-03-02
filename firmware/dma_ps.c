#include "xparameters.h"
#include "xil_io.h"
#include "xil_printf.h"
#include "xscugic.h"
#include "xdmaps.h"

#define PS_DMA_CHANNEL	0
#define DMA_LENGTH	1024

static int Dst[DMA_LENGTH] __attribute__ ((aligned (32)));

int SetupInterruptSystem(XScuGic *GicPtr, XDmaPs *DmaPtr) {
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

int XDmaPs_Example(u16 DeviceId) {
   int row, col;
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
   dma_cmd.BD.SrcAddr = (u32) XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR;
   dma_cmd.BD.DstAddr = (u32) Dst;
   dma_cmd.BD.Length = DMA_LENGTH * sizeof(int);

   dma_cfg = XDmaPs_LookupConfig(DeviceId);
   if (dma_cfg == NULL) {
      return XST_FAILURE;
   }
   status = XDmaPs_CfgInitialize(&dma_ptr, dma_cfg, dma_cfg->BaseAddress);
   if (status != XST_SUCCESS) {
      return XST_FAILURE;
   }

   status = SetupInterruptSystem(&gic_ptr, &dma_ptr);
   if (status != XST_SUCCESS) {
      return XST_FAILURE;
   }

   for (col = 0; col < DMA_LENGTH; col++)
      Dst[col] = 0;

   for (row = 0; row < 2; row++) {
       status = XDmaPs_Start(&dma_ptr, PS_DMA_CHANNEL, &dma_cmd, 0);
       if (status != XST_SUCCESS) {
          return XST_FAILURE;
       }

       xil_printf("Before DMA\n");
       while (XDmaPs_IsActive(&dma_ptr, PS_DMA_CHANNEL));
       xil_printf("After DMA\n");

       for (col = 0; col < DMA_LENGTH; col++) {
           if (col > 0 && (Dst[col]-Dst[col-1] <= 0)) xil_printf("diff ERROR");
          xil_printf("%x (diff=%d)\n", Dst[col], (col>0) ? Dst[col]-Dst[col-1] : 0);
       }
   }

   return XST_SUCCESS;
}

int main(void) {
   int Status;

   Xil_Out32(XPAR_AXI4_SLAVES_0_S_AXIL_BASEADDR, 0);
   Xil_Out32(XPAR_AXI4_SLAVES_0_S_AXIL_BASEADDR, 1);

   Status = XDmaPs_Example(XPAR_XDMAPS_1_DEVICE_ID);
   if (Status != XST_SUCCESS) {
      xil_printf("Error: XDMaPs_Example_W_Intr failed\r\n");
      return XST_FAILURE;
   }

   xil_printf("Successfully ran XDMaPs_Example_W_Intr\r\n");
   return XST_SUCCESS;
}
