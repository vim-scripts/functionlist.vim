" Functiontracker plugin v1.6
"
" Added autocommands for recent access ist so that user may go to a recent
" item by pressing enter on it
"
" Added support for javascript style functions
" Added support for functions with same name
" Added keymapping for easy navigation using fuctions first letter
" Made to work with split windows
" Added automatic update of recent function on entering or leaving insert mode
" while in a function
"
" Fixed issue when swithching to window while in insert mode
" Added auto resize in recent function list
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
"             map <F2> :Flisttoggle<CR>
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
	let l:last_accessed = t:window_last_accessed
	if(winbufnr(l:last_accessed) == a:bufno)
		exe l:last_accessed. ' wincmd w'
	else
		let l:thiswin = bufwinnr(a:bufno)
		exe l:thiswin . ' wincmd w'
	endif
endfunction

function! s:place_sign()
	setlocal cursorline
	return
	exec "sign unplace *"
	exec "sign define lineh linehl=Search texthl=Search" 
	exec "sign place 10 name=lineh line=".line('.')." buffer=" . t:tlistbuf
endfunction


function! s:goback_to_previous_size()
	if(winwidth(0) >15 ) 
		exe 'vertical res 15' 
	endif
endfunction

function! s:reindex()
	let l:lookup = s:index()
	call setbufvar(t:flbuf,"lookup",l:lookup)
	call s:refresh()
	exe 'normal ^'
endfunction

function! s:Searchfor(char)
	call search("^ ".a:char)
endfunction

function! s:iniflist()
	let l:thisbuf = bufnr('%')
	let t:window_last_accessed = winnr()
	if(exists("b:filelistrecentlist"))
		let l:oldrecentlist = b:filelistrecentlist
	endif
	setlocal spr
	15 vnew 
	"call matchadd('String','.')
	setlocal nospr
	setlocal cursorline
	setlocal ignorecase
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
	noremap <buffer> <silent> A :call <sid>Searchfor('a')<cr>
	noremap <buffer> <silent> B :call <sid>Searchfor('b')<cr>
	noremap <buffer> <silent> C :call <sid>Searchfor('c')<cr>
	noremap <buffer> <silent> D :call <sid>Searchfor('d')<cr>
	noremap <buffer> <silent> E :call <sid>Searchfor('e')<cr>
	noremap <buffer> <silent> F :call <sid>Searchfor('f')<cr>
	noremap <buffer> <silent> G :call <sid>Searchfor('g')<cr>
	noremap <buffer> <silent> H :call <sid>Searchfor('h')<cr>
	noremap <buffer> <silent> I :call <sid>Searchfor('i')<cr>
	noremap <buffer> <silent> J :call <sid>Searchfor('j')<cr>
	noremap <buffer> <silent> K :call <sid>Searchfor('k')<cr>
	noremap <buffer> <silent> L :call <sid>Searchfor('l')<cr>
	noremap <buffer> <silent> M :call <sid>Searchfor('m')<cr>
	noremap <buffer> <silent> N :call <sid>Searchfor('n')<cr>
	noremap <buffer> <silent> O :call <sid>Searchfor('o')<cr>
	noremap <buffer> <silent> P :call <sid>Searchfor('p')<cr>
	noremap <buffer> <silent> Q :call <sid>Searchfor('q')<cr>
	noremap <buffer> <silent> R :call <sid>Searchfor('r')<cr>
	noremap <buffer> <silent> S :call <sid>Searchfor('s')<cr>
	noremap <buffer> <silent> T :call <sid>Searchfor('t')<cr>
	noremap <buffer> <silent> U :call <sid>Searchfor('u')<cr>
	noremap <buffer> <silent> V :call <sid>Searchfor('v')<cr>
	noremap <buffer> <silent> W :call <sid>Searchfor('w')<cr>
	noremap <buffer> <silent> X :call <sid>Searchfor('x')<cr>
	noremap <buffer> <silent> Y :call <sid>Searchfor('y')<cr>
	noremap <buffer> <silent> Z :call <sid>Searchfor('z')<cr>

	noremap <buffer> <silent> a :call <sid>Searchfor('a')<cr>
	noremap <buffer> <silent> b :call <sid>Searchfor('b')<cr>
	noremap <buffer> <silent> c :call <sid>Searchfor('c')<cr>
	noremap <buffer> <silent> d :call <sid>Searchfor('d')<cr>
	noremap <buffer> <silent> e :call <sid>Searchfor('e')<cr>
	noremap <buffer> <silent> f :call <sid>Searchfor('f')<cr>
	noremap <buffer> <silent> g :call <sid>Searchfor('g')<cr>
	noremap <buffer> <silent> h :call <sid>Searchfor('h')<cr>
	noremap <buffer> <silent> i :call <sid>Searchfor('i')<cr>
	noremap <buffer> <silent> j :call <sid>Searchfor('j')<cr>
	noremap <buffer> <silent> k :call <sid>Searchfor('k')<cr>
	noremap <buffer> <silent> l :call <sid>Searchfor('l')<cr>
	noremap <buffer> <silent> m :call <sid>Searchfor('m')<cr>
	noremap <buffer> <silent> n :call <sid>Searchfor('n')<cr>
	noremap <buffer> <silent> o :call <sid>Searchfor('o')<cr>
	noremap <buffer> <silent> p :call <sid>Searchfor('p')<cr>
	noremap <buffer> <silent> q :call <sid>Searchfor('q')<cr>
	noremap <buffer> <silent> r :call <sid>Searchfor('r')<cr>
	noremap <buffer> <silent> s :call <sid>Searchfor('s')<cr>
	noremap <buffer> <silent> t :call <sid>Searchfor('t')<cr>
	noremap <buffer> <silent> u :call <sid>Searchfor('u')<cr>
	noremap <buffer> <silent> v :call <sid>Searchfor('v')<cr>
	noremap <buffer> <silent> w :call <sid>Searchfor('w')<cr>
	noremap <buffer> <silent> x :call <sid>Searchfor('x')<cr>
	noremap <buffer> <silent> y :call <sid>Searchfor('y')<cr>
	noremap <buffer> <silent> z :call <sid>Searchfor('z')<cr>
	noremap <buffer> <silent> _ :call <sid>Searchfor('_')<cr>
	noremap <buffer> <silent> <C-R> :call <sid>Repos()<cr>
	noremap <buffer> <silent> <C-M> :call <sid>Repos()<cr>
	noremap <buffer> <silent> <2-leftrelease> :call <sid>Repos()<cr>
    augroup Flistautocommands
		autocmd! * <buffer>
		au BufEnter  <buffer>  call <sid>reindex()
		au BufEnter  <buffer>  call <sid>resize()
		"au BufLeave  <buffer>  call <sid>goback_to_previous_size()
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
	noremap <buffer> <silent> <C-R> :call <sid>ReposRecent()<cr>
	noremap <buffer> <silent> <C-M> :call <sid>ReposRecent()<cr>
	augroup Flistautocommands
		autocmd! * <buffer>
		au BufEnter  <buffer>  call <sid>resizeRec()
    augroup END
	call s:switch_wnd(t:flbuf)
	let b:recbuf = l:recbuf
	call s:drawrecent()
	setlocal nomodifiable
	exe bufwinnr(t:flbuf). 'wincmd w'
