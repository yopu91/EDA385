################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/game_logic.c \
../src/image_cleanup.c \
../src/overlap_detect.c \
../src/platform.c 

LD_SRCS += \
../src/lscript.ld 

OBJS += \
./src/game_logic.o \
./src/image_cleanup.o \
./src/overlap_detect.o \
./src/platform.o 

C_DEPS += \
./src/game_logic.d \
./src/image_cleanup.d \
./src/overlap_detect.d \
./src/platform.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -Wl,--no-relax -I../../eyetoy_bsp_0/microblaze_0/include -mlittle-endian -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.40.a -mno-xl-soft-mul -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '


