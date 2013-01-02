
TESTS = string_test list_test map_test thread_test
check_PROGRAMS = string_test list_test map_test thread_test

string_test_SOURCES = string_test.m
string_test_LDADD = $(top_builddir)/src/libtinystep.la
string_test_OBJCFLAGS = -I$(top_srcdir)/src -I$(top_builddir)/src $(OBJC_CFLAGS)
string_test_LDFLAGS = $(OBJC_LIBS)

list_test_SOURCES = list_test.m
list_test_LDADD = $(top_builddir)/src/libtinystep.la
list_test_OBJCFLAGS = -I$(top_srcdir)/src -I$(top_builddir)/src $(OBJC_CFLAGS)
list_test_LDFLAGS = $(OBJC_LIBS)

map_test_SOURCES = map_test.m
map_test_LDADD = $(top_builddir)/src/libtinystep.la
map_test_OBJCFLAGS = -I$(top_srcdir)/src -I$(top_builddir)/src $(OBJC_CFLAGS)
map_test_LDFLAGS = $(OBJC_LIBS)

thread_test_SOURCES = thread_test.m
thread_test_LDADD = $(top_builddir)/src/libtinystep.la
thread_test_OBJCFLAGS = -I$(top_srcdir)/src -I$(top_builddir)/src $(OBJC_CFLAGS)
thread_test_LDFLAGS = $(OBJC_LIBS)