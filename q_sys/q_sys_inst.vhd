	component q_sys is
		port (
			clk_100_clk                                                        : in  std_logic                    := 'X';             -- clk
			reset_100_reset_n                                                  : in  std_logic                    := 'X';             -- reset_n
			clk_50_clk                                                         : in  std_logic                    := 'X';             -- clk
			reset_50_reset_n                                                   : in  std_logic                    := 'X';             -- reset_n
			systemclk_f_0_refclk_fgt_in_refclk_fgt_4                           : in  std_logic                    := 'X';             -- in_refclk_fgt_4
			systemclk_f_1_refclk_fgt_in_refclk_fgt_4                           : in  std_logic                    := 'X';             -- in_refclk_fgt_4
			systemclk_f_2_refclk_fgt_in_refclk_fgt_4                           : in  std_logic                    := 'X';             -- in_refclk_fgt_4
			ftile_xcvr_test_0_directphy_f_0_tx_serial_data_tx_serial_data      : out std_logic_vector(0 downto 0);                    -- tx_serial_data
			ftile_xcvr_test_0_directphy_f_0_tx_serial_data_n_tx_serial_data_n  : out std_logic_vector(0 downto 0);                    -- tx_serial_data_n
			ftile_xcvr_test_0_directphy_f_0_rx_serial_data_rx_serial_data      : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data
			ftile_xcvr_test_0_directphy_f_0_rx_serial_data_n_rx_serial_data_n  : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data_n
			ftile_xcvr_test_1_directphy_f_0_tx_serial_data_tx_serial_data      : out std_logic_vector(0 downto 0);                    -- tx_serial_data
			ftile_xcvr_test_1_directphy_f_0_tx_serial_data_n_tx_serial_data_n  : out std_logic_vector(0 downto 0);                    -- tx_serial_data_n
			ftile_xcvr_test_1_directphy_f_0_rx_serial_data_rx_serial_data      : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data
			ftile_xcvr_test_1_directphy_f_0_rx_serial_data_n_rx_serial_data_n  : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data_n
			ftile_xcvr_test_10_directphy_f_0_tx_serial_data_tx_serial_data     : out std_logic_vector(0 downto 0);                    -- tx_serial_data
			ftile_xcvr_test_10_directphy_f_0_tx_serial_data_n_tx_serial_data_n : out std_logic_vector(0 downto 0);                    -- tx_serial_data_n
			ftile_xcvr_test_10_directphy_f_0_rx_serial_data_rx_serial_data     : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data
			ftile_xcvr_test_10_directphy_f_0_rx_serial_data_n_rx_serial_data_n : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data_n
			ftile_xcvr_test_11_directphy_f_0_tx_serial_data_tx_serial_data     : out std_logic_vector(0 downto 0);                    -- tx_serial_data
			ftile_xcvr_test_11_directphy_f_0_tx_serial_data_n_tx_serial_data_n : out std_logic_vector(0 downto 0);                    -- tx_serial_data_n
			ftile_xcvr_test_11_directphy_f_0_rx_serial_data_rx_serial_data     : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data
			ftile_xcvr_test_11_directphy_f_0_rx_serial_data_n_rx_serial_data_n : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data_n
			ftile_xcvr_test_2_directphy_f_0_tx_serial_data_tx_serial_data      : out std_logic_vector(0 downto 0);                    -- tx_serial_data
			ftile_xcvr_test_2_directphy_f_0_tx_serial_data_n_tx_serial_data_n  : out std_logic_vector(0 downto 0);                    -- tx_serial_data_n
			ftile_xcvr_test_2_directphy_f_0_rx_serial_data_rx_serial_data      : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data
			ftile_xcvr_test_2_directphy_f_0_rx_serial_data_n_rx_serial_data_n  : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data_n
			ftile_xcvr_test_3_directphy_f_0_tx_serial_data_tx_serial_data      : out std_logic_vector(0 downto 0);                    -- tx_serial_data
			ftile_xcvr_test_3_directphy_f_0_tx_serial_data_n_tx_serial_data_n  : out std_logic_vector(0 downto 0);                    -- tx_serial_data_n
			ftile_xcvr_test_3_directphy_f_0_rx_serial_data_rx_serial_data      : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data
			ftile_xcvr_test_3_directphy_f_0_rx_serial_data_n_rx_serial_data_n  : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data_n
			ftile_xcvr_test_4_directphy_f_0_tx_serial_data_tx_serial_data      : out std_logic_vector(0 downto 0);                    -- tx_serial_data
			ftile_xcvr_test_4_directphy_f_0_tx_serial_data_n_tx_serial_data_n  : out std_logic_vector(0 downto 0);                    -- tx_serial_data_n
			ftile_xcvr_test_4_directphy_f_0_rx_serial_data_rx_serial_data      : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data
			ftile_xcvr_test_4_directphy_f_0_rx_serial_data_n_rx_serial_data_n  : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data_n
			ftile_xcvr_test_5_directphy_f_0_tx_serial_data_tx_serial_data      : out std_logic_vector(0 downto 0);                    -- tx_serial_data
			ftile_xcvr_test_5_directphy_f_0_tx_serial_data_n_tx_serial_data_n  : out std_logic_vector(0 downto 0);                    -- tx_serial_data_n
			ftile_xcvr_test_5_directphy_f_0_rx_serial_data_rx_serial_data      : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data
			ftile_xcvr_test_5_directphy_f_0_rx_serial_data_n_rx_serial_data_n  : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data_n
			ftile_xcvr_test_6_directphy_f_0_tx_serial_data_tx_serial_data      : out std_logic_vector(0 downto 0);                    -- tx_serial_data
			ftile_xcvr_test_6_directphy_f_0_tx_serial_data_n_tx_serial_data_n  : out std_logic_vector(0 downto 0);                    -- tx_serial_data_n
			ftile_xcvr_test_6_directphy_f_0_rx_serial_data_rx_serial_data      : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data
			ftile_xcvr_test_6_directphy_f_0_rx_serial_data_n_rx_serial_data_n  : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data_n
			ftile_xcvr_test_7_directphy_f_0_tx_serial_data_tx_serial_data      : out std_logic_vector(0 downto 0);                    -- tx_serial_data
			ftile_xcvr_test_7_directphy_f_0_tx_serial_data_n_tx_serial_data_n  : out std_logic_vector(0 downto 0);                    -- tx_serial_data_n
			ftile_xcvr_test_7_directphy_f_0_rx_serial_data_rx_serial_data      : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data
			ftile_xcvr_test_7_directphy_f_0_rx_serial_data_n_rx_serial_data_n  : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data_n
			ftile_xcvr_test_8_directphy_f_0_tx_serial_data_tx_serial_data      : out std_logic_vector(0 downto 0);                    -- tx_serial_data
			ftile_xcvr_test_8_directphy_f_0_tx_serial_data_n_tx_serial_data_n  : out std_logic_vector(0 downto 0);                    -- tx_serial_data_n
			ftile_xcvr_test_8_directphy_f_0_rx_serial_data_rx_serial_data      : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data
			ftile_xcvr_test_8_directphy_f_0_rx_serial_data_n_rx_serial_data_n  : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data_n
			ftile_xcvr_test_9_directphy_f_0_tx_serial_data_tx_serial_data      : out std_logic_vector(0 downto 0);                    -- tx_serial_data
			ftile_xcvr_test_9_directphy_f_0_tx_serial_data_n_tx_serial_data_n  : out std_logic_vector(0 downto 0);                    -- tx_serial_data_n
			ftile_xcvr_test_9_directphy_f_0_rx_serial_data_rx_serial_data      : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rx_serial_data
			ftile_xcvr_test_9_directphy_f_0_rx_serial_data_n_rx_serial_data_n  : in  std_logic_vector(0 downto 0) := (others => 'X')  -- rx_serial_data_n
		);
	end component q_sys;

	u0 : component q_sys
		port map (
			clk_100_clk                                                        => CONNECTED_TO_clk_100_clk,                                                        --                                           clk_100.clk
			reset_100_reset_n                                                  => CONNECTED_TO_reset_100_reset_n,                                                  --                                         reset_100.reset_n
			clk_50_clk                                                         => CONNECTED_TO_clk_50_clk,                                                         --                                            clk_50.clk
			reset_50_reset_n                                                   => CONNECTED_TO_reset_50_reset_n,                                                   --                                          reset_50.reset_n
			systemclk_f_0_refclk_fgt_in_refclk_fgt_4                           => CONNECTED_TO_systemclk_f_0_refclk_fgt_in_refclk_fgt_4,                           --                          systemclk_f_0_refclk_fgt.in_refclk_fgt_4
			systemclk_f_1_refclk_fgt_in_refclk_fgt_4                           => CONNECTED_TO_systemclk_f_1_refclk_fgt_in_refclk_fgt_4,                           --                          systemclk_f_1_refclk_fgt.in_refclk_fgt_4
			systemclk_f_2_refclk_fgt_in_refclk_fgt_4                           => CONNECTED_TO_systemclk_f_2_refclk_fgt_in_refclk_fgt_4,                           --                          systemclk_f_2_refclk_fgt.in_refclk_fgt_4
			ftile_xcvr_test_0_directphy_f_0_tx_serial_data_tx_serial_data      => CONNECTED_TO_ftile_xcvr_test_0_directphy_f_0_tx_serial_data_tx_serial_data,      --    ftile_xcvr_test_0_directphy_f_0_tx_serial_data.tx_serial_data
			ftile_xcvr_test_0_directphy_f_0_tx_serial_data_n_tx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_0_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  --  ftile_xcvr_test_0_directphy_f_0_tx_serial_data_n.tx_serial_data_n
			ftile_xcvr_test_0_directphy_f_0_rx_serial_data_rx_serial_data      => CONNECTED_TO_ftile_xcvr_test_0_directphy_f_0_rx_serial_data_rx_serial_data,      --    ftile_xcvr_test_0_directphy_f_0_rx_serial_data.rx_serial_data
			ftile_xcvr_test_0_directphy_f_0_rx_serial_data_n_rx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_0_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  --  ftile_xcvr_test_0_directphy_f_0_rx_serial_data_n.rx_serial_data_n
			ftile_xcvr_test_1_directphy_f_0_tx_serial_data_tx_serial_data      => CONNECTED_TO_ftile_xcvr_test_1_directphy_f_0_tx_serial_data_tx_serial_data,      --    ftile_xcvr_test_1_directphy_f_0_tx_serial_data.tx_serial_data
			ftile_xcvr_test_1_directphy_f_0_tx_serial_data_n_tx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_1_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  --  ftile_xcvr_test_1_directphy_f_0_tx_serial_data_n.tx_serial_data_n
			ftile_xcvr_test_1_directphy_f_0_rx_serial_data_rx_serial_data      => CONNECTED_TO_ftile_xcvr_test_1_directphy_f_0_rx_serial_data_rx_serial_data,      --    ftile_xcvr_test_1_directphy_f_0_rx_serial_data.rx_serial_data
			ftile_xcvr_test_1_directphy_f_0_rx_serial_data_n_rx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_1_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  --  ftile_xcvr_test_1_directphy_f_0_rx_serial_data_n.rx_serial_data_n
			ftile_xcvr_test_10_directphy_f_0_tx_serial_data_tx_serial_data     => CONNECTED_TO_ftile_xcvr_test_10_directphy_f_0_tx_serial_data_tx_serial_data,     --   ftile_xcvr_test_10_directphy_f_0_tx_serial_data.tx_serial_data
			ftile_xcvr_test_10_directphy_f_0_tx_serial_data_n_tx_serial_data_n => CONNECTED_TO_ftile_xcvr_test_10_directphy_f_0_tx_serial_data_n_tx_serial_data_n, -- ftile_xcvr_test_10_directphy_f_0_tx_serial_data_n.tx_serial_data_n
			ftile_xcvr_test_10_directphy_f_0_rx_serial_data_rx_serial_data     => CONNECTED_TO_ftile_xcvr_test_10_directphy_f_0_rx_serial_data_rx_serial_data,     --   ftile_xcvr_test_10_directphy_f_0_rx_serial_data.rx_serial_data
			ftile_xcvr_test_10_directphy_f_0_rx_serial_data_n_rx_serial_data_n => CONNECTED_TO_ftile_xcvr_test_10_directphy_f_0_rx_serial_data_n_rx_serial_data_n, -- ftile_xcvr_test_10_directphy_f_0_rx_serial_data_n.rx_serial_data_n
			ftile_xcvr_test_11_directphy_f_0_tx_serial_data_tx_serial_data     => CONNECTED_TO_ftile_xcvr_test_11_directphy_f_0_tx_serial_data_tx_serial_data,     --   ftile_xcvr_test_11_directphy_f_0_tx_serial_data.tx_serial_data
			ftile_xcvr_test_11_directphy_f_0_tx_serial_data_n_tx_serial_data_n => CONNECTED_TO_ftile_xcvr_test_11_directphy_f_0_tx_serial_data_n_tx_serial_data_n, -- ftile_xcvr_test_11_directphy_f_0_tx_serial_data_n.tx_serial_data_n
			ftile_xcvr_test_11_directphy_f_0_rx_serial_data_rx_serial_data     => CONNECTED_TO_ftile_xcvr_test_11_directphy_f_0_rx_serial_data_rx_serial_data,     --   ftile_xcvr_test_11_directphy_f_0_rx_serial_data.rx_serial_data
			ftile_xcvr_test_11_directphy_f_0_rx_serial_data_n_rx_serial_data_n => CONNECTED_TO_ftile_xcvr_test_11_directphy_f_0_rx_serial_data_n_rx_serial_data_n, -- ftile_xcvr_test_11_directphy_f_0_rx_serial_data_n.rx_serial_data_n
			ftile_xcvr_test_2_directphy_f_0_tx_serial_data_tx_serial_data      => CONNECTED_TO_ftile_xcvr_test_2_directphy_f_0_tx_serial_data_tx_serial_data,      --    ftile_xcvr_test_2_directphy_f_0_tx_serial_data.tx_serial_data
			ftile_xcvr_test_2_directphy_f_0_tx_serial_data_n_tx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_2_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  --  ftile_xcvr_test_2_directphy_f_0_tx_serial_data_n.tx_serial_data_n
			ftile_xcvr_test_2_directphy_f_0_rx_serial_data_rx_serial_data      => CONNECTED_TO_ftile_xcvr_test_2_directphy_f_0_rx_serial_data_rx_serial_data,      --    ftile_xcvr_test_2_directphy_f_0_rx_serial_data.rx_serial_data
			ftile_xcvr_test_2_directphy_f_0_rx_serial_data_n_rx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_2_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  --  ftile_xcvr_test_2_directphy_f_0_rx_serial_data_n.rx_serial_data_n
			ftile_xcvr_test_3_directphy_f_0_tx_serial_data_tx_serial_data      => CONNECTED_TO_ftile_xcvr_test_3_directphy_f_0_tx_serial_data_tx_serial_data,      --    ftile_xcvr_test_3_directphy_f_0_tx_serial_data.tx_serial_data
			ftile_xcvr_test_3_directphy_f_0_tx_serial_data_n_tx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_3_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  --  ftile_xcvr_test_3_directphy_f_0_tx_serial_data_n.tx_serial_data_n
			ftile_xcvr_test_3_directphy_f_0_rx_serial_data_rx_serial_data      => CONNECTED_TO_ftile_xcvr_test_3_directphy_f_0_rx_serial_data_rx_serial_data,      --    ftile_xcvr_test_3_directphy_f_0_rx_serial_data.rx_serial_data
			ftile_xcvr_test_3_directphy_f_0_rx_serial_data_n_rx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_3_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  --  ftile_xcvr_test_3_directphy_f_0_rx_serial_data_n.rx_serial_data_n
			ftile_xcvr_test_4_directphy_f_0_tx_serial_data_tx_serial_data      => CONNECTED_TO_ftile_xcvr_test_4_directphy_f_0_tx_serial_data_tx_serial_data,      --    ftile_xcvr_test_4_directphy_f_0_tx_serial_data.tx_serial_data
			ftile_xcvr_test_4_directphy_f_0_tx_serial_data_n_tx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_4_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  --  ftile_xcvr_test_4_directphy_f_0_tx_serial_data_n.tx_serial_data_n
			ftile_xcvr_test_4_directphy_f_0_rx_serial_data_rx_serial_data      => CONNECTED_TO_ftile_xcvr_test_4_directphy_f_0_rx_serial_data_rx_serial_data,      --    ftile_xcvr_test_4_directphy_f_0_rx_serial_data.rx_serial_data
			ftile_xcvr_test_4_directphy_f_0_rx_serial_data_n_rx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_4_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  --  ftile_xcvr_test_4_directphy_f_0_rx_serial_data_n.rx_serial_data_n
			ftile_xcvr_test_5_directphy_f_0_tx_serial_data_tx_serial_data      => CONNECTED_TO_ftile_xcvr_test_5_directphy_f_0_tx_serial_data_tx_serial_data,      --    ftile_xcvr_test_5_directphy_f_0_tx_serial_data.tx_serial_data
			ftile_xcvr_test_5_directphy_f_0_tx_serial_data_n_tx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_5_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  --  ftile_xcvr_test_5_directphy_f_0_tx_serial_data_n.tx_serial_data_n
			ftile_xcvr_test_5_directphy_f_0_rx_serial_data_rx_serial_data      => CONNECTED_TO_ftile_xcvr_test_5_directphy_f_0_rx_serial_data_rx_serial_data,      --    ftile_xcvr_test_5_directphy_f_0_rx_serial_data.rx_serial_data
			ftile_xcvr_test_5_directphy_f_0_rx_serial_data_n_rx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_5_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  --  ftile_xcvr_test_5_directphy_f_0_rx_serial_data_n.rx_serial_data_n
			ftile_xcvr_test_6_directphy_f_0_tx_serial_data_tx_serial_data      => CONNECTED_TO_ftile_xcvr_test_6_directphy_f_0_tx_serial_data_tx_serial_data,      --    ftile_xcvr_test_6_directphy_f_0_tx_serial_data.tx_serial_data
			ftile_xcvr_test_6_directphy_f_0_tx_serial_data_n_tx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_6_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  --  ftile_xcvr_test_6_directphy_f_0_tx_serial_data_n.tx_serial_data_n
			ftile_xcvr_test_6_directphy_f_0_rx_serial_data_rx_serial_data      => CONNECTED_TO_ftile_xcvr_test_6_directphy_f_0_rx_serial_data_rx_serial_data,      --    ftile_xcvr_test_6_directphy_f_0_rx_serial_data.rx_serial_data
			ftile_xcvr_test_6_directphy_f_0_rx_serial_data_n_rx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_6_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  --  ftile_xcvr_test_6_directphy_f_0_rx_serial_data_n.rx_serial_data_n
			ftile_xcvr_test_7_directphy_f_0_tx_serial_data_tx_serial_data      => CONNECTED_TO_ftile_xcvr_test_7_directphy_f_0_tx_serial_data_tx_serial_data,      --    ftile_xcvr_test_7_directphy_f_0_tx_serial_data.tx_serial_data
			ftile_xcvr_test_7_directphy_f_0_tx_serial_data_n_tx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_7_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  --  ftile_xcvr_test_7_directphy_f_0_tx_serial_data_n.tx_serial_data_n
			ftile_xcvr_test_7_directphy_f_0_rx_serial_data_rx_serial_data      => CONNECTED_TO_ftile_xcvr_test_7_directphy_f_0_rx_serial_data_rx_serial_data,      --    ftile_xcvr_test_7_directphy_f_0_rx_serial_data.rx_serial_data
			ftile_xcvr_test_7_directphy_f_0_rx_serial_data_n_rx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_7_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  --  ftile_xcvr_test_7_directphy_f_0_rx_serial_data_n.rx_serial_data_n
			ftile_xcvr_test_8_directphy_f_0_tx_serial_data_tx_serial_data      => CONNECTED_TO_ftile_xcvr_test_8_directphy_f_0_tx_serial_data_tx_serial_data,      --    ftile_xcvr_test_8_directphy_f_0_tx_serial_data.tx_serial_data
			ftile_xcvr_test_8_directphy_f_0_tx_serial_data_n_tx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_8_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  --  ftile_xcvr_test_8_directphy_f_0_tx_serial_data_n.tx_serial_data_n
			ftile_xcvr_test_8_directphy_f_0_rx_serial_data_rx_serial_data      => CONNECTED_TO_ftile_xcvr_test_8_directphy_f_0_rx_serial_data_rx_serial_data,      --    ftile_xcvr_test_8_directphy_f_0_rx_serial_data.rx_serial_data
			ftile_xcvr_test_8_directphy_f_0_rx_serial_data_n_rx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_8_directphy_f_0_rx_serial_data_n_rx_serial_data_n,  --  ftile_xcvr_test_8_directphy_f_0_rx_serial_data_n.rx_serial_data_n
			ftile_xcvr_test_9_directphy_f_0_tx_serial_data_tx_serial_data      => CONNECTED_TO_ftile_xcvr_test_9_directphy_f_0_tx_serial_data_tx_serial_data,      --    ftile_xcvr_test_9_directphy_f_0_tx_serial_data.tx_serial_data
			ftile_xcvr_test_9_directphy_f_0_tx_serial_data_n_tx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_9_directphy_f_0_tx_serial_data_n_tx_serial_data_n,  --  ftile_xcvr_test_9_directphy_f_0_tx_serial_data_n.tx_serial_data_n
			ftile_xcvr_test_9_directphy_f_0_rx_serial_data_rx_serial_data      => CONNECTED_TO_ftile_xcvr_test_9_directphy_f_0_rx_serial_data_rx_serial_data,      --    ftile_xcvr_test_9_directphy_f_0_rx_serial_data.rx_serial_data
			ftile_xcvr_test_9_directphy_f_0_rx_serial_data_n_rx_serial_data_n  => CONNECTED_TO_ftile_xcvr_test_9_directphy_f_0_rx_serial_data_n_rx_serial_data_n   --  ftile_xcvr_test_9_directphy_f_0_rx_serial_data_n.rx_serial_data_n
		);

