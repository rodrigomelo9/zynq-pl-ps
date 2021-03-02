library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI3_BurstSniffer_v1_0 is
   generic (
      -- Parameters of Axi Slave Bus Interface S_AXIL
      C_S_AXIL_DATA_WIDTH : integer := 32;
      C_S_AXIL_ADDR_WIDTH : integer := 10;
      -- Parameters of Axi Slave Bus Interface SLOT_0
      C_SLOT_0_ID_WIDTH   : integer := 1;
      C_SLOT_0_DATA_WIDTH : integer := 32;
      C_SLOT_0_ADDR_WIDTH : integer := 6;
      -- Parameters of Axi Slave Bus Interface SLOT_1
      C_SLOT_1_ID_WIDTH   : integer := 1;
      C_SLOT_1_DATA_WIDTH : integer := 32;
      C_SLOT_1_ADDR_WIDTH : integer := 6;
      -- Parameters of Axi Slave Bus Interface SLOT_2
      C_SLOT_2_ID_WIDTH   : integer := 1;
      C_SLOT_2_DATA_WIDTH : integer := 32;
      C_SLOT_2_ADDR_WIDTH : integer := 6;
      -- Parameters of Axi Slave Bus Interface SLOT_3
      C_SLOT_3_ID_WIDTH   : integer := 1;
      C_SLOT_3_DATA_WIDTH : integer := 32;
      C_SLOT_3_ADDR_WIDTH : integer := 6
   );
   port (
      aclk           : in std_logic;
      aresetn        : in std_logic;
      -- Ports of Axi Slave Bus Interface S_AXIL
      s_axil_awaddr  : in std_logic_vector(C_S_AXIL_ADDR_WIDTH-1 downto 0);
      s_axil_awprot  : in std_logic_vector(2 downto 0);
      s_axil_awvalid : in std_logic;
      s_axil_awready : out std_logic;
      s_axil_wdata   : in std_logic_vector(C_S_AXIL_DATA_WIDTH-1 downto 0);
      s_axil_wstrb   : in std_logic_vector((C_S_AXIL_DATA_WIDTH/8)-1 downto 0);
      s_axil_wvalid  : in std_logic;
      s_axil_wready  : out std_logic;
      s_axil_bresp   : out std_logic_vector(1 downto 0);
      s_axil_bvalid  : out std_logic;
      s_axil_bready  : in std_logic;
      s_axil_araddr  : in std_logic_vector(C_S_AXIL_ADDR_WIDTH-1 downto 0);
      s_axil_arprot  : in std_logic_vector(2 downto 0);
      s_axil_arvalid : in std_logic;
      s_axil_arready : out std_logic;
      s_axil_rdata   : out std_logic_vector(C_S_AXIL_DATA_WIDTH-1 downto 0);
      s_axil_rresp   : out std_logic_vector(1 downto 0);
      s_axil_rvalid  : out std_logic;
      s_axil_rready  : in std_logic;
      -- Ports of Axi Slave Bus Interface SLOT_0
      slot_0_awid    : in std_logic_vector(C_SLOT_0_ID_WIDTH-1 downto 0);
      slot_0_awaddr  : in std_logic_vector(C_SLOT_0_ADDR_WIDTH-1 downto 0);
      slot_0_awprot  : in std_logic_vector(2 downto 0);
      slot_0_awlen   : in std_logic_vector(3 downto 0);
      slot_0_awsize  : in std_logic_vector(2 downto 0);
      slot_0_awburst : in std_logic_vector(1 downto 0);
      slot_0_awcache : in std_logic_vector(3 downto 0);
      slot_0_awlock  : in std_logic_vector(1 downto 0);
      slot_0_awvalid : in std_logic;
      slot_0_awready : in std_logic;
      slot_0_wdata   : in std_logic_vector(C_SLOT_0_DATA_WIDTH-1 downto 0);
      slot_0_wstrb   : in std_logic_vector((C_SLOT_0_DATA_WIDTH/8)-1 downto 0);
      slot_0_wlast   : in std_logic;
      slot_0_wvalid  : in std_logic;
      slot_0_wready  : in std_logic;
      slot_0_bid     : in std_logic_vector(C_SLOT_0_ID_WIDTH-1 downto 0);
      slot_0_bresp   : in std_logic_vector(1 downto 0);
      slot_0_bvalid  : in std_logic;
      slot_0_bready  : in std_logic;
      slot_0_arid    : in std_logic_vector(C_SLOT_0_ID_WIDTH-1 downto 0);
      slot_0_araddr  : in std_logic_vector(C_SLOT_0_ADDR_WIDTH-1 downto 0);
      slot_0_arlen   : in std_logic_vector(3 downto 0);
      slot_0_arsize  : in std_logic_vector(2 downto 0);
      slot_0_arburst : in std_logic_vector(1 downto 0);
      slot_0_arcache : in std_logic_vector(3 downto 0);
      slot_0_arprot  : in std_logic_vector(2 downto 0);
      slot_0_arlock  : in std_logic_vector(1 downto 0);
      slot_0_arvalid : in std_logic;
      slot_0_arready : in std_logic;
      slot_0_rid     : in std_logic_vector(C_SLOT_0_ID_WIDTH-1 downto 0);
      slot_0_rdata   : in std_logic_vector(C_SLOT_0_DATA_WIDTH-1 downto 0);
      slot_0_rresp   : in std_logic_vector(1 downto 0);
      slot_0_rlast   : in std_logic;
      slot_0_rvalid  : in std_logic;
      slot_0_rready  : in std_logic;
      -- Ports of Axi Slave Bus Interface SLOT_1
      slot_1_awid    : in std_logic_vector(C_SLOT_1_ID_WIDTH-1 downto 0);
      slot_1_awaddr  : in std_logic_vector(C_SLOT_1_ADDR_WIDTH-1 downto 0);
      slot_1_awprot  : in std_logic_vector(2 downto 0);
      slot_1_awlen   : in std_logic_vector(3 downto 0);
      slot_1_awsize  : in std_logic_vector(2 downto 0);
      slot_1_awburst : in std_logic_vector(1 downto 0);
      slot_1_awcache : in std_logic_vector(3 downto 0);
      slot_1_awlock  : in std_logic_vector(1 downto 0);
      slot_1_awvalid : in std_logic;
      slot_1_awready : in std_logic;
      slot_1_wdata   : in std_logic_vector(C_SLOT_1_DATA_WIDTH-1 downto 0);
      slot_1_wstrb   : in std_logic_vector((C_SLOT_1_DATA_WIDTH/8)-1 downto 0);
      slot_1_wlast   : in std_logic;
      slot_1_wvalid  : in std_logic;
      slot_1_wready  : in std_logic;
      slot_1_bid     : in std_logic_vector(C_SLOT_1_ID_WIDTH-1 downto 0);
      slot_1_bresp   : in std_logic_vector(1 downto 0);
      slot_1_bvalid  : in std_logic;
      slot_1_bready  : in std_logic;
      slot_1_arid    : in std_logic_vector(C_SLOT_1_ID_WIDTH-1 downto 0);
      slot_1_araddr  : in std_logic_vector(C_SLOT_1_ADDR_WIDTH-1 downto 0);
      slot_1_arlen   : in std_logic_vector(3 downto 0);
      slot_1_arsize  : in std_logic_vector(2 downto 0);
      slot_1_arburst : in std_logic_vector(1 downto 0);
      slot_1_arcache : in std_logic_vector(3 downto 0);
      slot_1_arprot  : in std_logic_vector(2 downto 0);
      slot_1_arlock  : in std_logic_vector(1 downto 0);
      slot_1_arvalid : in std_logic;
      slot_1_arready : in std_logic;
      slot_1_rid     : in std_logic_vector(C_SLOT_1_ID_WIDTH-1 downto 0);
      slot_1_rdata   : in std_logic_vector(C_SLOT_1_DATA_WIDTH-1 downto 0);
      slot_1_rresp   : in std_logic_vector(1 downto 0);
      slot_1_rlast   : in std_logic;
      slot_1_rvalid  : in std_logic;
      slot_1_rready  : in std_logic;
      -- Ports of Axi Slave Bus Interface SLOT_2
      slot_2_awid    : in std_logic_vector(C_SLOT_2_ID_WIDTH-1 downto 0);
      slot_2_awaddr  : in std_logic_vector(C_SLOT_2_ADDR_WIDTH-1 downto 0);
      slot_2_awprot  : in std_logic_vector(2 downto 0);
      slot_2_awlen   : in std_logic_vector(3 downto 0);
      slot_2_awsize  : in std_logic_vector(2 downto 0);
      slot_2_awburst : in std_logic_vector(1 downto 0);
      slot_2_awcache : in std_logic_vector(3 downto 0);
      slot_2_awlock  : in std_logic_vector(1 downto 0);
      slot_2_awvalid : in std_logic;
      slot_2_awready : in std_logic;
      slot_2_wdata   : in std_logic_vector(C_SLOT_2_DATA_WIDTH-1 downto 0);
      slot_2_wstrb   : in std_logic_vector((C_SLOT_2_DATA_WIDTH/8)-1 downto 0);
      slot_2_wlast   : in std_logic;
      slot_2_wvalid  : in std_logic;
      slot_2_wready  : in std_logic;
      slot_2_bid     : in std_logic_vector(C_SLOT_2_ID_WIDTH-1 downto 0);
      slot_2_bresp   : in std_logic_vector(1 downto 0);
      slot_2_bvalid  : in std_logic;
      slot_2_bready  : in std_logic;
      slot_2_arid    : in std_logic_vector(C_SLOT_2_ID_WIDTH-1 downto 0);
      slot_2_araddr  : in std_logic_vector(C_SLOT_2_ADDR_WIDTH-1 downto 0);
      slot_2_arlen   : in std_logic_vector(3 downto 0);
      slot_2_arsize  : in std_logic_vector(2 downto 0);
      slot_2_arburst : in std_logic_vector(1 downto 0);
      slot_2_arcache : in std_logic_vector(3 downto 0);
      slot_2_arprot  : in std_logic_vector(2 downto 0);
      slot_2_arlock  : in std_logic_vector(1 downto 0);
      slot_2_arvalid : in std_logic;
      slot_2_arready : in std_logic;
      slot_2_rid     : in std_logic_vector(C_SLOT_2_ID_WIDTH-1 downto 0);
      slot_2_rdata   : in std_logic_vector(C_SLOT_2_DATA_WIDTH-1 downto 0);
      slot_2_rresp   : in std_logic_vector(1 downto 0);
      slot_2_rlast   : in std_logic;
      slot_2_rvalid  : in std_logic;
      slot_2_rready  : in std_logic;
      -- Ports of Axi Slave Bus Interface SLOT_3
      slot_3_awid    : in std_logic_vector(C_SLOT_3_ID_WIDTH-1 downto 0);
      slot_3_awaddr  : in std_logic_vector(C_SLOT_3_ADDR_WIDTH-1 downto 0);
      slot_3_awprot  : in std_logic_vector(2 downto 0);
      slot_3_awlen   : in std_logic_vector(3 downto 0);
      slot_3_awsize  : in std_logic_vector(2 downto 0);
      slot_3_awburst : in std_logic_vector(1 downto 0);
      slot_3_awcache : in std_logic_vector(3 downto 0);
      slot_3_awlock  : in std_logic_vector(1 downto 0);
      slot_3_awvalid : in std_logic;
      slot_3_awready : in std_logic;
      slot_3_wdata   : in std_logic_vector(C_SLOT_3_DATA_WIDTH-1 downto 0);
      slot_3_wstrb   : in std_logic_vector((C_SLOT_3_DATA_WIDTH/8)-1 downto 0);
      slot_3_wlast   : in std_logic;
      slot_3_wvalid  : in std_logic;
      slot_3_wready  : in std_logic;
      slot_3_bid     : in std_logic_vector(C_SLOT_3_ID_WIDTH-1 downto 0);
      slot_3_bresp   : in std_logic_vector(1 downto 0);
      slot_3_bvalid  : in std_logic;
      slot_3_bready  : in std_logic;
      slot_3_arid    : in std_logic_vector(C_SLOT_3_ID_WIDTH-1 downto 0);
      slot_3_araddr  : in std_logic_vector(C_SLOT_3_ADDR_WIDTH-1 downto 0);
      slot_3_arlen   : in std_logic_vector(3 downto 0);
      slot_3_arsize  : in std_logic_vector(2 downto 0);
      slot_3_arburst : in std_logic_vector(1 downto 0);
      slot_3_arcache : in std_logic_vector(3 downto 0);
      slot_3_arprot  : in std_logic_vector(2 downto 0);
      slot_3_arlock  : in std_logic_vector(1 downto 0);
      slot_3_arvalid : in std_logic;
      slot_3_arready : in std_logic;
      slot_3_rid     : in std_logic_vector(C_SLOT_3_ID_WIDTH-1 downto 0);
      slot_3_rdata   : in std_logic_vector(C_SLOT_3_DATA_WIDTH-1 downto 0);
      slot_3_rresp   : in std_logic_vector(1 downto 0);
      slot_3_rlast   : in std_logic;
      slot_3_rvalid  : in std_logic;
      slot_3_rready  : in std_logic
   );
