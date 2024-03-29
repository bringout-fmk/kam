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

function TDbKamNew()
*{
local oObj
oObj:=TDbKam():new()
oObj:self:=oObj
oObj:cName:="KAM"
oObj:lAdmin:=.f.
return oObj
*}

/*! \file fmk/kam/db/2g/db.prg
 *  \brief KAM Database
 *
 * TDbKam Database objekat 
 */


/*! \class TDbKam
 *  \brief Database objekat
 */


#ifdef CPP
class TDbKam: public TDB 
{
     public:
     	TObject self;
	string cName;
	*void dummy();
	*void skloniSezonu(string cSezona, bool finverse, bool fda, bool fnulirati, bool fRS);
	*void install(string cKorisn,string cSifra,variant p3,variant p4,variant p5,variant p6,variant p7);
	*void setgaDBFs();
	*void obaza(int i);
	*void ostalef();
	*void kreiraj(int nArea);
}
#endif

#ifndef CPP
#include "class(y).ch"
CREATE CLASS TDbKam INHERIT TDB

	EXPORTED:
	var    self
	var    cName
	method skloniSezonu
	method install	
	method setgaDBFs	
	method ostalef	
	method obaza	
	method kreiraj	
	method konvZn

END CLASS
#endif


/*! \fn *void TDbKam::dummy()
 */
*void TDbKam::dummy()
*{
method dummy
return
*}


/*! \fn *void TDBKam::skloniSezonu(string cSezona, bool finverse,bool fda,bool fnulirati,bool fRS)
 *  \brief formiraj sezonsku bazu podataka
 *  \param cSezona - 
 *  \param fInverse - .t. iz sezone u radno, .f. iz radnog u sezonu
 *  \param fda - ne znam
 *  \param fnulirati - nulirati tabele
 *  \param fRS - ne znam
 */

*void TDBKam::skloniSezonu(string cSezona, bool fInverse,bool fDa,bool fNulirati,bool fRS)
*{

method skloniSezonu(cSezona, fInverse, fDa, fNulirati, fRS)

save screen to cScr
if fDa==nil
	fDA:=.f.
endif
if fInverse==nil
	fInverse:=.f.
endif
if fNulirati==nil
	fNulirati:=.f.
endif
if fRS==nil
	// mrezna radna stanica , sezona je otvorena
  	fRS:=.f.
endif
if fRS // radna stanica
	aFilesK:={}
  	aFilesS:={}
  	aFilesP:={}
endif

if KLevel<>"0"
	MsgBeep("Nemate pravo na koristenje ove opcije")
endif
cls
if fRS
	// mrezna radna stanica
   	? "Formiranje DBF-ova u privatnom direktoriju, RS ...."
endif
?
if finverse
	? "Prenos iz sezonskih direktorija u radne podatke"
else
 	? "Prenos radnih podataka u sezonske direktorije"
endif

?

fNul:=.f.

Skloni(PRIVPATH,"PARAMS.DBF", cSezona, fInverse, fDa, fNul)
Skloni(PRIVPATH,"KAMPRIPR.DBF",cSezona, fInverse, fDa, fNul)
Skloni(PRIVPATH,"FMK.INI",cSezona,finverse,fda,fnul)

if fRS
	// mrezna radna stanica!!! , baci samo privatne direktorije
 	?
 	?
 	?
 	Beep(4)
 	? "pritisni nesto za nastavak..."
	restore screen from cScr
 	return
endif

// kumulativ datoteke
Skloni(KUMPATH,"KAMAT.DBF", cSezona, fInverse, fDa, fNul)
Skloni(KUMPATH,"FMK.INI",cSezona,finverse,fda,fnul)

if fNulirati
	fNul:=.t.
else
	fNul:=.f.
endif  

// Sif PATH
Skloni(SIFPATH,"KS.DBF",cSezona,finverse,fda,fnul)
Skloni(SIFPATH,"KS2.DBF",cSezona,finverse,fda,fnul)
Skloni(SIFPATH,"PARTN.DBF",cSezona,finverse,fda,fnul)
Skloni(SIFPATH,"KONTO.DBF",cSezona,finverse,fda,fnul)
Skloni(SIFPATH,"FMK.INI",cSezona,finverse,fda,fnul)
?
?
?
Beep(4)
? "pritisni nesto za nastavak..."

restore screen from cScr
return
*}

/*! \fn *void TDbKam::setgaDbfs()
 *  \brief Setuje matricu gaDbfs 
 */
*void TDbKam::setgaDbfs()
*{
method setgaDBFs()

public gaDbfs := {;
{ F_PARAMS ,"PARAMS"  , P_PRIVPATH    },;
{ F_KAMPRIPR  ,"PRIPR"   , P_PRIVPATH    },;
{ F_KAMAT  ,"KAMAT"   , P_KUMPATH     },;
{ F_KS     ,"KS"      , P_SIFPATH     },;
{ F_KS2    ,"KS2"     , P_SIFPATH     };
}

return
*}


/*! \fn *void TDbKam::install(string cKorisn,string cSifra,variant p3,variant p4,variant p5,variant p6,variant p7)
 *  \brief osnovni meni za instalacijske procedure
 */

*void TDbKam::install(string cKorisn,string cSifra,variant p3,variant p4,variant p5,variant p6,variant p7)
*{

method install(cKorisn,cSifra,p3,p4,p5,p6,p7)
	ISC_START(goModul,.f.)
return
*}

/*! \fn *void TDbKam::kreiraj(int nArea)
 *  \brief kreirane baze podataka KAM-a
 */
 
