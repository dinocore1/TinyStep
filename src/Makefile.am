
lib_LTLIBRARIES = libtinystep.la

#declare public headers that will be installed
pkginclude_HEADERS = \
	tinystep/TinyStep.h \
	tinystep/TSMemZone.h \
	tinystep/TSObject.h \
	tinystep/TSThread.h \
	tinystep/TSAutoreleasePool.h \
	tinystep/TSString.h \
	tinystep/TSIterator.h \
	tinystep/TSList.h \
	tinystep/TSComparator.h \
	tinystep/TSLinkedList.h \
	tinystep/TSArrayList.h \
	tinystep/TSMap.h \
	tinystep/TSKeyValuePair.h \
	tinystep/TSHashMap.h \
	tinystep/TSLock.h \
	tinystep/TSCondition.h \
	tinystep/TSOperationQueue.h 

libtinystep_la_SOURCES = \
	tinystep/TinyStep.h \
	TSMemZone.m tinystep/TSMemZone.h \
	TSObject.m tinystep/TSObject.h \
	TSThread.m tinystep/TSThread.h \
	TSAutoreleasePool.m tinystep/TSAutoreleasePool.h \
	TSString.m tinystep/TSString.h \
	TSLinkedList.m tinystep/TSLinkedList.h \
	TSArrayList.m tinystep/TSArrayList.h \
	TSKeyValuePair.m tinystep/TSKeyValuePair.h \
	TSHashMap.m tinystep/TSHashMap.h \
	TSLock.m tinystep/TSLock.h \
	TSCondition.m tinystep/TSCondition.h \
	TSOperationQueue.m tinystep/TSOperationQueue.h \
	TSFunctions.m

libtinystep_la_CPPFLAGS = $(OBJC_CFLAGS)
libtinystep_la_LDFLAGS = $(OBJC_LIBS)


