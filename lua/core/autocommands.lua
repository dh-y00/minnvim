local autocmd = vim.api.nvim_create_autocmd

-- 保存时自动格式化
autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end
})

-- 进入文件时光标回到上次的位置
autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
            vim.cmd("normal! g'\"")
        end
    end
})

