#!/usr/bin/env ruby

dry_run = false

require "fileutils"
require "mobi"
require_relative "ascii_tic"
String.prepend(AsciiTic)

mobi_path = ARGV[0]

if(mobi_path.nil? || !File.exist?(mobi_path) || !File.file?(mobi_path))
  abort "need valid path to mobi file"
else
  puts "#{mobi_path} ..."
end

# 1. parse and extract metadata
md = Mobi.metadata(File.open(mobi_path))

title = md.title.force_encoding("utf-8")
title_latin1 = title.to_ascii_brutal.strip

author = md.author.force_encoding("utf-8")
author_latin1 = author.to_ascii_brutal.strip


if(title_latin1.empty?)
  abort "...title in metadata empty, aborting."
end
if(author_latin1.empty?)
  abort "...author in metadata empty, aborting."
end

# 2. rename the file
new_title = "#{title_latin1} - #{author_latin1}"
new_filename = "#{new_title}.mobi"
if(File.basename(mobi_path) != new_filename)
  puts "...renaming to #{new_filename}"
  new_mobi_path = File.join(File.dirname(mobi_path), "#{new_title}.mobi")
  FileUtils.mv(mobi_path, new_mobi_path) unless dry_run
else
  puts "...file already named optimally in accordance with metadata"
end
