-- Unity framework module for `neotest-ctest`.
--
-- `neotest-ctest` ships framework modules for gtest, catch2, doctest, and
-- cpputest only. All four are C++ frameworks, so a pure-C test file written
-- against Unity is not recognised: `neotest-ctest`'s `discover_positions` calls
-- `framework.detect(path)`, which returns nil when no framework matches, and the
-- file then appears in the summary with no tests under it.
--
-- Framework modules are resolved with
-- `require("neotest-ctest.framework." .. name)`, and Neovim's Lua loader searches
-- every runtimepath entry, so a module placed in the user config is found
-- without patching the nixpkgs package. Add the name to
-- `plugins.neotest.adapters.ctest.settings.frameworks` to activate it.
--
-- Unity's test functions are plain C functions registered by `RUN_TEST(...)`
-- calls in `main()`. The `RUN_TEST` sites are the authoritative test list, so
-- positions are derived from them and then resolved to the corresponding function
-- definition's range. Deriving from `function_definition` nodes directly instead
-- would also match helpers and `main`.
local logger = require("neotest.logging")
local lib = require("neotest.lib")
local nio = require("nio")

local unity = {}

unity.lang = "c"

-- INFO: `neotest-ctest` uses this to decide whether this module applies to a
-- file. Mirrors the upstream framework modules, which match on the include.
unity.include_query = [[
  ;; an #include of the framework header
  (preproc_include
    path: (string_literal) @local.include
    (#match? @local.include "^[\"<]unity\\.h[\">]"))

  (preproc_include
    path: (system_lib_string) @system.include
    (#match? @system.include "^[\"<]unity\\.h[\">]"))
]]

--- Each `RUN_TEST(fn)` call site, in source order.
local run_query = [[
  (call_expression
    function: (identifier) @run.kind
    (#eq? @run.kind "RUN_TEST")
    arguments: (argument_list (identifier) @test.name)) @test.site
]]

--- Every function definition, so a test name can be resolved to its body.
local definition_query = [[
  (function_definition
    declarator: (function_declarator
      declarator: (identifier) @definition.name))
]]

local function text(node, source)
  return vim.treesitter.get_node_text(node, source)
end

--- Collect the tests declared in `path`, in registration order.
--- @param path string
--- @return table[] positions, string[] unresolved names, integer[] file range
local function collect_positions(path)
  -- INFO: `nio.run` drives this as a fast event, where most API functions are
  -- off-limits. Yielding once up front moves the rest onto the main loop.
  nio.scheduler()
  local source = lib.files.read(path)
  local lang_tree = vim.treesitter.get_string_parser(source, unity.lang, { injections = { [unity.lang] = "" } })
  local root = lib.treesitter.fast_parse(lang_tree):root()

  -- INFO: `node:range()` returns four values, so it has to be wrapped in a
  -- table. Assigning it to a single variable captures only the start row,
  -- which fails deep inside neotest's position builder.
  local definitions = {}
  local definition_q = lib.treesitter.normalise_query(unity.lang, definition_query)
  local file_range = { root:range() }
  for _, match in definition_q:iter_matches(root, source) do
    local nodes = {}
    for i, capture in ipairs(definition_q.captures) do
      nodes[capture] = type(match[i]) == "table" and match[i][#match[i]] or match[i]
    end
    local node = nodes["definition.name"]
    definitions[text(node, source)] = { node:range() }
  end

  local positions = {}
  local unresolved = {}
  local run_q = lib.treesitter.normalise_query(unity.lang, run_query)
  for _, match in run_q:iter_matches(root, source) do
    local nodes = {}
    for i, capture in ipairs(run_q.captures) do
      nodes[capture] = type(match[i]) == "table" and match[i][#match[i]] or match[i]
    end
    local name = text(nodes["test.name"], source)
    local range = definitions[name]
    if range then
      positions[#positions + 1] = {
        type = "test",
        path = path,
        name = name,
        range = range,
      }
    else
      -- INFO: Unity's Ruby generator emits runner files whose `RUN_TEST` sites
      -- reference functions defined in a different translation unit. Report the
      -- name so the gap is visible instead of silently dropping the test.
      unresolved[#unresolved + 1] = name
    end
  end

  return positions, unresolved, file_range
end

function unity.parse_positions(path)
  local positions, unresolved, file_range = collect_positions(path)
  for _, name in ipairs(unresolved) do
    logger.warn(("neotest-ctest/unity: no definition found for '%s' in %s"):format(name, path))
  end
  -- INFO: The leading `file` node describes the file itself. Its range comes
  -- from the parse tree rather than from a buffer, because `parse_positions`
  -- runs against file contents and the file need not even be open.
  return lib.positions.parse_tree(vim.list_extend({
    {
      type = "file",
      path = path,
      name = vim.fs.basename(path),
      range = file_range,
    },
  }, positions), {})
end

--- Unity reports failures as `path/to/file.c:LINE:FAIL`, plus optional detail
--- lines. Extract the first failure location per test.
function unity.parse_errors(output)
  local errors = {}
  for file, line in output:gmatch("([%w%p][^\n:]*%.c):(%d+):FAIL") do
    errors[#errors + 1] = { line = tonumber(line), message = ("%s:%s:FAIL"):format(file, line) }
  end
  return errors
end

return unity