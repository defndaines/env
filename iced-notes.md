# Iced Notes

Personal notes on using [vim-iced](https://github.com/liquidz/vim-iced),
mostly drawn from working through the [vim-iced Advent Calendar
2019](https://qiita.com/advent-calendar/2019/vim-iced).

## Leader Mapped Commands

> NOTE: My leader key is `,`.

`,hh` -> Pull up command palette to look up forgotten commands!


`,ei` -> evaluate inner element

`,ee` -> evaluate inner list

`,et` -> evaluate top list


`K` -> docs

`^x^o` -> autocomplete

`,hc` -> open ClojureDocs documentation

`,hs` -> pop-up source code

`,hS` -> open source in buffer


`,tp` -> Run all tests

`,tn` -> Run namespace's tests

`,tt` -> turn related tests under cursor

`,tr` -> re-run failed tests

`,tl` -> run last test again

`,ts` -> run spec tests, IcedTestSpecCheck


`,rcn` -> clean up namespace

`,ran` -> look up and add a namespace

`,ram` -> add missing namespaces

`,ref` -> extract function under cursor

`,rtf` -> convert to thread-first macro

`,rtl` -> convert to thread-last macro

`,rml` -> move to let  <-- this doesn't seem to be working for me.


`,bs` -> browse spec

## Non-mapped Comands

IcedUseCaseOpen -> pull up "use cases" of a function (like, see how it is used in your own code)
- IcedNextUseCase and IcedPrevUseCase

IcedDefJump -> jump to definition ... like `gf` (but gf isn't working in Clojure for me)
- ^t jumps back, as expected

IcedCycleSrcAndTest -> what I use ,z for right now, but jumps both ways.

IcedBrowseReferences

IcedBrowseVarReferences ... doesn't seem to work as I'd expect

IcedBrowseTestUnderCursor ... likewise, isn't working

IcedTestSpecCheck .. !!!
