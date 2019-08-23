SHELL=cmd.exe

DIR_ROOT=$(CURDIR)
OUTPUT_DIR =.\Objects

C_FILES+=.\XMC_LIB\XMC\XMC_LIB_2_7_1\XMClib\src\xmc4_gpio\
		.\XMC_LIB\XMC\XMC_LIB_2_7_1\XMClib\src\xmc_common\
		.\main\
		.\XMC_LIB\XMC\XMC_LIB_2_7_1\XMC4400_series\Source\system_XMC4400\
		.\XMC_LIB\XMC\XMC_LIB_2_7_1\XMClib\src\xmc_gpio
		
ADDITIONAL_C_FILES+=.\XMC_LIB\XMC\XMC_LIB_2_7_1\XMC4400_series\Source\system_XMC4400\
					.\XMC_LIB\XMC\XMC_LIB_2_7_1\XMClib\src\xmc_gpio

COMPILE_OBJS+=${addsuffix .o,$(C_FILES)}
ADDITIONAL_COMPILE_OBJS+=${addsuffix .o,$(ADDITIONAL_C_FILES)}

OBJECTS = $(wildcard $(OUTPUT_DIR)/*.o)

ASM_FILES+=.\XMC_LIB\XMC\XMC_LIB_2_7_1\XMC4400_series\Source\ARM\startup_XMC4402

INCL_DIRS = -I".\XMC_LIB\CMSIS_LIB\Include"\
			-I".\XMC_LIB\XMC\XMC_LIB_2_7_1\XMC4400_series\Include"\
			-I".\XMC_LIB\XMC\XMC_LIB_2_7_1\XMClib\inc"

ASM_CMD=%SYSTEMDRIVE%\Keil_v5\ARM\ARMCC\bin\armasm.exe --cpu Cortex-M4.fp --pd "__RTX SETA 1" --pd "__EVAL SETA 1" --apcs=interwork --cpreproc --pd "_RTE_ SETA 1" --pd "XMC4402_F100x256 SETA 1" --list= -o $(OUTPUT_DIR)\startup_XMC4402.o --depend $(OUTPUT_DIR)\startup_XMC4402.d
COMPILE_CMD=%SYSTEMDRIVE%\Keil_v5\ARM\ARMCC\bin\armcc.exe -c --cpu Cortex-M4.fp -D__RTX -D__EVAL  -O3 -Otime --apcs=interwork --split_sections -D_RTE_ -DXMC4402_F100x256 -DARM_MATH_CM4 -DXMC4402_F100x256 --C99 --md --output_dir=$(OUTPUT_DIR)
LINK_CMD=%SYSTEMDRIVE%\Keil_v5\ARM\ARMCC\bin\armlink.exe --cpu Cortex-M4.fp --strict --scatter ".\Blinky.sct" --summary_stderr --info summarysizes --map --xref --callgraph --symbols --info sizes --info totals --info unused --info veneers --list ".\Listings\Blinky.map" -o .\Objects\Blinky.axf $(OBJECTS)

.PHONY:Build_all
build:asm $(COMPILE_OBJS) output

asm:
	@echo  ****************************************Converting***************************************************************************************
	$(ASM_CMD) $(INCL_DIRS) $(ASM_FILES).s

%.o:%.c
	@echo  ****************************************Compiling***************************************************************************************
	$(COMPILE_CMD) $(INCL_DIRS) $^

	
.PHONY:output
output:$(OUTFILE).axf

$(OUTFILE).axf:$(OBJECTS)
	@echo  ****************************************Linking***************************************************************************************
	$(LINK_CMD)