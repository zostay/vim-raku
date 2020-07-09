" Vim filetype plugin file
" Language:      Raku
" Maintainer:    Sterling Hanenkamp <hanenkamp@cpan.org>
" Homepage:      https://github.com/Raku/vim-raku
" Bugs/requests: https://github.com/Raku/vim-raku/issues
" Last Change:   {{LAST_CHANGE}}
" Contributors:  Hinrik Örn Sigurðsson <hinrik.sig@gmail.com>
"                Moritz Lenz <moritz@faui2k3.org>
"                Sterling Hanenkamp <hanenkamp@cpan.org>
"                Luke Palmer <fibonaci@babylonia.flatirons.org>
"                Ned Konz <ned at bike-nomad dot com>
"
" Based on ftplugin/perl.vim by Dan Sharp <dwsharp at hotmail dot com>

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

" Make sure the continuation lines below do not cause problems in
" compatibility mode.
let s:save_cpo = &cpo
set cpo-=C

setlocal formatoptions-=t
setlocal formatoptions+=crqol
setlocal keywordprg=p6doc

setlocal comments=:#\|,:#=,:#
setlocal commentstring=#%s

" Provided by Ned Konz <ned at bike-nomad dot com>
"---------------------------------------------
setlocal include=\\<\\(use\\\|require\\)\\>
setlocal includeexpr=substitute(v:fname,'::','/','g')
setlocal suffixesadd=.pm6,.pm,.pod6,.raku,.rakumod,.rakudoc
setlocal define=[^A-Za-z_]

" The following line changes a global variable but is necessary to make
" gf and similar commands work. Thanks to Andrew Pimlott for pointing out
" the problem. If this causes a " problem for you, add an
" after/ftplugin/raku.vim file that contains
"       set isfname-=:
set isfname+=:
setlocal iskeyword=@,48-57,_,192-255,-

" Set this once, globally.
if !exists("rakupath")
    if executable("raku")
        let rakuexec = "raku"
    elseif executable("perl6")
        let rakuexec = "perl6"
    endif

    " TODO This is naive because raku has a repository format for installed
    " files that is not made available this way.
    if exists("rakuexec")
        let incprog = "print join q/,/, gather for $*REPO.repo-chain {when CompUnit::Repository::FileSystem {.distribution.meta<name>.take}}"
        try
            let rakupath = system(rakuexec." -e '".incprog."'")
            let rakupath = substitute(rakupath,',.$',',,','')
        catch /E145:/
            let rakupath = ".,,"
        endtry
    else
        " If we can't call raku to get its path, just default to using the
        " current directory and the directory of the current file.
        let rakupath = ".,,"
    endif
endif

" Append rakupath to the existing path value, if it is set.  Since we don't
" use += to do it because of the commas in rakupath, we have to handle the
" global / local settings, too.
if &l:path == ""
    if &g:path == ""
        let &l:path=rakupath
    else
        let &l:path=&g:path.",".rakupath
    endif
else
    let &l:path=&l:path.",".rakupath
endif
"---------------------------------------------

" Convert ascii-based ops into their single-character unicode equivalent
if get(g:, 'raku_unicode_abbrevs', 0)
    iabbrev <buffer> !(<) ⊄
    iabbrev <buffer> !(<=) ⊈
    iabbrev <buffer> !(>) ⊅
    iabbrev <buffer> !(>=) ⊉
    iabbrev <buffer> !(cont) ∌
    iabbrev <buffer> !(elem) ∉
    iabbrev <buffer> != ≠
    iabbrev <buffer> (&) ∩
    iabbrev <buffer> (+) ⊎
    iabbrev <buffer> (-) ∖
    iabbrev <buffer> (.) ⊍
    iabbrev <buffer> (<) ⊂
    iabbrev <buffer> (<+) ≼
    iabbrev <buffer> (<=) ⊆
    iabbrev <buffer> (>) ⊃
    iabbrev <buffer> (>+) ≽
    iabbrev <buffer> (>=) ⊇
    iabbrev <buffer> (\|) ∪
    iabbrev <buffer> (^) ⊖
    iabbrev <buffer> (atomic) ⚛
    iabbrev <buffer> (cont) ∋
    iabbrev <buffer> (elem) ∈
    iabbrev <buffer> * ×
    iabbrev <buffer> **0 ⁰
    iabbrev <buffer> **1 ¹
    iabbrev <buffer> **2 ²
    iabbrev <buffer> **3 ³
    iabbrev <buffer> **4 ⁴
    iabbrev <buffer> **5 ⁵
    iabbrev <buffer> **6 ⁶
    iabbrev <buffer> **7 ⁷
    iabbrev <buffer> **8 ⁸
    iabbrev <buffer> **9 ⁹
    iabbrev <buffer> ... …
    iabbrev <buffer> / ÷
    iabbrev <buffer> << «
    iabbrev <buffer> <<[=]<< «=«
    iabbrev <buffer> <<[=]>> «=»
    iabbrev <buffer> <= ≤
    iabbrev <buffer> =~= ≅
    iabbrev <buffer> >= ≥
    iabbrev <buffer> >> »
    iabbrev <buffer> >>[=]<< »=«
    iabbrev <buffer> >>[=]>> »=»
    iabbrev <buffer> Inf ∞
    iabbrev <buffer> atomic-add-fetch ⚛+=
    iabbrev <buffer> atomic-assign ⚛=
    iabbrev <buffer> atomic-fetch ⚛
    iabbrev <buffer> atomic-dec-fetch --⚛
    iabbrev <buffer> atomic-fetch-dec ⚛--
    iabbrev <buffer> atomic-fetch-inc ⚛++
    iabbrev <buffer> atomic-inc-fetch ++⚛
    iabbrev <buffer> atomic-sub-fetch ⚛−=
    iabbrev <buffer> e 𝑒
    iabbrev <buffer> o ∘
    iabbrev <buffer> pi π
    iabbrev <buffer> set() ∅
    iabbrev <buffer> tau τ
endif

" Undo the stuff we changed.
let b:undo_ftplugin = "setlocal fo< com< cms< inc< inex< def< isf< isk< kp< path<" .
        \         " | unlet! b:browsefilter"

" Restore the saved compatibility options.
let &cpo = s:save_cpo
unlet s:save_cpo
