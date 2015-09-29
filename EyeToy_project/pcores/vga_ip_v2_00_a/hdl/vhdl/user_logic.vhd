------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           2.00.a
-- Description:       User logic.
-- Date:              Fri Sep 25 09:27:17 2015 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_NUM_REG                    -- Number of software accessible registers
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Resetn                -- Bus to IP reset
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_NUM_REG                      : integer              := 4;
    C_SLV_DWIDTH                   : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    pixel_clk :  IN   STD_LOGIC;  --pixel clock at frequency of VGA mode being used
    reset_n   :  IN   STD_LOGIC;  --active low asycnchronous reset
    h_sync    :  OUT  STD_LOGIC;  --horiztonal sync pulse
    v_sync    :  OUT  STD_LOGIC;  --vertical sync pulse
    disp_ena  :  OUT  STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
    column    :  OUT  INTEGER;    --horizontal pixel coordinate
    row       :  OUT  INTEGER;    --vertical pixel coordinate
    n_blank   :  OUT  STD_LOGIC;  --direct blacking output to DAC
    n_sync    :  OUT  STD_LOGIC; --sync-on-green output to DAC
	RED0	  :  OUT  STD_LOGIC;
	RED1	  :  OUT  STD_LOGIC;
	RED2	  :  OUT  STD_LOGIC;
	GRN0	  :  OUT  STD_LOGIC;
	GRN1	  :  OUT  STD_LOGIC;
	GRN2	  :  OUT  STD_LOGIC;
	BLU1	  :  OUT  STD_LOGIC;
	BLU2	  :  OUT  STD_LOGIC;
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Resetn                  : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    Bus2IP_BE                      : in  std_logic_vector(C_SLV_DWIDTH/8-1 downto 0);
    Bus2IP_RdCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    Bus2IP_WrCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    IP2Bus_Data                    : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  --USER signal declarations added here, as needed for user logic


begin
  --USER logic implementation added here

  n_blank <= '1';  --no direct blanking
  n_sync <= '0';   --no sync on green
  
  
  imageGeneration : process(row, column)
	variable rowV , colV : unsigned(7 downto 0);
	begin	
		rowV := unsigned(row);
		colV := unsigned(column);
		if(rowV < 300)
			RED0 <= '1';
			RED1 <= '1';
			RED2 <= '1';
			GRN0 <= '0';
			GRN1 <= '0';
			GRN2 <= '0';
			BLU1 <= '0';
			BLU2 <= '0';
		else
		RED0 <= '1';
			RED1 <= '0';
			RED2 <= '0';
			GRN0 <= '0';
			GRN1 <= '0';
			GRN2 <= '0';
			BLU1 <= '1';
			BLU2 <= '1';
			
		end if;
	end process;
	
  PROCESS(pixel_clk, reset_n)
    VARIABLE h_count  :  INTEGER RANGE 0 TO h_period - 1 := 0;  --horizontal counter (counts the columns)
    VARIABLE v_count  :  INTEGER RANGE 0 TO v_period - 1 := 0;  --vertical counter (counts the rows)
  BEGIN
  
    IF(reset_n = '0') THEN  --reset asserted
      h_count := 0;         --reset horizontal counter
      v_count := 0;         --reset vertical counter
      h_sync <= NOT h_pol;  --deassert horizontal sync
      v_sync <= NOT v_pol;  --deassert vertical sync
      disp_ena <= '0';      --disable display
      column <= 0;          --reset column pixel coordinate
      row <= 0;             --reset row pixel coordinate
      
    ELSIF(pixel_clk'EVENT AND pixel_clk = '1') THEN

      --counters
      IF(h_count < h_period - 1) THEN    --horizontal counter (pixels)
        h_count := h_count + 1;
      ELSE
        h_count := 0;
        IF(v_count < v_period - 1) THEN  --veritcal counter (rows)
          v_count := v_count + 1;
        ELSE
          v_count := 0;
        END IF;
      END IF;

      --horizontal sync signal
      IF(h_count < h_pixels + h_fp OR h_count > h_pixels + h_fp + h_pulse) THEN
        h_sync <= NOT h_pol;    --deassert horiztonal sync pulse
      ELSE
        h_sync <= h_pol;        --assert horiztonal sync pulse
      END IF;
      
      --vertical sync signal
      IF(v_count < v_pixels + v_fp OR v_count > v_pixels + v_fp + v_pulse) THEN
        v_sync <= NOT v_pol;    --deassert vertical sync pulse
      ELSE
        v_sync <= v_pol;        --assert vertical sync pulse
      END IF;
      
      --set pixel coordinates
      IF(h_count < h_pixels) THEN  --horiztonal display time
        column <= h_count;         --set horiztonal pixel coordinate
      END IF;
      IF(v_count < v_pixels) THEN  --vertical display time
        row <= v_count;            --set vertical pixel coordinate
      END IF;

      --set display enable output
      IF(h_count < h_pixels AND v_count < v_pixels) THEN  --display time
        disp_ena <= '1';                                  --enable display
      ELSE                                                --blanking time
        disp_ena <= '0';                                  --disable display
      END IF;

    END IF;
  END PROCESS;

 

end IMP;
