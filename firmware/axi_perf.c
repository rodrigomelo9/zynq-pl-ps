/*
 * Copyright (c) 2009-2012 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "xaxipmon.h"
#include <sleep.h>

#define esc 27
#define cls printf("%c[2J",esc)
#define pos(row,col) printf("%c[%d;%dH",esc,row,col)

#define PERFMON_ID XPAR_AXI_PERF_MON_0_DEVICE_ID
#define PERFMON_BASEADDR XPAR_AXI_PERF_MON_0_BASEADDR


int main()
{
    printf("Performance test started\n\r");
	int status;
    init_platform();

    cls;
    pos(0,0);

    XAxiPmon_Config* perfmon_config = XAxiPmon_LookupConfig(PERFMON_ID);

    XAxiPmon perfmon;
    status = XAxiPmon_CfgInitialize(&perfmon, perfmon_config, PERFMON_BASEADDR);
    if (status != XST_SUCCESS) {
    	printf("Error initializing axi perfmon\r\n");
    	return status;
	}

	XAxiPmon_EnableMetricsCounter(&perfmon);

	u32 fpga_clk1 = 100 * 1000000; //100 MHz
	// init sample counter
	u32 prev_samples = XAxiPmon_SampleMetrics(&perfmon);

    for (;;) {
    	sleep(1);
    	u32 cur_samples = XAxiPmon_SampleMetrics(&perfmon);
    	u32 samples = cur_samples - prev_samples;
    	prev_samples = cur_samples;
    	double seconds = (double)samples / (double)fpga_clk1;
    	u32 Port_write[6];
    	u32 Port_read[6];
    	double Port_write_bw[6];
    	double Port_read_bw[6];
    	int i;
    	for (i=0; i<6; ++i) {
    		Port_write[i] = XAxiPmon_GetSampledMetricCounter(&perfmon, 0 + i*6);
    		Port_write_bw[i] = (double)Port_write[i] / (seconds * 1000 * 1000);
    		Port_read[i]  = XAxiPmon_GetSampledMetricCounter(&perfmon, 3 + i*6);
    		Port_read_bw[i] = (double)Port_read[i] / (seconds * 1000 * 1000);
    	}

    	cls;
    	pos(0,0);
    	printf("samples = %lu (%2.3f seconds)\r\n", samples, seconds);
    	for (i=0; i<6; ++i) {
    		if (i<4) {
    			printf("HP[%d] read count = %8lu (%6.3f MBytes/sec); ", i, Port_read[i], Port_read_bw[i]);
    			printf("HP[%d] write count = %8lu (%6.3f MBytes/sec)\r\n", i, Port_write[i], Port_write_bw[i]);
    		}
    		else if (i==4) {
        		printf("ACP read count = %8lu (%6.3f MBytes/sec); ", Port_read[i], Port_read_bw[i]);
        		printf("ACP write count = %8lu (%6.3f MBytes/sec)\r\n", Port_write[i], Port_write_bw[i]);
    		}
     		else if (i==5) {
        		printf("GP read count = %8lu (%6.3f MBytes/sec); ", Port_read[i], Port_read_bw[i]);
        		printf("GP write count = %8lu (%6.3f MBytes/sec)\r\n", Port_write[i], Port_write_bw[i]);
    		}
        }
  }


    return status;
}
