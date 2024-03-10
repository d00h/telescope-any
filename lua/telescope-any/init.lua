local function create_default_config()
  local builtin = require("telescope.builtin")
  return {
    pickers = {
      [":"] = builtin.current_buffer_fuzzy_find,
      ["/"] = builtin.live_grep,

      ["m "] = builtin.marks,
      ["q "] = builtin.quickfix,
      ["l "] = builtin.loclist,
      ["j "] = builtin.jumplist,

      ["man "] = builtin.man_pages,
      ["options "] = builtin.vim_options,
      ["keymaps "] = builtin.keymaps,

      ["colorscheme "] = builtin.colorscheme,
      ["colo "] = builtin.colorscheme,

      ["com "] = builtin.commands,
      ["command "] = builtin.commands,

      ["au "] = builtin.autocommands,
      ["autocommand "] = builtin.autocommands,

      ["highlight "] = builtin.highlights,
      ["hi "] = builtin.highlights,

      ["ctags "] = builtin.current_buffer_tags,

      ["o "] = builtin.oldfiles,
      ["b "] = builtin.buffers,

      ["gs "] = builtin.git_status,
      ["gb "] = builtin.git_branches,
      ["gc "] = builtin.git_commits,

      ["d "] = builtin.diagnostics,
      ["@"] = builtin.lsp_document_symbols,

      [""] = builtin.find_files,
    },
  }
end

local function split_pickers(pickers)
  local default_picker = pickers[""]
  pickers[""] = nil
  return pickers, default_picker
end

local function parse_input(input, pickers, default_picker)
  for prefix, picker in pairs(pickers) do
    if input:sub(1, #prefix) == prefix then
      return picker, input:sub(#prefix + 1, #input)
    end
  end
  return default_picker, input
end

local function create_prefix_help_picker(prefixes)
  return function(opts)
    local Picker = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    Picker:new({
      prompt_title = "Any",
      finder = finders.new_table({ results = prefixes }),
      sorter = conf.generic_sorter(opts),
      on_input_filter_cb = opts.on_input_filter_cb,
      default_text = opts.default_text,
      bufnr = opts.bufnr,
      winnr = opts.winnr,
    }):find()
  end
end

local function create_telescope_any(opts)
  if opts == nil or vim.tbl_count(opts) == 0 then
    opts = create_default_config()
  end
  local pickers, default_picker = split_pickers(opts.pickers or {})
  local prefix_help_picker = create_prefix_help_picker(vim.tbl_keys(opts.pickers))
  local prev_input = ""
  local prev_picker = prefix_help_picker

  local function apply_picker(picker, opts)
    vim.schedule(function()
      local success, ret = pcall(picker, opts)
      if success then
        prev_picker = picker
      else
        prev_picker = default_picker
        opts.default_text = ""
        opts.prompt_title = ret
        default_picker(opts)
      end
    end)
  end

  return function()
    local bufnr = vim.api.nvim_get_current_buf()
    local winnr = vim.api.nvim_get_current_win()
    local on_input_filter_cb
    on_input_filter_cb = function(input)
      prev_input = input
      local curr_picker, text
      if #input == 0 then
        curr_picker, text = prefix_help_picker, input
      else
        curr_picker, text = parse_input(input, pickers, default_picker)
      end
      if curr_picker ~= prev_picker then
        apply_picker(curr_picker, {
          on_input_filter_cb = on_input_filter_cb,
          default_text = input,
          bufnr = bufnr,
          winnr = winnr,
        })
      else
        return { prompt = text }
      end
    end

    apply_picker(prev_picker, {
      on_input_filter_cb = on_input_filter_cb,
      default_text = prev_input,
      bufnr = bufnr,
      winnr = winnr,
    })
  end
end

return {
  create_telescope_any = create_telescope_any,
}
