do --- debug.traceback doesn't crash on a dead coroutine
  local co = coroutine.create(function()
    local x = nil
    local y = x.x
  end)
  assert(coroutine.resume(co) == false)
  debug.traceback(co)
end

