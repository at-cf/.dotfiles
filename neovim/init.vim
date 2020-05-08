" boilerplate {{{
set encoding=utf-8 nobomb
scriptencoding utf-8

set nocompatible

augroup cf_vimrc
  autocmd!
augroup END
" }}}

" environment {{{
let g:cf_is_windows = has('win64') || has('win32')
" If not Windows then assume Linux
let g:cf_is_nvim    = has('nvim')
let g:cf_gui        = has('gui_running')
let s:cf_config_dir = fnamemodify(expand('$MYVIMRC'), ':p:h')
if g:cf_is_windows
  let s:cf_data_dir = resolve(expand('$LOCALAPPDATA/' . (g:cf_is_nvim ? 'nvim-data' : 'vim')))
else
  let s:cf_data_dir = resolve(expand('$XDG_CACHE_HOME/' . (g:cf_is_nvim ? 'nvim-data' : 'vim')))
endif
let s:cf_plugins    = g:cf_is_nvim ? (trim($NVIM_PLUGINS) ==? '1') : (trim($VIM_PLUGINS) ==? '1')
" utilities {{{
function! s:ensure_dir(path) abort
  " use $HOME not ~
  if !isdirectory(a:path)
    call mkdir(a:path, "p", 0700)
  endif
endfunction
" }}}
call s:ensure_dir(s:cf_data_dir)
" }}}

" built-in settings {{{
" display {{{
set title
set lazyredraw
set visualbell t_vb=
set belloff=all
set display+=lastline
set nocursorcolumn
set nocursorline
set number norelativenumber
set synmaxcol=500
" }}}

" keyboard {{{
set ttyfast
if !has('nvim')
  set ttimeout
  set ttimeoutlen=100
endif
" }}}

" mouse {{{
set mouse=
" }}}

" status line {{{
set laststatus=2
set noshowmode
set shortmess+=acI
set statusline=\ %f\ %r%m%=%{CrfLspStatus()}\ %{CrfGitInfo()}\ %y\ %l/%L\ (%P)\ 
set ruler
function! CrfGitInfo() abort
  if exists('*FugitiveHead')
    let l:info = FugitiveHead()
    if !empty(l:info)
      return ' <' . l:info . '>'
    endif
  endif
  return ' '
endfunction
function! CrfLspStatus() abort
  if exists('*lsp#get_buffer_diagnostics_counts')
    let l:counts = lsp#get_buffer_diagnostics_counts()
    return (l:counts.warning > 0 ? '[W:' . l:counts.warning . ']' : '') . (l:counts.error > 0 ? '[E:' . l:counts.error . ']' : '')
  endif
  return ''
endfunction
" }}}

" wild and file globbing stuff {{{
set wildmenu
set wildmode=longest,full
set wildignorecase
" wildignore {{{
set wildignore+=.git
set wildignore+=node_modules
set wildignore+=package-lock.json
set wildignore+=*.min.*,*-min.*
set wildignore+=dist
" }}}
" }}}

" file reading {{{
set modeline
set modelines=1
set autoread
" }}}

