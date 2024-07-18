----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     AES256GCM10G25GDemo.vhd
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

entity AES256GCM10G25GDemo is
    port
    (
        ExtRstB : in std_logic; -- extenal Reset, Active Low
        Clk     : in std_logic;

        LED     : out std_logic_vector(2 downto 0)
    );
end entity AES256GCM10G25GDemo;
architecture rtl of AES256GCM10G25GDemo is
----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------
    component AES256GCM10G25G is
    port
    (
        version      : out std_logic_vector(31 downto 0);

        RstB         : in std_logic;
        Clk          : in std_logic;

        KeyInValid   : in std_logic;
        KeyInBusy    : out std_logic;
        KeyInFinish  : out std_logic;
        KeyIn        : in std_logic_vector(255 downto 0);

        Start        : in std_logic;
        Busy         : out std_logic;
        Finish       : out std_logic;
        DecryptionEn : in std_logic;
        Bypass       : in std_logic;
        IvIn         : in std_logic_vector(95 downto 0);
        AadInCount   : in std_logic_vector(15 downto 0);
        DataInCount  : in std_logic_vector(15 downto 0);

        DataInRd     : out std_logic;
        DataIn       : in std_logic_vector(127 downto 0);

        DataOutValid : out std_logic;
        DataOut      : out std_logic_vector(127 downto 0);
        TagOutValid  : out std_logic;
        TagOut       : out std_logic_vector(127 downto 0)
    );
    end component AES256GCM10G25G;
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
    signal rExtRstBCnt     : std_logic_vector(20 downto 0);
    signal RstB            : std_logic;

    signal KeyInBusyEnc    : std_logic;
    signal KeyInFinishEnc  : std_logic;
    signal KeyInEnc        : std_logic_vector(255 downto 0);
    signal BusyEnc         : std_logic;
    signal FinishEnc       : std_logic;
    signal DecryptionEnEnc : std_logic;
    signal BypassEnc       : std_logic;
    signal IvInEnc         : std_logic_vector(95 downto 0);
    signal AadInCountEnc   : std_logic_vector(15 downto 0);
    signal DataInCountEnc  : std_logic_vector(15 downto 0);
    signal DataInRdEnc     : std_logic;
    signal DataInEnc       : std_logic_vector(127 downto 0);
    signal DataOutValidEnc : std_logic;
    signal DataOutEnc      : std_logic_vector(127 downto 0);
    signal TagOutValidEnc  : std_logic;
    signal TagOutEnc       : std_logic_vector(127 downto 0);

    signal KeyInBusyDec    : std_logic;
    signal KeyInFinishDec  : std_logic;
    signal KeyInDec        : std_logic_vector(255 downto 0);
    signal BusyDec         : std_logic;
    signal FinishDec       : std_logic;
    signal DecryptionEnDec : std_logic;
    signal BypassDec       : std_logic;
    signal IvInDec         : std_logic_vector(95 downto 0);
    signal AadInCountDec   : std_logic_vector(15 downto 0);
    signal DataInCountDec  : std_logic_vector(15 downto 0);
    signal DataInRdDec     : std_logic;
    signal DataInDec       : std_logic_vector(127 downto 0);
    signal DataOutValidDec : std_logic;
    signal DataOutDec      : std_logic_vector(127 downto 0);
    signal TagOutValidDec  : std_logic;
    signal TagOutDec       : std_logic_vector(127 downto 0);

    signal rKeyInValid     : std_logic;
    signal rCounter        : std_logic_vector(31 downto 0);
    signal PatternIn       : std_logic_vector(127 downto 0);
    signal rCounter1       : std_logic_vector(31 downto 0);
    signal rCounter2       : std_logic_vector(31 downto 0);
    signal rCounter3       : std_logic_vector(31 downto 0);
    signal rCounter4       : std_logic_vector(31 downto 0);
    signal VerifyOut       : std_logic_vector(127 downto 0);
    signal rWrong          : std_logic;

    signal rTestCnt        : std_logic_vector(15 downto 0);
    signal rStartEnc       : std_logic;
    signal rStartDec       : std_logic;
    signal rStartEnc1      : std_logic;
    signal rStartDec1      : std_logic;
    signal rIpRunning      : std_logic;

    signal rTagOutEnc1     : std_logic_vector(127 downto 0);
    signal rTagOutEnc2     : std_logic_vector(127 downto 0);
    signal rTagWrong       : std_logic;
begin
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
    LED <= rIpRunning & rWrong & rTagWrong;
