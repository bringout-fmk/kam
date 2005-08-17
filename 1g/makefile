VERZIJA=CDX
MODUL=KAM
MODVER=1.w.0.1.6

PRGS=/dev/fmk/kam/main/1g/e.prg
CS=
ASMS=

include /sclib/Makefile_clipper

FMK_LIBS=fmk_roba.lib fmk_svi.lib fmk_pi.lib fmk_evn.lib fmk_sec.lib fmk_rab.lib

SCLIB_LIBS=sc1g_arh.lib sc1g_ba.lib sc1g_cui.lib sc1g_db.lib sc1g_os.lib sc1g_ost.lib sc1g_par.lib sc1g_pr.lib sc1g_sif.lib sc1g_sql.lib sc1g_ut.lib sc2g_app.lib sc2g_db.lib sc1g_rpt.lib sc2g_cui.lib sc1g_key.lib 

MODUL_LIBS=km_1db.lib km_2db.lib km_1dok.lib km_1ma.lib km_2ma.lib km_1par.lib km_1rpt.lib km_1sif.lib km_1raz.lib 

PREF2=lib $(LIB_DOS_DEST)
FMKLIBCMD=$(addprefix $(PREF2), $(SCLIB_LIBS) $(FMK_LIBS) $(MODUL_LIBS) )


OBJS=$(OBJPRGS) $(OBJCS) $(OBJASMS)

all:    cleaneobj mod 

cleaneobj:
	rm -f /dev/fmk/kam/main/1g/e.obj
	
mod: $(OBJS)
	echo Prilikom kompilacije obj se napravi u tekucem direktoriju
	echo a blinker opet trazi obj fajl u orig direktoriju
	cp e.obj /dev/fmk/kam/main/1g/
	/sclib/form_blinker_lnk.sh $(LINKCMD)
	/sclib/form_blinker_lnk_2.sh $(FMKLIBCMD)
	$(LINKEREXE) @_bl_.lnk BEGINAREA  @_bl_2_.lnk ENDAREA $(DEBUGLINK) @H:\\CLIPPER\\$(VERZIJA)\\BL.LNK output e.exe
	cp e.exe $(EXEDEST)/$(MODUL).EXE

zip:
	/sclib/zip.sh h:\\cs\\fmk\\binary\\$(MODUL).zip ..\\chs\\\*.chs \\dev\\fmk\\svi\\\*.chs  $(EXEDOSDEST)\\$(MODUL).EXE 

commit:
	/sclib/commit.sh $(MODVER) h:\\cs\\fmk\\binary\\$(MODUL).zip

clean:
	rm -f *.obj *.OBJ
	rm -f $(OBJS) I$(MODULH).OBJ *.bak *.BAK




sfx:
	/cygdrive/p/bat/SFXMA.BAT kam