" vim files {{{
" undo
set undofile
set undolevels=5000
" backup
set nobackup
set nowritebackup
" swap
set updatetime=4000
set swapfile
if !g:cf_is_nvim
  call s:ensure_dir(escape(s:cf_data_dir, '\') . '/backup')
  execute 'set backupdir=' . escape(s:cf_data_dir, '\') . '/backup/'
  call s:ensure_dir(escape(s:cf_data_dir, '\') . '/view')
  execute 'set viewdir=' . escape(s:cf_data_dir, '\') . '/view/'
  call s:ensure_dir(escape(s:cf_data_dir, '\') . '/swap')
  execute 'set directory=' . escape(s:cf_data_dir, '\') . '/swap//'
  call s:ensure_dir(escape(s:cf_data_dir, '\') . '/undo')
  execute 'set undodir=' . escape(s:cf_data_dir, '\') . '/undo//'
endif
" }}}

" session/view {{{
set sessionoptions=curdir,tabpages
set viewoptions-=options
" }}}

" history {{{
set history=1000
" }}}

" security {{{
if !g:cf_is_nvim
  set cryptmethod=blowfish2
endif
" }}}

" spelling {{{
set spelllang=en spell
set nospell
execute 'set spellfile=' . escape(s:cf_config_dir, '\') . '/spell/en.utf-8.add'
" }}}

" splits and buffers {{{
set splitbelow
set splitright
set hidden
set nostartofline
set scrolloff=0
set sidescrolloff=0
set scrolljump=5
" }}}

" folding {{{
set nofoldenable
set foldmethod=marker
set foldmarker={{{,}}}
set foldlevelstart=99
set foldcolumn=0
" }}}

" input auto-formatting {{{
set formatoptions=
set formatoptions+=r " continue comments by default
set formatoptions+=o " do not continue comment using o or O
set formatoptions+=j " no // comment when joining commented lines
set nrformats-=octal
" can't stand this nonsense
nnoremap <C-a> <Nop>
nnoremap <C-x> <Nop>
" }}}

" whitespace {{{
set wrap
set linebreak
set nojoinspaces
set textwidth=0
set list
set listchars=tab:→\ ,trail:·,extends:»,precedes:«,nbsp:×
set fillchars=vert:│
set showbreak=···
set breakindent
set autoindent
set copyindent
set preserveindent
set smarttab
" }}}

" backspace {{{
set backspace=indent,eol,start
" }}}

" matching and searching {{{
set noshowmatch
set incsearch
set hlsearch
set wrapscan
set ignorecase
set smartcase
" }}}

" completion {{{
set complete-=i
set complete-=t
set completeopt=menuone,noinsert,noselect,preview
set infercase
" }}}

" leader {{{
let g:mapleader = "\<Space>"
" }}}

" disable default vim plugins {{{
" sometimes just checks if variable is declared, so 0/1 makes no difference
" https://github.com/rbtnn/vim-gloaded
let g:loaded_2html_plugin      = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_gzip              = 1
let g:loaded_logipat           = 1
" let g:loaded_matchparen      = 1
let g:loaded_rrhelper          = 1
let g:loaded_spellfile_plugin  = 1
let g:loaded_sql_completion    = 1
let g:loaded_syntax_completion = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:vimsyn_embed             = 1
" let g:loaded_netrwPlugin     = 1
" }}}
" }}}

" plug.vim {{{
" install vim-plug {{{
let s:cf_plug_vim = expand(s:cf_config_dir . '/autoload/plug.vim')
if s:cf_plugins && empty(glob(s:cf_plug_vim))
  if executable('curl')
    let s:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    exe 'silent !curl -fLo ' . s:cf_plug_vim . ' --create-dirs ' . s:plug_url
    augroup cf_vimrc
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    augroup END
  else
    echoerr 'vim-plug needs to be installed (install curl?)'
    finish
  endif
endif
" }}}
" utilities {{{
function! s:cf_plug_loaded(name) abort
  return exists('g:plugs') && has_key(g:plugs, a:name) && isdirectory(g:plugs[a:name].dir)
endfunction
" }}}
" plugin definition {{{
call s:ensure_dir(expand(s:cf_config_dir . '/plug'))
if s:cf_plugins && plug#begin(expand(s:cf_config_dir . '/plug'))
  " file {{{
  Plug 'justinmk/vim-dirvish'
  \ | let g:loaded_netrwPlugin = 1
  Plug 'tpope/vim-sleuth'
  Plug 'ctrlpvim/ctrlp.vim'
  \ | Plug 'FelikZ/ctrlp-py-matcher'
  " }}}
  " general {{{
  Plug 'https://gitlab.com/cf91/vim-redir-output.git', { 'on': [ 'RedirS', 'RedirT', 'RedirV' ] }
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'
  Plug 'alvan/vim-closetag', { 'for': 'html' }
  Plug 'Raimondi/delimitMate'
  Plug 'Valloric/ListToggle'
  Plug 'yssl/QFEnter'
  Plug 'https://gitlab.com/cf91/vim-quit-if-transient-buffers.git'
  Plug 'lfv89/vim-interestingwords', { 'on': '<Plug>InterestingWords' }
  Plug 'itchyny/vim-parenmatch'
  \ | let g:loaded_matchparen = 1
  runtime macros/matchit.vim
  if executable('tmux')
    Plug 'christoomey/vim-tmux-navigator'
  endif
  " }}}
  " development {{{
  Plug 'tpope/vim-fugitive'
  Plug 'sbdchd/neoformat', { 'on': 'Neoformat' }
  Plug 'SirVer/ultisnips'
  \ | Plug 'honza/vim-snippets'
  Plug 'prabirshrestha/asyncomplete.vim'
  \ | Plug 'prabirshrestha/asyncomplete-buffer.vim'
  \ | Plug 'prabirshrestha/asyncomplete-file.vim'
  \ | Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
  Plug 'prabirshrestha/async.vim'
  \ | Plug 'prabirshrestha/vim-lsp'
  \ | Plug 'prabirshrestha/asyncomplete-lsp.vim'
  if has('python3') && executable('python')
    Plug 'valloric/MatchTagAlways', { 'for': [ 'html', 'xml' ] }
  endif
  " }}}
  " language {{{
  Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
  Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescript' }
  Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
  Plug 'PProvost/vim-ps1', { 'for': 'ps1' }
  " }}}
  " themes {{{
  Plug 'dracula/vim', { 'as': 'dracula' }
  " }}}
  call plug#end()
else
  filetype plugin indent on
  syntax enable
endif
" }}}
" }}}

" theming {{{
if g:cf_is_nvim
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
else
  set t_Co=256
endif
if !g:cf_gui
  let &t_ZH = "\e[3m"
  let &t_ZR = "\e[23m"
  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[2 q"
  if has('termguicolors')
   set termguicolors
  endif
  " Fix block cursor
  augroup cf_vimrc
    autocmd VimEnter * silent exec "! echo -ne '\e[1 q'"
    autocmd VimLeave * silent exec "! echo -ne '\e[5 q'"
  augroup END
endif
" dracula or fallback {{{
let s:cf_set_custom_theme = 0
if s:cf_plug_loaded('dracula')
  try
    set background=dark
    silent! colorscheme dracula
    let s:cf_set_custom_theme = 1
  catch
    let s:cf_set_custom_theme = 0
  endtry
endif
if !s:cf_set_custom_theme
  try
    set background=light
    silent! colorscheme zellner
  catch
  endtry
endif
nnoremap <silent> <F5> :syntax sync fromstart<CR>
unlet s:cf_set_custom_theme
" }}}
" }}}

" feature plugin configuration {{{
" vim-dirvish {{{
if s:cf_plug_loaded('vim-dirvish')
  let g:dirvish_relative_paths = 0
  let g:dirvish_mode = ':sort | sort ,^.*[^\\\/]$, r'
else
  call s:ensure_dir(expand(s:cf_data_dir . '/netrw'))
  let g:netrw_home   = expand(s:cf_data_dir . '/netrw')
  let g:netrw_banner = 0
  function! s:cf_netrw_explore() abort
    let g:netrw_browse_split = 0
    let g:netrw_liststyle    = 0
    :Explore
  endfunction
  nnoremap <silent> - :call <SID>cf_netrw_explore()<CR>
endif
" }}}

" vim-sleuth {{{
if s:cf_plug_loaded('vim-sleuth')
  nnoremap <silent> <F2> :Sleuth<CR>
else
  set tabstop=2
  set softtabstop=2
  set shiftwidth=2
  set expandtab
endif
" }}}

" ctrlp.vim {{{
if s:cf_plug_loaded('ctrlp.vim')
  " caching
  let g:ctrlp_use_caching         = g:cf_is_nvim ? (trim($NVIM_CTRLP_CACHE) ==? '1') : (trim($VIM_CTRLP_CACHE) ==? '1')
  let g:ctrlp_clear_cache_on_exit = 0
  let g:ctrlp_cache_dir           = expand(s:cf_data_dir . '/ctrlp')
  call s:ensure_dir(expand(s:cf_data_dir . '/ctrlp'))
  " searching
  if executable('rg')
    let g:ctrlp_user_command = 'rg %s --files --color=never --smart-case'
  elseif g:cf_is_windows
    let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'
  else
    let g:ctrlp_user_command = 'find %s -type f'
  endif
  if s:cf_plug_loaded('ctrlp-py-matcher')
    let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
  endif
  " general
  let g:ctrlp_working_path_mode = 0
  let g:ctrlp_by_filename       = 1
  let g:ctrlp_match_window      = 'bottom,order:btt,min:1,max:20,results:20'
  let g:ctrlp_lazy_update       = 500
  let g:ctrlp_brief_prompt      = 1
  " mru
  let g:ctrlp_mruf_max            = 500
  let g:ctrlp_mruf_relative       = 1
  let g:ctrlp_mruf_case_sensitive = !g:cf_is_windows
  let g:ctrlp_mruf_save_on_update = 0
  noremap <Space><Space> :<C-u>CtrlP<CR>
  noremap <Leader>f :<C-u>CtrlP<CR>
  noremap <Leader>c :<C-u>CtrlPCurFile<CR>
  noremap <Leader>b :<C-u>CtrlPBuffer<CR>
  noremap <Leader>r :<C-u>CtrlPMRU<CR>
endif
" }}}

" delimitMate {{{
if s:cf_plug_loaded('delimitMate')
  augroup cf_vimrc
    autocmd FileType html,xml let b:delimitMate_matchpairs = "(:),[:],{:}"
  augroup END
endif
" }}}

" vim-interestingwords {{{
if s:cf_plug_loaded('vim-interestingwords')
  let g:interestingWordsCaseSensitive = 1
  let g:interestingWordsGUIColors = [
  \   '#EF798A',
  \   '#C3E991',
  \   '#51A3A3',
  \   '#CB904D',
  \   '#DFCC74',
  \   '#E5C3D1',
  \   '#F7A9A8',
  \   '#988B8E'
  \ ]
  nmap <silent> <Leader>k <Plug>InterestingWords
  nmap <silent> <Leader>K <Plug>InterestingWordsClear
endif
" }}}
"
" vim-fugitive {{{
if s:cf_plug_loaded('vim-fugitive')
endif
" }}}

" neoformat {{{
if s:cf_plug_loaded('neoformat')
  " general settings
  let g:neoformat_run_all_formatters = 0
  let g:neoformat_try_formatprg      = 1
  let g:neoformat_basic_format_align = 0
  let g:neoformat_basic_format_retab = 0
  let g:neoformat_basic_format_trim  = 0
  let g:neoformat_only_msg_on_error  = 1
  " formatter settings
  let g:neoformat_enabled_css        = ['prettier']
  let g:neoformat_enabled_html       = ['prettier']
  let g:neoformat_enabled_javascript = ['standard', 'prettier']
  let g:neoformat_enabled_json       = ['prettier']
  let g:neoformat_enabled_markdown   = ['prettier']
  let g:neoformat_enabled_scss       = ['prettier']
  let g:neoformat_enabled_typescript = ['prettier']
  let g:neoformat_enabled_yaml       = ['prettier']
  " takes precedence over all LSP stuff
  nnoremap <silent> gq :<C-u>Neoformat<CR>
  vnoremap <silent> gq :<C-u>Neoformat<CR>
endif
" }}}

" ultisnips {{{
if s:cf_plug_loaded('ultisnips')
  let g:UltiSnipsSnippetDirectories  = ['UltiSnips', 'CustomSnippets']
  let g:UltiSnipsEditSplit           = 'tabdo'
  let g:UltiSnipsEnableSnipMate      = 0
  let g:UltiSnipsListSnippets        = '<C-Tab>'
  let g:UltiSnipsExpandTrigger       = '<C-j>'
  let g:UltiSnipsJumpForwardTrigger  = '<C-j>'
  let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
endif
" }}}

" asyncomplete.vim {{{
if s:cf_plug_loaded('asyncomplete.vim')
  " settings
  let g:asyncomplete_auto_completeopt = 0
  let g:asyncomplete_auto_popup       = 1
  let g:asyncomplete_popup_delay      = 30
  let g:asyncomplete_auto_completeopt = 0
  " force refresh
  imap <C-Space> <Plug>(asyncomplete_force_refresh)
  " tab completion
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  if s:cf_plug_loaded('delimitMate')
    imap <expr> <CR> pumvisible() ? asyncomplete#close_popup() . "\<CR>" : "<Plug>delimitMateCR"
    imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "<Plug>delimitMateS-Tab"
  else
    inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() . "\<CR>" : "\<CR>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  endif
  " register sources
  function! s:cf_register_asyncomplete_sources() abort
    if s:cf_plug_loaded('asyncomplete-buffer.vim')
      let g:asyncomplete_buffer_clear_cache = 1
      call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
        \   'name': 'buffer',
        \   'whitelist': ['*'],
        \   'blacklist': [],
        \   'completor': function('asyncomplete#sources#buffer#completor'),
        \   'config': {
        \     'max_buffer_size': 5000000
        \   }
        \ }))
    endif
    if s:cf_plug_loaded('asyncomplete-file.vim')
      call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
        \   'name': 'file',
        \   'whitelist': ['typescript', 'javascript'],
        \   'blacklist': [],
        \   'completor': function('asyncomplete#sources#file#completor')
        \ }))
    endif
    if s:cf_plug_loaded('ultisnips') && s:cf_plug_loaded('asyncomplete-ultisnips.vim')
      call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
        \   'name': 'ultisnips',
        \   'whitelist': ['*'],
        \   'blacklist': [],
        \   'completor': function('asyncomplete#sources#ultisnips#completor')
        \ }))
    endif
  endfunction
  augroup cf_vimrc
    autocmd User asyncomplete_setup call s:cf_register_asyncomplete_sources()
  augroup END
endif
" }}}

" vim-lsp {{{
if s:cf_plug_loaded('vim-lsp')
  let g:lsp_async_completion             = 1
  let g:lsp_auto_enable                  = 1
  let g:lsp_diagnostics_echo_cursor      = 1
  let g:lsp_diagnostics_enabled          = 1
  let g:lsp_fold_enabled                 = 0
  let g:lsp_highlight_references_enabled = 0
  let g:lsp_highlights_enabled           = 1
  let g:lsp_hover_conceal                = 1
  let g:lsp_insert_text_enabled          = 1
  let g:lsp_preview_autoclose            = 1
  let g:lsp_preview_doubletap            = [function('lsp#ui#vim#output#closepreview')]
  let g:lsp_preview_float                = 1
  let g:lsp_preview_keep_focus           = 1 " :pclose
  let g:lsp_preview_max_height           = -1
  let g:lsp_preview_max_width            = -1
  let g:lsp_signature_help_enabled       = 1
  let g:lsp_signs_enabled                = 1
  let g:lsp_signs_priority               = 200
  let g:lsp_text_edit_enabled            = 1
  let g:lsp_textprop_enabled             = 1
  let g:lsp_use_event_queue              = 1
  let g:lsp_virtual_text_enabled         = 1
  let g:lsp_virtual_text_prefix          = '> '
  " lsp maps
  function! s:cf_set_lsp_buffer_settings()
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=auto
    nmap <buffer> <silent> <Leader>dd <Plug>(lsp-definition)
    nmap <buffer> <silent> <Leader>dD <Plug>(lsp-peek-definition)
    nmap <buffer> <silent> <Leader>di <Plug>(lsp-implementation)
    nmap <buffer> <silent> <Leader>dI <Plug>(lsp-peek-implementation)
    nmap <buffer> <silent> <Leader>dt <Plug>(lsp-type-definition)
    nmap <buffer> <silent> <Leader>dT <Plug>(lsp-peek-type-definition)
    nmap <buffer> <silent> <Leader>dg <Plug>(lsp-references)
    nmap <buffer> <silent> <Leader>dr <Plug>(lsp-rename)
    nmap <buffer> <silent> <Leader>da <Plug>(lsp-code-action)
    nmap <buffer> <silent> K          <Plug>(lsp-hover)
    nmap <buffer> <silent> <Leader>dx <Plug>(lsp-document-diagnostics)
    nmap <buffer> <silent> ]e         <Plug>(lsp-next-error)
    nmap <buffer> <silent> [E         <Plug>(lsp-previous-error)
    nmap <buffer> <silent> ]w         <Plug>(lsp-next-warning)
    nmap <buffer> <silent> [W         <Plug>(lsp-previous-warning)
    nmap <buffer> <silent> ]a         <Plug>(lsp-next-diagnostic)
    nmap <buffer> <silent> [A         <Plug>(lsp-previous-diagnostic)
  endfunction
  " register lsp servers
  function! s:cf_register_lsp_servers() abort
    if executable('typescript-language-server')
      call lsp#register_server({
      \   'name': 'typescript-language-server',
      \   'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
      \   'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
      \   'whitelist': ['typescript'],
      \ })
    endif
  endfunction
  augroup cf_vimrc
    autocmd User lsp_setup call s:cf_register_lsp_servers()
    autocmd User lsp_buffer_enabled call s:cf_set_lsp_buffer_settings()
  augroup END
endif
" }}}
" }}}

" general editing maps {{{
" typos {{{
cnoreabbrev QA qa
cnoreabbrev Qa qa
cnoreabbrev Q  q
cnoreabbrev WQ wq
cnoreabbrev Wq wq
cnoreabbrev WA wa
cnoreabbrev Wa wa
cnoreabbrev W  w
" }}}

" basic editing {{{
nnoremap <C-s> :w<CR>
nnoremap <C-q> :q<CR>
" have x not go into the default register
nnoremap x "_x
" }}}

" splits {{{
" navigate splits {{{
if !s:cf_plug_loaded('vim-tmux-navigator')
  nnoremap <C-j> <C-w><C-j>
  nnoremap <C-k> <C-w><C-k>
  nnoremap <C-l> <C-w><C-l>
  nnoremap <C-h> <C-w><C-h>
endif
" }}}
" cycle split with tab in normal mode {{{
nnoremap <Tab>   <C-w>w
nnoremap <S-Tab> <C-w>W
" }}}
" resize split (can take a count, eg. 2<S-Left>) {{{
nnoremap <S-Left>  <C-w><
nnoremap <S-Down>  <C-W>-
nnoremap <S-Up>    <C-W>+
nnoremap <S-Right> <C-w>>
" }}}
" create splits {{{
nnoremap <Leader>s :split<CR>
nnoremap <Leader>v :vsplit<CR>
" }}}
" }}}

" tabs {{{
nnoremap <C-t> :tabnew<CR>
" }}}

" treat long lines as break lines {{{
noremap j gj
noremap gj j
noremap k gk
noremap gk k
" }}}

" system clipboard {{{
vmap <C-c> "+ygv
imap <C-v> <ESC>"+pa
" }}}

" smart indent when entering insert mode with i on empty lines {{{
function! s:cf_indent_with_i() abort
  if len(getline('.')) == 0
    return "\"_cc"
  else
    return 'i'
  endif
endfunction
nnoremap <expr> i <SID>cf_indent_with_i()
" }}}
" }}}

" grepping {{{
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case 
  set grepformat^=%f:%l:%c:%m " file:line:column:message
endif
" grep helper functions {{{
function! s:cf_escape_grep(term) abort
  if !empty(a:term)
    return escape(a:term, '|')
  endif
  return a:term
endfunction
function! s:cf_do_my_lgrep(term, curr_dir) abort
  let l:safe_term = s:cf_escape_grep(a:term)
  if !empty(l:safe_term)
    if a:curr_dir
      exe 'silent lgrep! "' . l:safe_term . '" "' . expand('%:p:h') . '"' | lopen
    else
      exe 'silent lgrep! "' . l:safe_term . '"' | lopen
    endif
  endif
endfunction
" }}}
command! -nargs=+ Grep :call <SID>cf_do_my_lgrep(<q-args>, 0)
command! -nargs=+ GrepC :call <SID>cf_do_my_lgrep(<q-args>, 1)
nnoremap <silent> <Leader>8 :<C-u>call <SID>cf_do_my_lgrep(expand('<cword>'), 0)<CR>
nnoremap <silent> <Leader>* :<C-u>call <SID>cf_do_my_lgrep(expand('<cword>'), 1)<CR>
command! -nargs=0 CodeTasks :call <SID>cf_do_my_lgrep('TODO|FIXME|XXX', 0)
" grep by motion {{{
" doesn't support current directory search
function! s:cf_grep_from_selected(type) abort
  let l:saved_unnamed_register = @@
  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif
  let l:word = substitute(@@, '\n$', '', 'g')
  let @@ = l:saved_unnamed_register
  call s:cf_do_my_lgrep(l:word, 0)
endfunction
vnoremap <silent> gs :<C-u>call <SID>cf_grep_from_selected(visualmode())<CR>
nnoremap <silent> gs :<C-u>set operatorfunc=<SID>cf_grep_from_selected<CR>g@
" }}}
" prompt search {{{
function! s:cf_grep_prompt(curr_dir) abort
  let l:term = input('search: ')
  if !empty(l:term)
    call s:cf_do_my_lgrep(l:term, a:curr_dir)
  endif
endfunction
nnoremap <silent> <Leader>/ :call <SID>cf_grep_prompt(0)<CR>
nnoremap <silent> <Leader>? :call <SID>cf_grep_prompt(1)<CR>
" }}}
" }}}

" ll/qf navigation {{{
nnoremap ]L :llast<CR>
nnoremap ]l :lnext<CR>
nnoremap [l :lprev<CR>
nnoremap [L :lfirst<CR>
nnoremap ]Q :clast<CR>
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>
nnoremap [Q :cfirst<CR>
if s:cf_plug_loaded('ListToggle')
  let g:lt_location_list_toggle_map = '<Leader>l'
  let g:lt_quickfix_list_toggle_map = '<Leader>q'
endif
if s:cf_plug_loaded('QFEnter')
  let g:qfenter_keymap = {}
  let g:qfenter_keymap.vopen = ['<C-v>']
  let g:qfenter_keymap.hopen = ['<C-s>']
  let g:qfenter_keymap.topen = ['<C-t>']
endif
" }}}

" PowerShell {{{
if g:cf_is_windows
  command! -nargs=0 PowerShell :silent !start powershell
endif
" }}}

" ft customization {{{
" markdown {{{
function! s:cf_on_ft_markdown() abort
  setlocal spell
endfunction
" }}}
" gitcommit {{{
function! s:cf_on_ft_gitcommit() abort
  setlocal spell
  setlocal indentexpr=''
  setlocal colorcolumn=51,73
endfunction
" }}}
" fugitive {{{
function! s:cf_on_ft_fugitive() abort
endfunction
" }}}
augroup cf_vimrc
  autocmd filetype qf setlocal nonumber norelativenumber
  autocmd filetype markdown call s:cf_on_ft_markdown()
  autocmd filetype gitcommit call s:cf_on_ft_gitcommit()
  autocmd filetype fugitive call s:cf_on_ft_fugitive()
augroup end
" diff {{{
function! s:cf_on_diff() abort
  nnoremap <silent> <Leader>gr :diffg RE<CR>
  nnoremap <silent> <Leader>gb :diffg BA<CR>
  nnoremap <silent> <Leader>gl :diffg LO<CR>
  " ]c next change, [c previous change
endfunction
if &diff
  call s:cf_on_diff()
endif
" }}}
" }}}

" ginit.vim {{{
if g:cf_gui
  if g:cf_is_nvim
    if $NVIM_FONT !=? ""
      execute ':GuiFont! ' . $NVIM_FONT
    endif
    GuiTabline 0
    GuiPopupmenu 0
    " call GuiWindowMaximized(1)
    function! s:ToggleGuiFullscreen() abort
      if g:GuiWindowFullScreen
        call GuiWindowFullScreen(0)
      else
        call GuiWindowFullScreen(1)
      endif
    endfunction
    nnoremap <silent> <F11> :<C-u>call <SID>ToggleGuiFullscreen()<CR>
  else
    set t_vb=
    set guioptions-=m
    set guioptions-=t
    set guioptions-=T
    set guioptions-=r
    set guioptions-=l
    set guioptions-=R
    set guioptions-=L
    set guioptions-=e
    if $VIM_FONT !=? ""
      execute 'set guifont=' . $VIM_FONT
    endif
  endif
endif
" }}}

" fix cd {{{
if g:cf_gui && !g:cf_is_windows && (len(expand('%')) > 0)
  " https://askubuntu.com/questions/280816/gvim-always-starts-in-the-home-directory
  cd %:h
endif
" }}}

