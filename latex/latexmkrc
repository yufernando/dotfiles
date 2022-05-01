# Latexmk configuration for vimtex to do forward and backward search
$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode --shell-escape %O %S';

# From latexmk documentation: https://mg.readthedocs.io/latexmk.html
$pdf_previewer = 'open -a Skim';
# $pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode';
@generated_exts = (@generated_exts, 'synctex.gz');
