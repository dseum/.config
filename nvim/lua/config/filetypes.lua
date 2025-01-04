vim.filetype.add({
  extension = {
    mdx = "markdown.mdx",
  },
})
vim.filetype.add({
  extension = {
    dfy = "dafny",
  },
})
vim.filetype.add({
  extension = {
    v = "coq",
  },
})
vim.filetype.add({
  filename = {
    Caddyfile = "caddyfile",
  },
})
vim.filetype.add({
  pattern = {
    [".env.*"] = "sh",
  },
})
