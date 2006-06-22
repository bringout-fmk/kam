VERZIJA=CDX
MODUL=KAM

PRGS=e.prg
EXE_PRGS=e.prg
CS=
ASMS=

FMK_LIBS=fmk_roba.lib fmk_svi.lib fmk_pi.lib fmk_evn.lib fmk_sec.lib fmk_rab.lib fmk_lok.lib

SCLIB_LIBS=sc1g_arh.lib sc1g_ba.lib sc1g_cui.lib sc1g_db.lib sc1g_os.lib sc1g_ost.lib sc1g_par.lib sc1g_pr.lib sc1g_sif.lib sc1g_sql.lib sc1g_ut.lib sc2g_app.lib sc2g_db.lib sc1g_rpt.lib sc2g_cui.lib sc1g_key.lib 

MODUL_LIBS=km_1db.lib km_2db.lib km_1dok.lib km_1ma.lib km_2ma.lib km_1par.lib km_1rpt.lib km_1sif.lib km_1raz.lib 

include $(SC_BUILD_HOME_DIR)/sclib/Makefile_clipper

LIBEXE:=@echo pokrenute make exe  !
CPLIB:=@echo pokrenuti make exe !
RMLIB:=@echo pokrenuti make exe !
e.obj : $(SC_BUILD_HOME_DIR)/sclib/sc.ch $(SC_BUILD_HOME_DIR)/sclib/std_cdx.ch ../kam.ch


lib: exe
