call plug#begin('~/.config/nvim/plugged')

" resize window
Plug 'simeji/winresizer'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'


" Completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

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

Plug 'tpope/vim-surround'

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

" json
Plug 'elzr/vim-json'

" kotlin
Plug 'udalov/kotlin-vim'

call plug#end()


" Neovim Settings
colorscheme murphy
cnoremap init :<C-u>edit $MYVIMRC<CR>
cnoremap jq :<C-u>%!jq '.'<CR>
set number
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent

set clipboard&
set clipboard+=unnamedplus

let g:clipboard = {
    \   'name': 'myClipboard',
    \   'copy': {
    \      '+': 'win32yank.exe -i',
    \      '*': 'win32yank.exe -i',
    \    },
    \   'paste': {
    \      '+': 'win32yank.exe -o',
    \      '*': 'win32yank.exe -o',
    \   },
    \   'cache_enabled': 1,
    \ }

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
lua << EOF

local on_attach = function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
end
local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
)

vim.keymap.set('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>')
vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.format()<CR>')
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')

vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')

vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', 'gE', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')

vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')

local mason = require "mason"
local lspconfig = require "lspconfig"
local mason_lspconfig = require "mason-lspconfig"

mason.setup()

mason_lspconfig.setup_handlers({ function (server_name)
  lspconfig[server_name].setup ({
    on_attach = on_attach,
    capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
  })
end 
})


vim.opt.completeopt = "menu,menuone,noselect"

local cmp = require"cmp"
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,

  },

  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),

  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer" },
  })
})


EOF

" Expand
imap <expr> <C-s>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-s>'

smap <expr> <C-s>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-s>'

" Expand or jump
imap <expr> <C-a>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-a>'
smap <expr> <C-a>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-a>'


" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap        s   <Plug>(vsnip-select-text)
xmap        s   <Plug>(vsnip-select-text)
nmap        S   <Plug>(vsnip-cut-text)
xmap        S   <Plug>(vsnip-cut-text)

" treesitter
lua <<EOF
    require'nvim-treesitter.configs'.setup {
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = true,
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
let g:php_cs_fixer_path = "./tools/php-cs-fixer/vendor/friendsofphp/php-cs-fixer/php-cs-fixer"

let g:php_cs_fixer_cache = ".php_cs.cache"
let g:php_cs_fixer_config_file = ".php_cs"
nnoremap <silent><leader>pcd :call PhpCsFixerFixDirectory()<CR>
nnoremap <silent><leader>pcf :call PhpCsFixerFixFile()<CR>

autocmd BufWritePost *.php silent! call PhpCsFixerFixFile()

" vim-json
let g:vim_json_syntax_conceal = 0
