local ffi = require("ffi")

do --- function
  ffi.cdef[[
  int redir_foo(const char *s) asm("strlen");
  ]]

  assert(ffi.C.redir_foo("abcd") == 4)
end

do --- variable -windows
  if (jit.os == "BSD") then
    -- Use "h_errno" instead, "errno" isn't defined in BSD libc.
    ffi.cdef[[
    int redir_bar asm("h_errno");
    ]]
  else
    ffi.cdef[[
    int redir_bar asm("errno");
    ]]
  end

  ffi.C.redir_bar = 14
  assert(ffi.C.redir_bar == 14)
  ffi.C.redir_bar = 0
end
