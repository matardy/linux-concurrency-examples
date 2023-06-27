#
# Internetworking with TCP/IP, Volume III example code Makefile
#
#	David L Stevens, Internetworking Research Group at Purdue
#	Tue Sep 17 19:40:42 EST 1991
#

INCLUDE =

CLNTS = TCPecho 
SERVS = TCPmechod

DEFS =
CFLAGS = -W -pedantic -ansi -g ${DEFS} ${INCLUDE}

HDR =
CSRC = TCPecho.c 
CXSRC = connectTCP.c connectsock.c errexit.c

SSRC = TCPmechod.c
SXSRC = passiveTCP.c passivesock.c errexit.c

CXOBJ = connectTCP.o connectsock.o errexit.o
SXOBJ = passiveTCP.o passivesock.o errexit.o

PROGS = ${CLNTS} ${SERVS}

all: ${PROGS}

${CLNTS}: ${CXOBJ}
	${CC} -o $@ ${CFLAGS} $@.o ${CXOBJ}

${SERVS}: ${SXOBJ}
	${CC} -o $@ ${CFLAGS} $@.o ${SXOBJ}

TCPmechod: TCPmechod.o ${SXOBJ}
	${CC} -o $@ ${CFLAGS} $@.o ${SXOBJ}

clients: ${CLNTS}
servers: ${SERVS}

clean: FRC
	rm -f Makefile.bak a.out core errs lint.errs ${PROGS} *.o

depend: ${HDR} ${CSRC} ${SSRC} ${TNSRC} FRC
	maketd -a ${DEFS} ${INCLUDE} ${CSRC} ${SSRC} ${TNSRC}

install: all FRC
	@echo "Your installation instructions here."

lint: ${HDR} ${XSRC} ${CSRC} ${SSRC} FRC
	lint ${DEFS} ${INCLUDE} ${CSRC} ${SSRC} ${CXSRC} ${SXSRC}

print: Makefile ${SRC} FRC
	lpr Makefile ${CSRC} ${SSRC} ${CXSRC} ${SXSRC}

spotless: clean FRC
	rcsclean Makefile ${HDR} ${SRC}

tags: ${CSRC} ${SSRC} ${CXSRC} ${SXSRC}
	ctags ${CSRC} ${SSRC} ${CXSRC} ${SXSRC}

${HDR} ${CSRC} ${CXSRC} ${SSRC} ${SXSRC}:
	co $@

TCPecho: TCPecho.o
TCPdaytime: TCPdaytime.o
TCPtecho: TCPtecho.o
UDPecho: UDPecho.o
UDPtime: UDPtime.o
TCPdaytimed: TCPdaytimed.o
TCPechod: TCPechod.o
TCPmechod: TCPmechod.o
UDPtimed: UDPtimed.o
daytimed: daytimed.o
superd: superd.o

FRC:
	
# DO NOT DELETE THIS LINE - maketd DEPENDS ON IT
