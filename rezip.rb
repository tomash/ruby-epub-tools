#!/usr/bin/env ruby

require "fileutils"
require_relative "ascii_tic"
String.prepend(AsciiTic)

epub_path = ARGV[0]

if(epub_path.nil? || !File.exist?(epub_path) || !File.file?(epub_path))
  abort "need valid path to epub file"
else
  puts "#{epub_path} ..."
end

dirname = File.dirname(epub_path)
filename = File.basename(epub_path)
basename = File.basename(epub_path, ".epub")

puts "rezipping #{filename}..."

Dir.chdir(dirname) do
  system("unzip -q \"./#{filename}\" -d \"#{basename}\"")
  system("mv \"#{filename}\" \"#{filename}.bak\"")
  Dir.chdir(basename) do
    system("zip -q -r \"../#{filename}\" .")
  end
  system("rm -rf \"#{basename}\"")
end

puts "... complete! #{filename} should be good now. BAK file created."
