" Vim color file
" Maintainer: Kenta Murata <mrkn@mrkn.jp>

" This is the colorscheme designed by mrkn based on "desert256" colorscheme
" created by Henry So, Jr.  This colorscheme is designed to work with with
" 88- and 256-color xterms.
"
" The ancestor version "desert256" colorscheme is available at
" http://www.vim.org/scripts/script.php?script_id=1243
"
" The real feature of this color scheme, with a wink to the "inkpot"
" colorscheme, is the programmatic approximation of the gui colors to the
" palettes of 88- and 256- color xterms.  The functions that do this (folded
" away, for readability) are calibrated to the colors used for
" Thomas E. Dickey's xterm (version 200), which is available at
" http://dickey.his.com/xterm/xterm.html.
"
" Henry had struggled with trying to parse the rgb.txt file to avoid the
" necessity of converting color names to #rrggbb form, but decided it was just
" not worth the effort.  I thank a lot for his results.

set background=dark
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="mymrkn256"

if has("gui_running") || &t_Co == 88 || &t_Co == 256
    " functions {{{
    " returns an approximate grey index for the given grey level
    function! <SID>grey_number(x)
        if &t_Co == 88
            if a:x < 23
                return 0
            elseif a:x < 69
                return 1
            elseif a:x < 103
                return 2
            elseif a:x < 127
                return 3
            elseif a:x < 150
                return 4
            elseif a:x < 173
                return 5
            elseif a:x < 196
                return 6
            elseif a:x < 219
                return 7
            elseif a:x < 243
                return 8
            else
                return 9
            endif
        else
            if a:x < 14
                return 0
            else
                let l:n = (a:x - 8) / 10
                let l:m = (a:x - 8) % 10
                if l:m < 5
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual grey level represented by the grey index
    function! <SID>grey_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 46
            elseif a:n == 2
                return 92
            elseif a:n == 3
                return 115
            elseif a:n == 4
                return 139
            elseif a:n == 5
                return 162
            elseif a:n == 6
                return 185
            elseif a:n == 7
                return 208
            elseif a:n == 8
                return 231
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 8 + (a:n * 10)
            endif
        endif
    endfun

    " returns the palette index for the given grey index
    function! <SID>grey_color(n)
        if &t_Co == 88
            if a:n == 0
                return 16
            elseif a:n == 9
                return 79
            else
                return 79 + a:n
            endif
        else
            if a:n == 0
                return 16
            elseif a:n == 25
                return 231
            else
                return 231 + a:n
            endif
        endif
    endfun

    " returns an approximate color index for the given color level
    function! <SID>rgb_number(x)
        if &t_Co == 88
            if a:x < 69
                return 0
            elseif a:x < 172
                return 1
            elseif a:x < 230
                return 2
            else
                return 3
            endif
        else
            if a:x < 75
                return 0
            else
                let l:n = (a:x - 55) / 40
                let l:m = (a:x - 55) % 40
                if l:m < 20
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual color level for the given color index
    function! <SID>rgb_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 139
            elseif a:n == 2
                return 205
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 55 + (a:n * 40)
            endif
        endif
    endfun

    " returns the palette index for the given R/G/B color indices
    function! <SID>rgb_color(x, y, z)
        if &t_Co == 88
            return 16 + (a:x * 16) + (a:y * 4) + a:z
        else
            return 16 + (a:x * 36) + (a:y * 6) + a:z
        endif
    endfun

    " returns the palette index to approximate the given R/G/B color levels
    function! <SID>color(r, g, b)
        " get the closest grey
        let l:gx = <SID>grey_number(a:r)
        let l:gy = <SID>grey_number(a:g)
        let l:gz = <SID>grey_number(a:b)

        " get the closest color
        let l:x = <SID>rgb_number(a:r)
        let l:y = <SID>rgb_number(a:g)
        let l:z = <SID>rgb_number(a:b)

        if l:gx == l:gy && l:gy == l:gz
            " there are two possibilities
            let l:dgr = <SID>grey_level(l:gx) - a:r
            let l:dgg = <SID>grey_level(l:gy) - a:g
            let l:dgb = <SID>grey_level(l:gz) - a:b
            let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
            let l:dr = <SID>rgb_level(l:gx) - a:r
            let l:dg = <SID>rgb_level(l:gy) - a:g
            let l:db = <SID>rgb_level(l:gz) - a:b
            let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
            if l:dgrey < l:drgb
                " use the grey
                return <SID>grey_color(l:gx)
            else
                " use the color
                return <SID>rgb_color(l:x, l:y, l:z)
            endif
        else
            " only one possibility
            return <SID>rgb_color(l:x, l:y, l:z)
        endif
    endfun

    " returns the palette index to approximate the 'rrggbb' hex string
    function! <SID>rgb(rgb)
        let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
        let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
        let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

        return <SID>color(l:r, l:g, l:b)
    endfun

    " sets the highlighting for the given group
    function! <SID>X(group, fg, bg, attr)
        if a:fg != ""
            exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
        endif
        if a:bg != ""
            exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
        endif
        if a:attr != ""
            exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
        endif
    endfun
    " }}}

    "call <SID>X("Normal", "cccccc", "000000", "")

    " highlight groups
    call <SID>X("Cursor", "708090", "f0e68c", "")
    "CursorIM
    call <SID>X("CursorColumn", "", "333333", "none")
    call <SID>X("CursorLine", "", "333333", "none")
    call <SID>X("CursorLineNr", "", "333333", "none")
    "Directory
    "DiffAdd
    "DiffChange
    "DiffDelete
    "DiffText
    "ErrorMsg
    call <SID>X("DiffAdd", "262626", "00cc7f", "none")
    call <SID>X("DiffChange", "262626", "0087af", "none")
    call <SID>X("DiffDelete", "262626", "ffffff", "none")
    call <SID>X("DiffText", "262626", "8b0000", "none")

    call <SID>X("VertSplit", "666666", "666666", "none")
    call <SID>X("Folded", "ffd700", "000000", "bold")
    call <SID>X("FoldColumn", "d2b48c", "4d4d4d", "")
    call <SID>X("LineNr", "666666", "", "none")
    call <SID>X("ModeMsg", "daa520", "", "")
    call <SID>X("MoreMsg", "2e8b57", "", "")
    call <SID>X("NonText", "666699", "", "none")
    call <SID>X("Question", "00ff7f", "", "")
    call <SID>X("IncSearch", "708090", "f0e68c", "")
    call <SID>X("Search", "333333", "cccccc", "bold")
    call <SID>X("SpecialKey", "666699", "", "none")
    call <SID>X("StatusLine", "ffffff", "666666", "none")
    call <SID>X("StatusLineNC", "000000", "666666", "none")
    call <SID>X("Title", "cd5c5c", "", "")
    call <SID>X("Visual", "264f78", "f0e68c", "reverse")

    "VisualNOS
    call <SID>X("WarningMsg", "fa8072", "", "")
    "WildMenu
    "Menu
    "Scrollbar
    "Tooltip
    call <SID>X("Pmenu", "cccccc", "333333", "none")
    call <SID>X("PmenuSel", "663333", "cccccc", "bold")
    " call <SID>X("PmenuSbar", "", "", "")
    " call <SID>X("PmenuThumb", "", "", "")

    " syntax highlighting groups
    call <SID>X("Comment", "00cc7f", "", "")
    call <SID>X("Constant", "ffcc66", "", "")
    call <SID>X("Identifier", "99ff00", "", "none")
    call <SID>X("Statement", "6699ff", "", "none")
    call <SID>X("PreProc", "ff6666", "", "")
    call <SID>X("Type", "ffcc66", "", "bold")
    call <SID>X("Special", "ffdead", "", "")
    call <SID>X("Number", "cc66ff", "", "")
    call <SID>X("String", "99cccc", "", "")
    call <SID>X("Operator", "ff00ff", "", "")
    call <SID>X("Conditional", "ff6633", "", "bold")
    call <SID>X("Repeat", "66ff66", "", "bold")
    call <SID>X("Function", "9999ff", "", "none")
    call <SID>X("Delimiter", "99cccc", "", "bold")
    "Underlined
    call <SID>X("Ignore", "666666", "", "")
    call <SID>X("Error", "fa8072", "000000", "")
    call <SID>X("Todo", "ff4500", "eeee00", "")

    " for Ruby {{{
    call <SID>X("rubyDefine", "ffff00", "", "bold")
    call <SID>X("rubyClass", "3399ff", "", "bold")
    call <SID>X("rubyModule", "ff9966", "", "bold")
    call <SID>X("rubyControl", "ff99ff", "", "none")
    call <SID>X("rubyGlobalVariable", "ff3300", "", "")
    call <SID>X("rubyClassVariable", "ff3300", "", "")
    call <SID>X("rubyPredefinedVariable", "ff9999", "", "")
    call <SID>X("rubyPredefinedConstant", "ff9999", "", "")
    call <SID>X("rubySymbol", "99ffcc", "", "")
    call <SID>X("rubyKeyword", "ff6666", "", "bold")
    " }}}

    " for IndentGuides {{{
    call <SID>X("IndentGuidesOdd",  "666699", "333333", "")
    call <SID>X("IndentGuidesEven", "9999CC", "666666", "")
    " }}}

    " coc.nvim
    call <SID>X("CocHighlightText", "", "444444", "")

    " delete functions {{{
    delf <SID>X
    delf <SID>rgb
    delf <SID>color
    delf <SID>rgb_color
    delf <SID>rgb_level
    delf <SID>rgb_number
    delf <SID>grey_color
    delf <SID>grey_level
    delf <SID>grey_number
    " }}}
