library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI4_Masters_v1_0_M_AXIF is
   generic (
      C_NO_WRITE_RESPONSE  : boolean   := FALSE;
      C_AxCACHE            : std_logic_vector(3 downto 0) := "0010";
      C_M_AXI_ID_WIDTH     : integer   := 1;
      C_M_AXI_ADDR_WIDTH   : integer   := 32;
      C_M_AXI_DATA_WIDTH   : integer   := 32;
      C_M_AXI_AWUSER_WIDTH : integer   := 0;
      C_M_AXI_ARUSER_WIDTH : integer   := 0;
      C_M_AXI_WUSER_WIDTH  : integer   := 0;
      C_M_AXI_RUSER_WIDTH  : integer   := 0;
      C_M_AXI_BUSER_WIDTH  : integer   := 0
   );
   port (
      enable_i      :  in std_logic;
      length_i      :  in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
      counter_i     :  in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
      address_i     :  in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
      busy_o        : out std_logic;
      --
      M_AXI_ACLK    : in std_logic;
      M_AXI_ARESETN : in std_logic;
      M_AXI_AWID    : out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
      M_AXI_AWADDR  : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
      M_AXI_AWLEN   : out std_logic_vector(7 downto 0);
      M_AXI_AWSIZE  : out std_logic_vector(2 downto 0);
      M_AXI_AWBURST : out std_logic_vector(1 downto 0);
      M_AXI_AWLOCK  : out std_logic;
      M_AXI_AWCACHE : out std_logic_vector(3 downto 0);
      M_AXI_AWPROT  : out std_logic_vector(2 downto 0);
      M_AXI_AWQOS   : out std_logic_vector(3 downto 0);
      M_AXI_AWUSER  : out std_logic_vector(C_M_AXI_AWUSER_WIDTH-1 downto 0);
      M_AXI_AWVALID : out std_logic;
      M_AXI_AWREADY : in std_logic;
      M_AXI_WDATA   : out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
      M_AXI_WSTRB   : out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
      M_AXI_WLAST   : out std_logic;
      M_AXI_WUSER   : out std_logic_vector(C_M_AXI_WUSER_WIDTH-1 downto 0);
      M_AXI_WVALID  : out std_logic;
      M_AXI_WREADY  : in std_logic;
      M_AXI_BID     : in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
      M_AXI_BRESP   : in std_logic_vector(1 downto 0);
      M_AXI_BUSER   : in std_logic_vector(C_M_AXI_BUSER_WIDTH-1 downto 0);
      M_AXI_BVALID  : in std_logic;
      M_AXI_BREADY  : out std_logic;
      M_AXI_ARID    : out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
      M_AXI_ARADDR  : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
      M_AXI_ARLEN   : out std_logic_vector(7 downto 0);
      M_AXI_ARSIZE  : out std_logic_vector(2 downto 0);
      M_AXI_ARBURST : out std_logic_vector(1 downto 0);
      M_AXI_ARLOCK  : out std_logic;
      M_AXI_ARCACHE : out std_logic_vector(3 downto 0);
      M_AXI_ARPROT  : out std_logic_vector(2 downto 0);
      M_AXI_ARQOS   : out std_logic_vector(3 downto 0);
      M_AXI_ARUSER  : out std_logic_vector(C_M_AXI_ARUSER_WIDTH-1 downto 0);
      M_AXI_ARVALID : out std_logic;
      M_AXI_ARREADY : in std_logic;
      M_AXI_RID     : in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
      M_AXI_RDATA   : in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
      M_AXI_RRESP   : in std_logic_vector(1 downto 0);
      M_AXI_RLAST   : in std_logic;
      M_AXI_RUSER   : in std_logic_vector(C_M_AXI_RUSER_WIDTH-1 downto 0);
      M_AXI_RVALID  : in std_logic;
      M_AXI_RREADY  : out std_logic
   );
end AXI4_Masters_v1_0_M_AXIF;

