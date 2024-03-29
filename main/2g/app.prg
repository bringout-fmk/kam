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

/*! \fn TKamModNew()
 *  \brief
 */

function TKamModNew()
*{
local oObj

#ifdef CLIP

#else
	oObj:=TKamMod():new()
#endif

oObj:self:=oObj
return oObj
*}


#ifdef CPP
/*! \class TKamMod
 *  \brief KAM aplikacijski modul
 */

class TKamMod: public TAppMod
{
	public:
	*void dummy();
	*void setGVars();
	*void mMenu();
	*void mMenuStandard();
	*void sRegg();
	*void initdb();
	
#endif

#ifndef CPP
#include "class(y).ch"
CREATE CLASS TKamMod INHERIT TAppMod
	EXPORTED:
	method dummy 
	method setGVars
	method mMenu
	method mMenuStandard
	method sRegg
	method initdb
END CLASS
#endif


/*! \fn TKamMod::dummy()
 *  \brief dummy
 */

*void TKamMod::dummy()
*{
method dummy()
return
*}


*void TKamMod::initdb()
*{
method initdb()

::oDatabase:=TDBKamNew()

return nil
*}


/*! \fn *void TKamMod::mMenu()
 *  \brief Osnovni meni KAM modula
 */
*void TKamMod::mMenu()
*{
method mMenu()

private Izbor
private lPodBugom

say_fmk_ver()

goModul:oDataBase:setSigmaBD(IzFmkIni("Svi","SigmaBD","c:"+SLASH+"sigma",EXEPATH))

SETKEY(K_SH_F1,{|| Calc()})
Izbor:=1

O_KS
select ks

TrebaRegistrovati(10)
use

#ifdef PROBA
	KEYBOARD "213"
#endif

@ 1,2 SAY padc(gTS+": "+gNFirma,50,"*")
@ 4,5 SAY ""

::mMenuStandard()

::quit()

return nil
*}


*void TKamMod::mMenuStandard()
*{
method mMenuStandard

private opc:={}
private opcexe:={}

AADD(opc, "1. obracun pojedinacnog dokumenta            ")
AADD(opcexe, {|| Obrac()})
AADD(opc, "2. unos ispravka pripreme")
AADD(opcexe, {|| Unos()})
AADD(opc, "---------------------------------------")
AADD(opcexe, {|| nil})
AADD(opc, "3. prenos fin->kam")
AADD(opcexe, {|| FinKam()})
AADD(opc, "4. kontrola cjelovitosti kamatnih stopa")
AADD(opcexe, {|| KCKStopa()})
AADD(opc, "---------------------------------------")
AADD(opcexe, {|| nil})
AADD(opc, "8. sifrarnici")
AADD(opcexe, {|| Sifre()})
AADD(opc, "9. administracija baze podataka")
AADD(opcexe, {|| goModul:oDataBase:install()})
AADD(opc, "---------------------------------------")
AADD(opcexe, {|| nil})
AADD(opc, "X. parametri")
AADD(opcexe, {|| Pars()})

private Izbor:=1

Menu_SC("gkam",.t.,lPodBugom)

return
*}

*void TKamMod::sRegg()
*{
method sRegg()
sreg("KAM.EXE","KAM")
return
*}



/*! \fn *void TKamMod::setGVars()
 *  \brief opste funkcije KAM modula
 */
*void TKamMod::setGVars()
*{
method setGVars()
O_PARAMS

//::super:setGVars()

SetFmkSGVars()

O_PARAMS
private cSection:="1"
private cHistory:=" "
private aHistory:={}
public gDatObr:=date()
public gFirma:="10"
public gNFirma:=space(20)  // naziv firme
public gNW:="D"  // new vawe
public gDirFin:=""
public gVlZagl:=""
public gKumKam:="N"
public gPdvObr:="N"
Rpar("ff",@gFirma)
Rpar("fn",@gNFirma)
Rpar("nw",@gNW)
Rpar("df",@gDirFin)
RPar("vz",@gVlZagl)
RPar("do",@gDatObr)
RPar("kk",@gKumKam)
RPar("pd",@gPdvObr)

cOdradjeno:="D"
if file(EXEPATH+'scshell.ini')
        //cBrojLok:=R_IniRead ( 'TekucaLokacija','Broj',  "",EXEPATH+'scshell.INI' )
        cOdradjeno:=R_IniRead('ShemePromjena',alltrim(strtran(strtran(cDirPriv,"\","_"),":","_")),  "N" ,EXEPATH+'scshell.INI' )
        R_IniWrite('ShemePromjena',alltrim(strtran(strtran(cDirPriv,"\","_"),":","_")),  "D" ,EXEPATH+'scshell.INI' )
endif
if empty(gDirFin) .OR. cOdradjeno="N"
	gDirFin:=strtran(cDirRad,"KAM","FIN")+"\"
   	WPar("df",gDirfin)
endif

return
*}

