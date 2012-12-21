
lib_LTLIBRARIES = libtinystep.la

#declare public headers that will be installed
pkginclude_HEADERS = \
	tinystep/TinyStep.h \
	tinystep/TSObject.h \
	tinystep/TSString.h \
	tinystep/TSList.h \
	tinystep/TSLinkedList.h

libtinystep_la_SOURCES = \
	tinystep/TinyStep.h \
	TSObject.m tinystep/TSObject.h \
	TSString.m tinystep/TSString.h \
	TSLinkedList.m TSLinkedList.h

libtinystep_la_CPPFLAGS = $(OBJC_CFLAGS)
libtinystep_la_LDFLAGS = $(OBJC_LIBS)


