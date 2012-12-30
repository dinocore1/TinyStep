
lib_LTLIBRARIES = libtinystep.la

#declare public headers that will be installed
pkginclude_HEADERS = \
	tinystep/TinyStep.h \
	tinystep/TSMemZone.h \
	tinystep/TSObject.h \
	tinystep/TSThread.h \
	tinystep/TSAutoreleasePool.h \
	tinystep/TSString.h \
	tinystep/TSList.h \
	tinystep/TSLinkedList.h \
	tinystep/TSArrayList.h

libtinystep_la_SOURCES = \
	tinystep/TinyStep.h \
	TSMemZone.m tinystep/TSMemZone.h \
	TSObject.m tinystep/TSObject.h \
	TSThread.m tinystep/TSThread.h \
	TSAutoreleasePool.m tinystep/TSAutoreleasePool.h \
	TSString.m tinystep/TSString.h \
	TSLinkedList.m TSLinkedList.h \
	TSArrayList.m TSArrayList.h

libtinystep_la_CPPFLAGS = $(OBJC_CFLAGS)
libtinystep_la_LDFLAGS = $(OBJC_LIBS)


