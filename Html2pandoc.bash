#!/bin/bash
# 1. vivaldy $B$N(Bbookmark $B%(%/%9%]!<%H$G(Bhtml $B%U%!%$%k$rJ]B8(B
# 2. $B$3$N(Bhtml$B%U%!%$%k$r!"(Bpandoc -f html -t asciidoc bookmark.html > $HTTPINFO.asciidoc
# 3. bookmark.html $B$N(BShellScript $BItJ,$r@Z$j=P$9!!!!!!(Bsed -n 10,20p file
# 4. bookmark $B$G>O(B(ShellScript)$B@a(B($B@)8f!&JQ?tEy(B)$B9`(B(html$B$NBjL\(B) $B$G%G%#%l%/%H%j$d(Basciidoc $B%U%!%$%k$r:n@.$9$k(B

DTTM=`date +%Y%m%d_%H%M%S`
CMDNM00=${0%\.*}
CMDNM01=${CMDNM00#\./}
URL=$1
HTTPINFO=`basename $URL`
#CREATEDIR="${CMDNM01}_${DTTM}"
CREATEDIR="${DTTM}-$2"
#echo  "CREATEDIR : $CREATEDIR" "HTTP : $HTTPINFO" 
mkdir $CREATEDIR
echo $URL > ${CREATEDIR}/${HTTPINFO}

curl  $URL | pandoc -f html -t asciidoc >  $CREATEDIR/$HTTPINFO.asciidoc

