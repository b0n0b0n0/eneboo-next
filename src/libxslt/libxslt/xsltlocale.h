/*
 * Summary: Locale handling
 * Description: Interfaces for locale handling. Needed for language dependent
 *              sorting.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Nick Wellnhofer
 */

#ifndef __XML_XSLTLOCALE_H__
#define __XML_XSLTLOCALE_H__

#include <libxml/xmlstring.h>

#ifdef XSLT_LOCALE_XLOCALE

#include <locale.h>
/*
 * glibc exposed the extended locale API through <locale.h> and removed the
 * obsolete compatibility header <xlocale.h> in glibc 2.26.  Apple and some
 * BSD systems still provide <xlocale.h>, so include it only when available.
 */
#if defined(__has_include)
#  if __has_include(<xlocale.h>)
#    include <xlocale.h>
#  endif
#elif !defined(__GLIBC__)
#  include <xlocale.h>
#endif

#ifdef __GLIBC__
/* locale_t is defined only if _GNU_SOURCE is defined */
typedef __locale_t xsltLocale;
#else
typedef locale_t xsltLocale;
#endif
typedef xmlChar xsltLocaleChar;

#elif defined(XSLT_LOCALE_WINAPI)

#include <windows.h>
#include <winnls.h>

typedef LCID xsltLocale;
typedef wchar_t xsltLocaleChar;

#else

/*
 * XSLT_LOCALE_NONE:
 * Macro indicating that locale are not supported
 */
#ifndef XSLT_LOCALE_NONE
#define XSLT_LOCALE_NONE
#endif

typedef void *xsltLocale;
typedef xmlChar xsltLocaleChar;

#endif

xsltLocale xsltNewLocale(const xmlChar *langName);
void xsltFreeLocale(xsltLocale locale);
xsltLocaleChar *xsltStrxfrm(xsltLocale locale, const xmlChar *string);
int xsltLocaleStrcmp(xsltLocale locale, const xsltLocaleChar *str1, const xsltLocaleChar *str2);
void xsltFreeLocales(void);

#endif /* __XML_XSLTLOCALE_H__ */
