
" Section: Keyboard Mapping

let mapleader=" "
imap jk <ESC>
nmap <space><space> :
nmap <space> <nop>
map tt :NERDTreeToggle<CR>
map <C-e> :NERDTreeToggle<CR>
map s <nop>
map S :w<CR>
map Q :q<CR>
map R :source $MYVIMRC<CR>
map e <C-Right>
map w <C-Left>
nmap E $
nmap W 0
noremap = nzz
noremap - Nzz
noremap <LEADER><CR> :nohlsearch<CR>
map J 5j
map K 5k
map L 5l
map H 5h
" imap <C-[> <C-T>
" imap <C-]> <C-D>
imap <C-h> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>
nmap <C-[> <<
nmap <C-]> >>
map sd :set splitright<CR>:vsplit<CR>
map sa :set nosplitright<CR>:vsplit<CR>
map sw :set nosplitbelow<CR>:split<CR>
map sx :set splitbelow<CR>:split<CR>
map <LEADER>h <C-w>h
map <LEADER>j <C-w>j
map <LEADER>k <C-w>k
map <LEADER>l <C-w>l
map sv <C-w>t<C-w>H
map sh <C-w>t<C-w>K
map <up> :res +5<CR>
map <down> :res -5<CR>
map <left> :vertical resize-5<CR>
map <right> :vertical resize+5<CR>
map <LEADER>t :tabe<CR>
" map <s-tab> :tabnext<CR>
map tr :-tabnext<CR>
map ty :+tabnext<CR>
map <LEADER>w :tabclose<CR>

" Section: Feature Configurations

set hlsearch
set incsearch
set ignorecase
set smartcase
set showcmd
set wrap
set cursorline
set number
" set mouse=a
set encoding=utf-8
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set list
set backspace=indent,eol,start
set foldmethod=indent
set foldlevel=99
set relativenumber
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
let g:loaded_perl_provider = 0 " 禁用 Perl 外置

exec "nohlsearch"
syntax on
filetype plugin indent on
filetype on
filetype indent on
filetype plugin on

" Section: Plugins(with junegunn/vim-plug)

call plug#begin('~/.vim/plugged')
Plug 'connorholyday/vim-snazzy'        " 配色
Plug 'scrooloose/nerdtree'             " 文件树
Plug 'majutsushi/tagbar'               " 显示 函数/类 列表
Plug 'mbbill/undotree'                 " 显示历史操作记录
" Plug 'rust-lang/rust.vim'              " rust语言支持
" Plug 'scrooloose/syntastic'         
Plug 'vim-airline/vim-airline'         " 底部栏样式
Plug 'vim-airline/vim-airline-themes'  " airline 主题
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' } " 预览markdown
Plug 'leafoftree/vim-svelte-plugin'
Plug 'tpope/vim-surround'              " 快速操作成对的符号
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }  " 模糊搜索
Plug 'ryanoasis/vim-devicons'          " 图标库
Plug 'bagrat/vim-buffet'               " Tab美化
Plug 'plasticboy/vim-markdown'
Plug 'neoclide/coc.nvim'

call plug#end()

" Section: Plugin Configurations

color snazzy
let g:ale_sign_error = '✗' 
let g:ale_sign_warning = '⚠'
" 添加一个命令Format用于格式化当前buffer
command! -nargs=0 Format :call CocAction('format')
" Fold用于折叠当前buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" OR用于整理imports
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:airline#extensions#tabline#enabled = 1
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {"theme": "dark"},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0,
    \ 'toc': {}
    \ }

" Section: Plugin Keyboard Mapping

" <CR> 自动选择第一个补全候选
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" tab 从当前单词触发补全 或者选择第一个候选
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" 方括号在错误诊断间转移
nmap <silent> [ <Plug>(coc-diagnostic-prev)
nmap <silent> ] <Plug>(coc-diagnosic-next)
nmap [] <nop>
nmap [[ <nop>
nmap ]] <nop>
" 代码跳转
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" D 在预览窗口展示文档
nnoremap <silent> D :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" 游标停滞时显示参考
autocmd CursorHold * silent call CocActionAsync('highlight')
" 重命名符号
nmap <LEADER>rn <Plug>(coc-rename)
" 格式化选中的代码
xmap <LEADER>f  <Plug>(coc-format-selected)
nmap <LEADER>f  <Plug>(coc-format-selected)
" Tagbar切换显示
map T :TagbarOpenAutoClose<CR>
" Ctrl-F 格式化代码
command! -nargs=0 Prettier :CocCommand prettier.formatFile
noremap <C-F> :Prettier<CR>
