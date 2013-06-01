require 'spec_helper'

describe "Basic" do
  it "parses grep results into a different representation" do
    write_file 'grep_results', <<-EOF
      autoload/writable_search/proxy.vim-26-" to adjust next proxies.
      autoload/writable_search/proxy.vim:27:function! writable_search#proxy#UpdateSource(new_lines, adjustment) dict
      autoload/writable_search/proxy.vim-28-  let new_lines = a:new_lines
      --
      autoload/writable_search/parser.vim:1:function! writable_search#parser#Run()
      autoload/writable_search/parser.vim-2-  let grouped_lines = s:PartitionLines(getbufline('%', 1, '$'))
      --
      autoload/writable_search/parser.vim-25-  for lines in a:grouped_lines
      autoload/writable_search/parser.vim:26:    let current_proxy          = writable_search#proxy#New(bufnr('%'))
      autoload/writable_search/parser.vim-27-    let current_proxy.filename = s:FindFilename(lines)
    EOF

    vim.edit 'grep_results'
    vim.command 'WritableSearch'
    vim.echo(%<join(getbufline('%', 1, '$'), "\n")>).should eq normalize_string_indent(<<-EOF)
      autoload/writable_search/proxy.vim:26-28
       " to adjust next proxies.
       function! writable_search#proxy#UpdateSource(new_lines, adjustment) dict
         let new_lines = a:new_lines
      autoload/writable_search/parser.vim:1-2
       function! writable_search#parser#Run()
         let grouped_lines = s:PartitionLines(getbufline('%', 1, '$'))
      autoload/writable_search/parser.vim:25-27
         for lines in a:grouped_lines
           let current_proxy          = writable_search#proxy#New(bufnr('%'))
           let current_proxy.filename = s:FindFilename(lines)
    EOF
  end
end
