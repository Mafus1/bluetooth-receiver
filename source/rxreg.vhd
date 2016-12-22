-- Library & Use Statements
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Entity Declaration 
ENTITY rxreg IS
  PORT( 
			clk				: IN		std_logic;
			reset_n			: IN     std_logic;
			valid_data		: IN		std_logic;
			par_data_in	   : IN    	std_logic_vector(7 downto 0); 
			reg_0_l			: OUT		std_logic_vector(3 downto 0); -- to sevseg1 / only 4bit, split reg 0 least
			reg_0_m			: OUT		std_logic_vector(3 downto 0);	-- to sevseg2 / only 4bit, split reg 0 most
			reg_1_l			: OUT		std_logic_vector(3 downto 0);	-- to sevseg3 / only 4bit, split reg 1 least
			reg_1_m			: OUT		std_logic_vector(3 downto 0);	-- to sevseg4 / only 4bit, split reg 1 most
			reg_2_l			: OUT		std_logic_vector(3 downto 0);	-- to sevseg5 / only 4bit, split reg 2 least
			reg_2_m			: OUT		std_logic_vector(3 downto 0);	-- to sevseg6 / only 4bit, split reg 2 most
			reg_3_l			: OUT		std_logic_vector(3 downto 0);	-- to sevseg7 / only 4bit, split reg 3 least
			reg_3_m			: OUT		std_logic_vector(3 downto 0)	-- to sevseg8 / only 4bit, split reg 3 most
    	);
END rxreg;


-- Architecture Declaration 
ARCHITECTURE rtl OF rxreg IS

	-- Signals & Constants Declaration 
	CONSTANT default_data					: std_logic_vector(7 downto 0):= "00000000";
	CONSTANT default_reg						: unsigned(1 downto 0):= to_unsigned(0, 2);
	
	CONSTANT reg_0_state 					: unsigned(1 downto 0):= to_unsigned(0, 2);
	CONSTANT reg_1_state 					: unsigned(1 downto 0):= to_unsigned(1, 2);
	CONSTANT reg_2_state 					: unsigned(1 downto 0):= to_unsigned(2, 2);
	CONSTANT reg_3_state 					: unsigned(1 downto 0):= to_unsigned(3, 2);
	
	SIGNAL	current_reg, next_reg									: unsigned(1 downto 0):= default_reg;
	SIGNAL	reg_0, reg_1, reg_2, reg_3								: std_logic_vector(7 downto 0):= default_data;
	SIGNAL	next_reg_0, next_reg_1, next_reg_2, next_reg_3 	: std_logic_vector(7 downto 0):= default_data;
	
	
-- Begin Architecture
BEGIN 

	input_logic: PROCESS (ALL)
	BEGIN
		
		IF current_reg < 3 AND valid_data = '1' THEN
			next_reg <= current_reg + 1;
		ELSIF current_reg = 3 AND valid_data = '1' THEN
			next_reg <= default_reg;
		ELSE
			next_reg <= current_reg;
		END IF;
			
	END PROCESS input_logic;
	
	register_logic: PROCESS (ALL)
	BEGIN
	
		IF valid_data = '1' AND current_reg = reg_0_state THEN
			next_reg_0 <= par_data_in;
		ELSE
			next_reg_0 <= reg_0;
		END IF;
		
		IF valid_data = '1' AND current_reg = reg_1_state THEN
			next_reg_1 <= par_data_in;
		ELSE
			next_reg_1 <= reg_1;
		END IF;
		
		IF valid_data = '1' AND current_reg = reg_2_state THEN
			next_reg_2 <= par_data_in;
		ELSE
			next_reg_2 <= reg_2;
		END IF;
		
		IF valid_data = '1' AND current_reg = reg_3_state THEN
			next_reg_3 <= par_data_in;
		ELSE
			next_reg_3 <= reg_3;
		END IF;

	END PROCESS register_logic;

	flip_flops : PROCESS(reset_n, clk)
	BEGIN	
	
		IF reset_n = '0' THEN
			current_reg <= default_reg;
		ELSIF rising_edge(clk) THEN
			current_reg <= next_reg;
		END IF;
		
	END PROCESS flip_flops;	
	 
	register_flip_flops: PROCESS(reset_n, clk)
	BEGIN

		IF reset_n = '0' THEN
			reg_0 <= default_data;
			reg_1 <= default_data;
			reg_2 <= default_data;
			reg_3 <= default_data;
		ELSIF rising_edge(clk) THEN
			reg_0 <= next_reg_0;
			reg_1 <= next_reg_1;
			reg_2 <= next_reg_2;
			reg_3 <= next_reg_3;
		END IF;
		
	END PROCESS register_flip_flops;
	
	reg_0_l 	<= reg_0 (3 downto 0);		
	reg_0_m 	<= reg_0 (7 downto 4);		
	reg_1_l	<= reg_1 (3 downto 0);	
	reg_1_m	<= reg_1 (7 downto 4);			
	reg_2_l	<= reg_2 (3 downto 0);
	reg_2_m	<= reg_2 (7 downto 4);		
	reg_3_l	<= reg_3 (3 downto 0);	
	reg_3_m	<= reg_3 (7 downto 4);
		
	
END rtl;	
