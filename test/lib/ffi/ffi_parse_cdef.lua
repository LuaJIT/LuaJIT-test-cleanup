local ffi = require("ffi")

local ffi_util = require("common.ffi_util")
local checkfail, checktypes, fails =
  ffi_util.checkfail, ffi_util.checktypes, ffi_util.fails

do --- Invalid FFI declarations rejected
checkfail({
  "int",
  "int aa1; int aa2 ",
  "static int x;",
  "static const long long x = 1;", -- NYI
  "static const double x = 1;",	   -- NYI
  "static const bool x = 1;",	   -- NYI (intentional, need true/false)
  "struct { static int x = 1; };",
  ";;static int y"
}, ffi.cdef)
end

do --- FFI const definitions
ffi.cdef[[
static const int K_42a = 42;
static const char K_42b = 42+256;
static const short K_M1a = 65535;
static const unsigned short K_65535a = 65535;
static const int K_1b = 0xffffffff >> 31;
static const int K_1c = 0xffffffffu >> 31;
static const int K_M1b = (int)0xffffffff >> 31;
]]
end

do --- Arrays with size given by consts
checktypes{
  42,	1,	"char[K_42a]",
  42,	1,	"char[K_42b]",
  1,	1,	"char[-K_M1a]",
  65535, 1,	"char[K_65535a]",
  1,	1,	"char[K_1b]",
  1,	1,	"char[K_1c]",
  1,	1,	"char[-K_M1b]",
}
end

do --- Static consts in structs
ffi.cdef[[
struct str1 {
  enum {
    K_99 = 99
  };
  static const int K_55 = 55;
} extk;
]]
end

do --- Constant expression evaluation works
checktypes{
  99,	1,	"char[K_99]",
  99,	1,	"char[extk.K_99]",
  99,	1,	"char[((struct str1)0).K_99]",
  99,	1,	"char[((struct str1 *)0)->K_99]",
  55,	1,	"char[extk.K_55]",
}
end

do --- Static consts in structs do not have global scope
checkfail{
  "char[K_55]",
}
end

do --- Inline function definitions ignored
ffi.cdef[[
extern int func1(void);
extern int func2();
static int func3();
static inline int func4(int n)
{
  int i, k = 0;
  float x = 1.0f;
  for (i = 0; i < n; i++) {
    k += i;
  }
  return k;
}
;;;
]]
end

do --- Extern variables
ffi.cdef[[
int ext1;
extern int ext2;
]]
end
