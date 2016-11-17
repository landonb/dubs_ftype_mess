##############################################################
Installing Vim Syntax Files under dubs_ftype_mess/after/syntax
##############################################################

2016-11-17: How did I not have a problem with or notice this issue until now?

I guess Pathogen isn't sourcing ``dubs_ftype_mess/after/syntax`` after all --
it's been Dubs all along!

To add a Syntax file:

- Add the file to the syntax directory.

  ``dubs_ftype_mess/after/syntax``

- Edit the list of reST syntax highlighters (I know, round-about!).

  Find ``rst_syntax_code_list`` in ``dubs_all/dubs_preloads.vim``.

- The source file will be loaded the logic that sets up reST syntaxing.

  ``dubs_ftype_mess/after/ftplugin/rst_dubsacks.vim``

