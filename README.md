# soundklaus.el

Play [SoundCloud](https://soundcloud.com) music in [Emacs](http://www.gnu.org/software/emacs/) via [EMMS](http://www.gnu.org/software/emms).

![](http://imgs.xkcd.com/comics/techno.png)

## Installation

*soundklaus.el* is available on [MELPA](http://melpa.milkbox.net).

You can install `soundklaus.el` with the following command:

<kbd>M-x package-install [RET] soundklaus [RET]</kbd>

## Configuration

This mode requires a working [EMMS](http://www.gnu.org/software/emms) setup for Emacs. Follow the *EMMS* [Quick-Start Guide](http://www.gnu.org/software/emms/quickstart.html) to configure *EMMS*.

## Authentication

You need to authorize *soundklaus.el* to access your SoundCloud account. Your web browser should open Emacs via `emacsclient` for the [OAuth2](http://oauth.net/2) callback URL  `soundklaus://oauth/callback`. On a Linux system you can configure this by adding the following content to the  `~/.local/share/applications/soundklaus.desktop` file in your home directory.

	[Desktop Entry]
	Name=SoundKlaus
	Exec=emacsclient %u
	Icon=emacs-icon
	Type=Application
	Terminal=false
	MimeType=x-scheme-handler/soundklaus;

Now you can start the [OAuth2](http://oauth.net/2) authentication dance with `M-x soundklaus-connect`.

## Usage

When the authentication with *SoundCloud* was successful you can search songs with `M-x soundklaus-tracks` and playlists with `M-x soundklaus-playlists`. In the `*soundklaus*` buffer you can move to the next song with `C-n` or `n`, and to the previous one with `C-p` or `p`. Pressing `RET` plays the current song, and `a` adds the current song at point to the *EMMS* playlist.

## License

Copyright © 2014 r0man

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.
