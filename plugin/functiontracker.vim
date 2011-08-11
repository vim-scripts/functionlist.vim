" Functiontracker plugin v1.2
" Bug fixed where it wont index functions with numbers in the name(!!!)
"
" Last Change:	2011 Aug
" Maintainer:	Sandeep.c.r<sandeepcr2@gmail.com>
"
" This plugin displays a list of all lines with word 'function' in current
" file/buffer. This list is sorted on function name. It also maintains a list of
" recently accessed functions at the top so that you can switch between
" functions easily

" To make this plugin really useful you have to assign a shortcut key for this, 
" say you want F2 key to open the tab list.
"
" you can add the following line in your .vimrc file. 
"
"             map <F2> :Tablisttoggle<CR>
"
" If you are on windows " the file name would be _vimrc. The .vimrc file is  
" usually present in the users home directory.
"
" vimrc file will be hidden in linux so you will have to do a ls -ah to see it. 
"
" If the file  is not present you can just add one file with this line only.
"
" you have to Restart vim 
"
" Invoking this plugin opens a new vertical  window right to current window
"
"

function! s:switch_wnd(bufno)
	let l:thiswin = bufwinnr(a:bufno)
	exe l:thiswin . ' wincmd w'
endfunction

function! s:goback_to_previous_size()
	if(winwidth(0) >15 ) 
		exe 'vertical res 15' 
	endif
endfunction

function! s:reindex()
	let b:lookup = s:index()
	call s:refresh()
	exe 'normal ^'
endfunction

function! s:iniflist()
	let l:thisbuf = bufnr('%')

	if(exists("b:filelistrecentlist"))
		let l:oldrecentlist = b:filelistrecentlist
	endif
	setlocal spr
	15 vnew 
	call matchadd('String','.')
	setlocal nospr
	let t:flbuf = bufnr('%')
	let b:srcbuf = l:thisbuf
	if(exists("l:oldrecentlist"))
		let b:recent = l:oldrecentlist
	else
		let b:recent = []
	endif
	set nonu
	setlocal bt=nofile
	setlocal bt=nowrite
	setlocal bufhidden=delete
	setlocal noswapfile
	setlocal scrolloff=0
	setlocal sidescrolloff=0

	let b:lookup = s:index()
	call append(0,b:lookup[0])
	exe 'normal gg'
	setlocal nomodifiable
	map <buffer> <silent> <C-R> :call <sid>Repos()<cr>
	map <buffer> <silent> <C-M> :call <sid>Repos()<cr>
	map <buffer> <silent> <F5>  :call <sid>toggle()<cr>
	map <buffer> <silent> r :call <sid>reindex()<cr>
	map <buffer> <silent> <2-leftrelease> :call <sid>Repos()<cr>
    augroup Flistautocommands
		au BufEnter  <buffer>  call <sid>reindex()
		au BufEnter  <buffer>  call <sid>resize()
		au BufLeave  <buffer>  call <sid>goback_to_previous_size()
		au Bufhidden  <buffer>  call <sid>toggle()
    augroup END
	
	10 new 
	call matchadd('Keyword','.')
	setlocal bt=nofile
	setlocal bt=nowrite
	setlocal bufhidden=delete
	setlocal noswapfile
	setlocal scrolloff=0
	setlocal sidescrolloff=0
	let l:recbuf = bufnr('%')
	map <buffer>  <2-leftrelease> :call <sid>ReposRecent()<cr>
	call s:switch_wnd(t:flbuf)
	let b:recbuf = l:recbuf
	call s:drawrecent()
	setlocal nomodifiable
endfunction

function! s:resize()
	let l:current_size = winwidth(0)
	if(b:lookup[2] > l:current_size) 
		exe 'vertical res '. b:lookup[2]
	endif
endfunction

function! s:clearsearchbx()
call setline(1,'')
endfunction

function! s:toggle()
	if(exists("t:flbuf"))
		if(bufwinnr(t:flbuf) == -1)
			unlet t:flbuf
			call s:iniflist()
		else
			call s:switch_wnd(t:flbuf)
			call s:switch_wnd(b:recbuf)
			augroup Flistautocommands
				autocmd!
			augroup END
			:q!
			call s:switch_wnd(t:flbuf)
			augroup Flistautocommands
				autocmd!
			augroup END
			:q!
			:redraw!
			unlet t:flbuf
		endif
	else
		call s:iniflist()
	endif
endfunction

function! s:refresh()
	call s:switch_wnd(t:flbuf)
	setlocal modifiable
	for i in range(1,line('$'))
		call setline(i,'')
	endfor
		call setline(1,b:lookup[0])
	setlocal nomodifiable
endfunction

function! s:index()
	let l:bufnow = bufnr('%')
	call s:switch_wnd(b:srcbuf)
	let l:b =line('$')
	let l:flistd=[]
	let l:lookup = {}
	let l:lnc=0
	let l:maxlength = 0
	while (l:lnc < b)
		let l:line = getline(l:lnc)
		let l:matched = matchlist(l:line,'\s*function\s\+[*&]*\([a-zA-Z0-9_]*\)\s*(')
		if( ! empty(l:matched))
			let l:line =  ' '.l:matched[1]
			let l:current_length = strlen(l:line)
			if(l:current_length > l:maxlength) 
				let l:maxlength = l:current_length
			endif
			call add(l:flistd,l:line)
			let l:lookup[l:line] = l:lnc
		endif
		let l:lnc+=1
	endwhile
	let l:flistd = sort(l:flistd)
		let l:lineno = 0
	for l:a in l:flistd
		let l:lookup[l:lineno] = l:lookup[a]
		let l:lineno += 1
	endfor
	call s:switch_wnd(l:bufnow)
	return [l:flistd,l:lookup,l:maxlength]
endfunction

function! s:Repos()
	let l:llindex= line('.')
	let l:llindex -= 1
	if(!has_key(b:lookup[1],l:llindex)) 
		return
	endif
	let l:lineno = b:lookup[1][l:llindex]
	call s:addtorecent(getline('.'),l:llindex)
	call s:drawrecent()
	call setbufvar(b:srcbuf,"filelistrecentlist",b:recent)
	exe 'normal ^'
	call s:switch_wnd(b:srcbuf)
	call setpos('.',['.', l:lineno,0,0])
	exe 'normal zz'
endfunction


function! s:addtorecent(fnc,lno)
	for l:inc in b:recent
		if(l:inc[0] == a:fnc) 
			return
		endif
	endfor
	call insert(b:recent,[a:fnc,a:lno])
	if(len(b:recent) > 10) 
		call remove(b:recent,10,-1)
	endif
endfunction

function! s:ReposRecent()
	let l:lix= getline('.')
	call s:switch_wnd(t:flbuf)
	let l:lix = b:lookup[1][l:lix]
	call s:switch_wnd(b:srcbuf)
	call setpos('.',['.', l:lix,0,0])
	exe 'normal zz'
endfunction

function! s:drawrecent()	
	let l:recent = b:recent
	let l:bufsrc = b:srcbuf
	call s:switch_wnd(b:recbuf)
	let lnu = 1
	setlocal modifiable
	for [cnt,lnno] in l:recent
		call setline(lnu,cnt)
		let lnu += 1
	endfor
	setlocal nomodifiable
	call s:switch_wnd(t:flbuf)
endfunction

command! Flisttoggle :call <sid>toggle()

"map <buffer>  <F5>  :call <sid>toggle()<cr>

"let sline = get(llist,selection)
"call setpos('.',[0,sline,1,0])
"autocmd  FocusGained  *   :echo 'Welcome back, ! You look great!'
