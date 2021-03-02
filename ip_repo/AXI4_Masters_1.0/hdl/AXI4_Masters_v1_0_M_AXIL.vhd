library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI4_Masters_v1_0_M_AXIL is
   generic (
      C_NO_WRITE_RESPONSE  : boolean   := FALSE;
      C_M_AXI_ADDR_WIDTH   : integer   := 32;
      C_M_AXI_DATA_WIDTH   : integer   := 32
   );
   port (
      -- Users to add ports here
      enable_i      :  in std_logic;
      length_i      :  in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
      counter_i     :  in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
      address_i     :  in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
      busy_o        : out std_logic;
      --
      M_AXI_ACLK   : in std_logic;
      M_AXI_ARESETN   : in std_logic;
      M_AXI_AWADDR   : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
      M_AXI_AWPROT   : out std_logic_vector(2 downto 0);
      M_AXI_AWVALID   : out std_logic;
      M_AXI_AWREADY   : in std_logic;
      M_AXI_WDATA   : out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
      M_AXI_WSTRB   : out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
      M_AXI_WVALID   : out std_logic;
      M_AXI_WREADY   : in std_logic;
      M_AXI_BRESP   : in std_logic_vector(1 downto 0);
      M_AXI_BVALID   : in std_logic;
      M_AXI_BREADY   : out std_logic;
      M_AXI_ARADDR   : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
      M_AXI_ARPROT   : out std_logic_vector(2 downto 0);
      M_AXI_ARVALID   : out std_logic;
      M_AXI_ARREADY   : in std_logic;
      M_AXI_RDATA   : in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
      M_AXI_RRESP   : in std_logic_vector(1 downto 0);
      M_AXI_RVALID   : in std_logic;
      M_AXI_RREADY   : out std_logic
   );
end AXI4_Masters_v1_0_M_AXIL;

architecture implementation of AXI4_Masters_v1_0_M_AXIL is

   type state_t is (IDLE, INIT_WRITE, INIT_READ);
   signal state : state_t;

   -- AXI4LITE signals
   signal axi_awvalid   : std_logic;
   signal axi_wvalid   : std_logic;
   signal axi_arvalid   : std_logic;
   signal axi_rready   : std_logic;
   signal axi_bready   : std_logic;
   signal axi_awaddr   : std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
   signal axi_araddr   : std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);

   signal start_single_write   : std_logic;
   signal start_single_read   : std_logic;
   signal write_issued   : std_logic;
   signal read_issued   : std_logic;
   signal writes_done   : std_logic;
   signal reads_done   : std_logic;
   signal write_index   : unsigned(31 downto 0);
   signal read_index   : unsigned(31 downto 0);
   signal last_write   : std_logic;
   signal last_read   : std_logic;

