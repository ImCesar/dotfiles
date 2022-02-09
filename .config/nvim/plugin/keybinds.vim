let mapleader = " "

" source init
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>

" finding
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>
noremap <leader>ft <cmd>lua require('telescope.builtin').live_grep()<CR>
noremap <leader>fw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>

"lsp 
nnoremap <leader>gd :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>gi :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>sh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>gr :lua vim.lsp.buf.references()<CR>
nnoremap <leader>rn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>h :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>ca :lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>gn :lua vim.lsp.diagnostic.goto_next()<CR>

"git
nnoremap <silent> <leader>gg :LazyGit<CR>

"nvim-tree
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

" split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" default nvim-tree keybinds
" https://github.com/kyazdani42/nvim-tree.lua#keybindings
