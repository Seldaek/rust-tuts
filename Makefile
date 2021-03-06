# Flags declarations

BASE_DOC_OPTS := --from=markdown+hard_line_breaks --smart
HTML_OPTS = $(BASE_DOC_OPTS) --to=html5 --css=../css/rust.css --section-divs --template=template/template.html
TEX_OPTS = $(BASE_DOC_OPTS) --to=latex --standalone --number-sections --latex-engine=lualatex --template=template/template.tex
EPUB_OPTS = $(BASE_DOC_OPTS) --to=epub
WEB :=
TEX :=

# http://lincolnmullen.com/blog/make-and-pandoc/
# http://stackoverflow.com/a/9934724

WEB += $(patsubst source/%.md,tutorial/%.html,$(wildcard source/*.md))
tutorial/%.html: source/%.md
	pandoc -o $@ $(HTML_OPTS) $<

WEB += tutorial/tutorial.html
tutorial/tutorial.html:  $(wildcard source/ch-*.md)
	pandoc -o $@ $(HTML_OPTS) $^

TEX += tutorial/tutorial.tex
tutorial/tutorial.tex: $(wildcard source/ch-*.md)
	pandoc -o $@ $(TEX_OPTS) $^

TEX += tutorial/tutorial.pdf
tutorial/tutorial.pdf: tutorial/tutorial.tex
	lualatex -output-directory=tutorial $<

# Rules

docs: $(WEB)
docs-tex: $(TEX) clean-tex
docs-all: docs docs-tex

.PHONY: clean
clean:
	rm -f $(WEB) $(TEX) tutorial/*.aux tutorial/*.log tutorial/*.out
clean-tex:
	rm -f tutorial/*.aux tutorial/*.log tutorial/*.out