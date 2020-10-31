# pandoc-dhall-decoder

This module allows you to decode a `Pandoc` value using any `Text.Pandoc.Readers` function.

You should use newtypes like so:

```
newtype MyDoc = Project Pandoc
  deriving stock (Eq, Show, Generic)

instance D.FromDhall MyDoc where
  autoWith options = fmap MyDoc $ pandocDecoder readMarkdown def options
```
