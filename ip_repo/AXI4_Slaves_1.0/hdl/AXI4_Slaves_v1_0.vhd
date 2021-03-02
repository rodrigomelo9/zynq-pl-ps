library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI4_Slaves_v1_0 is
	generic (
		C_DATA_WIDTH		: integer	:= 32;
		C_ADDR_WIDTH		: integer	:= 10;
		-- Parameters of Axi Slave Bus Interface S_AXIF
		C_S_AXIF_ID_WIDTH	: integer	:= 1;
		C_S_AXIF_AWUSER_WIDTH	: integer	:= 0;
		C_S_AXIF_ARUSER_WIDTH	: integer	:= 0;
		C_S_AXIF_WUSER_WIDTH	: integer	:= 0;
		C_S_AXIF_RUSER_WIDTH	: integer	:= 0;
		C_S_AXIF_BUSER_WIDTH	: integer	:= 0
	);
	port (
		aclk		: in std_logic;
		aresetn		: in std_logic;
		-- Ports of Axi Slave Bus Interface S_AXIL
		s_axil_awaddr	: in std_logic_vector(C_ADDR_WIDTH-1 downto 0);
		s_axil_awprot	: in std_logic_vector(2 downto 0);
		s_axil_awvalid	: in std_logic;
		s_axil_awready	: out std_logic;
		s_axil_wdata	: in std_logic_vector(C_DATA_WIDTH-1 downto 0);
		s_axil_wstrb	: in std_logic_vector((C_DATA_WIDTH/8)-1 downto 0);
		s_axil_wvalid	: in std_logic;
		s_axil_wready	: out std_logic;
		s_axil_bresp	: out std_logic_vector(1 downto 0);
		s_axil_bvalid	: out std_logic;
		s_axil_bready	: in std_logic;
		s_axil_araddr	: in std_logic_vector(C_ADDR_WIDTH-1 downto 0);
		s_axil_arprot	: in std_logic_vector(2 downto 0);
		s_axil_arvalid	: in std_logic;
		s_axil_arready	: out std_logic;
		s_axil_rdata	: out std_logic_vector(C_DATA_WIDTH-1 downto 0);
		s_axil_rresp	: out std_logic_vector(1 downto 0);
		s_axil_rvalid	: out std_logic;
		s_axil_rready	: in std_logic;
		-- Ports of Axi Slave Bus Interface S_AXIF
		s_axif_awid	: in std_logic_vector(C_S_AXIF_ID_WIDTH-1 downto 0);
		s_axif_awaddr	: in std_logic_vector(C_ADDR_WIDTH-1 downto 0);
		s_axif_awlen	: in std_logic_vector(7 downto 0);
		s_axif_awsize	: in std_logic_vector(2 downto 0);
		s_axif_awburst	: in std_logic_vector(1 downto 0);
		s_axif_awlock	: in std_logic;
		s_axif_awcache	: in std_logic_vector(3 downto 0);
		s_axif_awprot	: in std_logic_vector(2 downto 0);
		s_axif_awqos	: in std_logic_vector(3 downto 0);
		s_axif_awregion	: in std_logic_vector(3 downto 0);
		s_axif_awuser	: in std_logic_vector(C_S_AXIF_AWUSER_WIDTH-1 downto 0);
		s_axif_awvalid	: in std_logic;
		s_axif_awready	: out std_logic;
		s_axif_wdata	: in std_logic_vector(C_DATA_WIDTH-1 downto 0);
		s_axif_wstrb	: in std_logic_vector((C_DATA_WIDTH/8)-1 downto 0);
		s_axif_wlast	: in std_logic;
		s_axif_wuser	: in std_logic_vector(C_S_AXIF_WUSER_WIDTH-1 downto 0);
		s_axif_wvalid	: in std_logic;
		s_axif_wready	: out std_logic;
		s_axif_bid	: out std_logic_vector(C_S_AXIF_ID_WIDTH-1 downto 0);
		s_axif_bresp	: out std_logic_vector(1 downto 0);
		s_axif_buser	: out std_logic_vector(C_S_AXIF_BUSER_WIDTH-1 downto 0);
		s_axif_bvalid	: out std_logic;
		s_axif_bready	: in std_logic;
		s_axif_arid	: in std_logic_vector(C_S_AXIF_ID_WIDTH-1 downto 0);
		s_axif_araddr	: in std_logic_vector(C_ADDR_WIDTH-1 downto 0);
		s_axif_arlen	: in std_logic_vector(7 downto 0);
		s_axif_arsize	: in std_logic_vector(2 downto 0);
		s_axif_arburst	: in std_logic_vector(1 downto 0);
		s_axif_arlock	: in std_logic;
		s_axif_arcache	: in std_logic_vector(3 downto 0);
		s_axif_arprot	: in std_logic_vector(2 downto 0);
		s_axif_arqos	: in std_logic_vector(3 downto 0);
		s_axif_arregion	: in std_logic_vector(3 downto 0);
		s_axif_aruser	: in std_logic_vector(C_S_AXIF_ARUSER_WIDTH-1 downto 0);
		s_axif_arvalid	: in std_logic;
		s_axif_arready	: out std_logic;
		s_axif_rid	: out std_logic_vector(C_S_AXIF_ID_WIDTH-1 downto 0);
		s_axif_rdata	: out std_logic_vector(C_DATA_WIDTH-1 downto 0);
		s_axif_rresp	: out std_logic_vector(1 downto 0);
		s_axif_rlast	: out std_logic;
		s_axif_ruser	: out std_logic_vector(C_S_AXIF_RUSER_WIDTH-1 downto 0);
		s_axif_rvalid	: out std_logic;
		s_axif_rready	: in std_logic;
		--
		gpio_o		: out std_logic_vector(C_DATA_WIDTH-1 downto 0)
	);
