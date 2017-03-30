fun! TaxiAliases(findstart, base)
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1 ] =~ '\w'
            let start -= 1
        endwhile
        return start
    else
        let res = []
        let aliases = systemlist("taxi alias")
        for alias in aliases
            let parts = split(alias)
            if parts[1] =~ '^' . a:base
                call add(res, parts[1])
            endif
        endfor
        return res
    endif
endfun

set omnifunc=TaxiAliases

fun! TaxiStatus()
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

fun! TaxiStatusClose()
    let winnr = bufwinnr('^_taxistatus$')
    if ( winnr >  0 )
        execute winnr . 'wincmd w'
        execute 'wincmd q'
    endif
endfun

autocmd BufWritePost *.tks :call TaxiStatus()

let s:pat = '^\(\w\+\)\s\+\([0-9:?-]\+\)\s\+\(.*\)$'

fun! _str_pad(str, len)
    let str_len = len(a:str)
    let diff = a:len - str_len + 4
    let space = repeat(' ', diff)

    return a:str . space
endfun

fun! TaxiFormatLine(lnum, col_sizes)
    let line = getline(a:lnum)
    let parts = matchlist(line, s:pat)
    " the separator
    let alias = _str_pad(parts[1], a:col_sizes[0])
    let time  = _str_pad(parts[2], a:col_sizes[1])

    call setline(a:lnum, alias . time . parts[3])
endfun

fun! TaxiFormatFile()
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
        call TaxiFormatLine(line, col_sizes)
    endfor
endfun

autocmd QuitPre *.tks :call TaxiStatusClose()
autocmd BufWritePre *.tks :call TaxiFormatFile()

