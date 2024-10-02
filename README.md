# ruby-epub-tools
Tools for simple manipulations of epub files.

Main one is `renamer.rb` which renames epub files based on metadata in the book. And also renames other files associated with the epub file (like .mobi and .pdf), if they are found in the same directory with the same base name.

Rationale: Amazon's tools for adding a new epub to one's library, either via send-to-kindle email or through the mobile app (share-to), don't properly read title and author from metadata. This renamer is a way to mitigate that.

`mobi.rb` is an experiment to make a similar renamer for mobi files. Should not be needed.

`rezip` is for rezipping epubs from one of polish epub providers. They tend to zip the files in a way that makes them incompatible with Archive::Zip used by `epub-parser` that's in turn used by `renamer.rb`. I'll look later if I can make Archive::Zip work with those zip files, but for now this simple script works.
