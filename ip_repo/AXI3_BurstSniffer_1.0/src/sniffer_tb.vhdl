library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Sniffer_tb is
end Sniffer_tb;

architecture Simul of Sniffer_tb is

   signal stop    : boolean;

   signal prepare : std_logic;
   signal addr    : std_logic_vector(7 downto 0);
   signal data    : std_logic_vector(31 downto 0);

   signal aclk,    aresetn : std_logic;
   signal awvalid, awready : std_logic;
   signal arvalid, arready : std_logic;

begin

   p_clock : process -- 150 MHz
   begin
      aclk <= '1';
      while not stop loop
         wait for 6.66 ns / 2;
         aclk <= not aclk;
      end loop;
      wait;
   end process p_clock;

   aresetn <= '0', '1' after 20 ns;

   SimpleAxiSniffer_inst : entity work.SimpleAxiSniffer
   port map (
      aclk_i    => aclk,
      aresetn_i => aresetn,
      prepare_i => prepare,
      -- Write
      awvalid_i => awvalid,
      awready_i => awready,
      wvalid_i  => '1',
      wready_i  => '1',
      wlast_i   => '1',
      bvalid_i  => '1',
      bready_i  => '1',
      awprot_i  => (others => '0'),
      awlen_i   => (others => '0'),
      awsize_i  => (others => '0'),
      awburst_i => (others => '0'),
      awcache_i => (others => '0'),
      awlock_i  => (others => '0'),
      -- Read
      arvalid_i => arvalid,
      arready_i => arready,
      rvalid_i  => '1',
      rready_i  => '1',
      rlast_i   => '1',
      arlen_i   => (others => '0'),
      arsize_i  => (others => '0'),
      arburst_i => (others => '0'),
      arcache_i => (others => '0'),
      arprot_i  => (others => '0'),
      arlock_i  => (others => '0'),
      --
      addr_i    => addr,
      data_o    => data
   );

   p_test: process
      variable data_to_send : std_logic_vector(15 downto 0);
   begin
      prepare <= '0';
      awvalid <= '0';
      awready <= '0';
      arvalid <= '0';
      arready <= '0';
      wait until aresetn='1';
      wait until rising_edge(aclk);
      prepare <= '1';
      wait until rising_edge(aclk);
      prepare <= '0';
      wait until rising_edge(aclk);
      awvalid <= '1';
      awready <= '1';
      wait until rising_edge(aclk);
      awvalid <= '0';
      awready <= '0';
      wait until rising_edge(aclk);
      arvalid <= '1';
      arready <= '1';
      wait until rising_edge(aclk);
      arvalid <= '0';
      arready <= '0';
      wait until rising_edge(aclk);
      wait for 1 us;
      for i in 0 to 255 loop
          addr <= std_logic_vector(to_unsigned(i,8));
          wait until rising_edge(aclk);
      end loop;
      stop <= TRUE;
      wait;
   end process p_test;

end architecture Simul;
