	.text
	.file	"filter.c"
	.section	.text.clamp,"ax",@progbits
	.hidden	clamp                   # -- Begin function clamp
	.globl	clamp
	.type	clamp,@function
clamp:                                  # @clamp
	.param  	i32, i32
	.result 	i32
# BB#0:
	block   	
	i32.div_s	$push8=, $0, $1
	tee_local	$push7=, $0=, $pop8
	i32.const	$push6=, 0
	i32.lt_s	$push0=, $pop7, $pop6
	br_if   	0, $pop0        # 0: down to label0
# BB#1:
	i32.const	$push3=, -1
	i32.const	$push1=, 255
	i32.gt_s	$push2=, $0, $pop1
	i32.select	$push4=, $pop3, $0, $pop2
	i32.const	$push9=, 255
	i32.and 	$push5=, $pop4, $pop9
	return  	$pop5
.LBB0_2:
	end_block                       # label0:
	i32.const	$push10=, 0
                                        # fallthrough-return: $pop10
	.endfunc
.Lfunc_end0:
	.size	clamp, .Lfunc_end0-clamp
                                        # -- End function
	.section	.text.applyKernel,"ax",@progbits
	.hidden	applyKernel             # -- Begin function applyKernel
	.globl	applyKernel
	.type	applyKernel,@function
applyKernel:                            # @applyKernel
	.param  	i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:
	i32.const	$11=, -1
	i32.const	$push39=, -1
	i32.add 	$push1=, $3, $pop39
	i32.mul 	$push2=, $4, $pop1
	i32.const	$push38=, 2
	i32.shl 	$push3=, $pop2, $pop38
	i32.const	$push37=, 2
	i32.shl 	$push0=, $2, $pop37
	i32.add 	$push4=, $pop3, $pop0
	i32.add 	$push5=, $0, $pop4
	i32.const	$push6=, -4
	i32.add 	$9=, $pop5, $pop6
	i32.const	$push36=, -1
	i32.add 	$8=, $2, $pop36
	i32.const	$push35=, 2
	i32.shl 	$7=, $4, $pop35
	copy_local	$10=, $6
	i32.const	$14=, 0
.LBB1_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
	loop    	                # label1:
	i32.add 	$12=, $11, $3
	copy_local	$0=, $8
	i32.const	$13=, 0
.LBB1_2:                                #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label2:
	block   	
	i32.const	$push40=, 0
	i32.lt_s	$push7=, $0, $pop40
	br_if   	0, $pop7        # 0: down to label3
# BB#3:                                 #   in Loop: Header=BB1_2 Depth=2
	i32.ge_u	$push8=, $12, $5
	br_if   	0, $pop8        # 0: down to label3
# BB#4:                                 #   in Loop: Header=BB1_2 Depth=2
	i32.const	$push41=, 0
	i32.lt_s	$push9=, $12, $pop41
	br_if   	0, $pop9        # 0: down to label3
# BB#5:                                 #   in Loop: Header=BB1_2 Depth=2
	i32.ge_u	$push10=, $0, $4
	br_if   	0, $pop10       # 0: down to label3
# BB#6:                                 #   in Loop: Header=BB1_2 Depth=2
	i32.add 	$push13=, $10, $13
	i32.load	$push14=, 0($pop13)
	i32.add 	$push11=, $9, $13
	i32.load8_u	$push12=, 0($pop11)
	i32.mul 	$push15=, $pop14, $pop12
	i32.add 	$14=, $pop15, $14
.LBB1_7:                                #   in Loop: Header=BB1_2 Depth=2
	end_block                       # label3:
	i32.const	$push46=, 1
	i32.add 	$0=, $0, $pop46
	i32.const	$push45=, 4
	i32.add 	$push44=, $13, $pop45
	tee_local	$push43=, $13=, $pop44
	i32.const	$push42=, 12
	i32.ne  	$push16=, $pop43, $pop42
	br_if   	0, $pop16       # 0: up to label2
# BB#8:                                 #   in Loop: Header=BB1_1 Depth=1
	end_loop
	i32.add 	$9=, $9, $7
	i32.const	$push51=, 12
	i32.add 	$10=, $10, $pop51
	i32.const	$push50=, 1
	i32.add 	$push49=, $11, $pop50
	tee_local	$push48=, $11=, $pop49
	i32.const	$push47=, 2
	i32.ne  	$push17=, $pop48, $pop47
	br_if   	0, $pop17       # 0: up to label1
