# less initialization script (csh)

# All less.*sh files should have the same semantics!

# In case you are curious, the test for non-emptiness is not as easy as in
# Bourne shell.  This "eval" construct is probably inspired by Stack
# Overflow question 13343392.
if ( $?LOCALMANPATH ) then
    :
else
    if ( ! $?MANPATH ) then
        setenv MANPATH /usr/share/man
    endif
    setenv LOCALMANPATH /usr/local/share/man
    setenv MANPATH "$LOCALMANPATH":"$MANPATH"
    setenv MANPATH /usr/local/llvm/13.0.0/cbuild/share/man:"$MANPATH"
endif

if ( $?LOCALINFOPATH ) then
    :
else
    if ( ! $?INFOPATH ) then
        setenv INFOPATH /usr/share/info
    endif
    setenv LOCALINFOPATH /usr/local/share/info
    setenv INFOPATH "$LOCALINFOPATH":"$INFOPATH"
endif
