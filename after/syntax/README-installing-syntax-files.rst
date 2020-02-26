##############################################################
Installing Vim Syntax Files under dubs_ftype_mess/after/syntax
##############################################################

To add a Syntax file:

- Add the file to the syntax directory::

    dubs_ftype_mess/after/syntax

- Edit the list of reST syntax highlighters:

  - Find ``rst_syntax_code_list`` in ``dubs_ftype_mess/plugin/dubs_preloads.vim``,
    and have your master ``.vimrc`` source that file before loading system plugs.

- The source file will then be loaded by the logic that wires reST syntax.
  See::

    dubs_ftype_mess/after/ftplugin/rst_dubsvim.vim

