vim.g.mapleader = " "
vim.g.maplocalleader = " "






-- Highlight Yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})



--- VSCODE LIKE
vim.keymap.set("n", "<M-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("n", "<M-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("n", "<M-Down>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("n", "<M-Up>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<M-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<M-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })


-- Toggle comment on the current line using the filetype's commentstring
local function toggle_comment()
	local cs = vim.bo.commentstring
	if cs == "" then
		return
	end -- exit if no commentstring defined

	-- extract the actual comment marker (e.g., "%s" -> remove it)
	local marker = cs:gsub("%%s", ""):gsub("^%s*(.-)%s*$", "%1")

	local row = vim.api.nvim_win_get_cursor(0)[1] - 1 -- 0-indexed
	local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]

	-- Toggle comment
	if line:match("^%s*" .. vim.pesc(marker)) then
		-- Uncomment
		line = line:gsub("^(%s*)" .. vim.pesc(marker) .. "%s?", "%1")
	else
		-- Comment
		line = marker .. " " .. line
	end

	vim.api.nvim_buf_set_lines(0, row, row + 1, false, { line })
end

vim.keymap.set("n", "<C-/>", toggle_comment, { silent = true, desc = "Toggle Comment" })
vim.keymap.set("n", "<C-_>", toggle_comment, { silent = true, desc = "Toggle Comment" }) -- when in tmux


-- VSCODE PASTE AND COPY: CTRL V and CTRL C
vim.keymap.set("i", "<C-v>", "<C-r>+", { silent = true })
vim.keymap.set("n", "<C-v>", '"+p', { silent = true })
vim.keymap.set("v", "<C-v>", '"+p', { silent = true })
vim.keymap.set("v", "<C-z>", 'u', { silent = true })
-- Function to copy like VSCode
local function copy_like_vscode()
	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" or mode == "\22" then
		-- If something is visually selected, yank it
		vim.cmd('normal! "+y')
	else
		-- If nothing is selected, yank the whole line
		vim.cmd('normal! "+yy')
	end
end
-- Map Ctrl-C in normal and visual mode
vim.keymap.set({ "n", "v" }, "<C-c>", copy_like_vscode, { silent = true })


-- Restore cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"') -- '"' is the last position mark
		local line = mark[1]
		local col = mark[2]
		local last_line = vim.api.nvim_buf_line_count(0)
		if line > 0 and line <= last_line then
			vim.api.nvim_win_set_cursor(0, { line, col })
		end
	end,
})




-- Disable Shift+Arrow completely
local opts = { noremap = true, silent = true }

vim.keymap.set({ "n", "i", "v" }, "<S-Up>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v" }, "<S-Down>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v" }, "<S-Left>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v" }, "<S-Right>", "<Nop>", opts)


-- =========================================================
-- Clipboard & Mouse
-- =========================================================
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
