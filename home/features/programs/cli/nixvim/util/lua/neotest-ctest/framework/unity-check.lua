-- Verification for the Unity framework module in `unity.lua`.
--
-- The module is loaded through the standard Lua loader from
-- `$XDG_CONFIG_HOME/nvim/lua/neotest-ctest/framework/`, which is where the
-- nixvim `xdg.configFile` entry deploys it. Nothing adds it to the runtimepath
-- explicitly, so this also confirms the deployment path works: the module has to
-- be resolvable without any runtimepath help from the adapter.
--
-- Run from a checkout with neotest and the tree-sitter `c` grammar on the
-- runtimepath:
--
--     NEOTEST_RTP=<neotest> TREE_SITTER_C=<grammar> \
--       nvim --headless -u /dev/null \
--       --cmd "set rtp+=$NEOTEST_RTP" --cmd "set rtp+=$TREE_SITTER_C" \
--       -l lua/neotest-ctest/framework/unity-check.lua
--
-- Exit status is non-zero when any assertion fails.

local nio = require("nio")
local lib = require("neotest.lib")
local unity = require("neotest-ctest.framework.unity")

local source = [[
#include "unity.h"
#include "calc.h"

static void helper(void) { }

void test_add_returns_sum(void) {
    TEST_ASSERT_EQUAL_INT(3, calc_add(1, 2));
}

void test_add_handles_zero(void) {
    TEST_ASSERT_EQUAL_INT(1, calc_add(1, 0));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_add_returns_sum);
    RUN_TEST(test_add_handles_zero);
    return UNITY_END();
}
]]

local path = vim.fn.tempname() .. ".c"
vim.fn.writefile(vim.split(source, "\n"), path)

local failures = 0
local function check(label, ok, detail)
  if ok then
    print(("ok   %s"):format(label))
  else
    failures = failures + 1
    print(("FAIL %s%s"):format(label, detail and (" -> " .. tostring(detail)) or ""))
  end
end

local function names_of(tbl)
  return vim.tbl_map(function(d)
    return d.name
  end, tbl)
end

nio.run(function()
  -- 1. `neotest-ctest`'s framework detection gates on include_query, so a
  -- non-matching include means the module is never consulted.
  local content = lib.files.read(path)
  local include_q = lib.treesitter.normalise_query(unity.lang, unity.include_query)
  local include_matched = false
  for _, match in include_q:iter_matches(lib.treesitter.fast_parse(vim.treesitter.get_string_parser(content, unity.lang, { injections = { [unity.lang] = "" } })):root(), content) do
    if match then
      include_matched = true
    end
  end
  check("include_query parses and matches", include_matched)

  -- 2. Positions: the two RUN_TEST tests, in registration order, anchored to
  -- their definitions rather than to the RUN_TEST sites in main().
  local ok, tree = pcall(unity.parse_positions, path)
  check("parse_positions returns without error", ok, tree)

  if ok then
    -- Tree:iter() yields (index, position); the single-variable form would
    -- capture the index, which is why an earlier revision saw an empty list.
    local data = {}
    for _, node in tree:iter() do
      data[#data + 1] = node
    end

    local tests = vim.tbl_filter(function(d)
      return d.type == "test"
    end, data)
    local test_names = names_of(tests)

    check("two tests discovered", #tests == 2, vim.inspect(test_names))
    check(
      "ordered by registration",
      #tests == 2 and test_names[1] == "test_add_returns_sum" and test_names[2] == "test_add_handles_zero",
      vim.inspect(test_names)
    )
    -- Source rows are 0-indexed. In the fixture the two definitions are on
    -- 1-indexed lines 6 and 10, i.e. rows 5 and 9. The RUN_TEST sites in main()
    -- are on rows 14 and 15, so these also prove the position is anchored to the
    -- definition rather than to the call site.
    check("first test anchored to its definition", #tests > 0 and tests[1].range[1] == 5, #tests > 0 and tests[1].range[1])
    check("second test anchored to its definition", #tests > 1 and tests[2].range[1] == 9, #tests > 1 and tests[2].range[1])
    check("helper not treated as a test", not vim.tbl_contains(test_names, "helper"), vim.inspect(test_names))
    check("main not treated as a test", not vim.tbl_contains(test_names, "main"), vim.inspect(test_names))
  end

  -- 3. parse_errors must recover the failing line from Unity's output.
  local errors = unity.parse_errors("test_calc.c:5:FAIL: Expected 3 Was 4\ntest_calc.c:9:PASS")
  check("parse_errors extracts one failure", #errors == 1, vim.inspect(errors))
  check("parse_errors keeps Unity's line number", #errors == 1 and errors[1].line == 5, #errors == 1 and errors[1].line)

  print(("\n%s (%d failure%s)"):format(failures == 0 and "PASS" or "FAIL", failures, failures == 1 and "" or "s"))
  os.remove(path)
  vim.schedule(function()
    vim.cmd(failures == 0 and "cquit 0" or "cquit 1")
  end)
end)
-- Keep the event loop alive so the nio task scheduled above can run to
-- completion; without this, -l exits before any async work executes.
vim.wait(10000, function()
  return false
end, 10)
