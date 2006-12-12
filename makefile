liball: 
	make -C dok/1g
	make -C main/2g
	make -C db/1g
	make -C db/2g
	make -C rpt/1g
	make -C sif/1g
	make -C param/1g
	make -C razdb/1g
	make -C 1g exe
	
cleanall:	
	cd dok/1g; make clean
	cd main/2g; make clean
	cd db/1g; make clean
	cd db/2g; make clean
	cd rpt/1g; make clean
	cd sif/1g; make clean
	cd param/1g; make clean
	cd razdb/1g; make clean


kam:	cleanall	liball