endfunction

function! s:gotocommandmode()
	call feedkeys("\<Esc>",'n')
endfunction

function! s:resize()
	let l:current_size = winwidth(0)
	if(b:lookup[2] > l:current_size) 
		exe 'vertical res '. b:lookup[2]
	endif
	call s:gotocommandmode()
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
				autocmd! * <buffer>
			augroup END
			:q!
			call s:switch_wnd(t:flbuf)
			augroup Flistautocommands
				autocmd! * <buffer>
			augroup END
			:q!
			:redraw!
			unlet t:flbuf
		endif
	else
		augroup Flistautocommands
			autocmd! * <buffer>
			au InsertEnter <buffer>  call <sid>oninsertchange()
			au InsertEnter <buffer>  call <sid>oninsertchange()
			au WinLeave <buffer>  call <sid>savelastwindow()
		augroup END
		call s:iniflist()
	endif
endfunction
function! s:savelastwindow()
	let t:window_last_accessed = winnr()
endfunction

function! s:oninsertchange()
	if(exists("t:flbuf"))
		let l:winnr = winnr()
		call s:reindex()
		exe l:winnr. ' wincmd w'
		call s:getcurrentfunction()
		exe l:winnr. ' wincmd w'
	endif
endfunction

function! s:resizeRec()
	if(exists("b:maxlen"))
	let l:current_size = winwidth(0)
		if(b:maxlen > l:current_size) 
			exe 'vertical res '. b:maxlen
		endif
	endif
	call s:gotocommandmode()
endfunction

function! s:refresh()
	call s:switch_wnd(t:flbuf)
	setlocal modifiable
	for i in range(1,line('$'))
		call setline(i,'')
	endfor
		call setline(1,b:lookup[0])
	setlocal nomodifiable
	if(exists("b:recbuf"))
		call setbufvar(b:recbuf,"maxlen",b:lookup[2])
	endif
