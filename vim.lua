require'gitsigns'.setup()

require'nvim-treesitter.configs'.setup{
    -- 启用高亮
    highlight = {
        enable = true,
	-- 禁用 vim 基于正则达式的语法高亮，太慢
        additional_vim_regex_highlighting = false,
    },
    -- 启用缩进
    indent = {
        enable = true,
    },

}

local on_attach = function(client, bufnr)
    -- 为方便使用，定义了两个工具函数
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- 配置标准补全快捷键
    -- 在插入模式可以按 <c-x><c-o> 触发补全
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local options = { noremap=true, silent=true }


    -- 设置 normal 模式下的快捷键
    -- 第一个参数 n 表示 normal 模式
    -- 第二个参数表示按键
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', options)
    -- 跳转到定义或者声明的地方
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', options)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', options)
    -- 查看接口的所有实现
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', options)
    -- 查看所有引用当前对象的地方
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', options)
    -- 跳转到下一个/上一个语法错误
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', options)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', options)
    buf_set_keymap('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', options)
    -- 手工触发格式化
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<cr>', options)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<cr>', options)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', options)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', options)
    -- 列出所有语法错误列表
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', options)
    -- 修改当前符号的名字
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', options)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', options)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', options)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', options)
end

require'lspconfig'.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
        debounce_text_changes = 150,
    },
}

local cmp = require'cmp'
cmp.setup {
    -- 必须指定 snippet 组件
    snippet = {
        expand = function(args) vim.fn['vsnip#anonymous'](args.body) end,
    },
    -- 配置补全内容来源
    sources = cmp.config.sources {
        -- 支持从打开的文件中补全内容
        { name = 'buffer', options = { get_bufnrs = vim.api.nvim_list_bufs } },
	-- 支持从 lsp 服务补全
        { name = 'nvim_lsp' },
	-- 支持补全文件路径，可以输入 / 或者 ~ 体验
        { name = 'path' },
    },
}

-- 将 cmp-lsp 跟 lsp 服务关联起来
-- 需要更新一上之前的 gopls 配置
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require'cmp_nvim_lsp'.update_capabilities(capabilities)
require'lspconfig'.gopls.setup {
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    },
}
