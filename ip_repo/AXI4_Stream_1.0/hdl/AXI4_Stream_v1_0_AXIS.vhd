library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI4_Stream_v1_0_AXIS is
   generic (
      C_M_AXIS_TDATA_WIDTH : integer := 32
   );
   port (
      -- Users to add ports here
      enable_i       :  in std_logic;
      length_i       :  in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
      counter_i      :  in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
      -- User ports ends
      M_AXIS_ACLK    :  in std_logic;
      M_AXIS_ARESETN :  in std_logic;
      M_AXIS_TVALID  : out std_logic;
      M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
      M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0):=(others => '1');
      M_AXIS_TLAST   : out std_logic;
      M_AXIS_TREADY  :  in std_logic
   );
end AXI4_Stream_v1_0_AXIS;

architecture implementation of AXI4_Stream_v1_0_AXIS is
   type state_t is (IDLE_S, SEND_S);
   signal state : state_t := IDLE_S;
   signal last_cnt : unsigned(31 downto 0);
begin

   M_AXIS_TDATA  <= std_logic_vector(counter_i);
   M_AXIS_TVALID <= '1' when state=SEND_S else '0';
   M_AXIS_TLAST  <= '1' when last_cnt = unsigned(length_i)-1 else '0';

   axis_p : process(M_AXIS_ACLK)
   begin
      if (rising_edge (M_AXIS_ACLK)) then
         if (M_AXIS_ARESETN = '0' or enable_i = '0') then
            state <= IDLE_S;
         else
            case state is
                 when IDLE_S =>
                      last_cnt <= (others => '0');
                      if enable_i = '1' then
                         state <= SEND_S;
                      end if;
                 when SEND_S =>
                      if M_AXIS_TREADY = '1' then
                         last_cnt <= last_cnt + 1;
                         if last_cnt = unsigned(length_i)-1 then
                            state <= IDLE_S;
                         end if;
                      end if;
            end case;
         end if;
      end if;
   end process axis_p;

end implementation;
