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
  AC_DEFINE([BUILD_DEBUG], [1], [enable debugging features])
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


#################### Filesystem support checks ################

AC_ARG_ENABLE([filesystem-support],
  AS_HELP_STRING([--disable-filesystem-support], [turns off filesystem support]),
  [FILESYSTEM_SUPPORT="no"],
  [FILESYSTEM_SUPPORT="yes"]
)

if test $FILESYSTEM_SUPPORT = yes ; then
  AC_CHECK_HEADER([dirent.h],
    AC_DEFINE(HAVE_DIRENT_H, 1, [Define to 1 if you have the <dirent.h> header file])
  ,
  AC_MSG_ERROR([dirent.h is required for filesystem support])
  )

  AC_CHECK_HEADER([sys/stat.h],
    AC_DEFINE(HAVE_SYS_STAT_H, 1)
  ,
  AC_MSG_ERROR([sys/stat.h is required for filesystem support])
  )

  AC_DEFINE([FILESYSTEM_SUPPORT], [1], [define if you have file system])
else
  AC_DEFINE([FILESYSTEM_SUPPORT], [0], [define if you have file system])
fi


################### Thread support checks ######################

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
  AC_MSG_ERROR([pthread is required for thread support])
  )
else
  THREAD_SUPPORT=""
  INCLUDE_PTHREAD=""
fi

AC_SUBST(THREAD_SUPPORT)
AC_SUBST(INCLUDE_PTHREAD)

#################### Obj-c objc_msgSend ###########################

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


#--------------------------------------------------------------------
# Check how to enable builtins for atomic operations
#--------------------------------------------------------------------

AC_LANG_PUSH(C)
AC_MSG_CHECKING([whether the compiler supports atomic operations]);
  AC_LINK_IFELSE([AC_LANG_PROGRAM([[typedef int atomic;]],
    [[atomic x; atomic y; __sync_bool_compare_and_swap(&x, y, y + 1);]])],
  have_atomic=yes,
  have_atomic=no);
  if test "$have_atomic" = "yes"; then
    AC_MSG_RESULT([yes]);
    AC_DEFINE(USE_ATOMIC_BUILTINS,1,
      [Define if the compiler provides builtins for atomic operations])
  else
    AC_MSG_RESULT([no]);
    if test "$CC" = "gcc"; then
      saved_CFLAGS="$CFLAGS";
      ATOMIC_CFLAGS="";
  
      # FIXME: Forcing -march=i568 for any i568 or later CPU is a
      # stop gap measure to make the compiler emit native assembly
      # for atomic operations on i586 or latter processors (GCC by
      # default emits code compatible with the original i386 and
      # requires library functions to emulate atomic operations).
      # When gnustep-make takes care of this kind of target setting,
      # the check can safely be removed.
      case "$target_cpu" in
        i586*|i686*|i786*)
          ATOMIC_CFLAGS="-march=i586"
          CFLAGS="$saved_CFLAGS $ATOMIC_CFLAGS"
          ;;
        x86_64)
          ATOMIC_CFLAGS="-march=x86-64"
          CFLAGS="$saved_CFLAGS $ATOMIC_CFLAGS"
          ;;
      esac
      AC_MSG_CHECKING([whether gcc supports atomic operations with -march]);
        AC_LINK_IFELSE([AC_LANG_PROGRAM([[typedef int atomic;]],
          [[atomic x; atomic y; __sync_bool_compare_and_swap(&x, y, y+1);]])],
        need_march=yes,
      need_march=no);

      if test "$need_march" = "yes"; then
        AC_MSG_RESULT([yes]);
        OBJCFLAGS="$OBJCFLAGS $ATOMIC_CFLAGS";
        AC_DEFINE(USE_ATOMIC_BUILTINS,1,
          [Define if the compiler provides builtins for atomic operations])
      else
        AC_MSG_RESULT([no]);
        saved_LDFLAGS="$LDFLAGS";
        LDFLAGS="$saved_LDFLAGS -lgcc";
        AC_MSG_CHECKING([whether gcc supports atomic operations using libgcc]);
          AC_LINK_IFELSE([AC_LANG_PROGRAM([[typedef int atomic;]],
            [[atomic x; atomic y; __sync_bool_compare_and_swap(&x, y, y+1);]])],
          atomic_in_libgcc=yes,
        atomic_in_libgcc=no);
        if test "$atomic_in_libgcc" = "yes"; then
          AC_MSG_RESULT([yes]);
          LIBS="$LIBS -lgcc";
          AC_DEFINE(USE_ATOMIC_BUILTINS,1,
            [Define if the compiler provides builtins for atomic operations])
        else
          LDFLAGS="$saved_LDFLAGS";
          AC_MSG_RESULT([no]);
        fi
      fi
    fi
  fi
AC_LANG_POP(C)

#output Makefiles
AC_CONFIG_FILES([
	Makefile 
	src/Makefile
	tests/Makefile
  src/tinystep/TSConfig.h
	])
AC_OUTPUT
