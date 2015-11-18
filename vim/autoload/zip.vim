" zip.vim: Handles browsing zipfiles recursively (needs python)
"            AUTOLOAD PORTION
" Date:		Dec 23, 2009
" Version:	1.1
" Last Modification By:	Arno <arenevier@fdn.fr>
" Original Author: That file is based on autoload/zip.vim from 
"                  Charles E Campbell, Jr <NdrOchip@ScampbellPfamily.AbizM-NOSPAM>
" License:	    Vim License  (see vim's :help license)
" Copyright:    Copyright (C) 2008-2009 Arno
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               zip.vim and zipPlugin.vim are provided *as is* and comes with
"               no warranty of any kind, either expressed or implied. By using
"               this plugin, you agree that in no event will the copyright
"               holder be liable for any damages resulting from the use
"               of this software.

let s:keepcpo= &cpo
set cpo&vim

if &cp || exists("g:loaded_zip") || v:version < 700 || !has("python")
 finish
endif

let g:loaded_zip     = "v1"
let s:zipfile_escape = ' ?&;\|'

python import sys, os, vim, re, tempfile
python from zipfile import ZipFile, ZIP_STORED, ZIP_DEFLATED
python from StringIO import StringIO

" ZipBrowseSelect: {{{2
fun! s:ZipBrowseSelect()
  let repkeep= &report
  set report=10
  let fname= getline(".")

  " sanity check
  if fname =~ '^"'
   let &report= repkeep
   return
  endif
  if fname =~ '/$'
   redraw!
   echohl Error | echo "***error*** (zip#Browse) Please specify a file, not a directory" | echohl None
   let &report= repkeep
   return
  endif
  "FIXME: file whose name contain '::' are considered as combined zip files
  if fname =~ '::'
   redraw!
   echohl Error | echo "***error*** (zip#Browse) cannot handle files whose name contain '::'. sorry :(" | echohl None
   return
  endif

  " get zipfile to the new-window
  let zipfile = b:zipfile
  let curfile= expand("%")

  new
  wincmd _
  exe "e zipfile:".escape(zipfile,s:zipfile_escape).'::'.escape(fname,s:zipfile_escape)
  filetype detect

  let &report= repkeep
endfun

fun! zip#Load(fname)
    " we need this to avoid combined zipfile to be read twice: once because it
    " ends it begins with zipfile: and once because it ends with .zip
    if a:fname !~ '^zipfile:'
        call zip#Read(a:fname)
    endif
endfun

fun! zip#Read(fname)
  let repkeep= &report
  set report=10

  try
    let pyarg = a:fname
    python pyZipCat()
  catch
    echohl Error | echo "***error*** (zip#Read) error uncompressing " . a:fname | echohl None
  endtry

  let &report= repkeep
endfun

fun! zip#Write(fname)

  let repkeep= &report
  set report=10

  try
    let pyarg = a:fname
    python pyZipWrite()
  catch
    echohl Error | echo "***error*** (zip#Write) error updating " . a:fname | echohl None
  endtry

  let &report= repkeep
  setlocal nomod

endfun

python << EOF

def zipSetupOptions():
  vim.command("setlocal noswapfile")
  vim.command("setlocal buftype=nofile")
  vim.command("setlocal bufhidden=hide")
  vim.command("setlocal nobuflisted")
  vim.command("setlocal nowrap")
  vim.command("setlocal ft=tar")
  vim.command("setlocal nomodifiable")
  vim.command("setlocal readonly")
  vim.command("setlocal nomodified")
  vim.command("noremap <silent> <buffer> <cr> :call <SID>ZipBrowseSelect()<cr>")

def zipDisplayHeaders(name):
  vim.current.buffer.append("\" Browsing zipfile %s" % (name))
  vim.current.buffer.append("\" Select a file with cursor and press ENTER")
  vim.current.buffer.append("\"")
  del (vim.current.buffer[0])

def zipList(file, name):
    vim.command("setlocal modifiable noreadonly")
    zipDisplayHeaders(name)
    for f in file.filelist:
        vim.current.buffer.append (f.orig_filename)
    zipSetupOptions()

def zipContent(file, target):
    vim.command("setlocal modifiable noreadonly")
    for line in file.read(target).split('\n'):
        vim.current.buffer.append(line)
    del vim.current.buffer[0]
    vim.command("set nomodified")

def pause():
    vim.command("call input(\"\")")

def pyZipCat():
    name = vim.eval("pyarg")
    fullname = re.sub('^zipfile:', '', name)
    list = fullname.split('::')

    fd = open(list[0], 'rb')
    archive = ZipFile(fd)

    if len(list) == 1: # only one file. display it's content
        zipList(archive, list[0])
        archive.close()
        fd.close()
        vim.command("let b:zipfile = \"%s\"" % fullname);
        return

    for file in list[1:-1]:
        str = StringIO()
        str.write(archive.read(file))
        archive = ZipFile(str)

    target = list[-1]

    if os.path.splitext(target)[-1] in ['.zip', '.jar', '.xpi']: # zip file: list content
        str = StringIO()
        str.write(archive.read(target))
        archive = ZipFile(str)
        zipList(archive, target)
    else: # normal file: display content
        zipContent(archive, target)
    archive.close()
    fd.close()
    vim.command("let b:zipfile = \"%s\"" % fullname);

def pyZipUpdate(archive, filetorep, buffer):
    """ in a zipfile, replace some file with a new content, and return a
    buffer containing new archive bytes """
    str = StringIO()
    newarch = ZipFile(str, 'a')
    for name in archive.namelist():
        if name == filetorep:
            buffer.seek(0)
            content = buffer.read()
        else:
            content = archive.read(name)
        zipinfo = archive.getinfo(name)
        if zipinfo.compress_type not in [ZIP_STORED, ZIP_DEFLATED]:
            archive_info.compress_type = ZIP_DEFLATED
        newarch.writestr(zipinfo, content)
    newarch.close()
    str.seek(0)
    return str

def pyZipWrite():
    name = vim.eval("pyarg")
    list = re.sub('^zipfile:', '', name).split('::')

    # first, extract archives from outer to inner
    fd = open(list[0], 'rb')
    archive = ZipFile(fd)
    archives = [archive]

    for file in list[1:-1]:
        str = StringIO()
        str.write(archive.read(file))
        archive = ZipFile(str)
        archives.append(archive)

    # current buffer
    buf = StringIO()
    buf.write('\n'.join(vim.current.buffer[:]))

    # now, go backward to update and recompress them
    for (arch, file) in reversed(zip(archives, list[1:])):
         newbuf = StringIO()
         newbuf.write(pyZipUpdate(arch, file, buf).read())
         buf = newbuf
         arch.close()
    buf.seek(0)

    fd.close()
    fd = open(list[0], 'wb')
    fd.write(buf.read())
    fd.close()
    buf.close()

EOF

let &cpo= s:keepcpo
unlet s:keepcpo
