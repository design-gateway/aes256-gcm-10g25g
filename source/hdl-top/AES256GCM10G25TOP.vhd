----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     AES256GCM10G25GTOP.vhd
-- Title        Top
--
-- Company      Design Gateway Co., Ltd.
-- Project      AES256GCM10G25GIP
-- PJ No.       
-- Syntax       VHDL
-- Note         
--
-- Version      1.00
-- Author       Pahol S.
-- Date         3/Nov/2023
-- Remark       New Creation
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity AES256GCM10G25GTOP is
    port
    (
        ExtRstIn : in std_logic;
        ExtClkP  : in std_logic;
        ExtClkN  : in std_logic;

        LED      : out std_logic_vector(3 downto 0)
    );
end entity AES256GCM10G25GTOP;
architecture rtl of AES256GCM10G25GTOP is
----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------
    component AES256GCM10G25GDemo is
    port
    (
        ExtRstB : in std_logic; -- extenal Reset, Active Low
        Clk     : in std_logic;

        LED     : out std_logic_vector(2 downto 0)
    );
    end component AES256GCM10G25GDemo;

    component clk_wiz_0 is
    port
    (
        Reset     : in std_logic;
        Clk_in1_p : in std_logic;
        Clk_in1_n : in std_logic;

        Clk_out1  : out std_logic;
        Locked    : out std_logic
    );
    end component clk_wiz_0;
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
    signal ExtRstB : std_logic;
    signal IPClk   : std_logic;
begin
----------------------------------------------------------------------------------
-- Component mapping 
----------------------------------------------------------------------------------
    LED(3) <= ExtRstB;

    c_clk_wiz_0 : clk_wiz_0
    port map
    (
        Reset     => ExtRstIn,
        Clk_in1_p => ExtClkP,
        Clk_in1_n => ExtClkN,

        Clk_out1  => IPClk,
        Locked    => ExtRstB
    );

    c_AES256GCM10G25GDemo : AES256GCM10G25GDemo
    port map
    (
        ExtRstB => ExtRstB,
    
        Clk     => IPClk,
        LED     => LED(2 downto 0)
    );

end architecture rtl;
