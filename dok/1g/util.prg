#include "\dev\fmk\kam\kam.ch"

// -----------------------------------
// ctrl-K - generisi mjesecne uplate
// ----------------------------------
function g_mj_uplate()
local nRataIznos
local nDanUplate
local cNaredni

nRataIznos := 313
nDanUplate := 15
cNaredni := "T"

Box(, 3, 70)

@ m_x+1, m_y+2 SAY "Iznos mjesecne rate ?" GET nRataIznos ;
   PICT "99999.99"

@ m_x+2, m_y+2 SAY "Uplata na dan u mjesecu ?"  GET nDanUplate ;
  PICT "99"

@ m_x+3, m_y+2 SAY "Uplata pocinje od tekuceg od ovog (T) ili narednog (N) mjeseca ?"  GET cNaredni  ;
  PICT "@!" ;
  VALID cNaredni $ "TN"
READ
BoxC()

if LASTKEY()==K_ESC
	return 0
endif

fill(nRataIznos, nDanUplate, (cNaredni == "N"))


// ---------------------------------------------------
// ----------------------------------------------------
static function fill(nRataIznos, nDanUplate, lNaredni)

SELECT PRIPR

go TOP


Scatter()
nOsn := _osnovica
nMonth := month(_datOd)
nYear := year(_datOd)

if lNaredni 
	add_month(@nMonth, @nYear)
endif

_datDo := d_m_y(nDanUplate, nMonth, nYear)
Gather()

do while !eof()
   
   APPEND BLANK
   nOsn := nOsn - nRataIznos
   _osnovica := nOsn
   _osndug := nOsn
   _datOd := d_m_y(nDanUplate + 1, nMonth, nYear)
   add_month(@nMonth, @nYear)
   _datDo := d_m_y(nDanUplate, nMonth, nYear)

   Gather()

   // glavnica je potrosena
   if ROUND(nOsn, 2) <= 0
   	exit
   endif

enddo

// ---------------------------------------
// dodaj mjesec
// --------------------------------------
static function add_month(nMonth, nYear)

if nMonth == 12
	nYear ++
	nMonth := 1
else
	nMonth ++
endif

return

// --------------------------------------------
// --------------------------------------------
static function d_m_y(nDay, nMonth, nYear)
local cPom

cPom := ""
cPom += PADL(ALLTRIM(STR(nYear)), 4, "0")
cPom += PADL(ALLTRIM(STR(nMonth)), 2, "0")
cPom += PADL(ALLTRIM(STR(nDay)), 2, "0")

return STOD(cPom)



