-- Library & Use Statements
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY edge_detect IS
  PORT( 
			clk		: IN    std_logic;
			data_in 	: IN    std_logic;
			reset_n	: IN    std_logic;
    	   rise    : OUT   std_logic;
			fall     : OUT   std_logic
    	);
END edge_detect;


-- Architecture Declaration 
ARCHITECTURE rtl OF edge_detect IS

	-- Signals & Constants Declaration 
	SIGNAL q1: std_logic;
	SIGNAL q2: std_logic;
	
-- Begin Architecture
BEGIN 
    -------------------------------------------
    -- Process for combinatorial logic
    ------------------------------------------- 
	 -- not needed in this file, using concurrent logic
	 
	 -------------------------------------------
    -- Process for registers (flip-flops)
    -------------------------------------------
	flip_flops : PROCESS(clk, reset_n)
	BEGIN	
		IF reset_n = '0' THEN
			q1 <= '0';
			q2 <= '0';
		ELSIF (rising_edge(clk)) THEN
			q1 <= data_in;
			q2 <= q1;
		END IF;
	END PROCESS flip_flops;	
	 
	 -------------------------------------------
    -- Concurrent Assignments  
    -------------------------------------------
	edge_detector_logic: PROCESS(q1, q2)
	BEGIN
		-- Default for rise und fall
		rise <= '0';
		fall <= '0';
	
		IF q1 = '1' AND q2 = '0' THEN
			rise <= '1';
		ELSIF q1 = '0' AND q2 = '1' THEN
			fall <= '1';
		END IF;
	END PROCESS edge_detector_logic;
END rtl;	
