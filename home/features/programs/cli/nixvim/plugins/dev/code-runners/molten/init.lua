function()
  local venv_path = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
  if not venv_path then
    vim.notify("No virtual environment found.", vim.log.levels.WARN)
    return
  end
  venv_path = vim.fn.fnamemodify(venv_path, ":p")

  local handle = io.popen("jupyter kernelspec list --json")
  local existing_kernels = {}
  if handle then
    local result = handle:read("*a")
    handle:close()
    local json = vim.fn.json_decode(result)
    for kernel_name, data in pairs(json.kernelspecs) do
      existing_kernels[kernel_name] = true
      local kernel_path = vim.fn.fnamemodify(data.spec.argv[1], ":p")
      if kernel_path:find(venv_path, 1, true) then
        vim.notify("Kernel spec for this virtual environment already exists.", vim.log.levels.INFO)
        return kernel_name
      end
    end
  end

  local new_kernel_name
  repeat
    new_kernel_name = vim.fn.input("Enter a unique name for the new kernel spec: ")
    if new_kernel_name == "" then
      vim.notify("Please provide a valid kernel name.", vim.log.levels.ERROR)
      return
    elseif existing_kernels[new_kernel_name] then
      vim.notify(
        "Kernel name '" .. new_kernel_name .. "' already exists. Please choose another name.",
        vim.log.levels.WARN
      )
      new_kernel_name = nil
    end
  until new_kernel_name

  print("Creating a new kernel spec for this virtual environment...")
  local cmd = string.format(
    '%s -m ipykernel install --user --name="%s"',
    vim.fn.shellescape(venv_path .. "/bin/python"),
    new_kernel_name
  )
  os.execute(cmd)
  vim.notify("Kernel spec '" .. new_kernel_name .. "' created successfully.", vim.log.levels.INFO)
  return new_kernel_name
end
