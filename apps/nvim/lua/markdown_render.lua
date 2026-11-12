-- Rendered markdown in place (headings, checkboxes, tables, code blocks).
-- Only markdown buffers; the raw text is still what gets saved.
require("render-markdown").setup({
  file_types = { "markdown" },
})
