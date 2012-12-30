
TESTS = string_test list_test
check_PROGRAMS = string_test list_test

string_test_SOURCES = string_test.m
string_test_LDADD = $(top_builddir)/src/libtinystep.la
string_test_OBJCFLAGS = -I$(top_srcdir)/src -I$(top_builddir)/src $(OBJC_CFLAGS)
string_test_LDFLAGS = $(OBJC_LIBS)

list_test_SOURCES = list_test.m
list_test_LDADD = $(top_builddir)/src/libtinystep.la
list_test_OBJCFLAGS = -I$(top_srcdir)/src -I$(top_builddir)/src $(OBJC_CFLAGS)
list_test_LDFLAGS = $(OBJC_LIBS)
