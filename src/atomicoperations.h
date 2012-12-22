

/*
 *	Reference count and memory management
 *	Reference counts for object are stored
 *	with the object.
 *	The zone in which an object has been
 *	allocated is stored with the object.
 */

/* Now, if we are on a platform where we know how to do atomic
 * read, increment, and decrement, then we define the GSATOMICREAD
 * macro and macros or functions to increment/decrement.
 * The presence of the GSATOMICREAD macro is used later to determine
 * whether to attempt atomic operations or to use locking for the
 * retain/release mechanism.
 * The GSAtomicIncrement() and GSAtomicDecrement() functions take a
 * pointer to a 32bit integer as an argument, increment/decrement the
 * value pointed to, and return the result.
 */
#ifdef	GSATOMICREAD
#undef	GSATOMICREAD
#endif


#if	defined(__MINGW__)
#ifndef _WIN64
#undef InterlockedIncrement
#undef InterlockedDecrement
LONG WINAPI InterlockedIncrement(LONG volatile *);
LONG WINAPI InterlockedDecrement(LONG volatile *);
#endif

/* Set up atomic read, increment and decrement for mswindows
 */

typedef int32_t volatile *gsatomic_t;

#define	GSATOMICREAD(X)	(*(X))

#define	GSAtomicIncrement(X)	InterlockedIncrement((LONG volatile*)X)
#define	GSAtomicDecrement(X)	InterlockedDecrement((LONG volatile*)X)


#elif defined(__llvm__) || (defined(USE_ATOMIC_BUILTINS) && (__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 1)))
/* Use the GCC atomic operations with recent GCC versions */

typedef int32_t volatile *gsatomic_t;
#define GSATOMICREAD(X) (*(X))
#define GSAtomicIncrement(X)    __sync_add_and_fetch(X, 1)
#define GSAtomicDecrement(X)    __sync_sub_and_fetch(X, 1)


#elif	defined(__linux__) && (defined(__i386__) || defined(__x86_64__))
/* Set up atomic read, increment and decrement for intel style linux
 */

typedef int32_t volatile *gsatomic_t;

#define	GSATOMICREAD(X)	(*(X))

static __inline__ int
GSAtomicIncrement(gsatomic_t X)
{
  register int tmp;
  __asm__ __volatile__ (
    "movl $1, %0\n"
    "lock xaddl %0, %1"
    :"=r" (tmp), "=m" (*X)
    :"r" (tmp), "m" (*X)
    :"memory" );
  return tmp + 1;
}

static __inline__ int
GSAtomicDecrement(gsatomic_t X)
{
  register int tmp;
  __asm__ __volatile__ (
    "movl $1, %0\n"
    "negl %0\n"
    "lock xaddl %0, %1"
    :"=r" (tmp), "=m" (*X)
    :"r" (tmp), "m" (*X)
    :"memory" );
 return tmp - 1;
}

#elif defined(__PPC__) || defined(__POWERPC__)

typedef int32_t volatile *gsatomic_t;

#define	GSATOMICREAD(X)	(*(X))

static __inline__ int
GSAtomicIncrement(gsatomic_t X)
{
  int tmp;
  __asm__ __volatile__ (
    "0:"
    "lwarx %0,0,%1 \n"
    "addic %0,%0,1 \n"
    "stwcx. %0,0,%1 \n"
    "bne- 0b \n"
    :"=&r" (tmp)
    :"r" (X)
    :"cc", "memory");
  return tmp;
}

static __inline__ int
GSAtomicDecrement(gsatomic_t X)
{
  int tmp;
  __asm__ __volatile__ (
    "0:"
    "lwarx %0,0,%1 \n"
    "addic %0,%0,-1 \n"
    "stwcx. %0,0,%1 \n"
    "bne- 0b \n"
    :"=&r" (tmp)
    :"r" (X)
    :"cc", "memory");
  return tmp;
}

#elif defined(__m68k__)

typedef int32_t volatile *gsatomic_t;

#define	GSATOMICREAD(X)	(*(X))

static __inline__ int
GSAtomicIncrement(gsatomic_t X)
{
  __asm__ __volatile__ (
    "addq%.l %#1, %0"
    :"=m" (*X));
    return *X;
}

static __inline__ int
GSAtomicDecrement(gsatomic_t X)
{
  __asm__ __volatile__ (
    "subq%.l %#1, %0"
    :"=m" (*X));
    return *X;
}

#elif defined(__mips__)

typedef int32_t volatile *gsatomic_t;

#define	GSATOMICREAD(X)	(*(X))

static __inline__ int
GSAtomicIncrement(gsatomic_t X)
{
  int tmp;

  __asm__ __volatile__ (
#if !defined(__mips64__)
    "   .set  mips2  \n"
#endif
    "0: ll    %0, %1 \n"
    "   addiu %0, 1  \n"
    "   sc    %0, %1 \n"
    "   beqz  %0, 0b  \n"
    :"=&r" (tmp), "=m" (*X));
    return tmp;
}

static __inline__ int
GSAtomicDecrement(gsatomic_t X)
{
  int tmp;

  __asm__ __volatile__ (
#if !defined(__mips64__)
    "   .set  mips2  \n"
#endif
    "0: ll    %0, %1 \n"
    "   addiu %0, -1 \n"
    "   sc    %0, %1 \n"
    "   beqz  %0, 0b  \n"
    :"=&r" (tmp), "=m" (*X));
    return tmp;
}
#endif