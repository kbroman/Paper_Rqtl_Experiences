rqtlexper.pdf: rqtlexper.tex rqtl_lines_code.pdf
	pdflatex rqtlexper
	pdflatex rqtlexper

rqtl_lines_code.pdf: R/colors.R Data/lines_code_by_version.csv R/rqtl_lines_code.R
	cd R;R CMD BATCH rqtl_lines_code.R

Data/lines_code_by_version.csv: Perl/grab_lines_code.pl Data/versions.txt
	cd Perl;grab_lines_code.pl

clean:
	rm rqtlexper.aux rqtlexper.out rqtlexper.log *~ */*~
