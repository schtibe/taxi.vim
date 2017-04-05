" Set the omnifunc to be able to complete the aliases via <ctrl-x> <ctrl-o>
set omnifunc=TaxiAliases
let s:pat = '^\(\w\+\)\s\+\([0-9:?-]\+\)\s\+\(.*\)$'
autocmd BufReadPost *.tks :call s:assemble_taxi_aliases()
autocmd BufWritePost *.tks :call s:taxi_status()
autocmd QuitPre *.tks :call s:taxi_status_close()
autocmd BufWritePre *.tks :call TaxiFormatFile()

let s:aliases = []

fun! s:assemble_taxi_aliases()
    let r_aliases = systemlist("taxi alias")
    for alias in r_aliases
        let parts = split(alias)
        let alias = parts[1]
        let text = join(parts[3:], ' ')
        call add(s:aliases, [ alias, text])
    endfor
endfun

fun! TaxiAliases(findstart, base)
    " Complete string under the cursor to the aliases available in taxi
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1 ] =~ '\w'
            let start -= 1
        endwhile
        return start
    else
        let res = []
        for alias in s:aliases
            if alias[0] =~ '^' . a:base
                call add(res, { 'word': alias[0], 'menu': alias[1] })
            endif
        endfor
        return res
    endif
endfun


fun! s:taxi_status()
    " Create a scratch window below that contains the total line
    " of the taxi status output
    let winnr = bufwinnr('^_taxistatus$')
    if ( winnr >  0 )
        execute winnr . 'wincmd w'
        execute 'normal ggdG'
    else
        setl splitbelow
        2new _taxistatus
        setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    endif

    let result = "Could not read the status"
    let status = systemlist('taxi status')
    for line in status
        if line =~ '^Total'
            let result = line
        endif
    endfor

    call append(0, [ result ])
    wincmd k
endfun

fun! s:taxi_status_close()
    " Close the status scratch window
    let winnr = bufwinnr('^_taxistatus$')
    if ( winnr >  0 )
        execute winnr . 'wincmd w'
        execute 'wincmd q'
    endif
endfun


fun! s:str_pad(str, len)
    " Right pad a string with zeroes
    let str_len = len(a:str)
    let diff = a:len - str_len + 4
    let space = repeat(' ', diff)

    return a:str . space
endfun

fun! s:taxi_format_line(lnum, col_sizes)
    " Format a line in taxi
    let line = getline(a:lnum)
    let parts = matchlist(line, s:pat)
    let alias = s:str_pad(parts[1], a:col_sizes[0])
    let time  = s:str_pad(parts[2], a:col_sizes[1])

    call setline(a:lnum, alias . time . parts[3])
endfun

fun! TaxiFormatFile()
    " Format the taxi file
    let data_lines = []
    let col_sizes = [0, 0, 0]
    for line_nr in range(1, line('$'))
        let line = getline(line_nr)
        let parts = matchlist(line, s:pat)
        if len(parts) > 0
            call add(data_lines, line_nr)
            for i in range(1, len(parts) - 1)
                let idx = i - 1
                if len(parts[i]) > 0
                    let col_sizes[idx] = max([col_sizes[idx], len(parts[i])])
                endif
            endfor
        endif
    endfor

    for line in data_lines
        call s:taxi_format_line(line, col_sizes)
    endfor
endfun
