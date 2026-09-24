// Compatibility shim for Windows/SystemInfo.cpp when the 7-Zip UI sources are excluded.
#include "StdAfx.h"

#include "Common/MyString.h"

#ifdef Z7_LARGE_PAGES
extern "C"
{
  extern size_t g_LargePageSize;
}
#endif

void Add_LargePages_String(AString &s)
{
#ifdef Z7_LARGE_PAGES
  if (g_LargePageSize != 0)
    s.Add_OptSpaced(" (LP)");
#else
  (void)s;
#endif
}
