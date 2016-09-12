RedPasswordGenerator
====================

Synopsis
--------

My exploration of [XKCD's Password Generator][1] via [Red][2].

I really like XKCD's interface, so I've mimicked it in my gui. It's a
work-in-progress as I learn [Red's VID dialect][3].

This project started as a simple script file. It's evolved quite far, but still
has far more evolution to undergo.

Running the generator
---------------------

From the Red Console:

```
    >> do %gui.r
```

opens the GUI. To run the non-gui version from the Red Console:

```
    >> do/args %generate-password.r [ config %config-default.r passwords 3 ]
```

will generate three passwords using the default configuration file.

[1]: https://xkpasswd.net/s/
[2]: http://www.red-lang.org
[3]: http://www.red-lang.org/2016/03/060-red-gui-system.html
