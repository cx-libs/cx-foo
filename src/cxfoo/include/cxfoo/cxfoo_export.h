
#ifndef CXFOO_EXPORT_H
#define CXFOO_EXPORT_H

#ifdef CXFOO_STATIC_DEFINE
#  define CXFOO_EXPORT
#  define CXFOO_NO_EXPORT
#else
#  ifndef CXFOO_EXPORT
#    ifdef cxfoo_EXPORTS
        /* We are building this library */
#      define CXFOO_EXPORT __declspec(dllexport)
#    else
        /* We are using this library */
#      define CXFOO_EXPORT __declspec(dllimport)
#    endif
#  endif

#  ifndef CXFOO_NO_EXPORT
#    define CXFOO_NO_EXPORT 
#  endif
#endif

#ifndef CXFOO_DEPRECATED
#  define CXFOO_DEPRECATED __declspec(deprecated)
#endif

#ifndef CXFOO_DEPRECATED_EXPORT
#  define CXFOO_DEPRECATED_EXPORT CXFOO_EXPORT CXFOO_DEPRECATED
#endif

#ifndef CXFOO_DEPRECATED_NO_EXPORT
#  define CXFOO_DEPRECATED_NO_EXPORT CXFOO_NO_EXPORT CXFOO_DEPRECATED
#endif

#if 0 /* DEFINE_NO_DEPRECATED */
#  ifndef CXFOO_NO_DEPRECATED
#    define CXFOO_NO_DEPRECATED
#  endif
#endif

#endif /* CXFOO_EXPORT_H */
