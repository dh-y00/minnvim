vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true
vim.opt.colorcolumn = "80"

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.autoread = true

vim.opt.termguicolors = true

vim.opt.signcolumn = "yes"

vim.opt.mouse = "a"

vim.opt.splitright = true

vim.opt.splitbelow = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 取消搜索高亮
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.encoding = "utf-8"
vim.opt.fileencodings = "utf-8,ucs-bom,gb18030,gbk,gb2312,cp936"

vim.opt.fileformat = "unix"
vim.opt.fileformats = "unix,dos"

vim.opt.showmode = false

-- can add .nvim.lua in every project, let every project have config with nvim
vim.opt.exrc = true
-- when full line, if the value is 'true' then change line to show, but the value is 'false' not change line to show
vim.opt.wrap = false

vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("$HOME/.local/share/nvim/undo")

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- 是 Vim 编辑器里用来对自动补全选项进行设置的一个选项
-- menu：开启补全菜单。当你触发补全时，Vim 会显示一个包含可能补全项的菜单。
-- menuone：即便只有一个补全项，也会显示补全菜单。通常情况下，如果只有一个补全项，Vim 会直接完成补全而不显示菜单，设置这个选项后，即使只有一个选项也会显示菜单。
-- noselect：补全菜单弹出后，不会自动选中任何补全项。用户需要手动选择想要的补全项。要是不设置这个选项，Vim 可能会自动选中第一个补全项。
-- preview：显示补全项的预览信息。对于某些补全源，如函数补全，会在预览窗口显示函数的文档或参数信息。
vim.opt.completeopt = { "menuone", "noselect" }

vim.keymap.set({ "n", "v" }, "<Left>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<Right>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<Up>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<Down>", "<Nop>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>ww", ":w<CR>", { desc = "保存" })
vim.keymap.set("n", "<leader>qq", ":q<CR>", { desc = "退出" })
