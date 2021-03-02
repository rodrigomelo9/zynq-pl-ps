
#ifndef AXI4_SLAVES_H
#define AXI4_SLAVES_H


/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"

#define AXI4_SLAVES_S_AXIL_SLV_REG0_OFFSET 0
#define AXI4_SLAVES_S_AXIL_SLV_REG1_OFFSET 4
#define AXI4_SLAVES_S_AXIL_SLV_REG2_OFFSET 8
#define AXI4_SLAVES_S_AXIL_SLV_REG3_OFFSET 12


/**************************** Type Definitions *****************************/
/**
 *
 * Write/Read 32 bit value to/from AXI4_SLAVES user logic memory (BRAM).
 *
 * @param   Address is the memory address of the AXI4_SLAVES device.
 * @param   Data is the value written to user logic memory.
 *
 * @return  The data from the user logic memory.
 *
 * @note
 * C-style signature:
 * 	void AXI4_SLAVES_mWriteMemory(u32 Address, u32 Data)
 * 	u32 AXI4_SLAVES_mReadMemory(u32 Address)
 *
 */
#define AXI4_SLAVES_mWriteMemory(Address, Data) \
    Xil_Out32(Address, (u32)(Data))
#define AXI4_SLAVES_mReadMemory(Address) \
    Xil_In32(Address)

/************************** Function Prototypes ****************************/
/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the AXI4_SLAVESinstance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus AXI4_SLAVES_Mem_SelfTest(void * baseaddr_p);

/**
 *
 * Write a value to a AXI4_SLAVES register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the AXI4_SLAVESdevice.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void AXI4_SLAVES_mWriteReg(u32 BaseAddress, unsigned RegOffset, u32 Data)
 *
 */
#define AXI4_SLAVES_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

/**
 *
 * Read a value from a AXI4_SLAVES register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the AXI4_SLAVES device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	u32 AXI4_SLAVES_mReadReg(u32 BaseAddress, unsigned RegOffset)
 *
 */
#define AXI4_SLAVES_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))

/************************** Function Prototypes ****************************/
/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the AXI4_SLAVES instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus AXI4_SLAVES_Reg_SelfTest(void * baseaddr_p);

#endif // AXI4_SLAVES_H
