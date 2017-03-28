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

    let status = systemlist('taxi status')
    for line in status
        if line =~ '^Total'
            let result = line
        endif
    endfor

    call append(0, [ result ])
    wincmd k
endfun

autocmd BufWritePost *.tks :call TaxiStatus()
