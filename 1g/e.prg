#include "\dev\fmk\kam\kam.ch"

#ifndef CPP
EXTERNAL RIGHT,LEFT,FIELDPOS
#endif

#ifdef LIB

/*! \fn Main(cKorisn,cSifra,p3,p4,p5,p6,p7)
 *  \brief
 */

function Main(cKorisn,cSifra,p3,p4,p5,p6,p7)
*{
	MainKam(cKorisn,cSifra,p3,p4,p5,p6,p7)
return
*}

#endif



/*! \fn MainKam(cKorisn,cSifra,p3,p4,p5,p6,p7)
 *  \brief
 */

function MainKam(cKorisn,cSifra,p3,p4,p5,p6,p7)
local oKam

oKam:=TKamModNew()
cModul:="KAM"

PUBLIC goModul

goModul:=oKam
oKam:init(NIL, cModul, D_KAM_VERZIJA, D_KAM_PERIOD , cKorisn, cSifra, p3,p4,p5,p6,p7)

oKam:run()

return 

