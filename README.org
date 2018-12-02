
# clim-input-test

This simple program makes a CLIM frame with a few panes in it. The key
pane to test is a pane with two text-field gadgets in
it. Unfortunately this results in unusable flickering (at least on the
CLX backend). The other two tests show temporary workarounds,
including putting two text-fields in separate panes and using the
:panes argument of make-application-frame to construct the pane. Both
of these work.

Daniel Kochmanski opened an
[Issue](https://github.com/McCLIM/McCLIM/issues/482) about this back
in May 2018 but it is still unfixed as of December 2018.