architecture implementation of AXI4_Masters_v1_0_M_AXIF is

   constant C_M_AXI_BURST_LEN : natural := 16;
   constant C_BURST_BYTES     : natural := C_M_AXI_BURST_LEN * C_M_AXI_DATA_WIDTH/8;

   type state_t is ( IDLE, INIT_WRITE, INIT_READ);
   signal state : state_t;

   signal axi_awaddr  : std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
   signal axi_awvalid : std_logic;
   signal axi_wlast   : std_logic;
   signal axi_wvalid  : std_logic;
   signal axi_bready  : std_logic;
   signal axi_araddr  : std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
   signal axi_arvalid : std_logic;
   signal axi_rready  : std_logic;

   signal wr_cnt, rd_cnt                   : unsigned(3 downto 0);
   signal wr_burst_cnt, rd_burst_cnt       : unsigned(31 downto 0);
   signal wr_burst_start, rd_burst_start   : std_logic;
   signal wr_done, rd_done                 : std_logic;
   signal wr_burst_active, rd_burst_active : std_logic;
   signal wr_next, rd_next                 : std_logic;

   signal burst_length                     : unsigned(31 downto 0);

begin

   burst_length <= unsigned(length_i) / C_M_AXI_BURST_LEN;

   M_AXI_AWID    <= (others => '0');
   M_AXI_AWADDR  <= std_logic_vector(unsigned(address_i) + unsigned(axi_awaddr));
   M_AXI_AWLEN   <= std_logic_vector(to_unsigned(C_M_AXI_BURST_LEN-1,8));
   M_AXI_AWSIZE  <= std_logic_vector(to_unsigned(2,3));
   M_AXI_AWBURST <= "01";
   M_AXI_AWLOCK  <= '0';
   M_AXI_AWCACHE <= C_AxCACHE;
   M_AXI_AWPROT  <= "000";
   M_AXI_AWQOS   <= x"0";
   M_AXI_AWUSER  <= (others => '1');
   M_AXI_AWVALID <= axi_awvalid;
   M_AXI_WDATA   <= counter_i;
   M_AXI_WSTRB   <= (others => '1');
   M_AXI_WLAST   <= axi_wlast;
   M_AXI_WUSER   <= (others => '0');
   M_AXI_WVALID  <= axi_wvalid;
   M_AXI_BREADY  <= axi_bready;
   M_AXI_ARID    <= (others => '0');
   M_AXI_ARADDR  <= std_logic_vector(unsigned(address_i) + unsigned(axi_araddr));
   M_AXI_ARLEN   <= std_logic_vector(to_unsigned(C_M_AXI_BURST_LEN-1,8));
   M_AXI_ARSIZE  <= std_logic_vector(to_unsigned(2,3));
   M_AXI_ARBURST <= "01";
   M_AXI_ARLOCK  <= '0';
   M_AXI_ARCACHE <= C_AxCACHE;
   M_AXI_ARPROT  <= "000";
   M_AXI_ARQOS   <= x"0";
   M_AXI_ARUSER  <= (others => '1');
   M_AXI_ARVALID <= axi_arvalid;
   M_AXI_RREADY  <= axi_rready;

   process(M_AXI_ACLK)
   begin
     if rising_edge (M_AXI_ACLK) then
       if M_AXI_ARESETN = '0' or enable_i = '1' then
         axi_awvalid <= '0';
       else
         if axi_awvalid = '0' and wr_burst_start = '1' then
           axi_awvalid <= '1';
         elsif M_AXI_AWREADY = '1' and axi_awvalid = '1' then
           axi_awvalid <= '0';
         else
           axi_awvalid <= axi_awvalid;
         end if;
       end if;
     end if;
   end process;

   process(M_AXI_ACLK)
   begin
     if rising_edge (M_AXI_ACLK) then
       if M_AXI_ARESETN = '0' or enable_i = '1' then
         axi_awaddr <= (others => '0');
       else
         if M_AXI_AWREADY= '1' and axi_awvalid = '1' then
           axi_awaddr <= std_logic_vector(unsigned(axi_awaddr) + C_BURST_BYTES);
         end if;
       end if;
     end if;
   end process;

   wr_next <= M_AXI_WREADY and axi_wvalid;

   process(M_AXI_ACLK)
   begin
     if rising_edge (M_AXI_ACLK) then
       if M_AXI_ARESETN = '0' or enable_i = '1' then
         axi_wvalid <= '0';
       else
         if axi_wvalid = '0' and wr_burst_start = '1' then
           axi_wvalid <= '1';
         elsif wr_next = '1' and axi_wlast = '1' then
           axi_wvalid <= '0';
         else
           axi_wvalid <= axi_wvalid;
         end if;
       end if;
     end if;
   end process;

   process(M_AXI_ACLK)
   begin
     if rising_edge (M_AXI_ACLK) then
       if M_AXI_ARESETN = '0' or enable_i = '1' then
         axi_wlast <= '0';
       else
         if ((wr_cnt = C_M_AXI_BURST_LEN-2 and C_M_AXI_BURST_LEN >= 2) and wr_next = '1') or (C_M_AXI_BURST_LEN = 1) then
           axi_wlast <= '1';
         elsif wr_next = '1' then
           axi_wlast <= '0';
         elsif axi_wlast = '1' and C_M_AXI_BURST_LEN = 1 then
           axi_wlast <= '0';
         end if;
       end if;
     end if;
   end process;

   process(M_AXI_ACLK)
   begin
     if rising_edge (M_AXI_ACLK) then
       if M_AXI_ARESETN = '0' or wr_burst_start = '1' or enable_i = '1' then
         wr_cnt <= (others => '0');
       else
         if wr_next = '1' and (wr_cnt < C_M_AXI_BURST_LEN) then
           wr_cnt <= wr_cnt + 1;
         end if;
       end if;
     end if;
   end process;

   process(M_AXI_ACLK)
   begin
     if rising_edge (M_AXI_ACLK) then
       if M_AXI_ARESETN = '0' or enable_i = '1' then
         axi_bready <= '0';
       else
         if C_NO_WRITE_RESPONSE then
            axi_bready <= '1';
         else
           if M_AXI_BVALID = '1' and axi_bready = '0' then
             axi_bready <= '1';
           elsif axi_bready = '1' then
             axi_bready <= '0';
           end if;
         end if;
       end if;
     end if;
   end process;

   process(M_AXI_ACLK)
   begin
     if rising_edge (M_AXI_ACLK) then
       if M_AXI_ARESETN = '0' or enable_i = '1' then
         axi_arvalid <= '0';
       else
         if axi_arvalid = '0' and rd_burst_start = '1' then
           axi_arvalid <= '1';
         elsif M_AXI_ARREADY = '1' and axi_arvalid = '1' then
           axi_arvalid <= '0';
         end if;
       end if;
     end if;
   end process;

   process(M_AXI_ACLK)
   begin
     if rising_edge (M_AXI_ACLK) then
       if M_AXI_ARESETN = '0' or enable_i = '1' then
         axi_araddr <= (others => '0');
       else
         if M_AXI_ARREADY = '1' and axi_arvalid = '1' then
           axi_araddr <= std_logic_vector(unsigned(axi_araddr) + C_BURST_BYTES);
         end if;
       end if;
     end if;
   end process;

   rd_next <= M_AXI_RVALID and axi_rready;

   process(M_AXI_ACLK)
   begin
     if rising_edge (M_AXI_ACLK) then
       if M_AXI_ARESETN = '0' or rd_burst_start = '1' or enable_i = '1' then
         rd_cnt <= (others => '0');
       else
         if (rd_next = '1' and rd_cnt < C_M_AXI_BURST_LEN) then
           rd_cnt <= rd_cnt + 1;
         end if;
       end if;
     end if;
   end process;

   process(M_AXI_ACLK)
   begin
     if rising_edge (M_AXI_ACLK) then
       if M_AXI_ARESETN = '0' or enable_i = '1' then
         axi_rready <= '0';
       else
         if M_AXI_RVALID = '1' then
           if M_AXI_RLAST = '1' and axi_rready = '1' then
             axi_rready <= '0';
            else
              axi_rready <= '1';
           end if;
         end if;
       end if;
     end if;
   end process;

   process(M_AXI_ACLK)
   begin
     if rising_edge (M_AXI_ACLK) then
       if M_AXI_ARESETN = '0' or enable_i = '1' then
         wr_burst_cnt <= (others => '0');
       else
         if M_AXI_AWREADY = '1' and axi_awvalid = '1' then
           if wr_burst_cnt < burst_length then
             wr_burst_cnt <= wr_burst_cnt + 1;
           end if;
         end if;
       end if;
     end if;
   end process;

   process(M_AXI_ACLK)
   begin
     if rising_edge (M_AXI_ACLK) then
       if M_AXI_ARESETN = '0' or enable_i = '1' then
         rd_burst_cnt <= (others => '0');
       else
         if M_AXI_ARREADY = '1' and axi_arvalid = '1' then
           if rd_burst_cnt < burst_length then
             rd_burst_cnt <= rd_burst_cnt + 1;
           end if;
         end if;
       end if;
     end if;
   end process;

   busy_o <= '1' when state /= IDLE else '0';

   MASTER_EXECUTION_PROC:process(M_AXI_ACLK)
   begin
     if rising_edge (M_AXI_ACLK) then
       if M_AXI_ARESETN = '0' then
         state     <= IDLE;
         wr_burst_start <= '0';
         rd_burst_start  <= '0';
       else
         case state is
            when IDLE =>
                if enable_i = '1' then
                  state  <= INIT_WRITE;
                else
                  state  <= IDLE;
                end if;
             when INIT_WRITE =>
                 if wr_done = '1' then
                   state <= IDLE;--READ;
                 else
                   if axi_awvalid = '0' and wr_burst_start = '0' and wr_burst_active = '0' then
                      wr_burst_start <= '1';
                   else
                      wr_burst_start <= '0';
                   end if;
               end if;
             when INIT_READ =>
                 if rd_done = '1' then
                   state <= IDLE;
                 else
                   if axi_arvalid = '0' and rd_burst_active = '0' and rd_burst_start = '0' then
                      rd_burst_start <= '1';
                   else
                      rd_burst_start <= '0';
                   end if;
               end if;
           end case  ;
        end if;
     end if;
   end process;

   process(M_AXI_ACLK)
   begin
     if rising_edge (M_AXI_ACLK) then
       if M_AXI_ARESETN = '0' or enable_i = '1' then
         wr_burst_active <= '0';
       else
         if wr_burst_start = '1' then
           wr_burst_active <= '1';
         elsif ((M_AXI_BVALID = '1' and not(C_NO_WRITE_RESPONSE)) or (axi_wlast = '1' and C_NO_WRITE_RESPONSE)) and axi_bready = '1' then
           wr_burst_active <= '0';
         end if;
       end if;
     end if;
   end process;

   process(M_AXI_ACLK)
   begin
     if rising_edge (M_AXI_ACLK) then
       if M_AXI_ARESETN = '0' or enable_i = '1' then
         wr_done <= '0';
       else
         if ((M_AXI_BVALID = '1' and not(C_NO_WRITE_RESPONSE)) or (axi_wlast = '1' and C_NO_WRITE_RESPONSE)) and wr_burst_cnt = burst_length and axi_bready = '1' then
           wr_done <= '1';
         end if;
       end if;
     end if;
   end process;

   process(M_AXI_ACLK)
   begin
     if rising_edge (M_AXI_ACLK) then
       if M_AXI_ARESETN = '0' or enable_i = '1' then
         rd_burst_active <= '0';
       else
         if rd_burst_start = '1'then
           rd_burst_active <= '1';
         elsif M_AXI_RVALID = '1' and axi_rready = '1' and M_AXI_RLAST = '1' then
           rd_burst_active <= '0';
         end if;
       end if;
     end if;
   end process;

   process(M_AXI_ACLK)
   begin
     if rising_edge (M_AXI_ACLK) then
       if M_AXI_ARESETN = '0' or enable_i = '1' then
         rd_done <= '0';
       else
         if M_AXI_RVALID = '1' and axi_rready = '1' and (rd_cnt = (C_M_AXI_BURST_LEN-1)) and rd_burst_cnt = burst_length then
           rd_done <= '1';
         end if;
       end if;
     end if;
   end process;

end implementation;
