library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI4_Stream_v1_0 is
	generic (
		C_AXIL_DATA_WIDTH	: integer	:= 32;
		C_AXIL_ADDR_WIDTH	: integer	:= 4;
		C_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_AXIS_START_COUNT	: integer	:= 32
	);
	port (
		aclk	: in std_logic;
        aresetn    : in std_logic;
		-- Ports of Axi Slave Bus Interface AXIL
		axil_awaddr	: in std_logic_vector(C_AXIL_ADDR_WIDTH-1 downto 0);
		axil_awprot	: in std_logic_vector(2 downto 0);
		axil_awvalid	: in std_logic;
		axil_awready	: out std_logic;
		axil_wdata	: in std_logic_vector(C_AXIL_DATA_WIDTH-1 downto 0);
		axil_wstrb	: in std_logic_vector((C_AXIL_DATA_WIDTH/8)-1 downto 0);
		axil_wvalid	: in std_logic;
		axil_wready	: out std_logic;
		axil_bresp	: out std_logic_vector(1 downto 0);
		axil_bvalid	: out std_logic;
		axil_bready	: in std_logic;
		axil_araddr	: in std_logic_vector(C_AXIL_ADDR_WIDTH-1 downto 0);
		axil_arprot	: in std_logic_vector(2 downto 0);
		axil_arvalid	: in std_logic;
		axil_arready	: out std_logic;
		axil_rdata	: out std_logic_vector(C_AXIL_DATA_WIDTH-1 downto 0);
		axil_rresp	: out std_logic_vector(1 downto 0);
		axil_rvalid	: out std_logic;
		axil_rready	: in std_logic;
		-- Ports of Axi Master Bus Interface AXIS
		axis_tvalid	: out std_logic;
		axis_tdata	: out std_logic_vector(C_AXIS_TDATA_WIDTH-1 downto 0);
		axis_tstrb	: out std_logic_vector((C_AXIS_TDATA_WIDTH/8)-1 downto 0);
		axis_tlast	: out std_logic;
		axis_tready	: in std_logic
	);
end AXI4_Stream_v1_0;

architecture arch_imp of AXI4_Stream_v1_0 is

   signal enable  : std_logic;
   signal length  : std_logic_vector(31 downto 0);
   signal counter : unsigned(31 downto 0);

begin

   counter_proc : process(aclk)
   begin
      if (rising_edge (aclk)) then
         if (aresetn = '0') then
            counter <= (others => '0');
         else
            if enable = '1' then
               counter <= counter + 1;
            else
               counter <= (others => '0');
            end if;
         end if;
      end if;
   end process counter_proc;

	AXI4_Stream_v1_0_AXIL_inst : entity work.AXI4_Stream_v1_0_AXIL
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_AXIL_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_AXIL_ADDR_WIDTH
	)
	port map (
		enable_o             => enable,
		length_o             => length,
		--
		S_AXI_ACLK	=> aclk,
		S_AXI_ARESETN	=> aresetn,
		S_AXI_AWADDR	=> axil_awaddr,
		S_AXI_AWPROT	=> axil_awprot,
		S_AXI_AWVALID	=> axil_awvalid,
		S_AXI_AWREADY	=> axil_awready,
		S_AXI_WDATA	=> axil_wdata,
		S_AXI_WSTRB	=> axil_wstrb,
		S_AXI_WVALID	=> axil_wvalid,
		S_AXI_WREADY	=> axil_wready,
		S_AXI_BRESP	=> axil_bresp,
		S_AXI_BVALID	=> axil_bvalid,
		S_AXI_BREADY	=> axil_bready,
		S_AXI_ARADDR	=> axil_araddr,
		S_AXI_ARPROT	=> axil_arprot,
		S_AXI_ARVALID	=> axil_arvalid,
		S_AXI_ARREADY	=> axil_arready,
		S_AXI_RDATA	=> axil_rdata,
		S_AXI_RRESP	=> axil_rresp,
		S_AXI_RVALID	=> axil_rvalid,
		S_AXI_RREADY	=> axil_rready
	);

    AXI4_Stream_v1_0_AXIS_inst : entity work.AXI4_Stream_v1_0_AXIS
	generic map (
		C_M_AXIS_TDATA_WIDTH	=> C_AXIS_TDATA_WIDTH
	)
	port map (
		enable_i        => enable,
		length_i        => length,
		counter_i       => std_logic_vector(counter),
		M_AXIS_ACLK	=> aclk,
		M_AXIS_ARESETN	=> aresetn,
		M_AXIS_TVALID	=> axis_tvalid,
		M_AXIS_TDATA	=> axis_tdata,
		M_AXIS_TSTRB	=> axis_tstrb,
		M_AXIS_TLAST	=> axis_tlast,
		M_AXIS_TREADY	=> axis_tready
	);

end arch_imp;
