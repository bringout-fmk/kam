#include "\dev\fmk\kam\kam.ch"


/*! \fn FinKam()
 *  \brief Centralna funkcija za generisanje kamatnog lista na osnovu podataka iz modula FIN
 */
function FinKam()
*{

cIdKonto:=PadR("2120",7)

O_PRIPR
O_KONTO
O_PARTN

dDatObr:=gDatobr
nDanaLimit:=0
cZatvorene:="D"
nDodDana:=30

qqPartner:=SPACE(100)

Box("#PRENOS RACUNA ZA OBRACUN FIN->KAM",8,65)
	@ m_x+1,m_y+2 SAY "Konto:         " GET cIdKonto valid P_Konto(@cIdKonto)
  	@ m_x+2,m_y+2 SAY "Datum obracuna:" GET dDAtObr
  	@ m_x+3,m_y+2 SAY "Uzeti u obzir samo racune cije je"
	@ m_x+4,m_y+2 SAY "valutiranje starije od (br.dana)" GET nDanalimit pict "9999999"
  	@ m_x+5,m_y+2 SAY "Uzeti u obzir stavke koje su zatvorene? (D/N)" GET cZatvorene pict "@!" valid cZatvorene $ "DN"
  	@ m_x+6,m_y+2 SAY "Ukoliko nije naveden datum valutiranja"
  	@ m_x+7,m_y+2 SAY "na datum dokumenta dodaj (br.dana)    " GET nDodDana pict "99"
  	@ m_x+8,m_y+2 SAY "Partneri" GET qqPartner pict "@!S50"
	
	do while .t.
  		READ
		ESC_BCR
  		aUsl1:=Parsiraj(qqPartner, "IdPartner", "C")
  		if aUsl1<>NIL
			exit
		endif
	enddo
BoxC()

O_PARAMS
private cSection:="1"
private cHistory:=" "
private aHistory:={}

gDatObr:=dDatObr
WPar("do",gDatObr)
select 99
use

FO_SUBAN
if !empty(aUsl1)
	private cFilt1:=aUsl1
 	set filter to &cFilt1
else
 	set filter to
endif

set order to 3
seek gFirma+cIdKonto

do while !eof() .and. idkonto==cIdKonto .and. idfirma=gFirma
	cIdPartner:=idpartner
   	nOsnDug:=0  // osnovni dug
   	do while !eof() .and. idkonto==cIdKonto .and. idpartner==cIdPartner .and. idfirma=gFirma
		cBrdok:=brdok
      		nDug:=0
      		nPot:=0
		dDatPoc:=ctod("")
      		cBrDokskip:="XYZYXYYXXX"
      		do while !eof() .and. idkonto==cIdKonto .and. idpartner==cIdPartner .and. brdok==cBrDok  .and. idfirma=gFirma
			//          if brdok==cBrDokSkip
          		if brdok==cBrDokSkip .or. datdok>dDatObr
             			skip
				loop
          		endif
          		if otvst="9" .and. cZatvorene=="N" 
				// samo otvorene stavke
             			if d_p=="1"
              				nOsnDug+=iznosbhd
             			else
              				nOsnDug-=iznosbhd
             			endif
             			skip
				loop
          		endif
			if d_p=="1"
             			if empty(dDatPoc)
               				if empty(datVal)
                 				//MsgBeep("Partner:"+CIDPARTNER+", RACUN BR"+CBRDOK+" NE sadrzi datum valutiranja !!")
                 				ddatPoc:=datdok+nDodDana
              				else
                				dDatPoc:=datval  
						// datum valutiranja
              				endif
             			endif
             			nDug+=iznosbhd
             			nOsndug+=iznosbhd
          		else
             			if !empty(dDatPoc) 
					// vec je nastalo dugovanje!!
                			dDatPoc:=datdok
             			endif
             			nPot+=iznosbhd
             			nOsndug-=iznosbhd
          		endif
			
			if !empty(dDatPoc)
             			select pripr
             			if ( idpartner + idkonto + brdok == cIdPartner + cIdKonto + cBrDok )
                		// vec postoji prosli dio racuna
				//njega zatvori sa
                		// predhodnim danom
                              		if datod>=dDatPoc // slijedeca promjena na isti datum
                  				replace  osnovica with ;
                           			osnovica+fsuban->(iif(d_p=="1",iznosbhd,-iznosbhd))
						select fsuban
						skip
						loop
                				//elseif (datod>=(dDatPoc-1))  
						//datumod veci od datum do
                				//  delete     
						// moze li se ovo deititi
                				//  go bottom
                				//  select fsuban; skip; loop
						// preskoci
                			else
                  				replace datdo with dDatPoc-1
                			endif
             			endif

             			if ( idpartner + idkonto + brdok <> cIdPartner + cIdKonto + cBrDok) .and. ( dDatObr - nDanalimit < dDatPoc )
                			// onda ne pohranjuj
                			cBrDokSkip:=cBrdok
             			else
               				// sasa: izbacen uslov
					//jer je prebacivao samo racune sa pozitivnim saldom i saldom 0
					//if (nDug-nPot) >= 0
                 			append blank
                 			replace idpartner with cIdPartner
					replace idkonto with cIdKonto
					replace osnovica with nDug-nPot
					replace brdok with cBrdok
					replace datod with dDatPoc
					replace datdo with dDatObr
               				//endif
             			endif
          		endif
			select fsuban
          		skip
      		enddo // cbrdok
	enddo // cidpartner
	select pripr
   	nTTTrec:=recno()
   	seek cIdPartner
   		
	do while !eof() .and. cIdPartner==idpartner
      		replace osndug with nOsndug  // nafiluj osnovni dug
      		skip
   	enddo
   	go nTTTrec
   	select fsuban
enddo // cidkonto

select pripr
set order to tag "1"
go top

//"1","IDPARTNER+BRDOK+dtos(datod)",PRIVPATH+"PRIPR")
// iscistiti stavke koje imaju datod>=datdo

cPBrDok:="XYZXYZSC"
do while !eof()
	skip
	nTrec:=recno()
	skip -1
    	if datod<=datdo .and. cPBrDok==BrDok .and. osndug=0
      		// ako se radi o zadnjoj uplati vec postojeceg racuna
		// ne brisi !
      		skip
		loop
    	endif
    	if datod>=datdo  .or. osndug<=0
      		delete()
    	else
      		cPBrDok:=BrDok
    	endif
    	go nTrec
enddo

go top
closeret

return
*}