# BB#9:
	end_loop
	i32.mul 	$push18=, $4, $3
	i32.add 	$12=, $pop18, $2
	i32.const	$0=, 0
	block   	
	i32.load	$push19=, 36($6)
	i32.div_s	$push54=, $14, $pop19
	tee_local	$push53=, $13=, $pop54
	i32.const	$push52=, 0
	i32.lt_s	$push20=, $pop53, $pop52
	br_if   	0, $pop20       # 0: down to label4
# BB#10:
	i32.const	$push23=, -1
	i32.const	$push21=, 255
	i32.gt_s	$push22=, $13, $pop21
	i32.select	$0=, $pop23, $13, $pop22
.LBB1_11:
	end_block                       # label4:
	i32.const	$push24=, 2
	i32.shl 	$push57=, $12, $pop24
	tee_local	$push56=, $13=, $pop57
	i32.add 	$push25=, $1, $pop56
	i32.store8	0($pop25), $0
	i32.const	$push26=, 1
	i32.or  	$push27=, $13, $pop26
	i32.add 	$push28=, $1, $pop27
	i32.store8	0($pop28), $0
	i32.const	$push55=, 2
	i32.or  	$push29=, $13, $pop55
	i32.add 	$push30=, $1, $pop29
	i32.store8	0($pop30), $0
	i32.const	$push31=, 3
	i32.or  	$push32=, $13, $pop31
	i32.add 	$push33=, $1, $pop32
	i32.const	$push34=, 255
	i32.store8	0($pop33), $pop34
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	applyKernel, .Lfunc_end1-applyKernel
                                        # -- End function
	.section	.text.outline_c,"ax",@progbits
	.hidden	outline_c               # -- Begin function outline_c
	.globl	outline_c
	.type	outline_c,@function
outline_c:                              # @outline_c
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:
	block   	
	i32.const	$push3=, 1
	i32.lt_s	$push0=, $3, $pop3
	br_if   	0, $pop0        # 0: down to label5
# BB#1:
	i32.const	$4=, 0
	i32.const	$push4=, 1
	i32.lt_s	$5=, $2, $pop4
.LBB2_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_4 Depth 2
	loop    	                # label6:
	block   	
	br_if   	0, $5           # 0: down to label7
# BB#3:                                 #   in Loop: Header=BB2_2 Depth=1
	i32.const	$6=, 0
.LBB2_4:                                #   Parent Loop BB2_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label8:
	i32.const	$push8=, outline_kernel
	call    	applyKernel@FUNCTION, $0, $1, $6, $4, $2, $3, $pop8
	i32.const	$push7=, 1
	i32.add 	$push6=, $6, $pop7
	tee_local	$push5=, $6=, $pop6
	i32.ne  	$push1=, $2, $pop5
	br_if   	0, $pop1        # 0: up to label8
.LBB2_5:                                #   in Loop: Header=BB2_2 Depth=1
	end_loop
	end_block                       # label7:
	i32.const	$push11=, 1
	i32.add 	$push10=, $4, $pop11
	tee_local	$push9=, $4=, $pop10
	i32.ne  	$push2=, $pop9, $3
	br_if   	0, $pop2        # 0: up to label6
.LBB2_6:
	end_loop
	end_block                       # label5:
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	outline_c, .Lfunc_end2-outline_c
                                        # -- End function
	.hidden	outline_kernel          # @outline_kernel
	.type	outline_kernel,@object
	.section	.rodata.outline_kernel,"a",@progbits
	.globl	outline_kernel
	.p2align	4
outline_kernel:
	.int32	4294967295              # 0xffffffff
	.int32	4294967295              # 0xffffffff
	.int32	4294967295              # 0xffffffff
	.int32	4294967295              # 0xffffffff
	.int32	8                       # 0x8
	.int32	4294967295              # 0xffffffff
	.int32	4294967295              # 0xffffffff
	.int32	4294967295              # 0xffffffff
	.int32	4294967295              # 0xffffffff
	.int32	1                       # 0x1
	.size	outline_kernel, 40

	.hidden	buffer                  # @buffer
	.type	buffer,@object
	.section	.bss.buffer,"aw",@nobits
	.globl	buffer
	.p2align	4
buffer:
	.skip	7372800
	.size	buffer, 7372800


	.ident	"clang version 5.0.0 (https://github.com/llvm-mirror/clang.git bb80e4561494419619dcc16e9c5f5135550c609a) (https://github.com/llvm-mirror/llvm.git 6f41872eed5f4c5f6b148cd4cb6c381e87679716)"
