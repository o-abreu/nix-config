{
  config,
  lib,
  ...
}:
{
  cmd ? null,
  opts,
}:
let
  code =
    with config.lib.nixvim.lua;
    # lua
    ''
      function()
        local cmd = ${toLuaObject cmd}
        local count = ${toString opts.count}
        local position = ${toLuaObject (lib.attrByPath [ "win" "position" ] null opts)}
        local terminal = require("snacks.terminal")

        -- Freeze the resolved target so <C-t> replays this exact
        -- terminal, regardless of the buffer focused at the time.
        local function open(cwd)
          local replay = {
            count = count,
            cwd = cwd,
          }
          if position then
            replay.win = { position = position }
          end
          _G.__last_term = function()
            terminal.toggle(cmd, replay)
          end
          _G.__last_term()
        end

        -- 1. Inside a matching terminal: toggle it, reusing its
        --    recorded cwd verbatim (never spawn a sibling).
        local cur = vim.b.snacks_terminal
        if cur and cur.cmd == cmd and cur.id == count then
          open(cur.cwd)
          return
        end

        -- 2. Seed the working directory from the current buffer,
        --    so REPLs (ipython, ...) start next to the file.
        local name = vim.api.nvim_buf_get_name(0)
        local seed = vim.fn.getcwd()
        if vim.bo.buftype == "" and name ~= "" then
          seed = vim.fs.normalize(vim.fn.fnamemodify(name, ":p:h"))
        end

        -- 3. One terminal per project tree: reuse a terminal in the
        --    same slot whose cwd lives in the same tree as the seed.
        local descendants_of = function(dir, root)
          if dir == root then
            return false
          end
          local prefix = root == "/" and "/" or root .. "/"
          return dir:sub(1, #prefix) == prefix
        end

        local best
        for _, term in ipairs(terminal.list()) do
          local position_ok = position == nil
            or (term.opts and term.opts.position == position)
            or (
              term.win
              and vim.w[term.win].snacks_win
              and vim.w[term.win].snacks_win.position == position
            )
          local meta = term.buf and vim.b[term.buf].snacks_terminal
          if position_ok and meta and meta.cmd == cmd and meta.id == count and meta.cwd then
            local tier
            if meta.cwd == seed then
              tier = 2
            elseif descendants_of(seed, meta.cwd) then
              tier = 1
            elseif descendants_of(meta.cwd, seed) then
              tier = 0
            end
            if tier then
              -- Most specific tree wins; longer paths break ties.
              local score = tier * 100000 + #meta.cwd
              if not best or score > best.score then
                best = { meta = meta, score = score }
              end
            end
          end
        end
        if best then
          open(best.meta.cwd)
          return
        end

        -- 4. No related terminal in this slot: spawn one seeded
        --    from the buffer's directory.
        open(seed)
      end
    '';
in
{
  __raw = code;
}
