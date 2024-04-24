# less initialization script (csh)

# All less.*sh files should have the same semantics!

# In case you are curious, the test for non-emptiness is not as easy as in
# Bourne shell.  This "eval" construct is probably inspired by Stack
# Overflow question 13343392.
if ( $?HOMELOCALBIN ) then
    :
else
    setenv HOMELOCALBIN $HOME/.local/bin
    setenv PATH "$HOMELOCALBIN":"$PATH"
endif
