library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SimpleAxiSniffer is
   generic (
      ENA_WRITE : boolean := TRUE;
      ENA_READ  : boolean := TRUE
   );
   port (
      aclk_i    :  in std_logic;
      aresetn_i :  in std_logic;
      prepare_i :  in std_logic;
      -- Write
      awvalid_i :  in std_logic;
      awready_i :  in std_logic;
      wvalid_i  :  in std_logic;
      wready_i  :  in std_logic;
      wlast_i   :  in std_logic;
      bvalid_i  :  in std_logic;
      bready_i  :  in std_logic;
      awprot_i  :  in std_logic_vector(2 downto 0);
      awlen_i   :  in std_logic_vector(3 downto 0);
      awsize_i  :  in std_logic_vector(2 downto 0);
      awburst_i :  in std_logic_vector(1 downto 0);
      awcache_i :  in std_logic_vector(3 downto 0);
      awlock_i  :  in std_logic_vector(1 downto 0);
      -- Read
      arvalid_i :  in std_logic;
      arready_i :  in std_logic;
      rvalid_i  :  in std_logic;
      rready_i  :  in std_logic;
      rlast_i   :  in std_logic;
      arlen_i   :  in std_logic_vector(3 downto 0);
      arsize_i  :  in std_logic_vector(2 downto 0);
      arburst_i :  in std_logic_vector(1 downto 0);
      arcache_i :  in std_logic_vector(3 downto 0);
      arprot_i  :  in std_logic_vector(2 downto 0);
      arlock_i  :  in std_logic_vector(1 downto 0);
      --
      addr_i    :  in std_logic_vector(7 downto 0);
      data_o    : out std_logic_vector(31 downto 0)
   );
end SimpleAxiSniffer;

architecture RTL of SimpleAxiSniffer is

   type ram_type is array (255 downto 0) of std_logic_vector(31 downto 0);
   shared variable ram : ram_type;

   type state_t is (IDLE_S, CAPTURE_S, DONE_S);
   signal wr_state, rd_state : state_t := IDLE_S;

   signal wr_iface, rd_iface : std_logic_vector(31 downto 0);

   signal wr_ena,   rd_ena   : std_logic;
   signal wr_addr,  rd_addr  : unsigned(7 downto 0);
   signal wr_data,  rd_data  : std_logic_vector(31 downto 0);

   signal addr               : unsigned(7 downto 0);

begin

   write_gen : if ENA_WRITE generate

      wr_iface( 1 downto  0) <= awready_i & awvalid_i ;
      wr_iface( 4 downto  2) <= wlast_i & wready_i & wvalid_i;
      wr_iface( 6 downto  5) <= bready_i & bvalid_i;
      wr_iface( 9 downto  7) <= awprot_i;
      wr_iface(13 downto 10) <= awlen_i;
      wr_iface(16 downto 14) <= awsize_i;
      wr_iface(18 downto 17) <= awburst_i;
      wr_iface(22 downto 19) <= awcache_i;
      wr_iface(24 downto 23) <= awlock_i;
      wr_iface(31 downto 25) <= (others => '0'); -- RFU

      write_proc : process (aclk_i)
      begin
         if rising_edge(aclk_i) then
            wr_data <= wr_iface;
            if aresetn_i = '0' or prepare_i = '1' then
               wr_state <= IDLE_S;
            else
               case wr_state is
                    when IDLE_S =>
                         wr_ena  <= '0';
                         wr_addr <= (others => '0');
                         if awready_i = '1' and awvalid_i = '1' then
                            wr_ena   <= '1';
                            wr_state <= CAPTURE_S;
                         end if;
                    when CAPTURE_S =>
                         if wr_addr = 127 then
                            wr_ena  <= '0';
                            wr_state <= DONE_S;
                         else
                            wr_addr <= wr_addr + 1;
                         end if;
                    when DONE_S =>
               end case;
            end if;
         end if;
      end process write_proc;

   end generate write_gen;

   read_gen : if ENA_READ generate

      rd_iface( 1 downto  0) <= arready_i & arvalid_i ;
      rd_iface( 4 downto  2) <= rlast_i & rready_i & rvalid_i;
      rd_iface( 6 downto  5) <= "00";
      rd_iface( 9 downto  7) <= arprot_i;
      rd_iface(13 downto 10) <= arlen_i;
      rd_iface(16 downto 14) <= arsize_i;
      rd_iface(18 downto 17) <= arburst_i;
      rd_iface(22 downto 19) <= arcache_i;
      rd_iface(24 downto 23) <= arlock_i;
      rd_iface(31 downto 25) <= (others => '0'); -- RFU

      read_proc : process (aclk_i)
      begin
         if rising_edge(aclk_i) then
            rd_data <= rd_iface;
            if aresetn_i = '0' or prepare_i = '1' then
               rd_state <= IDLE_S;
            else
               case rd_state is
                    when IDLE_S =>
                         rd_ena  <= '0';
                         rd_addr <= to_unsigned(128,8);
                         if arready_i = '1' and arvalid_i = '1' then
                            rd_ena   <= '1';
                            rd_state <= CAPTURE_S;
                         end if;
                    when CAPTURE_S =>
                         if rd_addr = 255 then
                            rd_ena  <= '0';
                            rd_state <= DONE_S;
                         else
                            rd_addr <= rd_addr + 1;
                         end if;
                    when DONE_S =>
               end case;
            end if;
         end if;
      end process read_proc;

   end generate read_gen;

   addr <= unsigned(addr_i) when wr_state = DONE_S or rd_state = DONE_S else wr_addr;

   wr_ch_mem_proc : process (aclk_i)
   begin
      if rising_edge(aclk_i) then
         data_o <= ram(to_integer(unsigned(addr)));
         if wr_ena = '1' then
            ram(to_integer(unsigned(addr))) := wr_data;
         end if;
      end if;
   end process wr_ch_mem_proc;

   rd_ch_mem_proc : process (aclk_i)
   begin
      if rising_edge(aclk_i) then
         if rd_ena = '1' then
            ram(to_integer(unsigned(rd_addr))) := rd_data;
         end if;
      end if;
   end process rd_ch_mem_proc;

end architecture RTL;