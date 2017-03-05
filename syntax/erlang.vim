" Vim syntax file
" Language:     Erlang (http://www.erlang.org)
" Maintainer:   Csaba Hoch <csaba.hoch@gmail.com>
" Contributor:  Adam Rutkowski <hq@mtod.org>
" Last Update:  2017-Feb-28
" License:      Vim license
" URL:          https://github.com/vim-erlang/vim-erlang-runtime

" Acknowledgements: This script was originally created by Kresimir Marzic [1].
" The script was then revamped by Csaba Hoch [2]. During the revamp, the new
" highlighting style and some code was taken from the Erlang syntax script
" that is part of vimerl [3], created by Oscar Hellström [4] and improved by
" Ricardo Catalinas Jiménez [5].

" [1]: Kreąimir Marľić (Kresimir Marzic) <kmarzic@fly.srk.fer.hr>
" [2]: Csaba Hoch <csaba.hoch@gmail.com>
" [3]: https://github.com/jimenezrick/vimerl
" [4]: Oscar Hellström <oscar@oscarh.net> (http://oscar.hellstrom.st)
" [5]: Ricardo Catalinas Jiménez <jimenezrick@gmail.com>

" Customization:
"
" To use the old highlighting style, add this to your .vimrc:
"
"     let g:erlang_old_style_highlight = 1
"
" To highlight further module attributes, add them to
" ~/.vim/after/syntax/erlang.vim:
"
"     syn keyword erlangAttribute myattr1 myattr2 contained

" quit when a syntax file was already loaded
if exists("b:current_syntax")
    finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Case sensitive
syn case match

setlocal iskeyword+=$,@-@

