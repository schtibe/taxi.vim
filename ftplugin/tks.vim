fun! TaxiAliases(findstart, base)
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1 ] =~ '\a'
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
