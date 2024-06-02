Error:

[[nushell . windows]]

```nu
  × I/O error
   ╭─[entry #33:1:10]
 1 │ http get https://win.rustup.rs
   ·          ──────────┬──────────
   ·                    ╰── Windows stdio in console mode does not support writing non-UTF-8 byte sequences
   ╰────
```

fixed by going to

settings -> time & languages -> language -> administrative language settings

and checking the box for 'Use Unicode UTF-8 for worldwide language support' in region setting


***** UPDATE - non issue

''
---
