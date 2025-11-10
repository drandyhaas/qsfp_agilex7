	component q_sys_systemclk_f_1 is
		port (
			out_systempll_synthlock_0 : out std_logic;        -- out_systempll_synthlock
			out_systempll_clk_0       : out std_logic;        -- clk
			out_refclk_fgt_4          : out std_logic;        -- clk
			in_refclk_fgt_4           : in  std_logic := 'X'; -- in_refclk_fgt_4
			disable_refclk_monitor_4  : in  std_logic := 'X'  -- disable_refclk_monitor_4
		);
	end component q_sys_systemclk_f_1;

	u0 : component q_sys_systemclk_f_1
		port map (
			out_systempll_synthlock_0 => CONNECTED_TO_out_systempll_synthlock_0, -- out_systempll_synthlock_0.out_systempll_synthlock
			out_systempll_clk_0       => CONNECTED_TO_out_systempll_clk_0,       --       out_systempll_clk_0.clk
			out_refclk_fgt_4          => CONNECTED_TO_out_refclk_fgt_4,          --          out_refclk_fgt_4.clk
			in_refclk_fgt_4           => CONNECTED_TO_in_refclk_fgt_4,           --                refclk_fgt.in_refclk_fgt_4
			disable_refclk_monitor_4  => CONNECTED_TO_disable_refclk_monitor_4   --  disable_refclk_monitor_4.disable_refclk_monitor_4
		);