end AXI3_BurstSniffer_v1_0;

architecture Structural of AXI3_BurstSniffer_v1_0 is

   signal prepare      : std_logic;
   signal slot         : std_logic_vector(1 downto 0);
   --
   signal addr         : std_logic_vector(7 downto 0);
   signal data         : std_logic_vector(31 downto 0);
   signal data0, data1 : std_logic_vector(31 downto 0);
   signal data2, data3 : std_logic_vector(31 downto 0);

begin

   data <= data0 when slot = "00" else data1 when slot = "01" else data2 when slot = "10" else data3;

   AXI3_BurstSniffer_v1_0_S_AXIL_inst : entity work.AXI3_BurstSniffer_v1_0_S_AXIL
   generic map (
      C_S_AXI_DATA_WIDTH => C_S_AXIL_DATA_WIDTH,
      C_S_AXI_ADDR_WIDTH => C_S_AXIL_ADDR_WIDTH
   )
   port map (
      prepare_o     => prepare,
      slot_o        => slot,
      --
      addr_o        => addr,
      data_i        => data,
      --
      S_AXI_ACLK    => aclk,
      S_AXI_ARESETN => aresetn,
      S_AXI_AWADDR  => s_axil_awaddr,
      S_AXI_AWPROT  => s_axil_awprot,
      S_AXI_AWVALID => s_axil_awvalid,
      S_AXI_AWREADY => s_axil_awready,
      S_AXI_WDATA   => s_axil_wdata,
      S_AXI_WSTRB   => s_axil_wstrb,
      S_AXI_WVALID  => s_axil_wvalid,
      S_AXI_WREADY  => s_axil_wready,
      S_AXI_BRESP   => s_axil_bresp,
      S_AXI_BVALID  => s_axil_bvalid,
      S_AXI_BREADY  => s_axil_bready,
      S_AXI_ARADDR  => s_axil_araddr,
      S_AXI_ARPROT  => s_axil_arprot,
      S_AXI_ARVALID => s_axil_arvalid,
      S_AXI_ARREADY => s_axil_arready,
      S_AXI_RDATA   => s_axil_rdata,
      S_AXI_RRESP   => s_axil_rresp,
      S_AXI_RVALID  => s_axil_rvalid,
      S_AXI_RREADY  => s_axil_rready
   );

   slot0_inst : entity work.SimpleAxiSniffer
   generic map (
      ENA_WRITE => FALSE,
      ENA_READ  => TRUE
   )
   port map (
      aclk_i    => aclk,
      aresetn_i => aresetn,
      prepare_i => prepare,
      -- Write
      awvalid_i => slot_0_awvalid,
      awready_i => slot_0_awready,
      wvalid_i  => slot_0_wvalid,
      wready_i  => slot_0_wready,
      wlast_i   => slot_0_wlast,
      bvalid_i  => slot_0_bvalid,
      bready_i  => slot_0_bready,
      awprot_i  => slot_0_awprot,
      awlen_i   => slot_0_awlen,
      awsize_i  => slot_0_awsize,
      awburst_i => slot_0_awburst,
      awcache_i => slot_0_awcache,
      awlock_i  => slot_0_awlock,
      -- Read
      arvalid_i => slot_0_arvalid,
      arready_i => slot_0_arready,
      rvalid_i  => slot_0_rvalid,
      rready_i  => slot_0_rready,
      rlast_i   => slot_0_rlast,
      arlen_i   => slot_0_arlen,
      arsize_i  => slot_0_arsize,
      arburst_i => slot_0_arburst,
      arcache_i => slot_0_arcache,
      arprot_i  => slot_0_arprot,
      arlock_i  => slot_0_arlock,
      --
      addr_i    => addr,
      data_o    => data0
   );

   slot1_inst : entity work.SimpleAxiSniffer
   generic map (
      ENA_WRITE => TRUE,
      ENA_READ  => FALSE
   )
   port map (
      aclk_i    => aclk,
      aresetn_i => aresetn,
      prepare_i => prepare,
      -- Write
      awvalid_i => slot_1_awvalid,
      awready_i => slot_1_awready,
      wvalid_i  => slot_1_wvalid,
      wready_i  => slot_1_wready,
      wlast_i   => slot_1_wlast,
      bvalid_i  => slot_1_bvalid,
      bready_i  => slot_1_bready,
      awprot_i  => slot_1_awprot,
      awlen_i   => slot_1_awlen,
      awsize_i  => slot_1_awsize,
      awburst_i => slot_1_awburst,
      awcache_i => slot_1_awcache,
      awlock_i  => slot_1_awlock,
      -- Read
      arvalid_i => slot_1_arvalid,
      arready_i => slot_1_arready,
      rvalid_i  => slot_1_rvalid,
      rready_i  => slot_1_rready,
      rlast_i   => slot_1_rlast,
      arlen_i   => slot_1_arlen,
      arsize_i  => slot_1_arsize,
      arburst_i => slot_1_arburst,
      arcache_i => slot_1_arcache,
      arprot_i  => slot_1_arprot,
      arlock_i  => slot_1_arlock,
      --
      addr_i    => addr,
      data_o    => data1
   );

   slot2_inst : entity work.SimpleAxiSniffer
   generic map (
      ENA_WRITE => TRUE,
      ENA_READ  => FALSE
   )
   port map (
      aclk_i    => aclk,
      aresetn_i => aresetn,
      prepare_i => prepare,
      -- Write
      awvalid_i => slot_2_awvalid,
      awready_i => slot_2_awready,
      wvalid_i  => slot_2_wvalid,
      wready_i  => slot_2_wready,
      wlast_i   => slot_2_wlast,
      bvalid_i  => slot_2_bvalid,
      bready_i  => slot_2_bready,
      awprot_i  => slot_2_awprot,
      awlen_i   => slot_2_awlen,
      awsize_i  => slot_2_awsize,
      awburst_i => slot_2_awburst,
      awcache_i => slot_2_awcache,
      awlock_i  => slot_2_awlock,
      -- Read
      arvalid_i => slot_2_arvalid,
      arready_i => slot_2_arready,
      rvalid_i  => slot_2_rvalid,
      rready_i  => slot_2_rready,
      rlast_i   => slot_2_rlast,
      arlen_i   => slot_2_arlen,
      arsize_i  => slot_2_arsize,
      arburst_i => slot_2_arburst,
      arcache_i => slot_2_arcache,
      arprot_i  => slot_2_arprot,
      arlock_i  => slot_2_arlock,
      --
      addr_i    => addr,
      data_o    => data2
   );

   slot3_inst : entity work.SimpleAxiSniffer
   generic map (
      ENA_WRITE => TRUE,
      ENA_READ  => FALSE
   )
   port map (
      aclk_i    => aclk,
      aresetn_i => aresetn,
      prepare_i => prepare,
      -- Write
      awvalid_i => slot_3_awvalid,
      awready_i => slot_3_awready,
      wvalid_i  => slot_3_wvalid,
      wready_i  => slot_3_wready,
      wlast_i   => slot_3_wlast,
      bvalid_i  => slot_3_bvalid,
      bready_i  => slot_3_bready,
      awprot_i  => slot_3_awprot,
      awlen_i   => slot_3_awlen,
      awsize_i  => slot_3_awsize,
      awburst_i => slot_3_awburst,
      awcache_i => slot_3_awcache,
      awlock_i  => slot_3_awlock,
      -- Read
      arvalid_i => slot_3_arvalid,
      arready_i => slot_3_arready,
      rvalid_i  => slot_3_rvalid,
      rready_i  => slot_3_rready,
      rlast_i   => slot_3_rlast,
      arlen_i   => slot_3_arlen,
      arsize_i  => slot_3_arsize,
      arburst_i => slot_3_arburst,
      arcache_i => slot_3_arcache,
      arprot_i  => slot_3_arprot,
      arlock_i  => slot_3_arlock,
      --
      addr_i    => addr,
      data_o    => data3
   );

end architecture Structural;