" Comments
syn match erlangComment           '%.*$' contains=erlangCommentAnnotation,erlangTodo
syn match erlangCommentAnnotation ' \@<=@\%(clear\|docfile\|end\|headerfile\|todo\|TODO\|type\|author\|copyright\|doc\|reference\|see\|since\|title\|version\|deprecated\|hidden\|private\|equiv\|spec\|throws\)' contained
syn match erlangCommentAnnotation /`[^']*'/ contained
syn keyword erlangTodo            TODO FIXME XXX contained

" Numbers (minimum base is 2, maximum is 36.)
syn match erlangNumberInteger '\<\d\+\>'
syn match erlangNumberInteger '\<\%([2-9]\|[12]\d\|3[0-6]\)\+#[[:alnum:]]\+\>'
syn match erlangNumberFloat   '\<\d\+\.\d\+\%([eE][+-]\=\d\+\)\=\>'

" Strings, atoms, characters
syn region erlangString            start=/"/ end=/"/ contains=erlangStringModifier
syn region erlangQuotedAtom        start=/'/ end=/'/ contains=erlangQuotedAtomModifier
syn match erlangStringModifier     '\\\%(\o\{1,3}\|x\x\x\|x{\x\+}\|\^.\|.\)\|\~\%([ni~]\|\%(-\=\d\+\|\*\)\=\.\=\%(\*\|\d\+\)\=\%(\..\)\=[tl]*[cfegswpWPBX#bx+]\)' contained
syn match erlangQuotedAtomModifier '\\\%(\o\{1,3}\|x\x\x\|x{\x\+}\|\^.\|.\)' contained
syn match erlangModifier           '\$\%([^\\]\|\\\%(\o\{1,3}\|x\x\x\|x{\x\+}\|\^.\|.\)\)'

" Operators, separators
syn match erlangOperator   '==\|=:=\|/=\|=/=\|<\|=<\|>\|>=\|=>\|:=\|++\|--\|=\|!\|<-\|+\|-\|\*\|\/'
syn keyword erlangOperator div rem or xor bor bxor bsl bsr and band not bnot andalso orelse
syn match erlangBracket    '{\|}\|\[\|]\||\|||'
syn match erlangPipe       '|'
syn match erlangRightArrow '->'

" Atoms, function calls (order is important)
syn match erlangAtom           '\<\l[[:alnum:]_@]*' contains=erlangBoolean
syn keyword erlangBoolean      true false contained
syn match erlangLocalFuncCall  '\<\a[[:alnum:]_@]*\>\%(\%(\s\|\n\|%.*\n\)*(\)\@=' contains=erlangBIF
syn match erlangLocalFuncRef   '\<\a[[:alnum:]_@]*\>\%(\%(\s\|\n\|%.*\n\)*/\)\@='
syn match erlangGlobalFuncCall '\<\%(\a[[:alnum:]_@]*\%(\s\|\n\|%.*\n\)*\.\%(\s\|\n\|%.*\n\)*\)*\a[[:alnum:]_@]*\%(\s\|\n\|%.*\n\)*:\%(\s\|\n\|%.*\n\)*\a[[:alnum:]_@]*\>\%(\%(\s\|\n\|%.*\n\)*(\)\@=' contains=erlangComment,erlangVariable
syn match erlangGlobalFuncRef  '\<\%(\a[[:alnum:]_@]*\%(\s\|\n\|%.*\n\)*\.\%(\s\|\n\|%.*\n\)*\)*\a[[:alnum:]_@]*\%(\s\|\n\|%.*\n\)*:\%(\s\|\n\|%.*\n\)*\a[[:alnum:]_@]*\>\%(\%(\s\|\n\|%.*\n\)*/\)\@=' contains=erlangComment,erlangVariable

" Variables, macros, records, maps
syn match erlangVariable '\<[A-Z_][[:alnum:]_@]*'
syn match erlangMacro    '??\=[[:alnum:]_@]\+'
syn match erlangMacro    '\%(-define(\)\@<=[[:alnum:]_@]\+'
syn match erlangMap      '#'
syn match erlangRecord   '#\s*\l[[:alnum:]_@]*'
syn region erlangQuotedRecord        start=/#\s*'/ end=/'/ contains=erlangQuotedAtomModifier

" Shebang (this line has to be after the ErlangMap)
syn match erlangShebang  '^#!.*'

" Bitstrings
syn match erlangBitType '\%(\/\%(\s\|\n\|%.*\n\)*\)\@<=\%(integer\|float\|binary\|bytes\|bitstring\|bits\|binary\|utf8\|utf16\|utf32\|signed\|unsigned\|big\|little\|native\|unit\)\%(\%(\s\|\n\|%.*\n\)*-\%(\s\|\n\|%.*\n\)*\%(integer\|float\|binary\|bytes\|bitstring\|bits\|binary\|utf8\|utf16\|utf32\|signed\|unsigned\|big\|little\|native\|unit\)\)*' contains=erlangComment

" Constants and Directives
syn match erlangUnknownAttribute '^\s*-\%(\s\|\n\|%.*\n\)*\l[[:alnum:]_@]*' contains=erlangComment
syn match erlangAttribute '^\s*-\%(\s\|\n\|%.*\n\)*\%(behaviou\=r\|compile\|export\(_type\)\=\|file\|import\|module\|author\|copyright\|doc\|vsn\|on_load\)\>' contains=erlangComment
syn match erlangInclude   '^\s*-\%(\s\|\n\|%.*\n\)*\%(include\|include_lib\)\>' contains=erlangComment
syn match erlangRecordDef '^\s*-\%(\s\|\n\|%.*\n\)*record\>' contains=erlangComment
syn match erlangDefine    '^\s*-\%(\s\|\n\|%.*\n\)*\%(define\|undef\)\>' contains=erlangComment
syn match erlangPreCondit '^\s*-\%(\s\|\n\|%.*\n\)*\%(ifdef\|ifndef\|else\|endif\)\>' contains=erlangComment
syn match erlangType      '^\s*-\%(\s\|\n\|%.*\n\)*\%(spec\|type\|opaque\|callback\)\>' contains=erlangComment

" Keywords
syn keyword erlangKeyword after begin case catch cond end fun if let of
syn keyword erlangKeyword receive when try

" Build-in-functions (BIFs)
syn keyword erlangBIF abs alive apply atom_to_binary atom_to_list contained
syn keyword erlangBIF binary_part binary_to_atom contained
syn keyword erlangBIF binary_to_existing_atom binary_to_float contained
syn keyword erlangBIF binary_to_integer bitstring_to_list contained
syn keyword erlangBIF binary_to_list binary_to_term bit_size contained
syn keyword erlangBIF byte_size check_old_code check_process_code contained
syn keyword erlangBIF concat_binary date delete_module demonitor contained
syn keyword erlangBIF disconnect_node element erase error exit contained
syn keyword erlangBIF float float_to_binary float_to_list contained
syn keyword erlangBIF garbage_collect get get_keys group_leader contained
syn keyword erlangBIF halt hd integer_to_binary integer_to_list contained
syn keyword erlangBIF iolist_to_binary iolist_size is_alive contained
syn keyword erlangBIF is_atom is_binary is_bitstring is_boolean contained
syn keyword erlangBIF is_float is_function is_integer is_list contained
syn keyword erlangBIF is_number is_pid is_port is_process_alive contained
syn keyword erlangBIF is_record is_reference is_tuple length link contained
syn keyword erlangBIF list_to_atom list_to_binary contained
syn keyword erlangBIF list_to_bitstring list_to_existing_atom contained
syn keyword erlangBIF list_to_float list_to_integer list_to_pid contained
syn keyword erlangBIF list_to_tuple load_module make_ref max min contained
syn keyword erlangBIF module_loaded monitor monitor_node node contained
syn keyword erlangBIF nodes now open_port pid_to_list port_close contained
syn keyword erlangBIF port_command port_connect pre_loaded contained
syn keyword erlangBIF process_flag process_flag process_info contained
syn keyword erlangBIF process purge_module put register registered contained
syn keyword erlangBIF round self setelement size spawn spawn_link contained
syn keyword erlangBIF spawn_monitor spawn_opt split_binary contained
syn keyword erlangBIF statistics term_to_binary throw time tl contained
syn keyword erlangBIF trunc tuple_size tuple_to_list unlink contained
syn keyword erlangBIF unregister whereis contained

" Sync at the beginning of functions: if this is not used, multiline string
" are not always recognized, and the indentation script cannot use the
" "searchpair" (because it would not always skip strings and comments when
" looking for keywords and opening parens/brackets).
syn sync match erlangSync grouphere NONE "^[a-z]\s*("
let b:erlang_syntax_synced = 1

" Define the default highlighting. See ":help group-name" for the groups and
" their colors.

let s:old_style = (exists("g:erlang_old_style_highlight") &&
                  \g:erlang_old_style_highlight == 1)

command -nargs=+ HiLink hi def link <args>

" Comments
HiLink erlangComment Comment
HiLink erlangCommentAnnotation Special
HiLink erlangTodo Todo
HiLink erlangShebang Comment

" Numbers
HiLink erlangNumberInteger Number
HiLink erlangNumberFloat Float

" Strings, atoms, characters
HiLink erlangString String

if s:old_style
  HiLink erlangQuotedAtom Type
else
  HiLink erlangQuotedAtom String
endif

HiLink erlangStringModifier Special
HiLink erlangQuotedAtomModifier Special
HiLink erlangModifier Special

" Operators, separators
HiLink erlangOperator Operator
HiLink erlangRightArrow Operator
if s:old_style
  HiLink erlangBracket Normal
  HiLink erlangPipe Normal
else
  HiLink erlangBracket Delimiter
  HiLink erlangPipe Delimiter
endif

" Atoms, functions, variables, macros
if s:old_style
  HiLink erlangAtom Normal
  HiLink erlangLocalFuncCall Normal
  HiLink erlangLocalFuncRef Normal
  HiLink erlangGlobalFuncCall Function
  HiLink erlangGlobalFuncRef Function
  HiLink erlangVariable Normal
  HiLink erlangMacro Normal
  HiLink erlangRecord Normal
  HiLink erlangQuotedRecord Normal
  HiLink erlangMap Normal
else
  HiLink erlangAtom String
  HiLink erlangLocalFuncCall Normal
  HiLink erlangLocalFuncRef Normal
  HiLink erlangGlobalFuncCall Normal
  HiLink erlangGlobalFuncRef Normal
  HiLink erlangVariable Identifier
  HiLink erlangMacro Macro
  HiLink erlangRecord Structure
  HiLink erlangQuotedRecord Structure
  HiLink erlangMap Structure
endif

" Bitstrings
if !s:old_style
  HiLink erlangBitType Type
endif

" Constants and Directives
if s:old_style
  HiLink erlangAttribute Type
  HiLink erlangMacroDef Type
  HiLink erlangUnknownAttribute Normal
  HiLink erlangInclude Type
  HiLink erlangRecordDef Type
  HiLink erlangDefine Type
  HiLink erlangPreCondit Type
  HiLink erlangType Type
else
  HiLink erlangAttribute Keyword
  HiLink erlangMacroDef Macro
  HiLink erlangUnknownAttribute Normal
  HiLink erlangInclude Include
  HiLink erlangRecordDef Keyword
  HiLink erlangDefine Define
  HiLink erlangPreCondit PreCondit
  HiLink erlangType Type
endif

" Keywords
HiLink erlangKeyword Keyword

" Build-in-functions (BIFs)
HiLink erlangBIF Function

if s:old_style
  HiLink erlangBoolean Statement
  HiLink erlangExtra Statement
  HiLink erlangSignal Statement
else
  HiLink erlangBoolean Boolean
  HiLink erlangExtra Statement
  HiLink erlangSignal Statement
endif

delcommand HiLink

let b:current_syntax = "erlang"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 et
