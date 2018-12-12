
// Generated by Cadence Genus(TM) Synthesis Solution 17.22-s017_1
// Generated on: Nov  8 2018 13:47:59 CET (Nov  8 2018 12:47:59 UTC)

// Verification Directory fv/permut_sel_aio 

module permut_sel_aio(clk, resn, en, sel, ready, init, amp_enable,
     cout);
  input clk, resn, en;
  input [15:0] sel;
  output ready, init, amp_enable;
  output [7:0] cout;
  wire clk, resn, en;
  wire [15:0] sel;
  wire ready, init, amp_enable;
  wire [7:0] cout;
  wire [15:0] swp_cnt;
  wire [2:0] \array[5] ;
  wire [2:0] \array[1] ;
  wire [2:0] \array[2] ;
  wire [2:0] \array[3] ;
  wire [2:0] \array[6] ;
  wire [2:0] \array[4] ;
  wire [2:0] \array[0] ;
  wire [2:0] \c[1] ;
  wire [2:0] \c[2] ;
  wire [2:0] \c[3] ;
  wire [2:0] \array[7] ;
  wire [2:0] \c[7] ;
  wire [2:0] \c[5] ;
  wire [3:0] i;
  wire [2:0] \c[4] ;
  wire [2:0] \c[6] ;
  wire [7:0] stepcount;
  wire [7:0] cout_r;
  wire [7:0] next_state;
  wire [7:0] state;
  wire UNCONNECTED, UNCONNECTED0, UNCONNECTED1, n_0, n_2, n_3, n_4, n_6;
  wire n_7, n_10, n_15, n_20, n_25, n_29, n_31, n_32;
  wire n_33, n_34, n_38, n_39, n_40, n_43, n_44, n_45;
  wire n_46, n_47, n_48, n_49, n_51, n_53, n_54, n_56;
  wire n_57, n_58, n_59, n_60, n_61, n_62, n_63, n_64;
  wire n_65, n_66, n_67, n_68, n_69, n_70, n_71, n_72;
  wire n_73, n_75, n_76, n_77, n_78, n_79, n_81, n_82;
  wire n_83, n_84, n_86, n_87, n_89, n_90, n_91, n_93;
  wire n_94, n_95, n_96, n_97, n_98, n_99, n_101, n_102;
  wire n_103, n_104, n_105, n_106, n_107, n_108, n_109, n_110;
  wire n_111, n_112, n_113, n_114, n_115, n_116, n_117, n_118;
  wire n_119, n_120, n_121, n_122, n_123, n_124, n_125, n_126;
  wire n_127, n_128, n_129, n_130, n_132, n_133, n_135, n_136;
  wire n_137, n_138, n_139, n_140, n_141, n_142, n_143, n_144;
  wire n_145, n_146, n_147, n_148, n_149, n_150, n_151, n_152;
  wire n_153, n_154, n_155, n_156, n_157, n_158, n_159, n_160;
  wire n_161, n_163, n_164, n_165, n_166, n_167, n_168, n_169;
  wire n_170, n_171, n_172, n_173, n_174, n_175, n_176, n_177;
  wire n_178, n_179, n_180, n_181, n_182, n_183, n_184, n_185;
  wire n_186, n_187, n_188, n_189, n_190, n_191, n_192, n_193;
  wire n_194, n_195, n_196, n_197, n_198, n_199, n_200, n_201;
  wire n_202, n_203, n_204, n_205, n_206, n_207, n_208, n_209;
  wire n_210, n_211, n_212, n_213, n_214, n_215, n_216, n_217;
  wire n_218, n_219, n_220, n_221, n_222, n_223, n_224, n_225;
  wire n_226, n_227, n_228, n_229, n_230, n_231, n_233, n_234;
  wire n_235, n_236, n_237, n_238, n_239, n_240, n_241, n_242;
  wire n_243, n_244, n_245, n_246, n_247, n_248, n_249, n_250;
  wire n_251, n_252, n_253, n_254, n_255, n_259, n_260, n_261;
  wire n_263, n_264, n_265, n_266, n_267, n_268, n_269, n_270;
  wire n_271, n_272, n_273, n_274, n_275, n_276, n_277, n_278;
  wire n_279, n_280, n_281, n_282, n_283, n_284, n_285, n_286;
  wire n_287, n_288, n_289, n_290, n_291, n_292, n_293, n_294;
  wire n_295, n_296, n_297, n_298, n_299, n_300, n_301, n_302;
  wire n_303, n_304, n_305, n_306, n_307, n_308, n_309, n_310;
  wire n_311, n_312, n_313, n_314, n_315, n_316, n_317, n_318;
  wire n_319, n_320, n_321, n_322, n_323, n_324, n_325, n_327;
  wire n_328, n_330, n_331, n_332, n_334, n_335, n_336, n_337;
  wire n_338, n_339, n_340, n_341, n_342, n_343, n_344, n_345;
  wire n_346, n_347, n_348, n_349, n_350, n_351, n_352, n_353;
  wire n_354, n_355, n_356, n_357, n_358, n_359, n_360, n_361;
  wire n_362, n_363, n_364, n_365, n_366, n_367, n_368, n_370;
  wire n_371, n_372, n_373, n_374, n_375, n_376, n_379, n_380;
  wire n_381, n_382, n_383, n_384, n_385, n_386, n_387, n_388;
  wire n_389, n_390, n_391, n_392, n_393, n_394, n_395, n_397;
  wire n_398, n_399, n_400, n_401, n_402, n_403, n_404, n_405;
  wire n_406, n_407, n_408, n_409, n_410, n_411, n_412, n_413;
  wire n_414, n_416, n_417, n_418, n_419, n_420, n_421, n_422;
  wire n_423, n_424, n_425, n_427, n_428, n_429, n_430, n_431;
  wire n_432, n_433, n_435, n_436, n_438, n_439, n_440, n_441;
  wire n_442, n_462, n_463, n_464, n_465, n_486, n_487, n_488;
  wire n_489, n_490, n_491, n_492, ready_934;
  DFSH \swp_cnt_reg[15] (.C (clk), .D (n_442), .Q (swp_cnt[15]));
  DFSH \array_reg[5][2] (.C (clk), .D (n_441), .Q (\array[5] [2]));
  NOR2XL g13214__8780(.A (n_463), .B (n_361), .O (n_442));
  DFSH \array_reg[1][0] (.C (clk), .D (n_439), .Q (\array[1] [0]));
  DFSH \array_reg[2][1] (.C (clk), .D (n_440), .Q (\array[2] [1]));
  DFSH \array_reg[3][2] (.C (clk), .D (n_425), .Q (\array[3] [2]));
  DFSH \array_reg[3][0] (.C (clk), .D (n_429), .Q (\array[3] [0]));
  DFSH \array_reg[6][2] (.C (clk), .D (n_421), .Q (\array[6] [2]));
  DFSH \array_reg[1][2] (.C (clk), .D (n_433), .Q (\array[1] [2]));
  DFSH \array_reg[4][2] (.C (clk), .D (n_435), .Q (\array[4] [2]));
  DFSH \array_reg[5][0] (.C (clk), .D (n_432), .Q (\array[5] [0]));
  NAND2 g13242__4296(.A (n_436), .B (n_428), .O (n_441));
  DFSH \swp_cnt_reg[14] (.C (clk), .D (n_427), .Q (swp_cnt[14]));
  DFSH \array_reg[2][0] (.C (clk), .D (n_423), .Q (\array[2] [0]));
  DFSH \array_reg[2][2] (.C (clk), .D (n_422), .Q (\array[2] [2]));
  DFSH \array_reg[1][1] (.C (clk), .D (n_424), .Q (\array[1] [1]));
  DFSH \array_reg[6][1] (.C (clk), .D (n_430), .Q (\array[6] [1]));
  DFSH \array_reg[3][1] (.C (clk), .D (n_431), .Q (\array[3] [1]));
  NAND2 g13239__3772(.A (n_402), .B (n_438), .O (n_440));
  DFSH \array_reg[6][0] (.C (clk), .D (n_419), .Q (\array[6] [0]));
  DFSH \array_reg[4][1] (.C (clk), .D (n_413), .Q (\array[4] [1]));
  NAND2 g13225__1474(.A (n_417), .B (n_438), .O (n_439));
  DFSH \array_reg[5][1] (.C (clk), .D (n_420), .Q (\array[5] [1]));
  DFSH \array_reg[4][0] (.C (clk), .D (n_412), .Q (\array[4] [0]));
  AND222OXL g13266__9682(.A (n_410), .B (n_392), .C (n_391), .D
       (\array[5] [2]), .E (n_370), .F (n_390), .O (n_436));
  NAND2 g13240__2683(.A (n_386), .B (n_428), .O (n_435));
  INV g13238(.A (n_411), .O (n_433));
  NAND2 g13241__1309(.A (n_394), .B (n_428), .O (n_432));
  NAND2 g13224__6877(.A (n_376), .B (n_438), .O (n_431));
  NAND2 g13243__2900(.A (n_398), .B (n_428), .O (n_430));
  DFSH \swp_cnt_reg[7] (.C (clk), .D (n_389), .Q (swp_cnt[7]));
  NAND2 g13223__2391(.A (n_382), .B (n_428), .O (n_429));
  NOR2XL g13230__7675(.A (n_379), .B (n_361), .O (n_427));
  OR222AXL g13248__7118(.A (n_331), .B (n_106), .C (n_226), .D (n_288),
       .E (n_271), .F (n_486), .O (n_425));
  INV g13250(.A (n_418), .O (n_424));
  INV g13251(.A (n_409), .O (n_423));
  INV g13252(.A (n_407), .O (n_422));
  NAND2 g13229__8757(.A (n_400), .B (n_428), .O (n_421));
  INV g13262(.A (n_388), .O (n_420));
  INV g13261(.A (n_380), .O (n_419));
  DFSH \swp_cnt_reg[0] (.C (clk), .D (n_360), .Q (swp_cnt[0]));
  DFSH \swp_cnt_reg[11] (.C (clk), .D (n_362), .Q (swp_cnt[11]));
  DFSH \swp_cnt_reg[13] (.C (clk), .D (n_367), .Q (swp_cnt[13]));
  DFSH \array_reg[0][2] (.C (clk), .D (n_366), .Q (\array[0] [2]));
  DFSH \array_reg[0][0] (.C (clk), .D (n_363), .Q (\array[0] [0]));
  DFSH \array_reg[0][1] (.C (clk), .D (n_368), .Q (\array[0] [1]));
  AND222OXL g13255__1786(.A (n_387), .B (n_488), .C (n_416), .D
       (\array[1] [1]), .E (n_414), .F (n_401), .O (n_418));
  AND222OXL g13245__5953(.A (n_416), .B (\array[1] [0]), .C (n_393), .D
       (n_488), .E (n_414), .F (n_408), .O (n_417));
  INV g13249(.A (n_371), .O (n_413));
  INV g13253(.A (n_399), .O (n_412));
  AND222OXL g13244__5703(.A (n_416), .B (\array[1] [2]), .C (n_410), .D
       (n_488), .E (n_414), .F (n_405), .O (n_411));
  AND222OXL g13256__7114(.A (n_406), .B (n_408), .C (n_404), .D
       (\array[2] [0]), .E (n_403), .F (\array[0] [0]), .O (n_409));
  AND222OXL g13257__5266(.A (n_406), .B (n_405), .C (n_404), .D
       (\array[2] [2]), .E (n_403), .F (\array[0] [2]), .O (n_407));
  AND222OXL g13258__2250(.A (n_404), .B (\array[2] [1]), .C (n_406), .D
       (n_401), .E (n_403), .F (\array[0] [1]), .O (n_402));
  AND222OXL g13260__6083(.A (n_397), .B (\array[6] [2]), .C (n_487), .D
       (n_405), .E (n_395), .F (\array[0] [2]), .O (n_400));
  AND222OXL g13259__2703(.A (n_385), .B (n_408), .C (n_384), .D
       (\array[4] [0]), .E (n_383), .F (\array[0] [0]), .O (n_399));
  DFSH \c_reg[1][0] (.C (clk), .D (n_351), .Q (\c[1] [0]));
  DFSH \c_reg[2][1] (.C (clk), .D (n_349), .Q (\c[2] [1]));
  DFSH \c_reg[3][0] (.C (clk), .D (n_346), .Q (\c[3] [0]));
  DFSH \c_reg[2][0] (.C (clk), .D (n_350), .Q (\c[2] [0]));
  DFSH \c_reg[3][1] (.C (clk), .D (n_355), .Q (\c[3] [1]));
  DFSH \swp_cnt_reg[3] (.C (clk), .D (n_343), .Q (swp_cnt[3]));
  DFSH \array_reg[7][2] (.C (clk), .D (n_352), .Q (\array[7] [2]));
  DFSH \swp_cnt_reg[4] (.C (clk), .D (n_338), .Q (swp_cnt[4]));
  DFSH \array_reg[7][0] (.C (clk), .D (n_354), .Q (\array[7] [0]));
  DFSH \swp_cnt_reg[2] (.C (clk), .D (n_341), .Q (swp_cnt[2]));
  DFSH \swp_cnt_reg[5] (.C (clk), .D (n_339), .Q (swp_cnt[5]));
  DFSH \swp_cnt_reg[1] (.C (clk), .D (n_337), .Q (swp_cnt[1]));
  DFSH \swp_cnt_reg[9] (.C (clk), .D (n_359), .Q (swp_cnt[9]));
  AND222OXL g13268__5795(.A (n_397), .B (\array[6] [1]), .C (n_487), .D
       (n_401), .E (n_395), .F (\array[0] [1]), .O (n_398));
  AND222OXL g13264__7344(.A (n_393), .B (n_392), .C (n_391), .D
       (\array[5] [0]), .E (n_381), .F (n_390), .O (n_394));
  NOR2XL g13327__1840(.A (n_342), .B (n_361), .O (n_389));
  AND222OXL g13265__5019(.A (n_387), .B (n_392), .C (n_391), .D
       (\array[5] [1]), .E (n_373), .F (n_390), .O (n_388));
  AND222OXL g13267__1857(.A (n_385), .B (n_405), .C (n_384), .D
       (\array[4] [2]), .E (n_383), .F (\array[0] [2]), .O (n_386));
  AND222OXL g13246__9906(.A (n_375), .B (\array[3] [0]), .C (n_393), .D
       (n_374), .E (n_381), .F (n_372), .O (n_382));
  AND222OXL g13263__8780(.A (n_397), .B (\array[6] [0]), .C (n_487), .D
       (n_408), .E (n_395), .F (\array[0] [0]), .O (n_380));
  MUX21XL g13269__4296(.A (swp_cnt[14]), .B (n_336), .SA (n_265), .O
       (n_379));
  AND222OXL g13247__1474(.A (n_375), .B (\array[3] [1]), .C (n_387), .D
       (n_374), .E (n_373), .F (n_372), .O (n_376));
  AND222OXL g13254__4547(.A (n_385), .B (n_401), .C (n_384), .D
       (\array[4] [1]), .E (n_383), .F (\array[0] [1]), .O (n_371));
  DFSH \array_reg[7][1] (.C (clk), .D (n_353), .Q (\array[7] [1]));
  DFSH \swp_cnt_reg[12] (.C (clk), .D (n_357), .Q (swp_cnt[12]));
  DFSH \swp_cnt_reg[8] (.C (clk), .D (n_358), .Q (swp_cnt[8]));
  DFSH \swp_cnt_reg[6] (.C (clk), .D (n_340), .Q (swp_cnt[6]));
  DFSH \swp_cnt_reg[10] (.C (clk), .D (n_356), .Q (swp_cnt[10]));
  INV g13319(.A (n_486), .O (n_370));
  OR2N2AXL g13320__9682(.A (\array[0] [1]), .B (n_365), .C (n_364), .D
       (n_145), .O (n_368));
  NOR2XL g13325__2683(.A (n_334), .B (n_361), .O (n_367));
  OR2N2AXL g13329__1309(.A (\array[0] [2]), .B (n_365), .C (n_364), .D
       (n_147), .O (n_366));
  OR2N2AXL g13328__6877(.A (\array[0] [0]), .B (n_365), .C (n_364), .D
       (n_146), .O (n_363));
  NOR2XL g13326__2900(.A (n_465), .B (n_361), .O (n_362));
  NOR2XL g13335__2391(.A (n_330), .B (n_361), .O (n_360));
  NOR2XL g13322__7675(.A (n_321), .B (n_361), .O (n_359));
  NOR2XL g13321__7118(.A (n_320), .B (n_361), .O (n_358));
  NOR2XL g13324__8757(.A (n_324), .B (n_361), .O (n_357));
  NOR2XL g13323__1786(.A (n_323), .B (n_361), .O (n_356));
  DFSH \c_reg[7][0] (.C (clk), .D (n_293), .Q (\c[7] [0]));
  DFSH \c_reg[5][2] (.C (clk), .D (n_311), .Q (\c[5] [2]));
  DFSH \i_reg[3] (.C (clk), .D (n_312), .Q (i[3]));
  DFSH \c_reg[7][2] (.C (clk), .D (n_289), .Q (\c[7] [2]));
  DFSH \c_reg[4][1] (.C (clk), .D (n_307), .Q (\c[4] [1]));
  DFSH \c_reg[5][1] (.C (clk), .D (n_299), .Q (\c[5] [1]));
  DFSH \c_reg[6][1] (.C (clk), .D (n_297), .Q (\c[6] [1]));
  DFSH \c_reg[4][0] (.C (clk), .D (n_308), .Q (\c[4] [0]));
  DFSH \c_reg[5][0] (.C (clk), .D (n_302), .Q (\c[5] [0]));
  DFSH \c_reg[6][2] (.C (clk), .D (n_294), .Q (\c[6] [2]));
  DFSH \c_reg[6][0] (.C (clk), .D (n_298), .Q (\c[6] [0]));
  DFSH \c_reg[4][2] (.C (clk), .D (n_304), .Q (\c[4] [2]));
  DFSH \i_reg[1] (.C (clk), .D (n_322), .Q (i[1]));
  OR22AXL g13330__5953(.A (n_348), .B (n_344), .C (n_280), .D (n_361),
       .O (n_355));
  NAND2 g13331__5703(.A (n_310), .B (n_438), .O (n_354));
  NAND2 g13332__7114(.A (n_314), .B (n_438), .O (n_353));
  NAND2 g13333__5266(.A (n_318), .B (n_428), .O (n_352));
  NAND2AN g13334__2250(.A (n_488), .B (n_276), .O (n_351));
  OR22AXL g13336__6083(.A (n_345), .B (n_347), .C (n_279), .D (n_361),
       .O (n_350));
  OR22AXL g13337__2703(.A (n_348), .B (n_347), .C (n_283), .D (n_361),
       .O (n_349));
  OR22AXL g13338__5795(.A (n_345), .B (n_344), .C (n_281), .D (n_361),
       .O (n_346));
  NOR2XL g13302__7344(.A (n_317), .B (n_361), .O (n_343));
  AND32OXL g13352__1840(.A (n_238), .B (n_266), .C (n_235), .D
       (swp_cnt[7]), .E (n_265), .O (n_342));
  NOR2XL g13301__5019(.A (n_327), .B (n_361), .O (n_341));
  NOR2XL g13297__1857(.A (n_319), .B (n_361), .O (n_340));
  NOR2XL g13298__9906(.A (n_315), .B (n_361), .O (n_339));
  NOR2XL g13299__8780(.A (n_316), .B (n_361), .O (n_338));
  NOR2XL g13300__4296(.A (n_325), .B (n_361), .O (n_337));
  DFSH \c_reg[7][1] (.C (clk), .D (n_292), .Q (\c[7] [1]));
  HADD g13296__1474(.A (swp_cnt[14]), .B (n_269), .S (n_336), .C
       (n_335));
  MUX21XL g13373__4547(.A (n_270), .B (swp_cnt[13]), .SA (n_266), .O
       (n_334));
  NOR2ANXL g13339__9682(.A (n_408), .B (n_332), .O (n_381));
  NOR2ANXL g13340__2683(.A (n_401), .B (n_332), .O (n_373));
  NOR2XL g13342__1309(.A (n_332), .B (n_186), .O (n_414));
  DFSH \i_reg[2] (.C (clk), .D (n_282), .Q (i[2]));
  INV g13393(.A (n_375), .O (n_331));
  EXNORXL g13382__6877(.A (swp_cnt[0]), .B (n_266), .O (n_330));
  OR211AXL g13401__2391(.A (n_261), .B (n_20), .C (n_328), .D (n_187),
       .O (n_416));
  OR211AXL g13397__7675(.A (n_287), .B (n_165), .C (n_328), .D (n_195),
       .O (n_404));
  MUX21XL g13354__7118(.A (swp_cnt[2]), .B (n_123), .SA (n_265), .O
       (n_327));
  MUX21XL g13344__8757(.A (swp_cnt[1]), .B (n_49), .SA (n_265), .O
       (n_325));
  MUX21XL g13345__1786(.A (swp_cnt[12]), .B (n_255), .SA (n_265), .O
       (n_324));
  MUX21XL g13346__5953(.A (swp_cnt[10]), .B (n_252), .SA (n_265), .O
       (n_323));
  OR2N1A g13347__5703(.A (n_309), .B (i[1]), .C (n_274), .O (n_322));
  MUX21XL g13348__7114(.A (swp_cnt[9]), .B (n_247), .SA (n_265), .O
       (n_321));
  MUX21XL g13349__5266(.A (swp_cnt[8]), .B (n_243), .SA (n_265), .O
       (n_320));
  MUX21XL g13350__2250(.A (swp_cnt[6]), .B (n_228), .SA (n_265), .O
       (n_319));
  MUX21XL g13367__6083(.A (n_410), .B (\array[7] [2]), .SA (n_313), .O
       (n_318));
  MUX21XL g13355__2703(.A (swp_cnt[3]), .B (n_149), .SA (n_265), .O
       (n_317));
  MUX21XL g13356__5795(.A (swp_cnt[4]), .B (n_185), .SA (n_265), .O
       (n_316));
  MUX21XL g13357__7344(.A (swp_cnt[5]), .B (n_220), .SA (n_265), .O
       (n_315));
  MUX21XL g13366__1840(.A (n_387), .B (\array[7] [1]), .SA (n_313), .O
       (n_314));
  INV g13363(.A (n_285), .O (n_312));
  OR2N2AXL g13364__5019(.A (\c[5] [2]), .B (n_301), .C (n_300), .D
       (n_303), .O (n_311));
  MUX21XL g13365__1857(.A (n_393), .B (\array[7] [0]), .SA (n_313), .O
       (n_310));
  NOR3XL g13360__9906(.A (n_286), .B (n_273), .C (i[2]), .O (n_403));
  DFMH \i_reg[0] (.C (clk), .D0 (n_284), .D1 (n_309), .S1 (i[0]), .Q
       (i[0]));
  OR2N2AXL g13368__8780(.A (\c[4] [0]), .B (n_306), .C (n_305), .D
       (n_345), .O (n_308));
  OR2N2AXL g13369__4296(.A (\c[4] [1]), .B (n_306), .C (n_305), .D
       (n_348), .O (n_307));
  OR2N2AXL g13370__3772(.A (\c[4] [2]), .B (n_306), .C (n_305), .D
       (n_303), .O (n_304));
  OR2N2AXL g13371__1474(.A (\c[5] [0]), .B (n_301), .C (n_300), .D
       (n_345), .O (n_302));
  OR2N2AXL g13372__4547(.A (\c[5] [1]), .B (n_301), .C (n_300), .D
       (n_348), .O (n_299));
  OR2N2AXL g13374__9682(.A (\c[6] [0]), .B (n_296), .C (n_295), .D
       (n_345), .O (n_298));
  OR2N2AXL g13375__2683(.A (\c[6] [1]), .B (n_296), .C (n_295), .D
       (n_348), .O (n_297));
  OR2N2AXL g13376__1309(.A (\c[6] [2]), .B (n_296), .C (n_295), .D
       (n_303), .O (n_294));
  OR2N2AXL g13377__6877(.A (\c[7] [0]), .B (n_291), .C (n_290), .D
       (n_345), .O (n_293));
  OR2N2AXL g13378__2900(.A (\c[7] [1]), .B (n_291), .C (n_290), .D
       (n_348), .O (n_292));
  OR2N2AXL g13379__2391(.A (\c[7] [2]), .B (n_291), .C (n_290), .D
       (n_303), .O (n_289));
  INV g13383(.A (n_288), .O (n_374));
  OR21AXL g13402__7675(.A (n_180), .B (n_361), .C (n_328), .O (n_384));
  OR21AXL g13398__7118(.A (n_199), .B (n_361), .C (n_328), .O (n_391));
  OR221A g13399__8757(.A (n_287), .B (n_227), .C (n_361), .D (n_156),
       .E (n_328), .O (n_375));
  OR21AXL g13400__1786(.A (n_277), .B (n_361), .C (n_328), .O (n_365));
  NOR2XL g13396__5953(.A (n_286), .B (n_260), .O (n_395));
  NOR2XL g13395__5703(.A (n_286), .B (n_259), .O (n_392));
  OR21AXL g13391__7114(.A (n_182), .B (n_361), .C (n_328), .O (n_397));
  AND22OXL g13380__2250(.A (n_284), .B (n_268), .C (n_309), .D (i[3]),
       .O (n_285));
  NAND2 g13385__6083(.A (n_347), .B (\c[2] [1]), .O (n_283));
  OR2N2AXL g13351__2703(.A (n_491), .B (n_284), .C (n_263), .D (n_287),
       .O (n_282));
  NAND2 g13384__5795(.A (n_344), .B (\c[3] [0]), .O (n_281));
  NAND3 g13362__7344(.A (n_278), .B (n_224), .C (i[0]), .O (n_332));
  NAND2 g13387__1840(.A (n_344), .B (\c[3] [1]), .O (n_280));
  NAND2 g13386__5019(.A (n_347), .B (\c[2] [0]), .O (n_279));
  NAND2 g13389__1857(.A (n_278), .B (n_492), .O (n_288));
  NAND2 g13388__9906(.A (n_278), .B (n_277), .O (n_364));
  AND2 g13390__8780(.A (n_278), .B (n_78), .O (n_383));
  OR211AXL g13353__4296(.A (n_272), .B (n_267), .C (\c[1] [0]), .D
       (n_438), .O (n_276));
  DFSH ready_reg(.C (clk), .D (n_489), .Q (ready_934));
  NOR3ANXL g13359__1474(.A (n_390), .B (n_275), .C (n_372), .O (n_385));
  OR2N1A g13394__4547(.A (n_273), .B (n_272), .C (n_284), .O (n_274));
  NOR3XL g13361__9682(.A (n_275), .B (n_271), .C (n_390), .O (n_406));
  INV g13404(.A (n_278), .O (n_286));
  NAND2 g13410__2683(.A (n_265), .B (n_428), .O (n_328));
  HADD g13406__1309(.A (swp_cnt[13]), .B (n_254), .S (n_270), .C
       (n_269));
  AND2 g13417__6877(.A (n_290), .B (n_438), .O (n_291));
  AND2 g13409__2900(.A (n_266), .B (n_268), .O (n_313));
  NAND2AN g13408__2391(.A (n_267), .B (n_160), .O (n_344));
  OR2 g13418__7675(.A (n_267), .B (n_273), .O (n_347));
  AND2 g13413__7118(.A (n_305), .B (n_428), .O (n_306));
  AND2 g13415__8757(.A (n_295), .B (n_438), .O (n_296));
  AND2 g13414__1786(.A (n_300), .B (n_428), .O (n_301));
  AND2 g13411__5953(.A (n_266), .B (n_438), .O (n_278));
  AND3 g13419__5703(.A (n_264), .B (n_263), .C (n_438), .O (n_284));
  NAND3AN g13416__5266(.A (n_261), .B (n_263), .C (i[0]), .O (n_275));
  NOR2XL g13420__2250(.A (n_263), .B (n_361), .O (n_309));
  NAND2 g13421__6083(.A (n_263), .B (n_198), .O (n_267));
  NAND2 g13422__2703(.A (n_263), .B (n_132), .O (n_305));
  NAND2AN g13427__5795(.A (n_260), .B (n_263), .O (n_295));
  NAND2 g13426__7344(.A (n_263), .B (n_268), .O (n_290));
  NAND2AN g13423__1840(.A (n_259), .B (n_263), .O (n_300));
  NOR2AN g13428__5019(.A (n_263), .B (n_264), .O (n_266));
  HADD g13431__8780(.A (swp_cnt[12]), .B (n_249), .S (n_255), .C
       (n_254));
  NOR2 g13429__4296(.A (n_253), .B (i[3]), .O (n_263));
  HADD g13433__3772(.A (swp_cnt[10]), .B (n_248), .S (n_252), .C
       (n_251));
  OR31AXL g13432__1474(.A (n_246), .B (n_76), .C (n_93), .D (n_250), .O
       (n_253));
  AND221OXL g13434__4547(.A (n_95), .B (n_75), .C (swp_cnt[15]), .D
       (n_245), .E (n_90), .O (n_250));
  NOR2ANXL g13435__9682(.A (n_248), .B (n_240), .O (n_249));
  HADD g13436__2683(.A (swp_cnt[9]), .B (n_242), .S (n_247), .C
       (n_248));
  OR2N2AXL g13440__1309(.A (sel[12]), .B (n_94), .C (n_244), .D (n_89),
       .O (n_246));
  OR3XL g13437__6877(.A (n_241), .B (swp_cnt[14]), .C (swp_cnt[13]), .O
       (n_245));
  AND221OXL g13443__2900(.A (sel[11]), .B (n_87), .C (n_86), .D
       (sel[10]), .E (n_237), .O (n_244));
  HADD g13439__2391(.A (swp_cnt[8]), .B (n_236), .S (n_243), .C
       (n_242));
  NOR3ANXL g13438__7675(.A (swp_cnt[12]), .B (n_239), .C (n_240), .O
       (n_241));
  AND21OXL g13442__7118(.A (n_238), .B (swp_cnt[8]), .C (swp_cnt[9]),
       .O (n_239));
  AND21OXL g13447__8757(.A (n_233), .B (swp_cnt[9]), .C (n_234), .O
       (n_237));
  DFMHRL \stepcount_reg[7] (.RB (resn), .C (clk), .D0 (stepcount[7]),
       .D1 (n_229), .S1 (n_231), .Q (stepcount[7]));
  INV g13446(.A (n_235), .O (n_236));
  AND2N1OXL g13450__1786(.A (n_233), .B (swp_cnt[9]), .C (sel[9]), .O
       (n_234));
  DFMHRL \stepcount_reg[6] (.RB (resn), .C (clk), .D0 (stepcount[6]),
       .D1 (n_223), .S1 (n_231), .Q (stepcount[6]));
  OR2 g13444__5953(.A (n_230), .B (swp_cnt[7]), .O (n_238));
  NAND2 g13448__5703(.A (n_230), .B (swp_cnt[7]), .O (n_235));
  EXOR g13451__7114(.A (stepcount[7]), .B (n_222), .O (n_229));
  HADD g13449__5266(.A (swp_cnt[6]), .B (n_219), .S (n_228), .C
       (n_230));
  OR2N2AXL g13454__2250(.A (n_32), .B (n_221), .C (n_31), .D (sel[8]),
       .O (n_233));
  NAND3AN g13457__6083(.A (n_227), .B (n_189), .C (n_225), .O (n_348));
  INV g13466(.A (n_410), .O (n_226));
  OR21AXL g13469__2703(.A (n_227), .B (n_390), .C (n_225), .O (n_303));
  NAND2AN g13474__5795(.A (n_224), .B (n_225), .O (n_345));
  HADD g13452__7344(.A (stepcount[6]), .B (n_200), .S (n_223), .C
       (n_222));
  DFMHRL \stepcount_reg[5] (.RB (resn), .C (clk), .D0 (stepcount[5]),
       .D1 (n_201), .S1 (n_231), .Q (stepcount[5]));
  NAND3 g13470__1840(.A (n_218), .B (n_206), .C (n_217), .O (n_393));
  NAND3 g13471__5019(.A (n_211), .B (n_205), .C (n_214), .O (n_387));
  NAND3 g13472__1857(.A (n_207), .B (n_202), .C (n_208), .O (n_410));
  DFMHRL \cout_r_reg[5] (.RB (resn), .C (clk), .D0 (cout[5]), .D1
       (n_194), .S1 (n_231), .Q (cout_r[5]));
  DFMHRL \cout_r_reg[4] (.RB (resn), .C (clk), .D0 (cout[4]), .D1
       (n_196), .S1 (n_231), .Q (cout_r[4]));
  DFMHRL \cout_r_reg[7] (.RB (resn), .C (clk), .D0 (cout[7]), .D1
       (n_191), .S1 (n_231), .Q (cout_r[7]));
  DFMHRL \cout_r_reg[3] (.RB (resn), .C (clk), .D0 (cout[3]), .D1
       (n_192), .S1 (n_231), .Q (cout_r[3]));
  OR21AXL g13456__9906(.A (n_0), .B (sel[7]), .C (n_216), .O (n_221));
  DFMHRL \cout_r_reg[1] (.RB (resn), .C (clk), .D0 (cout[1]), .D1
       (n_197), .S1 (n_231), .Q (cout_r[1]));
  DFMHRL \cout_r_reg[6] (.RB (resn), .C (clk), .D0 (cout[6]), .D1
       (n_193), .S1 (n_231), .Q (cout_r[6]));
  NOR2XL g13476__8780(.A (n_264), .B (n_361), .O (n_225));
  HADD g13455__4296(.A (swp_cnt[5]), .B (n_184), .S (n_220), .C
       (n_219));
  DFMHRL \cout_r_reg[0] (.RB (resn), .C (clk), .D0 (cout[0]), .D1
       (n_172), .S1 (n_231), .Q (cout_r[0]));
  DFMHRL \cout_r_reg[2] (.RB (resn), .C (clk), .D0 (cout[2]), .D1
       (n_183), .S1 (n_231), .Q (cout_r[2]));
  AND22OXL g13480__3772(.A (n_210), .B (\array[1] [0]), .C (n_209), .D
       (\array[6] [0]), .O (n_218));
  AND222OXL g13477__1474(.A (n_227), .B (\array[3] [0]), .C (n_213), .D
       (\array[5] [0]), .E (n_212), .F (\array[4] [0]), .O (n_217));
  AND222OXL g13467__4547(.A (swp_cnt[6]), .B (n_73), .C (n_103), .D
       (n_215), .E (n_163), .F (n_215), .O (n_216));
  AND222OXL g13481__9682(.A (n_227), .B (\array[3] [1]), .C (n_213), .D
       (\array[5] [1]), .E (n_212), .F (\array[4] [1]), .O (n_214));
  AND2 g13482__2683(.A (n_190), .B (n_161), .O (n_264));
  AND22OXL g13483__1309(.A (n_210), .B (\array[1] [1]), .C (n_209), .D
       (\array[6] [1]), .O (n_211));
  AND222OXL g13484__6877(.A (n_227), .B (\array[3] [2]), .C (n_213), .D
       (\array[5] [2]), .E (n_212), .F (\array[4] [2]), .O (n_208));
  AND22OXL g13485__2900(.A (n_210), .B (\array[1] [2]), .C (n_209), .D
       (\array[6] [2]), .O (n_207));
  AND22OXL g13486__2391(.A (n_204), .B (\array[0] [0]), .C (n_203), .D
       (\array[2] [0]), .O (n_206));
  AND22OXL g13487__7675(.A (n_204), .B (\array[0] [1]), .C (n_203), .D
       (\array[2] [1]), .O (n_205));
  AND22OXL g13488__7118(.A (n_204), .B (\array[0] [2]), .C (n_203), .D
       (\array[2] [2]), .O (n_202));
  HADD g13458__8757(.A (stepcount[5]), .B (n_157), .S (n_201), .C
       (n_200));
  DFMHRL \stepcount_reg[4] (.RB (resn), .C (clk), .D0 (stepcount[4]),
       .D1 (n_158), .S1 (n_231), .Q (stepcount[4]));
  AND211OXL g13478__1786(.A (n_159), .B (i[1]), .C (n_188), .D (n_198),
       .O (n_199));
  INV g13490(.A (n_178), .O (n_197));
  INV g13489(.A (n_173), .O (n_196));
  OR21AXL g13479__5953(.A (n_181), .B (n_155), .C (n_438), .O (n_195));
  INV g13491(.A (n_176), .O (n_194));
  INV g13502(.A (n_169), .O (n_193));
  INV g13501(.A (n_167), .O (n_192));
  INV g13492(.A (n_175), .O (n_191));
  AND2N2OXL g13508__5703(.A (n_189), .B (n_188), .C (n_164), .D (i[2]),
       .O (n_190));
  OR21AXL g13509__7114(.A (n_186), .B (n_188), .C (n_428), .O (n_187));
  HADD g13475__5266(.A (swp_cnt[4]), .B (n_148), .S (n_185), .C
       (n_184));
  OR21AXL g13504__2250(.A (n_171), .B (n_177), .C (n_7), .O (n_183));
  NOR2XL g13495__6083(.A (n_181), .B (n_179), .O (n_182));
  NOR2ANXL g13496__2703(.A (n_181), .B (n_179), .O (n_180));
  AND21OXL g13497__5795(.A (n_166), .B (n_177), .C (cout_r[1]), .O
       (n_178));
  AND21OXL g13498__7344(.A (n_174), .B (n_177), .C (cout_r[5]), .O
       (n_176));
  AND21OXL g13499__1840(.A (n_174), .B (n_170), .C (cout_r[7]), .O
       (n_175));
  AND21OXL g13494__5019(.A (n_168), .B (n_177), .C (cout_r[4]), .O
       (n_173));
  OR21AXL g13507__1857(.A (n_171), .B (n_170), .C (n_15), .O (n_172));
  AND21OXL g13506__9906(.A (n_168), .B (n_170), .C (cout_r[6]), .O
       (n_169));
  AND21OXL g13505__8780(.A (n_166), .B (n_170), .C (cout_r[3]), .O
       (n_167));
  OR2N1A g13510__4296(.A (n_165), .B (n_271), .C (i[0]), .O (n_277));
  NOR2XL g13512__3772(.A (n_189), .B (n_164), .O (n_212));
  NOR2ANXL g13513__1474(.A (n_224), .B (n_186), .O (n_210));
  NOR2XL g13514__4547(.A (n_186), .B (n_224), .O (n_204));
  DLH \next_state_reg[0] (.EN (n_151), .D (n_150), .Q (next_state[0]),
       .QB (UNCONNECTED));
  AND211OXL g13503__9682(.A (n_102), .B (sel[4]), .C (n_101), .D
       (n_144), .O (n_163));
  DFSHRL \state_reg[1] (.RB (resn), .C (clk), .D (next_state[1]), .Q
       (state[1]));
  DFSHRL \state_reg[2] (.RB (resn), .C (clk), .D (next_state[2]), .Q
       (state[2]));
  AND22OXL g13516__2683(.A (n_154), .B (n_160), .C (n_271), .D (i[1]),
       .O (n_161));
  INV g13529(.A (n_213), .O (n_159));
  AND2 g13515__1309(.A (n_165), .B (n_372), .O (n_203));
  HADD g13493__6877(.A (stepcount[4]), .B (n_137), .S (n_158), .C
       (n_157));
  AND2N1OXL g13517__2900(.A (n_372), .B (i[1]), .C (n_188), .O (n_156));
  AND2N1OXL g13518__2391(.A (n_224), .B (n_164), .C (n_155), .O
       (n_179));
  AND21OXL g13519__7675(.A (n_372), .B (i[0]), .C (n_119), .O (n_181));
  DFMHRL \stepcount_reg[3] (.RB (resn), .C (clk), .D0 (stepcount[3]),
       .D1 (n_138), .S1 (n_231), .Q (stepcount[3]));
  NAND2 g13534__7118(.A (n_154), .B (n_438), .O (n_261));
  NAND2 g13535__8757(.A (n_271), .B (n_154), .O (n_189));
  NOR2XL g13537__1786(.A (n_154), .B (n_164), .O (n_213));
  NOR2XL g13527__5953(.A (n_271), .B (n_164), .O (n_209));
  NAND2 g13528__5703(.A (n_271), .B (n_164), .O (n_186));
  NOR2ANXL g13524__7114(.A (n_152), .B (n_153), .O (n_166));
  NOR2XL g13523__5266(.A (n_153), .B (n_152), .O (n_174));
  NAND2 g13522__2250(.A (n_153), .B (n_152), .O (n_171));
  NOR2ANXL g13525__6083(.A (n_153), .B (n_152), .O (n_168));
  DLH \next_state_reg[1] (.EN (n_151), .D (n_141), .Q (next_state[1]),
       .QB (UNCONNECTED0));
  DLH \next_state_reg[2] (.EN (n_151), .D (n_68), .Q (next_state[2]),
       .QB (UNCONNECTED1));
  INVXL g13549(.A (n_143), .O (n_150));
  NOR2XL g13536__2703(.A (n_224), .B (n_390), .O (n_165));
  AND2 g13538__5795(.A (n_372), .B (n_224), .O (n_227));
  HADD g13511__7344(.A (swp_cnt[3]), .B (n_122), .S (n_149), .C
       (n_148));
  INV g13530(.A (n_405), .O (n_147));
  INV g13531(.A (n_408), .O (n_146));
  INV g13532(.A (n_401), .O (n_145));
  DFMHRL \stepcount_reg[0] (.RB (resn), .C (clk), .D0 (n_231), .D1
       (n_139), .S1 (stepcount[0]), .Q (stepcount[0]));
  AND2N1OXL g13533__1840(.A (n_135), .B (sel[3]), .C (n_136), .O
       (n_144));
  AND22OXL g13552__5019(.A (n_140), .B (state[0]), .C (n_142), .D
       (ready_934), .O (n_143));
  INV g13550(.A (n_224), .O (n_154));
  INV g13542(.A (n_177), .O (n_170));
  INV g13551(.A (n_372), .O (n_271));
  OR211A g13545__1857(.A (stepcount[2]), .B (n_96), .C (n_104), .D
       (n_231), .O (n_153));
  DFMHRL \stepcount_reg[1] (.RB (resn), .C (clk), .D0 (stepcount[1]),
       .D1 (n_46), .S1 (n_231), .Q (stepcount[1]));
  NAND3 g13539__9906(.A (n_129), .B (n_117), .C (n_116), .O (n_405));
  NAND3 g13540__8780(.A (n_128), .B (n_121), .C (n_112), .O (n_408));
  NAND3 g13541__4296(.A (n_133), .B (n_110), .C (n_113), .O (n_401));
  DFMHRL \stepcount_reg[2] (.RB (resn), .C (clk), .D0 (stepcount[2]),
       .D1 (n_82), .S1 (n_231), .Q (stepcount[2]));
  NOR2XL g13558__3772(.A (n_140), .B (n_139), .O (n_141));
  OR211AXL g13585__1474(.A (state[0]), .B (state[2]), .C (n_139), .D
       (n_77), .O (n_151));
  OR211AXL g13546__4547(.A (stepcount[2]), .B (n_107), .C (n_115), .D
       (n_231), .O (n_152));
  OR211A g13547__9682(.A (stepcount[2]), .B (n_97), .C (n_231), .D
       (n_114), .O (n_177));
  INV g13567(.A (n_390), .O (n_164));
  NAND3 g13556__2683(.A (n_120), .B (n_91), .C (n_105), .O (n_372));
  NAND2AN g13555__1309(.A (n_130), .B (n_118), .O (n_224));
  HADD g13543__6877(.A (stepcount[3]), .B (n_124), .S (n_138), .C
       (n_137));
  AND22OXL g13553__2900(.A (n_99), .B (n_34), .C (n_135), .D (sel[3]),
       .O (n_136));
  NAND2 g13571__2391(.A (n_108), .B (n_109), .O (n_390));
  AND222OXL g13554__7675(.A (n_132), .B (\array[4] [1]), .C (n_492), .D
       (\array[3] [1]), .E (n_268), .F (\array[7] [1]), .O (n_133));
  OR2N2AXL g13566__7118(.A (i[2]), .B (n_79), .C (n_81), .D (n_25), .O
       (n_130));
  AND222OXL g13575__8757(.A (n_127), .B (\array[1] [2]), .C (n_126), .D
       (\array[2] [2]), .E (n_125), .F (\array[5] [2]), .O (n_129));
  AND222OXL g13576__1786(.A (n_127), .B (\array[1] [0]), .C (n_126), .D
       (\array[2] [0]), .E (n_125), .F (\array[5] [0]), .O (n_128));
  NAND3ANXL g13570__5953(.A (stepcount[3]), .B (n_124), .C (n_29), .O
       (n_140));
  HADD g13557__5703(.A (swp_cnt[2]), .B (n_48), .S (n_123), .C (n_122));
  AND22OXL g13565__7114(.A (n_132), .B (\array[4] [0]), .C (n_492), .D
       (\array[3] [0]), .O (n_121));
  AND32OXL g13562__5266(.A (\c[2] [1]), .B (n_119), .C (n_198), .D
       (\c[3] [1]), .E (n_492), .O (n_120));
  AND22OXL g13563__2250(.A (n_127), .B (\c[1] [0]), .C (n_492), .D
       (\c[3] [0]), .O (n_118));
  AND22OXL g13564__6083(.A (n_132), .B (\array[4] [2]), .C (n_492), .D
       (\array[3] [2]), .O (n_117));
  AND22OXL g13591__2703(.A (n_111), .B (\array[6] [2]), .C (n_268), .D
       (\array[7] [2]), .O (n_116));
  NAND3 g13573__5795(.A (n_58), .B (n_61), .C (stepcount[2]), .O
       (n_115));
  NAND3 g13574__7344(.A (n_71), .B (n_62), .C (stepcount[2]), .O
       (n_114));
  AND22OXL g13581__1840(.A (n_127), .B (\array[1] [1]), .C (n_126), .D
       (\array[2] [1]), .O (n_113));
  AND22OXL g13592__5019(.A (n_111), .B (\array[6] [0]), .C (n_268), .D
       (\array[7] [0]), .O (n_112));
  AND22OXL g13587__1857(.A (n_125), .B (\array[5] [1]), .C (n_111), .D
       (\array[6] [1]), .O (n_110));
  AND22OXL g13589__9906(.A (n_132), .B (\c[4] [2]), .C (n_111), .D
       (\c[6] [2]), .O (n_109));
  AND22OXL g13590__8780(.A (n_125), .B (\c[5] [2]), .C (n_268), .D
       (\c[7] [2]), .O (n_108));
  OR211AXL g13582__4296(.A (n_106), .B (n_38), .C (n_57), .D (n_43), .O
       (n_107));
  AND22OXL g13593__3772(.A (n_125), .B (\c[5] [1]), .C (n_111), .D
       (\c[6] [1]), .O (n_105));
  NAND3 g13568__1474(.A (n_56), .B (n_65), .C (stepcount[2]), .O
       (n_104));
  INV g13595(.A (n_231), .O (n_139));
  OR32AXL g13578__4547(.A (n_102), .B (n_101), .C (sel[4]), .D
       (sel[5]), .E (n_2), .O (n_103));
  OR222AXL g13572__9682(.A (swp_cnt[2]), .B (n_33), .C (swp_cnt[0]), .D
       (n_45), .E (n_44), .F (swp_cnt[1]), .O (n_99));
  AND2 g13598__2683(.A (n_84), .B (state[2]), .O (n_98));
  NAND2 g13579__1309(.A (n_67), .B (n_59), .O (n_97));
  NAND2 g13580__6877(.A (n_60), .B (n_72), .O (n_96));
  OR32AXL g13583__2900(.A (n_94), .B (n_93), .C (sel[12]), .D
       (sel[13]), .E (n_3), .O (n_95));
  AND22OXL g13594__2391(.A (n_132), .B (\c[4] [1]), .C (n_268), .D
       (\c[7] [1]), .O (n_91));
  OR32AXL g13584__7675(.A (n_53), .B (n_51), .C (sel[14]), .D
       (sel[15]), .E (n_6), .O (n_90));
  AND222OXL g13588__7118(.A (n_40), .B (sel[10]), .C (n_87), .D (n_86),
       .E (n_240), .F (sel[11]), .O (n_89));
  AND2 g13603__8757(.A (n_84), .B (n_83), .O (n_142));
  AND22 g13604__1786(.A (n_69), .B (n_83), .O (n_231));
  HADD g13577__5953(.A (stepcount[2]), .B (n_70), .S (n_82), .C
       (n_124));
  AND22OXL g13599__5703(.A (n_126), .B (\c[2] [0]), .C (n_155), .D
       (\c[6] [0]), .O (n_81));
  OR2N2AXL g13586__7114(.A (\c[4] [0]), .B (n_78), .C (n_39), .D
       (n_188), .O (n_79));
  NAND2 g13634__5266(.A (i[2]), .B (n_428), .O (n_287));
  INVXL g13614(.A (n_84), .O (n_77));
  INV g13626(.A (n_75), .O (n_76));
  INV g13628(.A (n_111), .O (n_260));
  INV g13615(.A (n_125), .O (n_259));
  NOR2XL g13617__6083(.A (n_54), .B (sel[6]), .O (n_73));
  AND22OXL g13611__2703(.A (n_64), .B (\array[0] [0]), .C (n_63), .D
       (\array[2] [0]), .O (n_72));
  AND22OXL g13609__5795(.A (n_66), .B (\array[5] [1]), .C (n_70), .D
       (\array[7] [1]), .O (n_71));
  NOR2ANXL g13619__7344(.A (state[0]), .B (state[1]), .O (n_69));
  INVXL g13625(.A (n_47), .O (n_68));
  AND22OXL g13597__1840(.A (n_66), .B (\array[1] [1]), .C (n_70), .D
       (\array[3] [1]), .O (n_67));
  AND22OXL g13601__5019(.A (n_64), .B (\array[4] [0]), .C (n_63), .D
       (\array[6] [0]), .O (n_65));
  AND22OXL g13602__1857(.A (n_64), .B (\array[4] [1]), .C (n_63), .D
       (\array[6] [1]), .O (n_62));
  AND22OXL g13606__9906(.A (n_64), .B (\array[4] [2]), .C (n_63), .D
       (\array[6] [2]), .O (n_61));
  AND22OXL g13607__8780(.A (n_66), .B (\array[1] [0]), .C (n_70), .D
       (\array[3] [0]), .O (n_60));
  AND22OXL g13612__4296(.A (n_64), .B (\array[0] [1]), .C (n_63), .D
       (\array[2] [1]), .O (n_59));
  AND22OXL g13613__3772(.A (n_66), .B (\array[5] [2]), .C (n_70), .D
       (\array[7] [2]), .O (n_58));
  AND22OXL g13610__1474(.A (n_64), .B (\array[0] [2]), .C (n_63), .D
       (\array[2] [2]), .O (n_57));
  AND22OXL g13608__4547(.A (n_66), .B (\array[5] [0]), .C (n_70), .D
       (\array[7] [0]), .O (n_56));
  AND21OXL g13633__9682(.A (n_4), .B (sel[6]), .C (n_54), .O (n_215));
  AND21OXL g13632__2683(.A (n_53), .B (sel[14]), .C (n_51), .O (n_75));
  NOR2XL g13621__1309(.A (state[1]), .B (state[0]), .O (n_84));
  NOR2ANXL g13635__6877(.A (n_198), .B (n_272), .O (n_127));
  NOR2ANXL g13623__2900(.A (i[2]), .B (n_272), .O (n_125));
  AND2 g13636__2391(.A (n_119), .B (i[2]), .O (n_111));
  HADD g13596__7675(.A (swp_cnt[1]), .B (swp_cnt[0]), .S (n_49), .C
       (n_48));
  AND21OXL g13631__7118(.A (state[2]), .B (en), .C (state[1]), .O
       (n_47));
  OR2 g13630__8757(.A (n_66), .B (n_63), .O (n_46));
  AND2 g13622__5953(.A (n_78), .B (i[2]), .O (n_132));
  AND2 g13637__5703(.A (n_160), .B (i[2]), .O (n_268));
  INV3 g13652(.A (n_428), .O (n_361));
  OR2N1A g13620__7114(.A (swp_cnt[1]), .B (n_44), .C (sel[0]), .O
       (n_45));
  NAND2 g13618__5266(.A (n_66), .B (\array[1] [2]), .O (n_43));
  INV g13638(.A (n_119), .O (n_273));
  BF g13650(.A (n_428), .O (n_438));
  NAND2AN g13641__2250(.A (sel[11]), .B (swp_cnt[11]), .O (n_40));
  MUX21XL g13629__6083(.A (\c[7] [0]), .B (\c[5] [0]), .SA (i[1]), .O
       (n_39));
  INV g13639(.A (n_70), .O (n_38));
  NOR2ANXL g13642__2703(.A (sel[15]), .B (swp_cnt[15]), .O (n_51));
  NOR2XL g13660__5795(.A (n_198), .B (i[0]), .O (n_155));
  AND2 g13646__7344(.A (n_188), .B (i[1]), .O (n_119));
  AND22 g13664__1840(.A (en), .B (resn), .O (n_428));
  NAND2 g13655__5019(.A (swp_cnt[2]), .B (n_33), .O (n_34));
  NAND2 g13654__1857(.A (n_31), .B (sel[8]), .O (n_32));
  NOR4XL g13600__9906(.A (stepcount[7]), .B (stepcount[4]), .C
       (stepcount[6]), .D (stepcount[5]), .O (n_29));
  NOR2ANXL g13658__8780(.A (sel[7]), .B (swp_cnt[7]), .O (n_54));
  NOR2ANXL g13657__4296(.A (sel[5]), .B (swp_cnt[5]), .O (n_101));
  NOR2ANXL g13656__3772(.A (sel[13]), .B (swp_cnt[13]), .O (n_93));
  NAND2 g13661__1474(.A (n_25), .B (i[0]), .O (n_272));
  DFSHRL \state_reg[0] (.RB (resn), .C (clk), .D (next_state[0]), .Q
       (state[0]));
  NOR2XL g13640__4547(.A (i[2]), .B (i[1]), .O (n_20));
  INV4 g13704(.A (n_15), .O (cout[0]));
  NAND2 g13659__9682(.A (swp_cnt[11]), .B (swp_cnt[10]), .O (n_240));
  NOR2XL g13643__2683(.A (i[0]), .B (i[1]), .O (n_78));
  NOR2AN g13648__1309(.A (stepcount[1]), .B (stepcount[0]), .O (n_63));
  INV4 g13666(.A (n_10), .O (ready));
  INV4 g13697(.A (n_7), .O (cout[2]));
  NOR2XL g13644__6877(.A (i[0]), .B (i[2]), .O (n_126));
  AND2 g13662__2900(.A (i[1]), .B (i[0]), .O (n_160));
  NOR2 g13647__2391(.A (stepcount[0]), .B (stepcount[1]), .O (n_64));
  AND2 g13649__7675(.A (stepcount[0]), .B (stepcount[1]), .O (n_70));
  NOR2AN g13663__7118(.A (stepcount[0]), .B (stepcount[1]), .O (n_66));
  INV g13674(.A (swp_cnt[15]), .O (n_6));
  INV g13669(.A (swp_cnt[6]), .O (n_4));
  INV g13716(.A (swp_cnt[13]), .O (n_3));
  INV g13705(.A (cout_r[0]), .O (n_15));
  BF4 g13711(.A (cout_r[3]), .O (cout[3]));
  INV g13676(.A (swp_cnt[12]), .O (n_94));
  INV g13671(.A (swp_cnt[4]), .O (n_102));
  BF4 g13709(.A (cout_r[6]), .O (cout[6]));
  INV g13670(.A (swp_cnt[3]), .O (n_135));
  INV g13668(.A (\array[3] [2]), .O (n_106));
  INV g13678(.A (swp_cnt[11]), .O (n_87));
  BF4 g13713(.A (cout_r[1]), .O (cout[1]));
  INVXL g13685(.A (sel[2]), .O (n_33));
  INV g13673(.A (swp_cnt[5]), .O (n_2));
  INV g13715(.A (swp_cnt[7]), .O (n_0));
  INV g13717(.A (swp_cnt[10]), .O (n_86));
  INV g13672(.A (state[2]), .O (n_83));
  INV g13718(.A (i[1]), .O (n_25));
  INVXL g13667(.A (ready_934), .O (n_10));
  BF4 g13700(.A (cout_r[4]), .O (cout[4]));
  INV g13677(.A (swp_cnt[14]), .O (n_53));
  INV g13675(.A (swp_cnt[8]), .O (n_31));
  BF4 g13707(.A (cout_r[5]), .O (cout[5]));
  BF4 g13702(.A (cout_r[7]), .O (cout[7]));
  INV g13698(.A (cout_r[2]), .O (n_7));
  INVXL g13686(.A (sel[1]), .O (n_44));
  INV g13719(.A (i[0]), .O (n_188));
  INV g13679(.A (i[2]), .O (n_198));
  INV2 g13805(.A (n_266), .O (n_265));
  EXNORXL g2(.A (n_462), .B (swp_cnt[15]), .O (n_463));
  NOR2ANXL g3(.A (n_335), .B (n_265), .O (n_462));
  EXNORXL g13806(.A (n_464), .B (swp_cnt[11]), .O (n_465));
  AND2 g13807(.A (n_251), .B (n_266), .O (n_464));
  BF4 drc_bufs13815(.A (n_142), .O (init));
  BF4 drc_bufs(.A (n_98), .O (amp_enable));
  NAND2AN g13826(.A (n_332), .B (n_405), .O (n_486));
  NOR3ANXL g13827(.A (n_209), .B (n_275), .C (n_264), .O (n_487));
  NOR2ANXL g13828(.A (n_127), .B (n_286), .O (n_488));
  AND2N1OXL g13829(.A (n_253), .B (ready_934), .C (n_361), .O (n_489));
  INVXL g13830(.A (n_490), .O (n_491));
  HADD g13831(.A (n_160), .B (n_198), .S (n_490), .C (n_492));
endmodule
