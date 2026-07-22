local opt = vim.opt

opt.autoread = true
opt.backup = false
opt.writebackup = true
opt.swapfile = false
opt.undofile = true
opt.undolevels = 2048
opt.undodir = vim.fn.stdpath("state") .. "/undo//"

opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.shiftround = true
opt.autoindent = true
opt.smartindent = false
opt.cindent = false
opt.textwidth = 0
opt.wrap = false
opt.linebreak = true
opt.formatoptions = "qn1jtc"

opt.mouse = "a"
opt.startofline = false
opt.whichwrap = "b,s,h,l,<,>"
opt.virtualedit:append("block")
opt.matchpairs:append("<:>")
opt.showmatch = false

opt.timeoutlen = 900
opt.ttimeoutlen = 0
opt.termguicolors = true
opt.number = false
opt.relativenumber = false
opt.cursorline = true
opt.cursorcolumn = false
opt.splitright = true
opt.splitbelow = true
opt.inccommand = "split"
opt.signcolumn = "yes"
opt.scrolloff = 3
opt.sidescrolloff = 5

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
opt.gdefault = false

opt.list = false
opt.listchars = {
  trail = "·",
  precedes = "…",
  extends = "→",
  tab = "▸ ",
  eol = "$",
}

opt.foldmethod = "marker"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldminlines = 1
opt.completeopt = { "menu", "menuone", "noselect" }
opt.wildmenu = true
opt.wildignorecase = true
opt.wildignore = {
  "*.a", "*.o", "*.bmp", "*.gif", "*.ico", "*.jpg", "*.jpeg", "*.png",
  ".DS_Store", ".git", ".hg", ".svn", "*~", "*.swp", "*.tmp",
}

opt.tags = { "./tags", "tags", ".tags" }
opt.updatetime = 500

vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_winsize = 20
vim.g.netrw_liststyle = 3

vim.opt.statusline = table.concat({
  " %n",
  " %<%f",
  "%m%r",
  " [%{&filetype}]",
  " %{exists('*FugitiveStatusline')?FugitiveStatusline():''}",
  "%=",
  " %{get(b:,'gitsigns_head','')}",
  " %l:%c",
  " %p%% ",
})
