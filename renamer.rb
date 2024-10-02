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

module Archive
  class Zip
    module Entry
      # Compares the local and the central file records found in _lfr_ and _cfr
      # respectively.  Raises Archive::Zip::EntryError if the comparison fails.
      def self.compare_file_records(lfr, cfr)
        # Exclude the extra fields from the comparison since some implementations,
        # such as InfoZip, are known to have differences in the extra fields used
        # in local file records vs. central file records.
        if lfr.zip_path != cfr.zip_path then
          raise Zip::EntryError, "zip path differs between local and central file records: `#{lfr.zip_path}' != `#{cfr.zip_path}'"
        end
        if lfr.extraction_version != cfr.extraction_version then
          if(cfr.zip_path == "mimetype")
            # known problem for mimetype file, tolerating
          else
            raise Zip::EntryError, "`#{cfr.zip_path}': extraction version differs between local and central file records"
          end
        end
        if lfr.crc32 != cfr.crc32 then
          raise Zip::EntryError, "`#{cfr.zip_path}': CRC32 differs between local and central file records"
        end
        if lfr.compressed_size != cfr.compressed_size then
          raise Zip::EntryError, "`#{cfr.zip_path}': compressed size differs between local and central file records"
        end
        if lfr.uncompressed_size != cfr.uncompressed_size then
          raise Zip::EntryError, "`#{cfr.zip_path}': uncompressed size differs between local and central file records"
        end
        if lfr.general_purpose_flags != cfr.general_purpose_flags then
          raise Zip::EntryError, "`#{cfr.zip_path}': general purpose flag differs between local and central file records"
        end
        if lfr.compression_method != cfr.compression_method then
          raise Zip::EntryError, "`#{cfr.zip_path}': compression method differs between local and central file records"
        end
        if lfr.mtime != cfr.mtime then
          raise Zip::EntryError, "`#{cfr.zip_path}': last modified time differs between local and central file records"
        end
      end
    end
  end
end
class EpubRenamer
  attr_reader :epub_path
  def initialize(epub_path)
    @epub_path = epub_path
  end

  def parse_and_extract_metadata
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
end

# Main execution
renamer = EpubRenamer.new(epub_path)
title_latin1, author_latin1 = renamer.parse_and_extract_metadata
new_title = renamer.rename_epub_file(epub_path, title_latin1, author_latin1)
renamer.rename_associated_file(epub_path, new_title, ".mobi")
renamer.rename_associated_file(epub_path, new_title, ".pdf")
