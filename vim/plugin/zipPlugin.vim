" zipPlugin.vim: Handles browsing zipfiles
"            PLUGIN PORTION
" Date:			Mar 29, 2008
" Last Modification By:	Arno <arenevier@fdn.fr>
" Original Author: That file is based on plugin/zipPlugin.vim from 
"                  Charles E Campbell, Jr <NdrOchip@ScampbellPfamily.AbizM-NOSPAM>
" License:		Vim License  (see vim's :help license)
" Copyright:    Copyright (C) 2008 Arno
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               zipPlugin.vim is provided *as is* and comes with no warranty
"               of any kind, either expressed or implied. By using this
"               plugin, you agree that in no event will the copyright
"               holder be liable for any damages resulting from the use
"               of this software.
"
if &cp || exists("g:loaded_zipPlugin") || !has("python")
 finish
endif
let g:loaded_zipPlugin = 1
let s:keepcpo          = &cpo
set cpo&vim

augroup zip
 au!
 
 au BufReadCmd   zipfile:*/*	call zip#Read(expand("<amatch>"))
 au BufWriteCmd  zipfile:*/*	call zip#Write(expand("<amatch>"))

 au BufReadCmd   *.zip		call zip#Load(expand("<amatch>"))
 au BufReadCmd   *.jar		call zip#Load(expand("<amatch>"))
 au BufReadCmd   *.xpi		call zip#Load(expand("<amatch>"))
augroup END

let &cpo= s:keepcpo
unlet s:keepcpo
