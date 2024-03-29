require('neodev').setup({})

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    -- vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

--vim.g.haskell_tools = {
--    hls = {
--        capabilities = lsp_zero.get_capabilities()
--    }
--}

---- Autocmd that will actually be in charging of starting hls
--local hls_augroup = vim.api.nvim_create_augroup('haskell-lsp', {clear = true})
--vim.api.nvim_create_autocmd('FileType', {
--    group = hls_augroup,
--    pattern = {'haskell'},
--    callback = function()
--        ---
--        -- Suggested keymaps from the quick setup section:
--        -- https://github.com/mrcjkb/haskell-tools.nvim#quick-setup
--        ---

--        local ht = require('haskell-tools')
--        local bufnr = vim.api.nvim_get_current_buf()
--        local def_opts = { noremap = true, silent = true, buffer = bufnr, }
--        -- haskell-language-server relies heavily on codeLenses,
--        -- so auto-refresh (see advanced configuration) is enabled by default
--        vim.keymap.set('n', '<space>ca', vim.lsp.codelens.run, opts)
--        -- Hoogle search for the type signature of the definition under the cursor
--        vim.keymap.set('n', '<space>hs', ht.hoogle.hoogle_signature, opts)
--        -- Evaluate all code snippets
--        vim.keymap.set('n', '<space>ea', ht.lsp.buf_eval_all, opts)
--        -- Toggle a GHCi repl for the current package
--        vim.keymap.set('n', '<leader>rr', ht.repl.toggle, opts)
--        -- Toggle a GHCi repl for the current buffer
--        vim.keymap.set('n', '<leader>rf', function()
--            ht.repl.toggle(vim.api.nvim_buf_get_name(0))
--        end, def_opts)
--        vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)
--    end
--})

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {'tsserver', 'yamlls', 'eslint'},
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
        end,
    }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
    sources = {
        {name = 'path'},
        {name = 'nvim_lsp'},
        {name = 'nvim_lua'},
    },
    formatting = lsp_zero.cmp_format(),
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
})
