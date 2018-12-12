module SPARE(Clk, nReset, scen, tst_mode, si, so, enable,test,dataout,datain,ff_datain, ff_dataout);
input           Clk;
input           nReset;
input           scen;
input   [9:0]   tst_mode;
input           si;
output          so;
output          enable;
output          test;
output  [7:0]   dataout;
input   [7:0]   datain;
input   [9:0]  ff_datain;
output  [9:0]  ff_dataout;


GNDTIE  gt___0(.O(enable));
VDDTIE  vt___0(.O(test));

assign so = ff_dataout[9];

//assign [9:0] sc_en = {scen, scen, scen, scen, scen, scen, scen, scen};
//assign [9:0] nRes   = {nReset, nReset, nReset, nReset, nReset, nReset, nReset, nReset};
//assign [9:0] ClkIn = {Clk, Clk, Clk, Clk, Clk, Clk, Clk};

DFCRLQ  I_DFCRLQ_7(.S1(tst_mode[7]), .D0(ff_dataout[7]), .D1(ff_datain[7]), .SCEN(scen), .SCIN(ff_dataout[6]), .C(Clk), .RB(nReset), .Q(ff_dataout[7]));
DFCRLQ  I_DFCRLQ_6(.S1(tst_mode[6]), .D0(ff_dataout[6]), .D1(ff_datain[6]), .SCEN(scen), .SCIN(ff_dataout[5]), .C(Clk), .RB(nReset), .Q(ff_dataout[6]));
DFCRLQ  I_DFCRLQ_5(.S1(tst_mode[5]), .D0(ff_dataout[5]), .D1(ff_datain[5]), .SCEN(scen), .SCIN(ff_dataout[4]), .C(Clk), .RB(nReset), .Q(ff_dataout[5]));
DFCRLQ  I_DFCRLQ_4(.S1(tst_mode[4]), .D0(ff_dataout[4]), .D1(ff_datain[4]), .SCEN(scen), .SCIN(ff_dataout[3]), .C(Clk), .RB(nReset), .Q(ff_dataout[4]));
DFCRLQ  I_DFCRLQ_3(.S1(tst_mode[3]), .D0(ff_dataout[3]), .D1(ff_datain[3]), .SCEN(scen), .SCIN(ff_dataout[2]), .C(Clk), .RB(nReset), .Q(ff_dataout[3]));
DFCRLQ  I_DFCRLQ_2(.S1(tst_mode[2]), .D0(ff_dataout[2]), .D1(ff_datain[2]), .SCEN(scen), .SCIN(ff_dataout[1]), .C(Clk), .RB(nReset), .Q(ff_dataout[2]));
DFCRLQ  I_DFCRLQ_1(.S1(tst_mode[1]), .D0(ff_dataout[1]), .D1(ff_datain[1]), .SCEN(scen), .SCIN(ff_dataout[0]), .C(Clk), .RB(nReset), .Q(ff_dataout[1]));
DFCRLQ  I_DFCRLQ_0(.S1(tst_mode[0]), .D0(ff_dataout[0]), .D1(ff_datain[0]), .SCEN(scen), .SCIN(si), .C(Clk), .RB(nReset), .Q(ff_dataout[0]));

DFCSLQ  I_DFCSLQ_1(.S1(tst_mode[9]), .D0(ff_dataout[9]), .D1(ff_datain[9]), .SCEN(scen), .SCIN(ff_dataout[8]), .C(Clk), .SB(nReset) ,. Q(ff_dataout[9]));
DFCSLQ  I_DFCSLQ_0(.S1(tst_mode[8]), .D0(ff_dataout[8]), .D1(ff_datain[8]), .SCEN(scen), .SCIN(ff_dataout[7]), .C(Clk), .SB(nReset) ,. Q(ff_dataout[8]));

BF2     bf_000(.A(datain[0]) , .O(net_000));
BF2     bf_001(.A(datain[1]) , .O(net_001));
BF2     bf_002(.A(datain[2]) , .O(net_002));
BF2     bf_003(.A(datain[3]) , .O(net_003));
BF2     bf_004(.A(datain[4]) , .O(net_004));
BF2     bf_005(.A(datain[5]) , .O(net_005));
BF2     bf_006(.A(datain[6]) , .O(net_006));
BF2     bf_007(.A(datain[7]) , .O(net_007));

