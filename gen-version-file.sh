#!/bin/sh
# Based on git's GIT-VERSION-GEN.

VF=version.txt
DEF_VER="vUNKNOWN ($(date +%Y-%m-%dT%T))"

LF='
'

if test -d .git -o -f .git &&
    VN=$(git describe --abbrev=4 HEAD 2>/dev/null) &&
    case "$VN" in
    *$LF*) (exit 1) ;;
    v[0-9]*)
        git update-index -q --refresh
        test -z "$(git diff-index --name-only HEAD --)" ||
        VN="$VN-dirty" ;;
    esac
then
    VN=$(echo "$VN" | sed -e 's/-/./g');
else
    VN="$DEF_VER"
fi

VN=$(expr "$VN" : v*'\(.*\)')

if test -r $VF
then
    VC=$(sed -e 's/^VERSION=//' <$VF)
else
    VC=unset
fi
test "$VN" = "$VC" || {
    echo >&2 "VERSION=$VN"
    echo "VERSION=$VN" >$VF
}


