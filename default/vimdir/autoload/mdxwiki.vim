" TRANSFORM HEADINGS
" transforms H2+ - seems bug free
" omits H1 in markdown, intentionally not parsed
function mdxwiki#transformH2plusHeadings ()
  :g/^## /s:^##:==:|:norm A ==
  :g/^### /s:^###:===:|:norm A ===
  :g/^#### /s:^#####:====:|:norm A ====
endfunction

" TRANSFORM LINKS
" tested, works decently, using s:::c to confirm
function mdxwiki#transformLinks()
  :%s:\v\[([^[]+)\][(]([^)]+)[)]:[[\1>>\2]]:gc
endfunction