end AXI4_Slaves_v1_0;

architecture arch_imp of AXI4_Slaves_v1_0 is

	signal enable	: std_logic;
	signal counter	: unsigned(C_DATA_WIDTH-1 downto 0);

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

	gpio_o <= std_logic_vector(counter);

	AXI4_Slaves_v1_0_S_AXIL_inst : entity work.AXI4_Slaves_v1_0_S_AXIL
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_ADDR_WIDTH
	)
	port map (
		enable_o	=> enable,
		counter_i	=> std_logic_vector(counter),
		--
		S_AXI_ACLK	=> aclk,
		S_AXI_ARESETN	=> aresetn,
		S_AXI_AWADDR	=> s_axil_awaddr,
		S_AXI_AWPROT	=> s_axil_awprot,
		S_AXI_AWVALID	=> s_axil_awvalid,
		S_AXI_AWREADY	=> s_axil_awready,
		S_AXI_WDATA	=> s_axil_wdata,
		S_AXI_WSTRB	=> s_axil_wstrb,
		S_AXI_WVALID	=> s_axil_wvalid,
		S_AXI_WREADY	=> s_axil_wready,
		S_AXI_BRESP	=> s_axil_bresp,
		S_AXI_BVALID	=> s_axil_bvalid,
		S_AXI_BREADY	=> s_axil_bready,
		S_AXI_ARADDR	=> s_axil_araddr,
		S_AXI_ARPROT	=> s_axil_arprot,
		S_AXI_ARVALID	=> s_axil_arvalid,
		S_AXI_ARREADY	=> s_axil_arready,
		S_AXI_RDATA	=> s_axil_rdata,
		S_AXI_RRESP	=> s_axil_rresp,
		S_AXI_RVALID	=> s_axil_rvalid,
		S_AXI_RREADY	=> s_axil_rready
	);

	AXI4_Slaves_v1_0_S_AXIF_inst : entity work.AXI4_Slaves_v1_0_S_AXIF
	generic map (
		C_S_AXI_ID_WIDTH	=> C_S_AXIF_ID_WIDTH,
		C_S_AXI_DATA_WIDTH	=> C_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_ADDR_WIDTH,
		C_S_AXI_AWUSER_WIDTH	=> C_S_AXIF_AWUSER_WIDTH,
		C_S_AXI_ARUSER_WIDTH	=> C_S_AXIF_ARUSER_WIDTH,
		C_S_AXI_WUSER_WIDTH	=> C_S_AXIF_WUSER_WIDTH,
		C_S_AXI_RUSER_WIDTH	=> C_S_AXIF_RUSER_WIDTH,
		C_S_AXI_BUSER_WIDTH	=> C_S_AXIF_BUSER_WIDTH
	)
	port map (
		counter_i	=> std_logic_vector(counter),
		--
		S_AXI_ACLK	=> aclk,
		S_AXI_ARESETN	=> aresetn,
		S_AXI_AWID	=> s_axif_awid,
		S_AXI_AWADDR	=> s_axif_awaddr,
		S_AXI_AWLEN	=> s_axif_awlen,
		S_AXI_AWSIZE	=> s_axif_awsize,
		S_AXI_AWBURST	=> s_axif_awburst,
		S_AXI_AWLOCK	=> s_axif_awlock,
		S_AXI_AWCACHE	=> s_axif_awcache,
		S_AXI_AWPROT	=> s_axif_awprot,
		S_AXI_AWQOS	=> s_axif_awqos,
		S_AXI_AWREGION	=> s_axif_awregion,
		S_AXI_AWUSER	=> s_axif_awuser,
		S_AXI_AWVALID	=> s_axif_awvalid,
		S_AXI_AWREADY	=> s_axif_awready,
		S_AXI_WDATA	=> s_axif_wdata,
		S_AXI_WSTRB	=> s_axif_wstrb,
		S_AXI_WLAST	=> s_axif_wlast,
		S_AXI_WUSER	=> s_axif_wuser,
		S_AXI_WVALID	=> s_axif_wvalid,
		S_AXI_WREADY	=> s_axif_wready,
		S_AXI_BID	=> s_axif_bid,
		S_AXI_BRESP	=> s_axif_bresp,
		S_AXI_BUSER	=> s_axif_buser,
		S_AXI_BVALID	=> s_axif_bvalid,
		S_AXI_BREADY	=> s_axif_bready,
		S_AXI_ARID	=> s_axif_arid,
		S_AXI_ARADDR	=> s_axif_araddr,
		S_AXI_ARLEN	=> s_axif_arlen,
		S_AXI_ARSIZE	=> s_axif_arsize,
		S_AXI_ARBURST	=> s_axif_arburst,
		S_AXI_ARLOCK	=> s_axif_arlock,
		S_AXI_ARCACHE	=> s_axif_arcache,
		S_AXI_ARPROT	=> s_axif_arprot,
		S_AXI_ARQOS	=> s_axif_arqos,
		S_AXI_ARREGION	=> s_axif_arregion,
		S_AXI_ARUSER	=> s_axif_aruser,
		S_AXI_ARVALID	=> s_axif_arvalid,
		S_AXI_ARREADY	=> s_axif_arready,
		S_AXI_RID	=> s_axif_rid,
		S_AXI_RDATA	=> s_axif_rdata,
		S_AXI_RRESP	=> s_axif_rresp,
		S_AXI_RLAST	=> s_axif_rlast,
		S_AXI_RUSER	=> s_axif_ruser,
		S_AXI_RVALID	=> s_axif_rvalid,
		S_AXI_RREADY	=> s_axif_rready
	);

end arch_imp;
