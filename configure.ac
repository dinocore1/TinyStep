AC_PREREQ(2.59)
AC_INIT(TinyStep, 0.1, paul@dev-smart.com)

AC_CANONICAL_SYSTEM # create cross platform build system
AM_INIT_AUTOMAKE

AC_ARG_ENABLE([debug],
  AS_HELP_STRING([--enable-debug], [compile with -g -O0]),
  [echo "compiling with -g -O0"
  OBJCFLAGS+=" -g -O0"
  CFLAGS+=" -g -O0"
  CXXFLAGS+=" -g -O0"
  ]
)

AC_PROG_OBJC([clang])
AC_LANG([Objective C])

LT_INIT

PKG_CHECK_MODULES( OBJC, libobjc)

#output Makefiles
AC_CONFIG_FILES([
	Makefile 
	src/Makefile
	tests/Makefile
	])
AC_OUTPUT

