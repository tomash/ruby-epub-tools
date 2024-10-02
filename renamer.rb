#!/usr/bin/env ruby

require "fileutils"
require "epub/parser"
require_relative "ascii_tic"
String.prepend(AsciiTic)

epub_path = ARGV[0]

if(epub_path.nil? || !File.exist?(epub_path) || !File.file?(epub_path))
  abort "need valid path to epub file"
else
  puts "#{epub_path} ..."
end

def parse_and_extract_metadata(epub_path)
  book = EPUB::Parser.parse(epub_path)
  md = book.package.metadata

  title = md.titles[0].content
  title_latin1 = title.to_ascii_brutal.strip
  title_latin1.gsub!("/","-") # no slashes in filename

  author = md.creators[0].content
  author_latin1 = author.to_ascii_brutal.strip
  author_latin1.gsub!("/","-") # no slashes in filename

  abort "...title in metadata empty, aborting." if title_latin1.empty?
  abort "...author in metadata empty, aborting." if author_latin1.empty?

  [title_latin1, author_latin1]
end

def rename_epub_file(epub_path, title_latin1, author_latin1)
  new_title = "#{title_latin1} - #{author_latin1}"
  new_filename = "#{new_title}.epub"
  if File.basename(epub_path) != new_filename
    puts "...renaming to #{new_filename}"
    new_epub_path = File.join(File.dirname(epub_path), new_filename)
    FileUtils.mv(epub_path, new_epub_path)
  else
    puts "...file already named optimally in accordance with metadata"
  end
  new_title
end

def rename_associated_file(epub_path, new_title, extension)
  associated_file_name = File.basename(epub_path, File.extname(epub_path)) + extension
  associated_file_path = File.join(File.dirname(epub_path), associated_file_name)

  if File.exist?(associated_file_path) && File.file?(associated_file_path)
    puts "...found associated #{extension} file"
    if File.basename(associated_file_name) != "#{new_title}#{extension}"
      puts "...renaming associated #{extension} file as well"
      new_file_path = File.join(File.dirname(associated_file_path), "#{new_title}#{extension}")
      FileUtils.mv(associated_file_path, new_file_path)
    end
  end
end

# Main execution
title_latin1, author_latin1 = parse_and_extract_metadata(epub_path)
new_title = rename_epub_file(epub_path, title_latin1, author_latin1)
rename_associated_file(epub_path, new_title, ".mobi")
rename_associated_file(epub_path, new_title, ".pdf")
