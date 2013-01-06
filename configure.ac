AC_PREREQ(2.59)
AC_INIT(TinyStep, 0.1, paul@dev-smart.com)
AC_CONFIG_HEADERS([src/tinystep/config.h]) #setup config header

AC_CANONICAL_SYSTEM # create cross platform build system
AM_INIT_AUTOMAKE
LT_INIT

AC_PROG_OBJC([clang])

PKG_CHECK_MODULES( OBJC, libobjc)

AC_ARG_ENABLE([debug],
  AS_HELP_STRING([--enable-debug], [compile with -g -O0]),
  [echo "compiling with -g -O0"
  OBJCFLAGS+=" -g -O0"
  CFLAGS+=" -g -O0"
  CXXFLAGS+=" -g -O0"
  ]
)

AC_CHECK_HEADERS([\
  malloc.h \
  stdint.h \
  inttypes.h \
  sys/inttypes.h \
  string.h \
  stdlib.h
  ])

if test $ac_cv_header_stdint_h = yes; then
INCLUDE_STDINT="#include <stdint.h>"
elif test $ac_cv_header_inttypes_h = yes; then
INCLUDE_STDINT="#include <inttypes.h>"
elif test $ac_cv_header_sys_inttypes_h = yes; then
INCLUDE_STDINT="#include <sys/inttypes.h>"
else
INCLUDE_STDINT="no"
fi

AC_SUBST(INCLUDE_STDINT)
AC_SUBST(DEFINE_INT8_T)
AC_SUBST(DEFINE_UINT8_T)
AC_SUBST(DEFINE_INT16_T)
AC_SUBST(DEFINE_UINT16_T)
AC_SUBST(DEFINE_INT32_T)
AC_SUBST(DEFINE_UINT32_T)
AC_SUBST(DEFINE_INT64_T)
AC_SUBST(DEFINE_UINT64_T)
AC_SUBST(DEFINE_INTPTR_T)

AC_ARG_ENABLE([thread-support],
  AS_HELP_STRING([--disable-thread-support], [turns off thread support]),
  [THREAD_SUPPORT="no"],
  [THREAD_SUPPORT="yes"]
)

if test $THREAD_SUPPORT = yes ; then
  AC_CHECK_HEADER([pthread.h],
  [
  THREAD_SUPPORT="#define THREAD_SUPPORT 1"
  INCLUDE_PTHREAD="#include <pthread.h>"
  ] 
  ,
  AC_MSG_ERROR([pthread is required])
  )
else
  THREAD_SUPPORT=""
  INCLUDE_PTHREAD=""
fi

AC_SUBST(THREAD_SUPPORT)
AC_SUBST(INCLUDE_PTHREAD)


#macro used to send an objc message (may be slightly diffrent depending on platform)
OBJCSENDMESSAGE="objc_msg_lookup(obj, selector)(obj, selector, __VA_ARGS__)"

#
# Platform specific setup
#
#############################
#AC_CANONICAL_HOST
# Check for which host we are on and setup a few things
# specifically based on the host
case $host_os in
  darwin* )
        # Do something specific for mac
        OBJCSENDMESSAGE="objc_msgSend(obj, selector, __VA_ARGS__)"
        ;;
  linux*)
        # Do something specific for linux
        ;;
   *BSD*)
        # Do something specific for BSD
        ;;
    *)
        #Default Case
        AC_MSG_ERROR([Your platform is not currently supported])
        ;;
esac

AC_SUBST(OBJCSENDMESSAGE)

#output Makefiles
AC_CONFIG_FILES([
	Makefile 
	src/Makefile
	tests/Makefile
  src/tinystep/TSConfig.h
	])
AC_OUTPUT
