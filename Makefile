rqtlexper.pdf: rqtlexper.tex rqtlexper.bib fig1.eps fig2.eps
	pdflatex rqtlexper
	bibtex rqtlexper
	pdflatex rqtlexper
	pdflatex rqtlexper

rqtlexper.tex: rqtlexper.Rnw Data/lines_code_detail.txt
	R -e 'library(knitr);knit("rqtlexper.Rnw")'

Data/lines_code_detail.txt: Data/lines_code_by_version.csv Python/countStuff.py
	Python/countStuff.py > Data/lines_code_detail.txt

fig1.eps: R/lodcurve_fig1.R
	cd R;R CMD BATCH lodcurve_fig1.R

fig2.eps: R/colors.R Data/lines_code_by_version.csv R/rqtl_lines_code.R
	cd R;R CMD BATCH rqtl_lines_code.R

Data/lines_code_by_version.csv: Perl/grab_lines_code.pl Data/versions.txt
	cd Perl;grab_lines_code.pl

dropbox: rqtlexper.pdf
	cp rqtlexper.pdf ~/Dropbox/PapersInProgress/

clean:
	rm rqtlexper.aux rqtlexper.out rqtlexper.log *~ */*~

zip: rqtlexper.pdf
	zip broman.zip rqtlexper.pdf rqtlexper.tex fig1.eps fig2.eps rqtlexper.bbl rqtlexper.bib
