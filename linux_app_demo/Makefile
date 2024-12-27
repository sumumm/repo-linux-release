##============================================================================#
# Copyright © hk. 2022-2025. All rights reserved.
# File name: Makefile
# Author   : 苏木
# Date     : 2024-12-27
# Version  : 
# Description: 
##============================================================================#
##

##
CROSS_COMPILE 	?= 
TARGET		  	?= app_demo.out
NFS_APP_DEMO    ?= ~/4nfs/app

OBJ_DIR         ?= ./
CC 				:= $(CROSS_COMPILE)gcc
LD				:= $(CROSS_COMPILE)ld
OBJCOPY 		:= $(CROSS_COMPILE)objcopy
OBJDUMP 		:= $(CROSS_COMPILE)objdump

CFLAGS 		    := -Wall

INCDIRS 		:= ./ 

SRCDIRS			:= ./			   

STATIC_LIB_DIRS := ./ 

STATIC_LIB_NAME := 

INCLUDE			:= $(patsubst %, -I %, $(INCDIRS))
STATIC_LIB_FLAG	:= $(patsubst %, -L %, $(STATIC_LIB_DIRS))
STATIC_LIB	    := $(patsubst %, -l%, $(STATIC_LIB_NAME))

CFILES			:= $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.c))

SFILENDIR		:= $(notdir  $(SFILES))
CFILENDIR		:= $(notdir  $(CFILES))

COBJS			:= $(patsubst %, $(OBJ_DIR)%, $(CFILENDIR:.c=.o))
OBJS			:= $(COBJS)

VPATH			:= $(SRCDIRS)
.PHONY: clean
	
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(INCLUDE) $(STATIC_LIB_FLAG) $(STATIC_LIB) $(OBJS) -o $@

$(COBJS) : $(OBJ_DIR)%.o : %.c
	$(CC) $(CFLAGS) -c  $(INCLUDE) $< -o $@
	
clean:
	rm -rf $(TARGET) $(COBJS)

install:
	@cp -avf $(TARGET) $(NFS_APP_DEMO)
	@cp -avf data $(NFS_APP_DEMO)

uninstall:
	@rm -rvf $(NFS_APP_DEMO)/$(TARGET)
	@rm -rvf $(NFS_APP_DEMO)/data

print:
	@echo "INCLUDE=$(INCLUDE)"
	@echo "STATIC_LIB=$(STATIC_LIB)"
	@echo "STATIC_LIB_FLAG=$(STATIC_LIB_FLAG)"