AND2    an_100(.A(net_000), .B(net_001), .O(net_100));
AND2    an_101(.A(net_001), .B(net_002), .O(net_101));
AND2    an_102(.A(net_002), .B(net_003), .O(net_102));
AND4    an_103(.A(net_003), .B(net_004), .C(net_005), .D(net_006), .O(net_103));

OR2     an_104(.A(net_004), .B(net_005), .O(net_104));
OR2     an_105(.A(net_005), .B(net_006), .O(net_105));
OR2     an_106(.A(net_006), .B(net_007), .O(net_106));
OR4     an_107(.A(net_007), .B(net_000), .C(net_001), .D(net_002), .O(net_107));

AND22O  an_200(.A(net_000), .B(net_007), .C(net_100), .D(net_107), .O(net_200));
AND22O  an_201(.A(net_001), .B(net_006), .C(net_101), .D(net_106), .O(net_201));
AND22O  an_202(.A(net_002), .B(net_005), .C(net_102), .D(net_105), .O(net_202));
AND22O  an_203(.A(net_003), .B(net_004), .C(net_103), .D(net_104), .O(net_203));
OR22A   an_204(.A(net_004), .B(net_003), .C(net_104), .D(net_103), .O(net_204));
OR22A   an_205(.A(net_005), .B(net_002), .C(net_105), .D(net_102), .O(net_205));
OR22A   an_206(.A(net_006), .B(net_001), .C(net_106), .D(net_101), .O(net_206));
OR22A   an_207(.A(net_007), .B(net_000), .C(net_107), .D(net_100), .O(net_207));

AND222O an_300(.A(net_000), .B(net_007), .C(net_100), .D(net_105), .E(net_200), .F(net_205), .O(net_300));
AND222O an_301(.A(net_001), .B(net_006), .C(net_101), .D(net_104), .E(net_201), .F(net_204), .O(net_301));
NAND6   an_302(.A(net_002), .B(net_005), .C(net_102), .D(net_107), .E(net_202), .F(net_207), .O(net_302));
NAND6   an_303(.A(net_003), .B(net_004), .C(net_103), .D(net_106), .E(net_203), .F(net_206), .O(net_303));
NOR5    an_304(.A(net_004), .B(net_003), .C(net_104), .D(net_100), .E(net_204), .O(net_304));
NOR5    an_305(.A(net_005), .B(net_002), .C(net_105), .D(net_101), .E(net_205), .O(net_305));
OR222A  an_306(.A(net_006), .B(net_001), .C(net_106), .D(net_103), .E(net_206), .F(net_201), .O(net_306));
OR222A  an_307(.A(net_007), .B(net_000), .C(net_107), .D(net_102), .E(net_207), .F(net_200), .O(net_307));

EXOR    an_400(.A(net_000), .B(net_307), .O(net_400));
EXOR    an_401(.A(net_001), .B(net_306), .O(net_401));
EXNOR   an_402(.A(net_002), .B(net_305), .O(net_402));
MUX21   an_403(.A(net_003), .B(net_304), .SA(net_004), .O(net_403));
MUX21   an_404(.A(net_004), .B(net_303), .SA(net_003), .O(net_404));
MUX21   an_405(.A(net_005), .B(net_302), .SA(net_002), .O(net_405));
NOR2    an_406(.A(net_006), .B(net_301), .O(net_406));
NAND2   an_407(.A(net_007), .B(net_300), .O(net_407));

INV2    an_500(.A(net_400), .O(dataout[0]));
INV2    an_501(.A(net_401), .O(dataout[1]));
INV2    an_502(.A(net_402), .O(dataout[2]));
INV4    an_503(.A(net_403), .O(dataout[3]));
INV4    an_504(.A(net_404), .O(dataout[4]));
INV4    an_505(.A(net_405), .O(dataout[5]));
BF4     an_506(.A(net_406), .O(dataout[6]));
BF4     an_507(.A(net_407), .O(dataout[7]));

endmodule

