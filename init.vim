call plug#begin('~/.config/nvim/plugged')

" resize window
Plug 'simeji/winresizer'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

" Completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

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

call plug#end()

" Neovim Settings
cnoremap init :<C-u>edit $MYVIMRC<CR>
set number
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent

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
local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
end

local opts = { noremap = true, silent = true }
    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
    buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
    buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)

    buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

local lsp_installer = require "nvim-lsp-installer"
local lspconfig = require "lspconfig"
lsp_installer.setup()

for _, server in ipairs(lsp_installer.get_installed_servers()) do
  lspconfig[server.name].setup {
    on_attach = on_attach,
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
  }
end

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
    { name = "vsnip" },
  }, {
    { name = "buffer" },
  })
})

EOF

" treesitter
lua << EOF

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
