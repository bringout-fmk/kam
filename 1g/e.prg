/* 
 * This file is part of the bring.out FMK, a free and open source 
 * accounting software suite,
 * Copyright (c) 1996-2011 by bring.out doo Sarajevo.
 * It is licensed to you under the Common Public Attribution License
 * version 1.0, the full text of which (including FMK specific Exhibits)
 * is available in the file LICENSE_CPAL_bring.out_FMK.md located at the 
 * root directory of this source code archive.
 * By using this software, you agree to be bound by its terms.
 */


#include "kam.ch"

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

