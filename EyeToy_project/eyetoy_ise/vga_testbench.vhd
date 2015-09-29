--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:57:45 09/28/2015
-- Design Name:   
-- Module Name:   C:/temp/EyeToy_project/eyetoy_ise/vga_testbench.vhd
-- Project Name:  eyetoy_ise
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: user_logic
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY vga_testbench IS
END vga_testbench;
 
ARCHITECTURE behavior OF vga_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT user_logic
    PORT(
         pixel_clk : IN  std_logic;
         reset_n : IN  std_logic;
         h_sync : OUT  std_logic;
         v_sync : OUT  std_logic;
         disp_ena : OUT  std_logic;
         column : OUT  std_logic;
         row : OUT  std_logic;
         n_blank : OUT  std_logic;
         n_sync : OUT  std_logic;
         RED0 : OUT  std_logic;
         RED1 : OUT  std_logic;
         RED2 : OUT  std_logic;
         GRN0 : OUT  std_logic;
         GRN1 : OUT  std_logic;
         GRN2 : OUT  std_logic;
         BLU1 : OUT  std_logic;
         BLU2 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal pixel_clk : std_logic := '0';
   signal reset_n : std_logic := '0';

 	--Outputs
   signal h_sync : std_logic;
   signal v_sync : std_logic;
   signal disp_ena : std_logic;
   signal column : std_logic;
   signal row : std_logic;
   signal n_blank : std_logic;
   signal n_sync : std_logic;
   signal RED0 : std_logic;
   signal RED1 : std_logic;
   signal RED2 : std_logic;
   signal GRN0 : std_logic;
   signal GRN1 : std_logic;
   signal GRN2 : std_logic;
   signal BLU1 : std_logic;
   signal BLU2 : std_logic;

   -- Clock period definitions
   constant pixel_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: user_logic PORT MAP (
          pixel_clk => pixel_clk,
          reset_n => reset_n,
          h_sync => h_sync,
          v_sync => v_sync,
          disp_ena => disp_ena,
          column => column,
          row => row,
          n_blank => n_blank,
          n_sync => n_sync,
          RED0 => RED0,
          RED1 => RED1,
          RED2 => RED2,
          GRN0 => GRN0,
          GRN1 => GRN1,
          GRN2 => GRN2,
          BLU1 => BLU1,
          BLU2 => BLU2
        );

   -- Clock process definitions
   pixel_clk_process :process
   begin
		pixel_clk <= '0';
		wait for pixel_clk_period/2;
		pixel_clk <= '1';
		wait for pixel_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for pixel_clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
