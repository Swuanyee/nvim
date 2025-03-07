" Blue Dolphin colorscheme for Vim/Neovim
" Converted from a VSCode theme JSON to basic Vim highlight groups.
" Place this file in your colors/ directory and use :colorscheme bluedolphin

if exists("syntax_on")
  syntax reset
endif
set background=dark
let g:colors_name = "bluedolphin"

" Normal text: using editor.background and editor.foreground
highlight Normal       guifg=#c5f1ff guibg=#003950

" Comments: mapped from tokenColors (e.g. "#6A9955")
highlight Comment      guifg=#6A9955 gui=italic

" Constants (numbers, booleans, etc.)
highlight Constant     guifg=#FCB8B8

" Strings
highlight String       guifg=#A8FFD4CE

" Functions: e.g. entity.name.function
highlight Function     guifg=#8bfbff

" Identifiers: variables and such (e.g. meta.definition.variable.name)
highlight Identifier   guifg=#9CDCFE

" Keywords/Statements: using many keyword scopes (e.g. "#6ed1ff")
highlight Statement    guifg=#6ed1ff

" PreProcessor directives
highlight PreProc      guifg=#C5F1FF

" Types/Class names: from semantic tokens like class.declaration:python
highlight Type         guifg=#6AFFB4 gui=bold,italic

" Special symbols
highlight Special      guifg=#8bfbff

" Underlined text (for links or underlined tokens)
highlight Underlined   guifg=#6ed1ff gui=underline

" Line numbers: active and inactive
highlight LineNr       guifg=#9dfcff73 guibg=#002b3f
highlight CursorLineNr guifg=#f4d69e guibg=#003950

" Cursor: using the editorCursor color (#00bcd4)
highlight Cursor       guifg=#ffffff guibg=#00bcd4

" Visual selection: based on editor.selectionBackground
highlight Visual       guibg=#0180aa71

" Search highlighting (using editor.findMatchBackground)
highlight Search       guifg=#ffffff guibg=#02b7e44d

" Popup Menu (for completions)
highlight Pmenu        guifg=#aff3ff guibg=#002b3f
highlight PmenuSel     guifg=#ffffff guibg=#014d6b

" Status line: using statusBar foreground and background colors
highlight StatusLine   guifg=#ddf9ff guibg=#002b3f
highlight StatusLineNC guifg=#c5f1ff guibg=#002b3f

" Diff highlights (if using vimdiff)
highlight DiffAdd      guifg=none   guibg=#99b76d23
highlight DiffChange   guifg=none   guibg=#d6ffc1
highlight DiffDelete   guifg=none   guibg=#ef535033
highlight DiffText     guifg=none   guibg=#ffe585

" Error and warning messages
highlight Error        guifg=#ff8188 guibg=none
highlight WarningMsg   guifg=#ffe585 guibg=none
highlight Todo         guifg=#70d2ff guibg=none gui=italic

" Cursor line (if enabled)
highlight CursorLine   guibg=#002b3f