----------------------------------------------------------------------------------
-- Component mapping 
----------------------------------------------------------------------------------
    c_AES256GCM10G25GEnc : AES256GCM10G25G
    port map
    (
        version      => open,

        RstB         => RstB,
        Clk          => Clk,

        KeyInValid   => rKeyInValid,
        KeyInBusy    => KeyInBusyEnc,
        KeyInFinish  => KeyInFinishEnc,
        KeyIn        => KeyInEnc,

        Start        => rStartEnc,
        Busy         => BusyEnc,
        Finish       => FinishEnc,
        DecryptionEn => DecryptionEnEnc,
        Bypass       => BypassEnc,
        IvIn         => IvInEnc,
        AadInCount   => AadInCountEnc,
        DataInCount  => DataInCountEnc,

        DataInRd     => DataInRdEnc,
        DataIn       => DataInEnc,

        DataOutValid => DataOutValidEnc,
        DataOut      => DataOutEnc,
        TagOutValid  => TagOutValidEnc,
        TagOut       => TagOutEnc
    );

    PatternIn       <= rCounter & rCounter & rCounter & rCounter;
    VerifyOut       <= rCounter4 & rCounter4 & rCounter4 & rCounter4;
    -- Encryption Parameter
    KeyInEnc        <= x"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f";
    DecryptionEnEnc <= '0';
    BypassEnc       <= '0';
    IvInEnc         <= x"00112233445566778899aabb";
    AadInCountEnc   <= x"0040";
    DataInCountEnc  <= x"1000";
    DataInEnc       <= PatternIn;
    -- Decryption Parameter
    KeyInDec        <= x"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f";
    DecryptionEnDec <= '1';
    BypassDec       <= '0';
    IvInDec         <= x"00112233445566778899aabb";
    AadInCountDec   <= x"0040";
    DataInCountDec  <= x"1000";
    DataInDec       <= DataOutEnc;

    c_AES256GCM10G25GDec : AES256GCM10G25G
    port map
    (
        version      => open,
        
        RstB         => RstB,
        Clk          => Clk,
        
        KeyInValid   => rKeyInValid,
        KeyInBusy    => KeyInBusyDec,
        KeyInFinish  => KeyInFinishDec,
        KeyIn        => KeyInDec,
        
        Start        => rStartDec,
        Busy         => BusyDec,
        Finish       => FinishDec,
        DecryptionEn => DecryptionEnDec,
        Bypass       => BypassDec,
        IvIn         => IvInDec,
        AadInCount   => AadInCountDec,
        DataInCount  => DataInCountDec,
        
        DataInRd     => DataInRdDec,
        DataIn       => DataInDec,
        
        DataOutValid => DataOutValidDec,
        DataOut      => DataOutDec,
        TagOutValid  => TagOutValidDec,
        TagOut       => TagOutDec
    );
----------------------------------------------------------------------------------
-- Logics 
----------------------------------------------------------------------------------
    u_rExtRstBCnt : process (Clk) is
    begin
        if (rising_edge(Clk)) then
            if (ExtRstB = '0') then
                rExtRstBCnt(20 downto 0) <= (others => '0');
            else
                -- Use bit20 to debounce about 10 ms (Clk = 100 MHz)
                if (rExtRstBCnt(20) = '0') then
                    rExtRstBCnt(20 downto 0) <= rExtRstBCnt(20 downto 0) + 1;
                else
                    rExtRstBCnt(20 downto 0) <= rExtRstBCnt(20 downto 0);
                end if;
            end if;
        end if;
    end process u_rExtRstBCnt;

    RstB <= rExtRstBCnt(20);

    p_Enc : process (Clk) is
    begin
        if (rising_edge(Clk)) then
            rCounter4 <= rCounter3;
            rCounter3 <= rCounter2;
            rCounter2 <= rCounter1;
            rCounter1 <= rCounter;
            if (RstB = '0') then
                rCounter <= (others => '0');
            else
                rCounter <= rCounter + 1;
            end if;

            if (RstB = '0') then
                rTestCnt <= (others => '0');
            else
                if (rTestCnt = x"0202") then
                    rTestCnt <= (others => '0');
                else
                    rTestCnt <= rTestCnt + 1;
                end if;
            end if;

            if (RstB = '0') then
                rKeyInValid <= '0';
            else
                if (rTestCnt = 2) then
                    rKeyInValid <= '1';
                else
                    rKeyInValid <= '0';
                end if;
            end if;

            rStartEnc1  <=  rStartEnc;
            if (RstB = '0') then
                rStartEnc <= '0';
            else
                if (rTestCnt = x"0028") then
                    rStartEnc <= '1';
                else
                    rStartEnc <= '0';
                end if;
            end if;

            rStartDec1  <=  rStartDec;
            if (RstB = '0') then
                rStartDec <= '0';
            else
                if (rTestCnt = x"002A") then
                    rStartDec <= '1';
                else
                    rStartDec <= '0';
                end if;
            end if;

            -- To detect IP Core still running, after 'InitStart' is actived, 'Busy' must be actived.
            if ( RstB='0' ) then
                rIpRunning  <=  '0';
            else
                if ( rStartEnc1='1' ) then
                    if ( BusyEnc='1' ) then
                        rIpRunning  <=  '1';
                    else
                        rIpRunning  <=  '0';
                    end if;
                elsif ( rStartDec1='1' ) then
                    if ( BusyDec='1' ) then
                        rIpRunning  <=  '1';
                    else
                        rIpRunning  <=  '0';
                    end if;
                else
                    rIpRunning  <=  rIpRunning;
                end if;
            end if;

            if (RstB = '0') then
                rWrong <= '0';
            else
                if (DataOutValidDec = '1') then
                    if (not(DataOutDec = VerifyOut)) then
                        rWrong <= '1';
                    else
                        rWrong <= rWrong;
                    end if;
                else
                    rWrong <= rWrong;
                end if;
            end if;

            rTagOutEnc2 <= rTagOutEnc1;
            rTagOutEnc1 <= TagOutEnc;

            if (RstB = '0') then
                rTagWrong <= '0';
            else
                if (TagOutValidDec = '1') then
                    if (not(TagOutDec = rTagOutEnc2)) then
                        rTagWrong <= '1';
                    else
                        rTagWrong <= rTagWrong;
                    end if;
                else
                    rTagWrong <= rTagWrong;
                end if;
            end if;

        end if;
    end process p_Enc;

end architecture rtl;
