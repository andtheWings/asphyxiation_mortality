files <- list.files(pattern = "^.*\\.Rmd$")

for (f in files) rmarkdown::render(f, output_format = "md_document", output_dir = "markdown_output")