endfunction

function! s:index()
	let l:bufnow = bufnr('%')
	if(exists("b:srcbuf")) 
		call s:switch_wnd(b:srcbuf)
	endif
	let l:b =line('$')
	let l:flistd=[]
	let l:lookup = {}
	let l:lookupl = {}
	let l:lnc=0
	let l:maxlength = 0
	while (l:lnc <= b)
		let l:line = getline(l:lnc)
		let l:matched = matchlist(l:line,'\s*function\s*[*&]*\([a-zA-Z0-9_]*\)\s*(')
		if( ! empty(l:matched))
			if(!empty(l:matched[1]))
				let l:line =  ' '.l:matched[1]
			else 
				let l:funcpos = stridx(tolower(l:line),'function')
				if(l:funcpos>8) 
					let l:line = '...'.strpart(l:line,l:funcpos-8,17)
				else 
					let l:line = strpart(l:line,0,15).'...'
				endif
				let l:line =  ' '.l:line
			endif
			let l:current_length = strlen(l:line)
			if(l:current_length > l:maxlength) 
				let l:maxlength = l:current_length
			endif
			let l:suffix= 1
			let l:lsrc = l:line
			while(has_key(l:lookup,l:line))
				let l:line= l:lsrc.'('.l:suffix.')'
				let l:suffix+= 1
			endwhile
			call add(l:flistd,l:line)
			let l:lookup[l:line] = l:lnc
		endif
		let l:lnc+=1
	endwhile
	let l:flistd = sort(l:flistd)
		let l:lineno = 0
	for l:a in l:flistd
		let l:index = l:lookup[l:a]
		let l:lookupl[l:lineno] = l:index
		let l:lineno += 1
	endfor
	call s:switch_wnd(l:bufnow)
	return [l:flistd,l:lookupl,l:maxlength]
endfunction

function! s:Repos()
	let l:llindex= line('.')
	let l:llindex -= 1
	if(!exists("b:lookup") || !has_key(b:lookup[1],l:llindex)) 
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
	let l:idx = 0
	let l:recent = getbufvar(t:flbuf,"recent")
	for l:inc in l:recent
		if(l:inc[0] == a:fnc) 
			call remove(l:recent,l:idx)
		endif
		let l:idx+=1
	endfor
	call insert(l:recent,[a:fnc,a:lno])
	if(len(l:recent) > 10) 
		call remove(l:recent,10,-1)
	endif
	call setbufvar(t:flbuf,"recent",l:recent)
endfunction

function! s:ReposRecent()
	let l:lixl= getline('.')
	call s:switch_wnd(t:flbuf)
	let l:lix = index(b:lookup[0],l:lixl)
	if(l:lix != -1)
		let l:lix = b:lookup[1][l:lix]
		call s:addtorecent(l:lixl,l:lix)
		call s:drawrecent()
		call s:switch_wnd(b:srcbuf)
		call setpos('.',['.', l:lix,0,0])
		exe 'normal zz'
	endif
endfunction

function! s:drawrecent()	
	let l:recent = getbufvar(t:flbuf, 'recent')
	let l:bufsrc = getbufvar(t:flbuf,'srcbuf')
	let l:recbuf = getbufvar(t:flbuf,'recbuf')
	call s:switch_wnd(l:recbuf)
	let lnu = 1
	setlocal modifiable
	for [cnt,lnno] in l:recent
		call setline(lnu,cnt)
		let lnu += 1
	endfor
	setlocal nomodifiable
	call s:switch_wnd(t:flbuf)
endfunction

function! s:getcurrentfunction()
	let l:lineno = search('function','bnW')
	let l:lookup = getbufvar(t:flbuf,"lookup")
	if(type(l:lookup)!=3)
		return
	endif
	for l:key in keys(l:lookup[1])
		if(l:lookup[1][l:key] == l:lineno)
			call s:addtorecent(l:lookup[0][l:key],l:lineno)
			call s:drawrecent()
			let l:bufsrc = getbufvar(t:flbuf,'srcbuf')
			call s:switch_wnd(l:bufsrc)
		endif
	endfor
endfunction

command! Flisttoggle :call <sid>toggle()

"map <buffer>  <F5>  :call <sid>toggle()<cr>

"let sline = get(llist,selection)
"call setpos('.',[0,sline,1,0])
"autocmd  FocusGained  *   :echo 'Welcome back, ! You look great!'
