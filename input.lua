-- function input (cb, arg)
  -- hs.task.new(hs.configdir..'/inputsource', function() end, function (task, out, err)
  --   if cb then
  --     cb(out, err)
  --   end
  --   return false
  -- end, arg):start()
-- end
-- hs.keycodes.inputSourceChanged(function ()
--   input(function (out, err)
--     if string.match(out, conf.input.block) then
--       input(nil, {conf.input.fallback})
--     end
--   end, {})
-- end)
-- function switchInput ()
--   input(function (out, err)
--     if string.match(out, conf.input.default) then
--       input(nil, {conf.input.fallback})
--     else
--       input(nil, {conf.input.default})
--     end
--   end, {})
-- end