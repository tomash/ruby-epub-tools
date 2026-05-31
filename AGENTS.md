# ruby-epub-tools

Multi-repo workspace: `wallabag2epub`, `epubrenamer`, and **`bookformer`** (`repos/bookformer`, `https://github.com/tomash/bookformer`) live alongside this repo under `/agent/repos/`.

## Cursor Cloud specific instructions

### Ruby

No `.tool-versions` in this repo; use the same **Ruby 3.4.9** as `repos/epubrenamer` (mise). From this repo root:

```bash
bundle install
bundle exec ruby renamer.rb /path/to/file.epub
```

### Tests

No automated test suite in-tree. Smoke-test with a local `.epub` file.

### Scope

`rezip.rb` and `mobi.rb` are legacy/experimental per README; `renamer.rb` is the maintained entry point.