begin

   M_AXI_AWADDR   <= std_logic_vector (unsigned(address_i) + unsigned(axi_awaddr));
   M_AXI_WDATA   <= counter_i;
   M_AXI_AWPROT   <= "000";
   M_AXI_AWVALID   <= axi_awvalid;
   M_AXI_WVALID   <= axi_wvalid;
   M_AXI_WSTRB   <= "1111";
   M_AXI_BREADY   <= axi_bready;
   M_AXI_ARADDR   <= std_logic_vector(unsigned(address_i) + unsigned(axi_araddr));
   M_AXI_ARVALID   <= axi_arvalid;
   M_AXI_ARPROT   <= "001";
   M_AXI_RREADY   <= axi_rready;

     process(M_AXI_ACLK)
     begin
       if (rising_edge (M_AXI_ACLK)) then
         if (M_AXI_ARESETN = '0' or enable_i = '1') then
           axi_awvalid <= '0';
         else
           if (start_single_write = '1') then
             axi_awvalid <= '1';
           elsif (M_AXI_AWREADY = '1' and axi_awvalid = '1') then
             axi_awvalid <= '0';
           end if;
         end if;
       end if;
     end process;

     process(M_AXI_ACLK)
     begin
       if (rising_edge (M_AXI_ACLK)) then
         if (M_AXI_ARESETN = '0' or enable_i = '1') then
           write_index <= (others => '0');
         elsif (start_single_write = '1') then
           write_index <= write_index + 1;
         end if;
       end if;
     end process;

      process(M_AXI_ACLK)
      begin
        if (rising_edge (M_AXI_ACLK)) then
          if (M_AXI_ARESETN = '0' or enable_i = '1') then
            axi_wvalid <= '0';
          else
            if (start_single_write = '1') then
              axi_wvalid <= '1';
            elsif (M_AXI_WREADY = '1' and axi_wvalid = '1') then
              axi_wvalid <= '0';
            end if;
          end if;
        end if;
      end process;

     process(M_AXI_ACLK)
     begin
       if (rising_edge (M_AXI_ACLK)) then
         if (M_AXI_ARESETN = '0' or enable_i = '1') then
           axi_bready <= '0';
         else
           if C_NO_WRITE_RESPONSE then
              axi_bready <= '1';
           else
              if (M_AXI_BVALID = '1' and axi_bready = '0') then
                 axi_bready <= '1';
              elsif (axi_bready = '1') then
                axi_bready <= '0';
              end if;
            end if;
         end if;
       end if;
     end process;

     process(M_AXI_ACLK)
     begin
       if (rising_edge (M_AXI_ACLK)) then
         if (M_AXI_ARESETN = '0' or enable_i = '1') then
           read_index <= (others => '0');
         else
           if (start_single_read = '1') then
             read_index <= read_index + 1;
           end if;
         end if;
       end if;
     end process;

     process(M_AXI_ACLK)
     begin
       if (rising_edge (M_AXI_ACLK)) then
         if (M_AXI_ARESETN = '0' or enable_i = '1') then
           axi_arvalid <= '0';
         else
           if (start_single_read = '1') then
             axi_arvalid <= '1';
           elsif (M_AXI_ARREADY = '1' and axi_arvalid = '1') then
             axi_arvalid <= '0';
           end if;
         end if;
       end if;
     end process;

     process(M_AXI_ACLK)
     begin
       if (rising_edge (M_AXI_ACLK)) then
         if (M_AXI_ARESETN = '0' or enable_i = '1') then
           axi_rready <= '1';
         else
           if (M_AXI_RVALID = '1' and axi_rready = '0') then
             axi_rready <= '1';
           elsif (axi_rready = '1') then
             axi_rready <= '0';
           end if;
         end if;
       end if;
     end process;

       process(M_AXI_ACLK)
         begin
          if (rising_edge (M_AXI_ACLK)) then
            if (M_AXI_ARESETN = '0' or enable_i = '1') then
              axi_awaddr <= (others => '0');
            elsif (M_AXI_AWREADY = '1' and axi_awvalid = '1') then
              axi_awaddr <= std_logic_vector (unsigned(axi_awaddr) + 4);
            end if;
          end if;
         end process;

       process(M_AXI_ACLK)
           begin
             if (rising_edge (M_AXI_ACLK)) then
               if (M_AXI_ARESETN = '0' or enable_i = '1') then
                 axi_araddr <= (others => '0');
               elsif (M_AXI_ARREADY = '1' and axi_arvalid = '1') then
                 axi_araddr <= std_logic_vector (unsigned(axi_araddr) + 4);
               end if;
             end if;
           end process;

   busy_o <= '1' when state /= IDLE else '0';

     MASTER_EXECUTION_PROC:process(M_AXI_ACLK)
     begin
       if (rising_edge (M_AXI_ACLK)) then
         if (M_AXI_ARESETN = '0' ) then
            state  <= IDLE;
           start_single_write <= '0';
           write_issued   <= '0';
           start_single_read  <= '0';
           read_issued  <= '0';
         else
           case (state) is
             when IDLE =>
               if ( enable_i = '1') then
                 state  <= INIT_WRITE;
               end if;
             when INIT_WRITE =>
               if (writes_done = '1') then
                 state <= IDLE;
               else
                 if (axi_awvalid = '0' and axi_wvalid = '0' and M_AXI_BVALID = '0' and
                   last_write = '0' and start_single_write = '0' and write_issued = '0') then
                   start_single_write <= '1';
                   write_issued  <= '1';
                 elsif (axi_bready = '1') then
                   write_issued   <= '0';
                   if C_NO_WRITE_RESPONSE then
                      start_single_write <= '0';
                   end if;
                 else
                   start_single_write <= '0';
                 end if;
               end if;
             when INIT_READ =>
               if (reads_done = '1') then
                 state <= IDLE;
               else
                 if (axi_arvalid = '0' and M_AXI_RVALID = '0' and last_read = '0' and
                   start_single_read = '0' and read_issued = '0') then
                   start_single_read <= '1';
                   read_issued   <= '1';
                 elsif (axi_rready = '1') then
                   read_issued   <= '0';
                 else
                   start_single_read <= '0';
                 end if;
               end if;
           end case  ;
         end if;
       end if;
     end process;

     process(M_AXI_ACLK)
     begin
       if (rising_edge (M_AXI_ACLK)) then
         if (M_AXI_ARESETN = '0' or enable_i = '1') then
           last_write <= '0';
         else
           if (write_index = unsigned(length_i) and M_AXI_AWREADY = '1') then
             last_write  <= '1';
           end if;
         end if;
       end if;
     end process;

     process(M_AXI_ACLK)
     begin
       if (rising_edge (M_AXI_ACLK)) then
         if (M_AXI_ARESETN = '0' or enable_i = '1') then
           writes_done <= '0';
         else
           if (last_write = '1' and ((M_AXI_BVALID = '1' and not(C_NO_WRITE_RESPONSE)) or C_NO_WRITE_RESPONSE) and axi_bready = '1') then
             writes_done <= '1';
           end if;
         end if;
       end if;
     end process;

     process(M_AXI_ACLK)
     begin
       if (rising_edge (M_AXI_ACLK)) then
         if (M_AXI_ARESETN = '0' or enable_i = '1') then
           last_read <= '0';
         else
           if read_index = unsigned(length_i) and (M_AXI_ARREADY = '1') then
             last_read <= '1';
           end if;
         end if;
       end if;
     end process;

     process(M_AXI_ACLK)
     begin
       if (rising_edge (M_AXI_ACLK)) then
         if (M_AXI_ARESETN = '0' or enable_i = '1') then
           reads_done <= '0';
         else
           if (last_read = '1' and M_AXI_RVALID = '1' and axi_rready = '1') then
             reads_done <= '1';
           end if;
         end if;
       end if;
     end process;

end implementation;