*void TDbKam::kreiraj(int nArea)
*{
method kreiraj(nArea)

if (nArea==nil)
	nArea:=-1
endif

if (nArea<>-1)
	CreSystemDb(nArea)
endif

CreFMKSvi()

// KS.DBF   ***********
aDbf:={}
AADD(aDBf,{ 'ID'                  , 'C' ,   3 ,  0 })
AADD(aDBf,{ 'NAZ'                 , 'C' ,  10 ,  0 })
AADD(aDBf,{ 'DatOD'               , 'D' ,   8 ,  0 })
AADD(aDBf,{ 'DatDo'               , 'D' ,   8 ,  0 })
AADD(aDBf,{ 'StRev'               , 'N' ,   8 ,  4 })
AADD(aDBf,{ 'StKam'               , 'N' ,   8 ,  4 })
AADD(aDBf,{ 'DEN'                 , 'N' ,  15 ,  6 })
AADD(aDBf,{ 'Tip'                 , 'C' ,   1 ,  0 })
AADD(aDBf,{ 'DUZ'                , 'N' ,   4 ,  0 })
if !file(SIFPATH+"KS.DBF")
   DBCREATE2(SIFPATH+'KS.DBF',aDbf)
endif
CREATE_INDEX("ID","id",SIFPATH+"KS") // kamatne stope
CREATE_INDEX("2","dtos(DatOd)",SIFPATH+"KS") // kamatne stope

if !file(SIFPATH+"KS2.DBF")
   DBCREATE2(SIFPATH+'KS2.DBF',aDbf)
endif
CREATE_INDEX("ID","id",SIFPATH+"KS2") // kamatne stope
CREATE_INDEX("2","dtos(DatOd)",SIFPATH+"KS2") // kamatne stope


aDbf:={}
AADD(aDBf,{ 'IDPARTNER'             , 'C' ,  6  ,  0 })
AADD(aDBf,{ 'IDKONTO'             , 'C' ,  7  ,  0 })
AADD(aDBf,{ 'BRDOK'               , 'C' , 10  ,  0 })
AADD(aDBf,{ 'DATOD'               , 'D' ,  8 ,   0 })
AADD(aDBf,{ 'DATDO'               , 'D' ,  8 ,   0 })
AADD(aDBf,{ 'OSNOVICA'            , 'N' , 18 ,   2 })
AADD(aDBf,{ 'OSNDUG'              , 'N' , 18 ,   2 })
AADD(aDBf,{ 'M1'                  , 'C' ,  1 ,   0 })
if !file(PRIVPATH+'PRIPR.dbf')
      DBCREATE2(PRIVPATH+'PRIPR.DBF',aDbf)
endif
CREATE_INDEX("1","IDPARTNER+BRDOK+dtos(datod)",PRIVPATH+"PRIPR")

if !file(KUMPATH+'KAMAT.dbf')
      DBCREATE2(KUMPATH+'KAMAT.DBF',aDbf)
endif
CREATE_INDEX("1","IDPARTNER+BRDOK+dtos(datod)",KUMPATH+"KAMAT")

return
*}



/*! \fn *void TDbKam::obaza(int i)
 *  \brief otvara odgovarajucu tabelu
 *  
 *      
 */

*void TDbKam::obaza(int i)
*{

method obaza(i)

local lIdIDalje
local cDbfName

lIdiDalje:=.f.

if i==F_PARAMS .or. i==F_KAMPRIPR  
	lIdiDalje:=.t.
endif

if i==F_KAMAT .or. i==F_KS .or. i==F_KS2 
	lIdiDalje:=.t.
endif

if lIdiDalje
	cDbfName:=DBFName(i,.t.)
	select(i)
	usex(cDbfName)
else
	use
	return
endif


return
*}

/*! \fn *void TDbKam::ostalef()
 *  \brief Ostalef funkcije (bivsi install modul)
 *  \note  sifra: SIGMAXXX
*/

*void TDbKam::ostalef()
*{
method ostalef()

return
*}

/*! \fn *void TDbKam::konvZn()
 *  \brief koverzija 7->8 baze podataka VIRM-a
 */
 
*void TDbKam::konvZn()
*{
method konvZn() 
local cIz:="7"
local cU:="8"
local aPriv:={}
local aKum:={}
local aSif:={}
local GetList:={}
local cSif:="D"
local cKum:="D"
local cPriv:="D"

if !SigmaSif("KZ      ")
	return
endif

Box(,8,50)
	@ m_x+2, m_y+2 SAY "Trenutni standard (7/8)        " GET cIz   VALID   cIz$"78"  PICT "9"
  	@ m_x+3, m_y+2 SAY "Konvertovati u standard (7/8/A)" GET cU    VALID    cU$"78A" PICT "@!"
  	@ m_x+5, m_y+2 SAY "Konvertovati sifrarnike (D/N)  " GET cSif  VALID  cSif$"DN"  PICT "@!"
  	@ m_x+6, m_y+2 SAY "Konvertovati radne baze (D/N)  " GET cKum  VALID  cKum$"DN"  PICT "@!"
  	@ m_x+7, m_y+2 SAY "Konvertovati priv.baze  (D/N)  " GET cPriv VALID cPriv$"DN"  PICT "@!"
  	read
  	if LastKey()==K_ESC
		BoxC()
		return
	endif
  	if Pitanje(,"Jeste li sigurni da zelite izvrsiti konverziju (D/N)","N")=="N"
    		BoxC()
		return
  	endif
BoxC()

aPriv:= { }
aKum:= { }
aSif:={ F_KS, F_KS2 , F_KAMAT }

if cSif=="N"
	aSif:={}
endif

if cKum=="N"
	aKum:={}
endif

if cPriv=="N"
	aPriv:={}
endif

KZNbaza(aPriv,aKum,aSif,cIz,cU)

return
*}

