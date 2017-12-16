Dubsacks Vim — Filetype Hacks
=============================

About This Plugin
-----------------

This plugin customizes filetype-specific behavior,
mostly by adding syntax highlighting for non-standard
filetypes.

Installation
------------

Standard Pathogen installation:

.. code-block:: bash

   cd ~/.vim/bundle/
   git clone https://github.com/landonb/dubs_ftype_mess.git

Or, Standard submodule installation:

.. code-block:: bash

   cd ~/.vim/bundle/
   git submodule add https://github.com/landonb/dubs_ftype_mess.git

Online help:

.. code-block:: vim

   :Helptags
   :help dubs-ftype-mess

Key Mappings
------------

Filetype-Specific Commands
^^^^^^^^^^^^^^^^^^^^^^^^^^

reStructured Text
~~~~~~~~~~~~~~~~~

==================================  ==================================  ==============================================================================
Key Mapping                         Description                         Notes
==================================  ==================================  ==============================================================================
\```                                Start hyperlink                     Type three backticks in a row to insert hyperlink boilerplate.
==================================  ==================================  ==============================================================================

Other Features
--------------

- Fix syntax highlighting bug:

  - Sometimes -- especially with the ActionScript syntax
    highlighter -- files look like all-comments or all-text
    (e.g., the text is all pink) because the syntax parser started
    from the top of the window or thereabouts and not from the
    start of the buffer, and it encountered the end of a quote
    or comment but interpreted the ending as a new beginning.

  - The fix is to have the syntax highlighter always parse
    from the start of the file.

- Tell Vim to automatically load ``ftplugin/*.vim`` files
  (by specifying ``filetype plugin on``).

  - By default, Vim doesn't load filetype plugins.

- Enhance comments formatting (auto-indenting) to recognize
  special keywords, like ``NOTE`` and ``FIXME``, and to indent
  specially (so the note or todo comments are columnized).

  - Also set ``formatoptions+=croql`` and customize
    ``indentexpr`` and ``indentkeys``.

  - Applies to the following filetypes:
    Vim, Python, Shell (Bash), SQL, ActionScript, and MXML.

- Fix smartindent's handling of octothorpes in Python files:
  by default, smartindent assumes ``#`` is used just for C-style macros,
  so when you type a pound sign, it removes all whitespace between it
  and the start of the line (effectively removing all indentation).
  For Python files, we want to be able to write comments wherever.

  - Also, for shell files, ``smartindent`` is completely
    disabled, otherwise Vim won't tab your octothorpes.
    E.g., select multiple lines, hit Tab, and pounded lines stay put.

- Miscellaneous features:

  - Recognize ``*.wp`` and ``*.wiki`` files as
    ``filetype=mediawiki`` and ``syntax=mediawiki``.

  - Various Markdown and Textile formatting tweaks.

  - Recognize ``*.nsh`` files as ``nsis`` filetype
    (Nullsoft Scriptable Installer System).

- Changes specific to reStructured Text files:

  - Customize reST filetype ``iskeyword`` so colons are not picked up
    when doing a search for the word under cursor (e.g., if the word
    under the cursor is ``some_word:``, the search should ignore the
    colon and instead just search ``some_word``).

  - Enable ``spell`` checking for reST files, but unset ``spellcapcheck``.

  - Extend ``.rst`` syntax ``.. code-block:: <language>`` mappings to
    recognize additional languages,
    including ActionScript, Bash, HTML, JavaScript, and MXML.

- Includes specialized syntax highlighters for the following languages:

..  - JavaScript
..    (extends Vim's built-in JavaScript syntax file with support
..    for ECMA Script 6-style ```interpolation of ${var}s```)

  - JavaScript (the same as the stock Vim file
    but adds grave accent (`) string recognition,
    as proposed in ECMAScript 6)

  - ActionScript and MXML (Adobe® Flash languages)

  - DTD (Document Type Definition for XML)

  - Mkd (Markdown)

  - Textile (Markup language)

  - Wikipedia

