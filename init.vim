call plug#begin('~/.config/nvim/plugged')

" resize window
Plug 'simeji/winresizer'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

" syntax highlight
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" tree viewer
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/glyph-palette.vim'

" status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" fuzzy finder
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" indent
Plug 'Yggdroot/indentLine'
Plug 'cohama/lexima.vim'

" trailing whitespace
Plug 'bronson/vim-trailing-whitespace'

" php
Plug 'stephpy/vim-php-cs-fixer'

" javascript
Plug 'pangloss/vim-javascript'

" typescript
Plug 'leafgarland/typescript-vim'

" blade
Plug 'jwalton512/vim-blade'

call plug#end()

" Neovim Settings
cnoremap init :<C-u>edit $MYVIMRC<CR>
set number
set expandtab
set tabstop=4
set shiftwidth=4
set indentexpr=4
set autoindent
set smartindent

noremap <space>h ^
noremap <space>l $
map <silent> <C-h> :b#<cr>
map <silent> <C-j> :bprevious<cr>
map <silent> <C-k> :bnext<cr>
tnoremap <C-\> <C-\><C-n><cr>

" Anywhere SID.
function! s:SID_PREFIX()
        return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()
        let s = ''
        for i in range(1, tabpagenr('$'))
                let bufnrs = tabpagebuflist(i)
                let bufnr = bufnrs[tabpagewinnr(i) - 1]
                let no = i  " display 0-origin tabpagenr.
                let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
                let title = fnamemodify(bufname(bufnr), ':t')
                let title = '[' . title . ']'
                let s .= '%'.i.'T'
                let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
                let s .= no . ':' . title
                let s .= mod
                let s .= '%#TabLineFill# '
        endfor
        let s .= '%#TabLineFill#%T%=%#TabLine#'
        return s
endfunction

let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2

" The prefix key.
nnoremap    [Tag] <Nop>
nmap    t [Tag]

" Tab jump
for n in range(1, 9)
        execute 'nnoremap <silent> [Tag]'.n ':<C-u>tabnext'.n.'<CR>'
endfor

map <silent> [Tag]c :tablast <bar> tabnew<cr>
map <silent> [Tag]x :tabclose<cr>
map <silent> [Tag]n :tabnext<cr>
map <silent> [Tag]p :tabprevious<cr>

highlight Pmenu ctermfg=white ctermbg=black
highlight PmenuSel ctermfg=white ctermbg=gray

" nvim-lspconfig
lua require'lsp'()

" nvim-completion
set completeopt=menuone,noinsert,noselect
set shortmess+=c

" treesitter
lua <<EOF
    require'nvim-treesitter.configs'.setup {
      ensure_installed = "maintained",
      highlight = {
        enable = true,
      },
    }
EOF

" tree viewer
nnoremap <silent> <leader>f. :Fern .<cr>
nnoremap <silent> <leader>fd :Fern . -drawer<cr>
nnoremap <silent> <leader>fr :Fern . -reveal=%:p<cr>
let g:fern#renderer = "nerdfont"

augroup my-glyph-palette
    autocmd! *
    autocmd FileType fern call glyph_palette#apply()
    autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END

" status bar
let g:airline#extensions#tabline#enabled = 1

" telescope
nnoremap <silent> <leader>ff <cmd>Telescope find_files<cr>
nnoremap <silent> <leader>fb <cmd>Telescope buffers<cr>
nnoremap <silent> <leader>fl <cmd>Telescope live_grep<cr>
nnoremap <silent> <leader>fg <cmd>Telescope grep_string<cr>
nnoremap <silent> <leader>kc <cmd>Telescope git_commits<cr>
nnoremap <silent> <leader>kv <cmd>Telescope git_bcommits<cr>
nnoremap <silent> <leader>kb <cmd>Telescope git_branches<cr>
nnoremap <silent> <leader>ks <cmd>Telescope git_status<cr>

lua << EOF
    local actions = require('telescope.actions')
    require('telescope').setup({
        defaults = {
            mappings = {
                i = {
                    ["<c-j>"] = actions.move_selection_next,
                    ["<c-k>"] = actions.move_selection_previous
                }
            }
        }
    })
EOF

" php-cs-fixer
let g:php_cs_fixer_path = "~/vendor/friendsofphp/php-cs-fixer/php-cs-fixer"
let g:php_cs_fixer_cache = ".php_cs.cache"
let g:php_cs_fixer_config_file = ".php_cs"
nnoremap <silent><leader>pcd :call PhpCsFixerFixDirectory()<CR>
nnoremap <silent><leader>pcf :call PhpCsFixerFixFile()<CR>
"autocmd BufWritePost *.php silent! call PhpCsFixerFixFile()
