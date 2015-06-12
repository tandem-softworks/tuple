#ifdef RUBY_2_2_x
#ifndef BDIGIT
# if SIZEOF_INT*2 <= SIZEOF_LONG_LONG
#  define BDIGIT unsigned int
#  define SIZEOF_BDIGIT SIZEOF_INT
#  define BDIGIT_DBL unsigned LONG_LONG
#  define BDIGIT_DBL_SIGNED LONG_LONG
#  define PRI_BDIGIT_PREFIX ""
#  define PRI_BDIGIT_DBL_PREFIX PRI_LL_PREFIX
# elif SIZEOF_INT*2 <= SIZEOF_LONG
#  define BDIGIT unsigned int
#  define SIZEOF_BDIGIT SIZEOF_INT
#  define BDIGIT_DBL unsigned long
#  define BDIGIT_DBL_SIGNED long
#  define PRI_BDIGIT_PREFIX ""
#  define PRI_BDIGIT_DBL_PREFIX "l"
# elif SIZEOF_SHORT*2 <= SIZEOF_LONG
#  define BDIGIT unsigned short
#  define SIZEOF_BDIGIT SIZEOF_SHORT
#  define BDIGIT_DBL unsigned long
#  define BDIGIT_DBL_SIGNED long
#  define PRI_BDIGIT_PREFIX "h"
#  define PRI_BDIGIT_DBL_PREFIX "l"
# else
#  define BDIGIT unsigned short
#  define SIZEOF_BDIGIT (SIZEOF_LONG/2)
#  define SIZEOF_ACTUAL_BDIGIT SIZEOF_LONG
#  define BDIGIT_DBL unsigned long
#  define BDIGIT_DBL_SIGNED long
#  define PRI_BDIGIT_PREFIX "h"
#  define PRI_BDIGIT_DBL_PREFIX "l"
# endif
#endif
#ifndef SIZEOF_ACTUAL_BDIGIT
# define SIZEOF_ACTUAL_BDIGIT SIZEOF_BDIGIT
#endif

#define BIGNUM_EMBED_LEN_NUMBITS 3
#ifndef BIGNUM_EMBED_LEN_MAX
# if (SIZEOF_VALUE*3/SIZEOF_ACTUAL_BDIGIT) < (1 << BIGNUM_EMBED_LEN_NUMBITS)-1
#   define BIGNUM_EMBED_LEN_MAX (SIZEOF_VALUE*3/SIZEOF_ACTUAL_BDIGIT)
# else
#   define BIGNUM_EMBED_LEN_MAX ((1 << BIGNUM_EMBED_LEN_NUMBITS)-1)
# endif
#endif

struct RBignum {
    struct RBasic basic;
    union {
        struct {
            size_t len;
            BDIGIT *digits;
        } heap;
        BDIGIT ary[BIGNUM_EMBED_LEN_MAX];
    } as;
};
#define BIGNUM_SIGN_BIT FL_USER1
/* sign: positive:1, negative:0 */
#define BIGNUM_SIGN(b) ((RBASIC(b)->flags & BIGNUM_SIGN_BIT) != 0)

#define BIGNUM_EMBED_FLAG FL_USER2
#define BIGNUM_EMBED_LEN_MASK (FL_USER5|FL_USER4|FL_USER3)
#define BIGNUM_EMBED_LEN_SHIFT (FL_USHIFT+BIGNUM_EMBED_LEN_NUMBITS)
#define BIGNUM_LEN(b) \
    ((RBASIC(b)->flags & BIGNUM_EMBED_FLAG) ? \
     (long)((RBASIC(b)->flags >> BIGNUM_EMBED_LEN_SHIFT) & \
            (BIGNUM_EMBED_LEN_MASK >> BIGNUM_EMBED_LEN_SHIFT)) : \
     RBIGNUM(b)->as.heap.len)
/* LSB:BIGNUM_DIGITS(b)[0], MSB:BIGNUM_DIGITS(b)[BIGNUM_LEN(b)-1] */
#define BIGNUM_DIGITS(b) \
    ((RBASIC(b)->flags & BIGNUM_EMBED_FLAG) ? \
     RBIGNUM(b)->as.ary : \
     RBIGNUM(b)->as.heap.digits)
#define RBIGNUM(obj) (R_CAST(RBignum)(obj))

#else
# define BDIGITS(x) ((BDIGIT*)RBIGNUM(x)->digits)
#endif
