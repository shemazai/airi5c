
// Generated by Cadence Genus(TM) Synthesis Solution 17.22-s017_1
// Generated on: Oct 20 2018 10:53:39 CEST (Oct 20 2018 08:53:39 UTC)

// Verification Directory fv/permut_sel 

module permut_sel(sel, clk, resn, ready, sel_out);
  input [15:0] sel;
  input clk, resn;
  output ready;
  output [23:0] sel_out;
  wire [15:0] sel;
  wire clk, resn;
  wire ready;
  wire [23:0] sel_out;
  wire [15:0] swp_cnt;
  wire [2:0] \array[5] ;
  wire [2:0] \array[1] ;
  wire [2:0] \array[2] ;
  wire [2:0] \array[4] ;
  wire [2:0] \array[6] ;
  wire [2:0] \c[7] ;
  wire [2:0] \array[3] ;
  wire [2:0] \c[3] ;
  wire [2:0] \c[1] ;
  wire [2:0] \c[5] ;
  wire [2:0] \array[0] ;
  wire [3:0] i;
  wire [2:0] \array[7] ;
  wire [2:0] \c[6] ;
  wire [2:0] \c[2] ;
  wire [2:0] \c[4] ;
  wire n_6, n_9, n_13, n_18, n_19, n_23, n_24, n_25;
  wire n_34, n_36, n_38, n_41, n_44, n_45, n_46, n_47;
  wire n_49, n_50, n_51, n_52, n_53, n_55, n_57, n_58;
  wire n_59, n_60, n_61, n_62, n_63, n_64, n_65, n_66;
  wire n_67, n_69, n_70, n_71, n_73, n_74, n_75, n_77;
  wire n_78, n_79, n_80, n_81, n_82, n_83, n_84, n_85;
  wire n_86, n_87, n_88, n_89, n_90, n_91, n_92, n_93;
  wire n_94, n_95, n_96, n_97, n_98, n_99, n_100, n_101;
  wire n_102, n_103, n_104, n_105, n_106, n_107, n_108, n_109;
  wire n_110, n_111, n_112, n_113, n_114, n_115, n_116, n_117;
  wire n_118, n_119, n_120, n_121, n_123, n_124, n_125, n_126;
  wire n_127, n_128, n_129, n_130, n_131, n_132, n_133, n_134;
  wire n_135, n_136, n_137, n_138, n_139, n_140, n_141, n_142;
  wire n_143, n_144, n_145, n_146, n_147, n_148, n_149, n_150;
  wire n_151, n_152, n_153, n_154, n_155, n_156, n_157, n_158;
  wire n_159, n_160, n_161, n_162, n_163, n_164, n_165, n_166;
  wire n_167, n_168, n_170, n_171, n_172, n_173, n_175, n_176;
  wire n_177, n_178, n_179, n_182, n_183, n_184, n_185, n_187;
  wire n_188, n_189, n_190, n_191, n_192, n_193, n_194, n_195;
  wire n_196, n_197, n_198, n_199, n_200, n_201, n_202, n_203;
  wire n_204, n_205, n_206, n_207, n_208, n_209, n_210, n_211;
  wire n_212, n_213, n_214, n_215, n_216, n_217, n_218, n_219;
  wire n_220, n_221, n_222, n_223, n_224, n_225, n_226, n_227;
  wire n_228, n_229, n_230, n_231, n_232, n_233, n_234, n_235;
  wire n_236, n_237, n_238, n_239, n_240, n_241, n_242, n_243;
  wire n_244, n_245, n_246, n_247, n_248, n_249, n_250, n_251;
  wire n_252, n_253, n_254, n_255, n_257, n_258, n_259, n_260;
  wire n_262, n_263, n_264, n_265, n_266, n_267, n_268, n_269;
  wire n_270, n_271, n_272, n_273, n_294, n_295, n_296, n_297;
  wire ready_624, \sel_out[0]_625 , \sel_out[1]_626 , \sel_out[2]_627 ,
       \sel_out[3]_628 , \sel_out[4]_629 , \sel_out[5]_630 ,
       \sel_out[6]_631 ;
  wire \sel_out[7]_632 , \sel_out[8]_633 , \sel_out[9]_634 ,
       \sel_out[10]_635 , \sel_out[11]_636 , \sel_out[12]_637 ,
       \sel_out[13]_638 , \sel_out[14]_639 ;
  wire \sel_out[15]_640 , \sel_out[16]_641 , \sel_out[17]_642 ,
       \sel_out[18]_643 , \sel_out[19]_644 , \sel_out[20]_645 ,
       \sel_out[21]_646 , \sel_out[22]_647 ;
  wire \sel_out[23]_648 ;
  DFMHRL \swp_cnt_reg[15] (.RB (resn), .C (clk), .D0 (n_266), .D1
       (swp_cnt[15]), .S1 (n_273), .Q (swp_cnt[15]));
  DFSHRL \array_reg[5][1] (.RB (resn), .C (clk), .D (n_272), .Q
       (\array[5] [1]));
  DFSHSL \array_reg[5][0] (.SB (resn), .C (clk), .D (n_270), .Q
       (\array[5] [0]));
  DFSHSL \array_reg[5][2] (.SB (resn), .C (clk), .D (n_271), .Q
       (\array[5] [2]));
  DFSHRL \array_reg[1][2] (.RB (resn), .C (clk), .D (n_239), .Q
       (\array[1] [2]));
  DFSHRL \array_reg[2][0] (.RB (resn), .C (clk), .D (n_234), .Q
       (\array[2] [0]));
  DFSHRL \array_reg[2][2] (.RB (resn), .C (clk), .D (n_244), .Q
       (\array[2] [2]));
  DFSHRL \array_reg[4][0] (.RB (resn), .C (clk), .D (n_263), .Q
       (\array[4] [0]));
  DFSHRL \array_reg[4][1] (.RB (resn), .C (clk), .D (n_258), .Q
       (\array[4] [1]));
  DFSHRL \array_reg[6][0] (.RB (resn), .C (clk), .D (n_252), .Q
       (\array[6] [0]));
  DFSHRL \array_reg[1][1] (.RB (resn), .C (clk), .D (n_242), .Q
       (\array[1] [1]));
  DFMHRL \c_reg[7][0] (.RB (resn), .C (clk), .D0 (n_268), .D1 (\c[7]
       [0]), .S1 (n_294), .Q (\c[7] [0]));
  DFMHRL \c_reg[7][2] (.RB (resn), .C (clk), .D0 (n_227), .D1 (\c[7]
       [2]), .S1 (n_294), .Q (\c[7] [2]));
  DFMHRL \c_reg[7][1] (.RB (resn), .C (clk), .D0 (n_269), .D1 (\c[7]
       [1]), .S1 (n_294), .Q (\c[7] [1]));
  DFSHSL \array_reg[2][1] (.SB (resn), .C (clk), .D (n_238), .Q
       (\array[2] [1]));
  DFSHSL \array_reg[4][2] (.SB (resn), .C (clk), .D (n_255), .Q
       (\array[4] [2]));
  DFSHSL \array_reg[6][1] (.SB (resn), .C (clk), .D (n_247), .Q
       (\array[6] [1]));
  DFSHSL \array_reg[1][0] (.SB (resn), .C (clk), .D (n_243), .Q
       (\array[1] [0]));
  DFSHSL \array_reg[6][2] (.SB (resn), .C (clk), .D (n_265), .Q
       (\array[6] [2]));
  DFSHRL \array_reg[3][2] (.RB (resn), .C (clk), .D (n_231), .Q
       (\array[3] [2]));
  DFSHSL \array_reg[3][1] (.SB (resn), .C (clk), .D (n_224), .Q
       (\array[3] [1]));
  DFSHSL \array_reg[3][0] (.SB (resn), .C (clk), .D (n_233), .Q
       (\array[3] [0]));
  DFMHRL \swp_cnt_reg[14] (.RB (resn), .C (clk), .D0 (n_202), .D1
       (swp_cnt[14]), .S1 (n_273), .Q (swp_cnt[14]));
  INV g7636(.A (n_262), .O (n_272));
  INV g7635(.A (n_235), .O (n_271));
  INV g7637(.A (n_264), .O (n_270));
  DFMHRL \c_reg[3][1] (.RB (resn), .C (clk), .D0 (\c[3] [1]), .D1
       (n_269), .S1 (n_267), .Q (\c[3] [1]));
  DFMHRL \c_reg[3][0] (.RB (resn), .C (clk), .D0 (\c[3] [0]), .D1
       (n_268), .S1 (n_267), .Q (\c[3] [0]));
  EXOR g7620__8780(.A (swp_cnt[15]), .B (n_201), .O (n_266));
  OR221A g7664__4296(.A (n_253), .B (n_250), .C (n_254), .D (n_248), .E
       (n_216), .O (n_265));
  AND222OXL g7641__3772(.A (n_215), .B (n_297), .C (n_260), .D
       (\array[5] [0]), .E (n_259), .F (n_220), .O (n_264));
  OR221A g7665__1474(.A (n_249), .B (n_257), .C (n_251), .D (n_296), .E
       (n_206), .O (n_263));
  AND222OXL g7640__4547(.A (n_214), .B (n_297), .C (n_260), .D
       (\array[5] [1]), .E (n_259), .F (n_225), .O (n_262));
  OR221A g7666__9682(.A (n_245), .B (n_257), .C (n_246), .D (n_296), .E
       (n_205), .O (n_258));
  OR221A g7667__2683(.A (n_254), .B (n_257), .C (n_253), .D (n_296), .E
       (n_204), .O (n_255));
  OR221A g7668__1309(.A (n_251), .B (n_250), .C (n_249), .D (n_248), .E
       (n_210), .O (n_252));
  OR221A g7663__6877(.A (n_246), .B (n_250), .C (n_245), .D (n_248), .E
       (n_203), .O (n_247));
  OR221A g7670__2900(.A (n_254), .B (n_237), .C (n_253), .D (n_236), .E
       (n_209), .O (n_244));
  OR221A g7671__2391(.A (n_241), .B (n_232), .C (n_251), .D (n_240), .E
       (n_211), .O (n_243));
  OR221A g7672__7675(.A (n_241), .B (n_223), .C (n_246), .D (n_240), .E
       (n_219), .O (n_242));
  OR221A g7673__7118(.A (n_241), .B (n_229), .C (n_253), .D (n_240), .E
       (n_217), .O (n_239));
  OR221A g7669__8757(.A (n_245), .B (n_237), .C (n_246), .D (n_236), .E
       (n_208), .O (n_238));
  AND222OXL g7639__1786(.A (n_212), .B (n_297), .C (n_260), .D
       (\array[5] [2]), .E (n_259), .F (n_222), .O (n_235));
  OR221A g7662__5953(.A (n_249), .B (n_237), .C (n_251), .D (n_236), .E
       (n_218), .O (n_234));
  DFSHRL \c_reg[1][0] (.RB (resn), .C (clk), .D (n_207), .Q (\c[1]
       [0]));
  OR221A g7642__5703(.A (n_230), .B (n_232), .C (n_251), .D (n_228), .E
       (n_192), .O (n_233));
  OR221A g7643__7114(.A (n_230), .B (n_229), .C (n_253), .D (n_228), .E
       (n_194), .O (n_231));
  DFMHRL \c_reg[5][1] (.RB (resn), .C (clk), .D0 (\c[5] [1]), .D1
       (n_269), .S1 (n_226), .Q (\c[5] [1]));
  DFMHRL \c_reg[5][2] (.RB (resn), .C (clk), .D0 (\c[5] [2]), .D1
       (n_227), .S1 (n_226), .Q (\c[5] [2]));
  DFMHRL \c_reg[5][0] (.RB (resn), .C (clk), .D0 (\c[5] [0]), .D1
       (n_268), .S1 (n_226), .Q (\c[5] [0]));
  DFMHRL \array_reg[0][1] (.RB (resn), .C (clk), .D0 (\array[0] [1]),
       .D1 (n_225), .S1 (n_221), .Q (\array[0] [1]));
  OR221A g7638__5266(.A (n_230), .B (n_223), .C (n_246), .D (n_228), .E
       (n_193), .O (n_224));
  DFSHRL \i_reg[3] (.RB (resn), .C (clk), .D (n_200), .Q (i[3]));
  DFMHRL \array_reg[0][2] (.RB (resn), .C (clk), .D0 (\array[0] [2]),
       .D1 (n_222), .S1 (n_221), .Q (\array[0] [2]));
  DFMHRL \array_reg[0][0] (.RB (resn), .C (clk), .D0 (\array[0] [0]),
       .D1 (n_220), .S1 (n_221), .Q (\array[0] [0]));
  DFSHRL \i_reg[1] (.RB (resn), .C (clk), .D (n_199), .Q (i[1]));
  DFSHRL \i_reg[2] (.RB (resn), .C (clk), .D (n_198), .Q (i[2]));
  NAND3 g7708__2250(.A (n_241), .B (n_240), .C (\array[1] [1]), .O
       (n_219));
  NAND3 g7710__6083(.A (n_237), .B (n_236), .C (\array[2] [0]), .O
       (n_218));
  NAND3 g7709__2703(.A (n_241), .B (n_240), .C (\array[1] [2]), .O
       (n_217));
  NAND3 g7695__5795(.A (n_248), .B (n_250), .C (\array[6] [2]), .O
       (n_216));
  DFMHSL \array_reg[7][0] (.SB (resn), .C (clk), .D0 (\array[7] [0]),
       .D1 (n_215), .S1 (n_213), .Q (\array[7] [0]));
  DFMHSL \array_reg[7][1] (.SB (resn), .C (clk), .D0 (\array[7] [1]),
       .D1 (n_214), .S1 (n_213), .Q (\array[7] [1]));
  DFMHSL \array_reg[7][2] (.SB (resn), .C (clk), .D0 (\array[7] [2]),
       .D1 (n_212), .S1 (n_213), .Q (\array[7] [2]));
  NAND3 g7707__1840(.A (n_241), .B (n_240), .C (\array[1] [0]), .O
       (n_211));
  NAND3 g7697__5019(.A (n_248), .B (n_250), .C (\array[6] [0]), .O
       (n_210));
  NAND3 g7698__1857(.A (n_237), .B (n_236), .C (\array[2] [2]), .O
       (n_209));
  NAND3 g7699__9906(.A (n_237), .B (n_236), .C (\array[2] [1]), .O
       (n_208));
  NAND2 g7700__8780(.A (n_241), .B (n_187), .O (n_207));
  NAND3 g7704__4296(.A (n_257), .B (n_296), .C (\array[4] [0]), .O
       (n_206));
  NAND3 g7705__3772(.A (n_257), .B (n_296), .C (\array[4] [1]), .O
       (n_205));
  NAND3 g7706__1474(.A (n_257), .B (n_296), .C (\array[4] [2]), .O
       (n_204));
  NAND3 g7696__4547(.A (n_248), .B (n_250), .C (\array[6] [1]), .O
       (n_203));
  HADD g7650__9682(.A (swp_cnt[14]), .B (n_176), .S (n_202), .C
       (n_201));
  INV g7716(.A (n_189), .O (n_200));
  OR2N2AXL g7721__2683(.A (i[1]), .B (n_197), .C (n_196), .D (n_67), .O
       (n_199));
  OR2N2AXL g7722__1309(.A (i[2]), .B (n_197), .C (n_196), .D (n_69), .O
       (n_198));
  DFMHRL \c_reg[6][0] (.RB (resn), .C (clk), .D0 (\c[6] [0]), .D1
       (n_268), .S1 (n_191), .Q (\c[6] [0]));
  NOR2XL g7719__6877(.A (n_185), .B (i[2]), .O (n_267));
  DFMHRL \c_reg[2][1] (.RB (resn), .C (clk), .D0 (n_269), .D1 (\c[2]
       [1]), .S1 (n_190), .Q (\c[2] [1]));
  DFMHRL \c_reg[4][0] (.RB (resn), .C (clk), .D0 (n_268), .D1 (\c[4]
       [0]), .S1 (n_195), .Q (\c[4] [0]));
  DFMHRL \c_reg[4][2] (.RB (resn), .C (clk), .D0 (n_227), .D1 (\c[4]
       [2]), .S1 (n_195), .Q (\c[4] [2]));
  DFMHRL \c_reg[4][1] (.RB (resn), .C (clk), .D0 (n_269), .D1 (\c[4]
       [1]), .S1 (n_195), .Q (\c[4] [1]));
  NOR2XL g7712__2900(.A (n_260), .B (n_297), .O (n_259));
  DFMHRL \swp_cnt_reg[8] (.RB (resn), .C (clk), .D0 (n_154), .D1
       (swp_cnt[8]), .S1 (n_273), .Q (swp_cnt[8]));
  DFMHRL \swp_cnt_reg[5] (.RB (resn), .C (clk), .D0 (n_126), .D1
       (swp_cnt[5]), .S1 (n_273), .Q (swp_cnt[5]));
  DFMHRL \swp_cnt_reg[11] (.RB (resn), .C (clk), .D0 (n_168), .D1
       (swp_cnt[11]), .S1 (n_273), .Q (swp_cnt[11]));
  DFMHRL \swp_cnt_reg[13] (.RB (resn), .C (clk), .D0 (n_177), .D1
       (swp_cnt[13]), .S1 (n_273), .Q (swp_cnt[13]));
  DFMHRL \i_reg[0] (.RB (resn), .C (clk), .D0 (n_188), .D1 (n_197), .S1
       (i[0]), .Q (i[0]));
  NAND3 g7703__2391(.A (n_228), .B (n_230), .C (\array[3] [2]), .O
       (n_194));
  NAND3 g7702__7675(.A (n_228), .B (n_230), .C (\array[3] [1]), .O
       (n_193));
  NAND3 g7701__7118(.A (n_228), .B (n_230), .C (\array[3] [0]), .O
       (n_192));
  DFMHRL \c_reg[6][1] (.RB (resn), .C (clk), .D0 (\c[6] [1]), .D1
       (n_269), .S1 (n_191), .Q (\c[6] [1]));
  DFMHRL \c_reg[6][2] (.RB (resn), .C (clk), .D0 (\c[6] [2]), .D1
       (n_227), .S1 (n_191), .Q (\c[6] [2]));
  DFMHRL \c_reg[2][0] (.RB (resn), .C (clk), .D0 (n_268), .D1 (\c[2]
       [0]), .S1 (n_190), .Q (\c[2] [0]));
  DFMHRL \swp_cnt_reg[1] (.RB (resn), .C (clk), .D0 (n_52), .D1
       (swp_cnt[1]), .S1 (n_273), .Q (swp_cnt[1]));
  DFMHRL \swp_cnt_reg[0] (.RB (resn), .C (clk), .D0 (n_183), .D1
       (n_273), .S1 (swp_cnt[0]), .Q (swp_cnt[0]));
  DFMHRL \swp_cnt_reg[2] (.RB (resn), .C (clk), .D0 (n_88), .D1
       (swp_cnt[2]), .S1 (n_273), .Q (swp_cnt[2]));
  DFMHRL \swp_cnt_reg[3] (.RB (resn), .C (clk), .D0 (n_108), .D1
       (swp_cnt[3]), .S1 (n_273), .Q (swp_cnt[3]));
  DFMHRL \swp_cnt_reg[12] (.RB (resn), .C (clk), .D0 (n_166), .D1
       (swp_cnt[12]), .S1 (n_273), .Q (swp_cnt[12]));
  DFMHRL \swp_cnt_reg[4] (.RB (resn), .C (clk), .D0 (n_116), .D1
       (swp_cnt[4]), .S1 (n_273), .Q (swp_cnt[4]));
  DFMHRL \swp_cnt_reg[6] (.RB (resn), .C (clk), .D0 (n_145), .D1
       (swp_cnt[6]), .S1 (n_273), .Q (swp_cnt[6]));
  DFMHRL \swp_cnt_reg[7] (.RB (resn), .C (clk), .D0 (n_150), .D1
       (swp_cnt[7]), .S1 (n_273), .Q (swp_cnt[7]));
  DFMHRL \swp_cnt_reg[9] (.RB (resn), .C (clk), .D0 (n_158), .D1
       (swp_cnt[9]), .S1 (n_273), .Q (swp_cnt[9]));
  DFMHRL \swp_cnt_reg[10] (.RB (resn), .C (clk), .D0 (n_163), .D1
       (swp_cnt[10]), .S1 (n_273), .Q (swp_cnt[10]));
  AND21OXL g7717__8757(.A (n_188), .B (n_179), .C (i[3]), .O (n_189));
  OR21AXL g7718__1786(.A (n_184), .B (n_178), .C (\c[1] [0]), .O
       (n_187));
  NAND2AN g7750__5953(.A (n_184), .B (i[1]), .O (n_185));
  OR211A g7723__7114(.A (n_182), .B (n_135), .C (i[0]), .D (n_183), .O
       (n_260));
  NAND2AN g7753__5266(.A (n_184), .B (n_134), .O (n_236));
  NAND3AN g7724__2250(.A (n_184), .B (n_140), .C (n_142), .O (n_228));
  DFSHRL ready_reg(.RB (resn), .C (clk), .D (n_295), .Q (ready_624));
  AND21OXL g7761__6083(.A (n_121), .B (i[0]), .C (n_273), .O (n_221));
  NOR2ANXL g7757__2703(.A (n_182), .B (n_184), .O (n_226));
  NAND3AN g7762__5795(.A (n_184), .B (n_268), .C (n_128), .O (n_250));
  NAND2AN g7756__1840(.A (n_184), .B (n_139), .O (n_240));
  DFMHRL \sel_out_reg[7] (.RB (resn), .C (clk), .D0 (\sel_out[7]_632 ),
       .D1 (\array[5] [1]), .S1 (n_167), .Q (\sel_out[7]_632 ));
  DFMHRL \sel_out_reg[4] (.RB (resn), .C (clk), .D0 (\sel_out[4]_629 ),
       .D1 (\array[6] [1]), .S1 (n_167), .Q (\sel_out[4]_629 ));
  DFMHRL \sel_out_reg[3] (.RB (resn), .C (clk), .D0 (\sel_out[3]_628 ),
       .D1 (\array[6] [0]), .S1 (n_167), .Q (\sel_out[3]_628 ));
  DFMHRL \sel_out_reg[2] (.RB (resn), .C (clk), .D0 (\sel_out[2]_627 ),
       .D1 (\array[7] [2]), .S1 (n_167), .Q (\sel_out[2]_627 ));
  DFMHRL \sel_out_reg[1] (.RB (resn), .C (clk), .D0 (\sel_out[1]_626 ),
       .D1 (\array[7] [1]), .S1 (n_167), .Q (\sel_out[1]_626 ));
  DFMHRL \sel_out_reg[11] (.RB (resn), .C (clk), .D0 (\sel_out[11]_636
       ), .D1 (\array[4] [2]), .S1 (n_167), .Q (\sel_out[11]_636 ));
  INV g7768(.A (n_188), .O (n_196));
  DFMHRL \sel_out_reg[15] (.RB (resn), .C (clk), .D0 (\sel_out[15]_640
       ), .D1 (\array[2] [0]), .S1 (n_167), .Q (\sel_out[15]_640 ));
  DFMHRL \sel_out_reg[19] (.RB (resn), .C (clk), .D0 (\sel_out[19]_644
       ), .D1 (\array[1] [1]), .S1 (n_167), .Q (\sel_out[19]_644 ));
  AND2 g7760__5019(.A (n_183), .B (n_179), .O (n_213));
  NAND2 g7755__1857(.A (n_183), .B (n_172), .O (n_248));
  NAND2 g7754__9906(.A (n_183), .B (n_104), .O (n_230));
  NAND2 g7759__8780(.A (n_183), .B (n_173), .O (n_237));
  NAND2 g7758__4296(.A (n_183), .B (n_175), .O (n_257));
  NAND2AN g7764__3772(.A (n_178), .B (n_183), .O (n_241));
  DFMHRL \sel_out_reg[16] (.RB (resn), .C (clk), .D0 (\sel_out[16]_641
       ), .D1 (\array[2] [1]), .S1 (n_167), .Q (\sel_out[16]_641 ));
  DFMHRL \sel_out_reg[6] (.RB (resn), .C (clk), .D0 (\sel_out[6]_631 ),
       .D1 (\array[5] [0]), .S1 (n_167), .Q (\sel_out[6]_631 ));
  DFMHRL \sel_out_reg[8] (.RB (resn), .C (clk), .D0 (\sel_out[8]_633 ),
       .D1 (\array[5] [2]), .S1 (n_167), .Q (\sel_out[8]_633 ));
  DFMHRL \sel_out_reg[0] (.RB (resn), .C (clk), .D0 (\sel_out[0]_625 ),
       .D1 (\array[7] [0]), .S1 (n_167), .Q (\sel_out[0]_625 ));
  DFMHRL \sel_out_reg[10] (.RB (resn), .C (clk), .D0 (\sel_out[10]_635
       ), .D1 (\array[4] [1]), .S1 (n_167), .Q (\sel_out[10]_635 ));
  DFMHRL \sel_out_reg[12] (.RB (resn), .C (clk), .D0 (\sel_out[12]_637
       ), .D1 (\array[3] [0]), .S1 (n_167), .Q (\sel_out[12]_637 ));
  DFMHRL \sel_out_reg[13] (.RB (resn), .C (clk), .D0 (\sel_out[13]_638
       ), .D1 (\array[3] [1]), .S1 (n_167), .Q (\sel_out[13]_638 ));
  DFMHRL \sel_out_reg[14] (.RB (resn), .C (clk), .D0 (\sel_out[14]_639
       ), .D1 (\array[3] [2]), .S1 (n_167), .Q (\sel_out[14]_639 ));
  DFMHRL \sel_out_reg[9] (.RB (resn), .C (clk), .D0 (\sel_out[9]_634 ),
       .D1 (\array[4] [0]), .S1 (n_167), .Q (\sel_out[9]_634 ));
  DFMHRL \sel_out_reg[17] (.RB (resn), .C (clk), .D0 (\sel_out[17]_642
       ), .D1 (\array[2] [2]), .S1 (n_167), .Q (\sel_out[17]_642 ));
  DFMHRL \sel_out_reg[18] (.RB (resn), .C (clk), .D0 (\sel_out[18]_643
       ), .D1 (\array[1] [0]), .S1 (n_167), .Q (\sel_out[18]_643 ));
  DFMHRL \sel_out_reg[21] (.RB (resn), .C (clk), .D0 (\sel_out[21]_646
       ), .D1 (\array[0] [0]), .S1 (n_167), .Q (\sel_out[21]_646 ));
  DFMHRL \sel_out_reg[22] (.RB (resn), .C (clk), .D0 (\sel_out[22]_647
       ), .D1 (\array[0] [1]), .S1 (n_167), .Q (\sel_out[22]_647 ));
  DFMHRL \sel_out_reg[23] (.RB (resn), .C (clk), .D0 (\sel_out[23]_648
       ), .D1 (\array[0] [2]), .S1 (n_167), .Q (\sel_out[23]_648 ));
  DFMHRL \sel_out_reg[20] (.RB (resn), .C (clk), .D0 (\sel_out[20]_645
       ), .D1 (\array[1] [2]), .S1 (n_167), .Q (\sel_out[20]_645 ));
  DFMHRL \sel_out_reg[5] (.RB (resn), .C (clk), .D0 (\sel_out[5]_630 ),
       .D1 (\array[6] [2]), .S1 (n_167), .Q (\sel_out[5]_630 ));
  HADD g7725__1474(.A (swp_cnt[13]), .B (n_165), .S (n_177), .C
       (n_176));
  NAND2AN g7766__4547(.A (n_197), .B (n_175), .O (n_195));
  NAND2AN g7767__9682(.A (n_197), .B (i[0]), .O (n_184));
  INV2 g7769(.A (n_183), .O (n_273));
  NAND2AN g7771__1309(.A (n_197), .B (n_173), .O (n_190));
  NOR2XL g7770__6877(.A (n_171), .B (n_197), .O (n_188));
  NOR2ANXL g7772__2900(.A (n_172), .B (n_197), .O (n_191));
  AND2 g7773__2391(.A (n_171), .B (n_170), .O (n_183));
  INV g7775(.A (n_170), .O (n_197));
  EXOR g7776__7675(.A (swp_cnt[11]), .B (n_162), .O (n_168));
  NOR2XL g7777__7118(.A (n_164), .B (i[3]), .O (n_170));
  HADD g7778__8757(.A (swp_cnt[12]), .B (n_160), .S (n_166), .C
       (n_165));
  BF3 g7782(.A (n_164), .O (n_167));
  OR211AXL g7783__1786(.A (sel[15]), .B (n_6), .C (n_161), .D (n_91),
       .O (n_164));
  HADD g7784__5953(.A (swp_cnt[10]), .B (n_159), .S (n_163), .C
       (n_162));
  AND222OXL g7785__5703(.A (swp_cnt[14]), .B (n_65), .C (n_152), .D
       (n_90), .E (n_157), .F (swp_cnt[15]), .O (n_161));
  NOR2ANXL g7786__7114(.A (n_159), .B (n_155), .O (n_160));
  HADD g7787__5266(.A (swp_cnt[9]), .B (n_153), .S (n_158), .C (n_159));
  OR3XL g7788__2250(.A (n_156), .B (swp_cnt[13]), .C (swp_cnt[14]), .O
       (n_157));
  NOR3ANXL g7789__6083(.A (swp_cnt[12]), .B (n_151), .C (n_155), .O
       (n_156));
  HADD g7790__2703(.A (swp_cnt[8]), .B (n_148), .S (n_154), .C (n_153));
  AND211OXL g7796__5795(.A (n_78), .B (sel[12]), .C (n_77), .D (n_147),
       .O (n_152));
  AND21OXL g7791__7344(.A (n_149), .B (swp_cnt[8]), .C (swp_cnt[9]), .O
       (n_151));
  NOR2ANXL g7792__1840(.A (n_149), .B (n_148), .O (n_150));
  AND221OXL g7797__5019(.A (n_59), .B (swp_cnt[11]), .C (n_144), .D
       (n_96), .E (n_97), .O (n_147));
  OR2 g7793__1857(.A (n_146), .B (swp_cnt[7]), .O (n_149));
  AND2 g7794__9906(.A (n_146), .B (swp_cnt[7]), .O (n_148));
  INV g7799(.A (n_215), .O (n_232));
  INV g7802(.A (n_212), .O (n_229));
  INV g7803(.A (n_214), .O (n_223));
  HADD g7795__8780(.A (swp_cnt[6]), .B (n_125), .S (n_145), .C (n_146));
  AND211OXL g7800__4296(.A (n_74), .B (sel[8]), .C (n_73), .D (n_131),
       .O (n_144));
  NAND3 g7804__3772(.A (n_141), .B (n_130), .C (n_118), .O (n_212));
  NAND3 g7801__1474(.A (n_136), .B (n_132), .C (n_120), .O (n_215));
  NAND3 g7805__4547(.A (n_138), .B (n_127), .C (n_119), .O (n_214));
  AND3 g7806__9682(.A (n_171), .B (n_143), .C (n_123), .O (n_269));
  AND2 g7808__2683(.A (n_171), .B (n_111), .O (n_268));
  AND21OXL g7807__1309(.A (n_143), .B (n_142), .C (n_133), .O (n_227));
  AND222OXL g7809__6877(.A (n_140), .B (\array[3] [2]), .C (n_139), .D
       (\array[1] [2]), .E (n_137), .F (\array[0] [2]), .O (n_141));
  AND222OXL g7810__2900(.A (n_140), .B (\array[3] [1]), .C (n_139), .D
       (\array[1] [1]), .E (n_137), .F (\array[0] [1]), .O (n_138));
  AND222OXL g7811__2391(.A (n_135), .B (\array[5] [0]), .C (n_134), .D
       (\array[2] [0]), .E (n_129), .F (\array[4] [0]), .O (n_136));
  INV g7812(.A (n_133), .O (n_171));
  AND22OXL g7821__7675(.A (n_137), .B (\array[0] [0]), .C (n_140), .D
       (\array[3] [0]), .O (n_132));
  AND222OXL g7816__7118(.A (swp_cnt[7]), .B (n_36), .C (swp_cnt[6]), .D
       (n_58), .E (n_117), .F (n_57), .O (n_131));
  AND22OXL g7818__8757(.A (n_129), .B (\array[4] [2]), .C (n_128), .D
       (\array[6] [2]), .O (n_130));
  AND22OXL g7819__1786(.A (n_129), .B (\array[4] [1]), .C (n_128), .D
       (\array[6] [1]), .O (n_127));
  NOR2ANXL g7817__5953(.A (n_124), .B (n_114), .O (n_133));
  HADD g7798__5703(.A (swp_cnt[5]), .B (n_115), .S (n_126), .C (n_125));
  AND2N2OXL g7822__7114(.A (n_123), .B (n_66), .C (n_113), .D (i[1]),
       .O (n_124));
  INV g7824(.A (n_137), .O (n_121));
  AND22OXL g7814__5266(.A (n_139), .B (\array[1] [0]), .C (n_128), .D
       (\array[6] [0]), .O (n_120));
  AND22OXL g7815__2250(.A (n_134), .B (\array[2] [1]), .C (n_135), .D
       (\array[5] [1]), .O (n_119));
  AND22OXL g7820__6083(.A (n_134), .B (\array[2] [2]), .C (n_135), .D
       (\array[5] [2]), .O (n_118));
  NOR2XL g7825__2703(.A (n_123), .B (n_142), .O (n_129));
  NOR2ANXL g7826__5795(.A (n_142), .B (n_123), .O (n_137));
  OR221A g7834__7344(.A (n_62), .B (n_109), .C (sel[5]), .D (n_18), .E
       (n_63), .O (n_117));
  HADD g7813__1840(.A (swp_cnt[4]), .B (n_107), .S (n_116), .C (n_115));
  OR2N2AXL g7827__5019(.A (i[2]), .B (n_142), .C (n_112), .D (n_41), .O
       (n_114));
  AND3 g7829__1857(.A (n_113), .B (n_112), .C (n_142), .O (n_139));
  AND3 g7828__9906(.A (n_111), .B (n_110), .C (n_142), .O (n_134));
  INV g7830(.A (n_140), .O (n_143));
  NOR2XL g7835__8780(.A (n_111), .B (n_142), .O (n_135));
  NAND2 g7832__4296(.A (n_113), .B (n_111), .O (n_123));
  AND2 g7833__3772(.A (n_112), .B (n_110), .O (n_140));
  NOR2XL g7836__1474(.A (n_113), .B (n_142), .O (n_128));
  INV g7838(.A (n_222), .O (n_253));
  INV g7841(.A (n_112), .O (n_111));
  INV g7843(.A (n_225), .O (n_246));
  INV g7842(.A (n_220), .O (n_251));
  INV g7837(.A (n_113), .O (n_110));
  NAND3 g7840__4547(.A (n_106), .B (n_99), .C (n_92), .O (n_222));
  NAND3 g7844__9682(.A (n_105), .B (n_98), .C (n_84), .O (n_112));
  OR222AXL g7853__2683(.A (n_89), .B (n_46), .C (swp_cnt[4]), .D
       (n_61), .E (n_45), .F (swp_cnt[3]), .O (n_109));
  NAND3 g7846__1309(.A (n_101), .B (n_100), .C (n_81), .O (n_225));
  NAND3 g7845__6877(.A (n_103), .B (n_94), .C (n_80), .O (n_220));
  HADD g7831__2900(.A (swp_cnt[3]), .B (n_87), .S (n_108), .C (n_107));
  AND3 g7839__2391(.A (n_95), .B (n_82), .C (n_93), .O (n_113));
  AND222OXL g7847__7675(.A (n_83), .B (\array[4] [2]), .C (n_85), .D
       (\array[5] [2]), .E (n_173), .F (\array[2] [2]), .O (n_106));
  AND222OXL g7850__7118(.A (n_104), .B (\c[3] [0]), .C (n_102), .D
       (\c[1] [0]), .E (n_172), .F (\c[6] [0]), .O (n_105));
  AND222OXL g7849__8757(.A (n_104), .B (\array[3] [0]), .C (n_102), .D
       (\array[1] [0]), .E (n_172), .F (\array[6] [0]), .O (n_103));
  AND222OXL g7848__1786(.A (n_104), .B (\array[3] [1]), .C (n_102), .D
       (\array[1] [1]), .E (n_172), .F (\array[6] [1]), .O (n_101));
  AND22OXL g7852__5953(.A (n_173), .B (\array[2] [1]), .C (n_179), .D
       (\array[7] [1]), .O (n_100));
  AND22OXL g7855__5703(.A (n_172), .B (\array[6] [2]), .C (n_179), .D
       (\array[7] [2]), .O (n_99));
  AND22OXL g7860__7114(.A (n_173), .B (\c[2] [0]), .C (n_179), .D
       (\c[7] [0]), .O (n_98));
  OR2N2AXL g7859__5266(.A (n_96), .B (n_75), .C (n_60), .D (sel[10]),
       .O (n_97));
  AND22OXL g7858__2250(.A (n_173), .B (\c[2] [1]), .C (n_172), .D
       (\c[6] [1]), .O (n_95));
  AND22OXL g7861__6083(.A (n_173), .B (\array[2] [0]), .C (n_179), .D
       (\array[7] [0]), .O (n_94));
  AND2 g7856__2703(.A (n_86), .B (n_71), .O (n_142));
  AND22OXL g7854__5795(.A (n_104), .B (\c[3] [1]), .C (n_179), .D
       (\c[7] [1]), .O (n_93));
  AND22OXL g7857__7344(.A (n_104), .B (\array[3] [2]), .C (n_102), .D
       (\array[1] [2]), .O (n_92));
  NAND2 g7862__1840(.A (n_79), .B (n_90), .O (n_91));
  AND222OXL g7865__5019(.A (n_49), .B (sel[1]), .C (n_25), .D (n_64),
       .E (n_44), .F (sel[2]), .O (n_89));
  HADD g7851__1857(.A (swp_cnt[2]), .B (n_51), .S (n_88), .C (n_87));
  AND22OXL g7863__9906(.A (n_85), .B (\c[5] [2]), .C (n_70), .D
       (\c[6] [2]), .O (n_86));
  AND22OXL g7870__8780(.A (n_85), .B (\c[5] [0]), .C (n_83), .D
       (\c[4] [0]), .O (n_84));
  AND22OXL g7871__4296(.A (n_175), .B (\c[4] [1]), .C (n_85), .D
       (\c[5] [1]), .O (n_82));
  AND22OXL g7872__3772(.A (n_85), .B (\array[5] [1]), .C (n_83), .D
       (\array[4] [1]), .O (n_81));
  AND22OXL g7874__1474(.A (n_85), .B (\array[5] [0]), .C (n_83), .D
       (\array[4] [0]), .O (n_80));
  OR32AXL g7866__4547(.A (n_78), .B (n_77), .C (sel[12]), .D (sel[13]),
       .E (n_9), .O (n_79));
  OR32AXL g7867__9682(.A (n_74), .B (n_73), .C (sel[8]), .D (sel[9]),
       .E (n_13), .O (n_75));
  AND22OXL g7873__2683(.A (n_179), .B (\c[7] [2]), .C (n_83), .D
       (\c[4] [2]), .O (n_71));
  AND2 g7869__1309(.A (n_70), .B (i[2]), .O (n_172));
  NOR2AN g7868__6877(.A (n_70), .B (i[2]), .O (n_173));
  HADD g7864__2900(.A (n_34), .B (n_47), .S (n_69), .C (n_104));
  HADD g7876__2391(.A (n_66), .B (i[1]), .S (n_67), .C (n_70));
  NOR2XL g7881__7675(.A (n_53), .B (sel[14]), .O (n_65));
  INV g7878(.A (n_50), .O (n_64));
  NAND3AN g7877__7118(.A (n_62), .B (swp_cnt[4]), .C (n_61), .O (n_63));
  AND2 g7882__8757(.A (n_182), .B (n_66), .O (n_175));
  AND21OXL g7886__1786(.A (swp_cnt[10]), .B (n_59), .C (n_38), .O
       (n_60));
  NOR2XL g7885__5953(.A (n_55), .B (sel[6]), .O (n_58));
  AND21OXL g7887__5703(.A (n_23), .B (sel[6]), .C (n_55), .O (n_57));
  AND21OXL g7890__7114(.A (n_24), .B (sel[14]), .C (n_53), .O (n_90));
  AND2 g7883__5266(.A (n_182), .B (i[0]), .O (n_85));
  HADD g7875__2250(.A (swp_cnt[1]), .B (swp_cnt[0]), .S (n_52), .C
       (n_51));
  OR21AXL g7880__6083(.A (n_49), .B (sel[1]), .C (sel[0]), .O (n_50));
  AND2 g7884__2703(.A (n_47), .B (i[2]), .O (n_179));
  OR2N2AXL g7888__5795(.A (n_45), .B (swp_cnt[3]), .C (n_44), .D
       (sel[2]), .O (n_46));
  AND2N2OXL g7889__7344(.A (swp_cnt[11]), .B (n_59), .C (n_19), .D
       (sel[10]), .O (n_96));
  INV g7898(.A (n_47), .O (n_41));
  INV g7891(.A (n_102), .O (n_178));
  NOR2ANXL g7900__1840(.A (sel[15]), .B (swp_cnt[15]), .O (n_53));
  NOR2ANXL g7892__5019(.A (sel[13]), .B (swp_cnt[13]), .O (n_77));
  INV g7897(.A (n_155), .O (n_38));
  NOR2ANXL g7901__1857(.A (sel[5]), .B (swp_cnt[5]), .O (n_62));
  NOR2XL g7899__9906(.A (swp_cnt[7]), .B (n_36), .O (n_55));
  NOR2ANXL g7893__8780(.A (sel[9]), .B (swp_cnt[9]), .O (n_73));
  NOR2XL g7894__4296(.A (n_34), .B (i[1]), .O (n_182));
  NAND2 g7902__3772(.A (swp_cnt[10]), .B (swp_cnt[11]), .O (n_155));
  NOR2 g7896__1474(.A (i[2]), .B (i[1]), .O (n_102));
  AND2 g7903__4547(.A (i[0]), .B (i[1]), .O (n_47));
  NOR2 g7895__9682(.A (i[0]), .B (i[1]), .O (n_83));
  BF4 g7904(.A (\sel_out[3]_628 ), .O (sel_out[3]));
  BF4 g7931(.A (\sel_out[21]_646 ), .O (sel_out[21]));
  BF4 g7909(.A (\sel_out[13]_638 ), .O (sel_out[13]));
  BF4 g7905(.A (\sel_out[9]_634 ), .O (sel_out[9]));
  BF4 g7908(.A (\sel_out[17]_642 ), .O (sel_out[17]));
  BF4 g7936(.A (\sel_out[5]_630 ), .O (sel_out[5]));
  BF4 g7927(.A (\sel_out[8]_633 ), .O (sel_out[8]));
  BF4 g7911(.A (\sel_out[15]_640 ), .O (sel_out[15]));
  INV g7922(.A (swp_cnt[0]), .O (n_25));
  INV g7955(.A (swp_cnt[14]), .O (n_24));
  INV g7950(.A (swp_cnt[6]), .O (n_23));
  BF4 g7929(.A (\sel_out[11]_636 ), .O (sel_out[11]));
  BF4 g7916(.A (\sel_out[10]_635 ), .O (sel_out[10]));
  BF4 g7915(.A (\sel_out[12]_637 ), .O (sel_out[12]));
  INV g7951(.A (swp_cnt[10]), .O (n_19));
  INV g7921(.A (swp_cnt[5]), .O (n_18));
  INV g7920(.A (swp_cnt[1]), .O (n_49));
  INVXL g7933(.A (sel[3]), .O (n_45));
  INV g7949(.A (swp_cnt[2]), .O (n_44));
  INV g7923(.A (i[2]), .O (n_34));
  INVXL g7944(.A (sel[7]), .O (n_36));
  INV g7953(.A (swp_cnt[8]), .O (n_74));
  INV g7961(.A (i[0]), .O (n_66));
  INV g7959(.A (\array[0] [1]), .O (n_245));
  INV g7957(.A (\array[0] [2]), .O (n_254));
  BF4 g7925(.A (\sel_out[19]_644 ), .O (sel_out[19]));
  BF4 g7932(.A (\sel_out[2]_627 ), .O (sel_out[2]));
  BF4 g7918(.A (\sel_out[14]_639 ), .O (sel_out[14]));
  INV g7952(.A (swp_cnt[9]), .O (n_13));
  BF4 g7910(.A (\sel_out[22]_647 ), .O (sel_out[22]));
  BF4 g7914(.A (\sel_out[0]_625 ), .O (sel_out[0]));
  BF4 g7906(.A (\sel_out[20]_645 ), .O (sel_out[20]));
  INV g7958(.A (swp_cnt[13]), .O (n_9));
  BF4 g7926(.A (\sel_out[4]_629 ), .O (sel_out[4]));
  BF4 g7913(.A (\sel_out[1]_626 ), .O (sel_out[1]));
  INV g7956(.A (swp_cnt[15]), .O (n_6));
  BF4 g7928(.A (\sel_out[7]_632 ), .O (sel_out[7]));
  BF4 g7917(.A (\sel_out[18]_643 ), .O (sel_out[18]));
  BF4 g7912(.A (ready_624), .O (ready));
  BF4 g7934(.A (\sel_out[16]_641 ), .O (sel_out[16]));
  BF4 g7907(.A (\sel_out[6]_631 ), .O (sel_out[6]));
  BF4 g7919(.A (\sel_out[23]_648 ), .O (sel_out[23]));
  INVXL g7938(.A (sel[4]), .O (n_61));
  INV g7960(.A (swp_cnt[12]), .O (n_78));
  INVXL g7948(.A (sel[11]), .O (n_59));
  INV g7954(.A (\array[0] [0]), .O (n_249));
  NAND2AN g2(.A (n_185), .B (i[2]), .O (n_294));
  OR2 g8049(.A (ready_624), .B (n_167), .O (n_295));
  NAND2AN g8050(.A (n_184), .B (n_129), .O (n_296));
  NOR2ANXL g8051(.A (n_85), .B (n_273), .O (n_297));
endmodule

