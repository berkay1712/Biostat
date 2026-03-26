library(officer)
doc     <- read_docx("c:/Users/berka/OneDrive/Skrivebord/Biostat/Exam/Eksamensbesvarelse.docx")
content <- docx_summary(doc)
txt     <- content[content$content_type == "paragraph", "text"]
writeLines(as.character(txt), "c:/Users/berka/OneDrive/Skrivebord/Biostat/Exam/medstuderendes.txt")
cat("Done. Lines:", length(txt), "\n")
