# **********************************************************************
#
# Copyright (c) 2003-2007 ZeroC, Inc. All rights reserved.
#
# This copy of Ice is licensed to you under the terms described in the
# ICE_LICENSE file included in this distribution.
#
# **********************************************************************

!if "$(ICE_HOME)" == ""
ICE_DIR		= $(top_srcdir)\..
USE_SRC_DIR	= 1
!else
ICE_DIR 	= $(ICE_HOME)
!endif

#
# Select an installation base directory. The directory will be created
# if it does not exist.
#

prefix			= C:\IceRuby-$(VERSION)

#
# Define OPTIMIZE as yes if you want to build with optimization.
# Otherwise the Ice extension is built with debug information.
#

OPTIMIZE		= yes

#
# Specify your C++ compiler. Supported values are:
# VC60
#
!if "$(CPP_COMPILER)" == ""
CPP_COMPILER            = VC60
!endif

#
# Set RUBY_HOME to your Ruby installation directory.
#
!if "$(RUBY_HOME)" == ""
RUBY_HOME		= C:\ruby
!endif

#
# Set STLPORT_HOME to your STLPort installation directory.
#
!if "$(STLPORT_HOME)" == ""
STLPORT_HOME            = C:\Ice-$(VERSION)-ThirdParty-VC60
!endif

# ----------------------------------------------------------------------
# Don't change anything below this line!
# ----------------------------------------------------------------------

SHELL			= /bin/sh
VERSION			= 3.3.0
SOVERSION		= 33
libdir			= $(top_srcdir)\lib
rubydir			= $(top_srcdir)\ruby

install_libdir		= $(prefix)\lib
install_slicedir        = $(prefix)\slice
install_rubydir		= $(prefix)\ruby

THIRDPARTY_HOME         = $(STLPORT_HOME)

!if "$(CPP_COMPILER)" != "VC60"
!error Invalid setting for CPP_COMPILER: $(CPP_COMPILER)
!endif

!include $(top_srcdir)\..\cpp\config\Make.rules.msvc

!if "$(OPTIMIZE)" != "yes"
LIBSUFFIX       = $(LIBSUFFIX)d
!endif

ICE_LIBS		= ice$(LIBSUFFIX).lib iceutil$(LIBSUFFIX).lib slice$(LIBSUFFIX).lib

!if "$(USE_SRC_DIR)" == "1"
ICE_CPPFLAGS		= -I"$(ICE_DIR)\cpp\include"
ICE_LDFLAGS		= /LIBPATH:"$(ICE_DIR)\cpp\lib"
!else
ICE_CPPFLAGS		= -I"$(ICE_DIR)\include"
ICE_LDFLAGS		= /LIBPATH:"$(ICE_DIR)\lib"
!endif

slicedir                = $(top_srcdir)\..\slice

RUBY_CPPFLAGS		= -I"$(RUBY_HOME)\lib\ruby\1.8\i386-mswin32"
RUBY_LDFLAGS		= /LIBPATH:"$(RUBY_HOME)\lib"
RUBY_LIBS		= msvcrt-ruby18.lib

ICECPPFLAGS		= -I$(slicedir)
SLICE2RBFLAGS		= $(ICECPPFLAGS)

!if "$(USE_SRC_DIR)" == "1"
SLICE2RB		= "$(ICE_DIR)\cpp\bin\slice2rb.exe"
!else
SLICE2RB		= "$(ICE_DIR)\bin\slice2rb.exe"
!endif

EVERYTHING		= all clean install

.SUFFIXES:
.SUFFIXES:		.cpp .obj .rb

all:: $(SRCS)

.cpp.obj::
	$(CXX) /c $(CPPFLAGS) $(CXXFLAGS) $<

clean::
	del /q $(TARGETS) core *.obj *.bak

all:: $(SRCS) $(TARGETS)

install::