else
    " color terminal definitions
    hi SpecialKey    ctermfg=darkgreen
    hi NonText       cterm=bold ctermfg=darkblue
    hi Directory     ctermfg=darkcyan
    hi ErrorMsg      cterm=bold ctermfg=7 ctermbg=1
    hi IncSearch     cterm=NONE ctermfg=yellow ctermbg=green
    hi Search        cterm=NONE ctermfg=grey ctermbg=blue
    hi MoreMsg       ctermfg=darkgreen
    hi ModeMsg       cterm=NONE ctermfg=brown
    hi LineNr        ctermfg=3
    hi Question      ctermfg=green
    hi StatusLine    cterm=bold,reverse
    hi StatusLineNC  cterm=reverse
    hi VertSplit     cterm=reverse
    hi Title         ctermfg=5
    hi Visual        cterm=reverse
    hi VisualNOS     cterm=bold,underline
    hi WarningMsg    ctermfg=1
    hi WildMenu      ctermfg=0 ctermbg=3
    hi Folded        ctermfg=darkgrey ctermbg=NONE
    hi FoldColumn    ctermfg=darkgrey ctermbg=NONE
    hi DiffAdd       ctermbg=4
    hi DiffChange    ctermbg=5
    hi DiffDelete    cterm=bold ctermfg=4 ctermbg=6
    hi DiffText      cterm=bold ctermbg=1
    hi Comment       ctermfg=darkcyan
    hi Constant      ctermfg=brown
    hi Special       ctermfg=5
    hi Identifier    ctermfg=6
    hi Statement     ctermfg=3
    hi PreProc       ctermfg=5
    hi Type          ctermfg=2
    hi Underlined    cterm=underline ctermfg=5
    hi Ignore        ctermfg=darkgrey
    hi Error         cterm=bold ctermfg=7 ctermbg=1
endif

" vim: foldlevel=0 foldmethod=marker
