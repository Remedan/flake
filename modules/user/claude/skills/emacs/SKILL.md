---
name: emacs
description: Interact with a running Emacs daemon via emacsclient to evaluate Elisp — inspect state, test changes, and debug configuration live. Use when tweaking an Emacs/Doom config, when asked to "eval", "run in emacs", "check my emacs", reload config, inspect a variable/function/keybinding, or read the *Messages*/*Warnings* buffers. This is a Doom Emacs (GNU Emacs 30) setup whose config is managed by home-manager (~/.config/doom/ files are read-only symlinks; source is in the home-manager repo).
---

# Interacting with Emacs

Emacs runs as a **daemon**. Talk to it by evaluating Elisp with `emacsclient -e`.
The return value is printed as an Elisp s-expression on stdout.

```bash
emacsclient -e '(+ 1 2)'        # => 3
emacsclient -e '(emacs-version)'
```

This is a **Doom Emacs** setup. Personal config:
- `~/.config/doom/init.el`     — enabled Doom modules
- `~/.config/doom/config.el`   — user config
- `~/.config/doom/packages.el` — package declarations

**The config is managed by home-manager.** The files under `~/.config/doom/` are
read-only symlinks into the Nix store — do **not** edit them directly (edits won't
stick and the files aren't writable). The real source lives in the home-manager repo:
- `~/.config/home-manager/modules/user/emacs/doom/{init,config,packages}.el`

To change config: edit the source `.el` files in the repo, then rebuild:
```bash
home-manager switch
```
New files must be `git add`-ed first — the flake ignores untracked files. After the
rebuild updates the symlinks, reload/restart Emacs to pick up the changes (below).

## Core workflow

### Evaluating Elisp
Prefer single-quoting the whole form so the shell leaves it alone. Inside the
form, use double quotes for Elisp strings:

```bash
emacsclient -e '(message "hello from %s" (system-name))'
```

For multi-line or complex Elisp, write a temp file and load it — far less error-prone
than fighting shell quoting:

```bash
cat > /tmp/snippet.el <<'EOF'
(let ((xs '(1 2 3)))
  (apply #'+ xs))
EOF
emacsclient -e '(load "/tmp/snippet.el")'
# or evaluate the file's last value:
emacsclient -e "(with-temp-buffer (insert-file-contents \"/tmp/snippet.el\") (eval (read (concat \"(progn \" (buffer-string) \")\"))))"
```

Note: `emacsclient -e` prints **only the final form's value**. To see intermediate
output, return a value, or push it into `*Messages*` with `(message ...)` and read
that buffer (below).

### Reading buffers (messages, warnings, errors)
Errors during startup or eval land in `*Messages*` and `*Warnings*`. Read them:

```bash
# Tail of *Messages*
emacsclient -e '(with-current-buffer "*Messages*" (buffer-substring-no-properties (max (point-min) (- (point-max) 2000)) (point-max)))'

# *Warnings* (byte-compile / native-comp / startup warnings), if it exists
emacsclient -e '(when (get-buffer "*Warnings*") (with-current-buffer "*Warnings*" (buffer-string)))'
```

The output is a quoted Elisp string with `\n` escapes. To get it readable, pipe
through `printf %b` on just the inner content, or wrap the call:

```bash
emacsclient -e '(princ "ignored")' >/dev/null   # princ goes nowhere useful via -e
```
Simplest: read the raw escaped string, it's usually legible enough. If you need it
unescaped, ask Emacs to write to a file instead:

```bash
emacsclient -e '(with-temp-file "/tmp/messages.txt" (insert-buffer-substring "*Messages*"))' && tail -n 40 /tmp/messages.txt
```

## Inspecting state

```bash
# Variable value
emacsclient -e 'doom-version'
emacsclient -e 'major-mode'                 # in the daemon, usually fundamental-mode

# Is a symbol bound / a function defined?
emacsclient -e '(boundp (quote my-var))'
emacsclient -e '(fboundp (quote my-func))'

# Describe a variable's docstring / a function
emacsclient -e '(documentation (quote save-buffer))'

# What is a key bound to? (in global map)
emacsclient -e '(key-binding (kbd "C-c C-c"))'

# Loaded features
emacsclient -e '(featurep (quote magit))'

# Which file defined a function
emacsclient -e '(symbol-file (quote save-buffer))'

# List buffers
emacsclient -e '(mapcar (function buffer-name) (buffer-list))'
```

## Testing config changes

Because the config files are read-only nix-store symlinks (see above), you can't edit
`~/.config/doom/config.el` and reload it in place. To iterate quickly, test forms
**live in the daemon** first, then persist the working version into the repo source:

```bash
# Try a setting interactively to find the right value
emacsclient -e '(setq some-var 42)'

# Eval a candidate snippet directly (doesn't touch any file)
emacsclient -e '(progn (setq foo 1) (message "foo=%s" foo))'
```

Once you've confirmed a change works, write it into the repo source
(`~/.config/home-manager/modules/user/emacs/doom/config.el`), rebuild, then reload.
Loading the live `~/.config/doom/config.el` symlink only reflects changes *after* a
rebuild has updated it:

```bash
emacsclient -e '(load "~/.config/doom/config.el")'   # only meaningful post-rebuild
```

### Doom-specific
```bash
# Full reload after editing config (equivalent to 'doom/reload' / SPC h r r)
emacsclient -e '(doom/reload)'

# After editing init.el or packages.el, you must sync from a shell, then restart:
#   doom sync
# then restart the daemon (see below). doom/reload alone does NOT install new packages.
```

## Restarting the daemon
`doom/reload` reloads config but cannot pick up new packages or `init.el` module
changes. For those, restart the daemon. The daemon runs as a **systemd user service**
(`services.emacs` in home-manager), so restart it through systemd — not by spawning
`emacs --daemon` by hand. **Ask the user before restarting** — it drops their running
session/buffers.

```bash
doom sync                                   # after init.el / packages.el changes
systemctl --user restart emacs              # restart the daemon service
# verify:
emacsclient -e '(emacs-version)'
```

## Tips & gotchas
- **The user's shell is fish**, not bash. This bites Elisp quoting:
  - An Elisp apostrophe — `'x` (quote) or `#'fn` (function) — contains a `'` that
    **closes the shell's single-quoted string**. fish accepts `\'` inside single
    quotes but bash does not, so don't rely on escaping. Instead, write the Elisp
    with **no apostrophes**: use `(quote x)` for `'x` and `(function fn)` for `#'fn`.
    Example: `(mapcar (function buffer-name) (buffer-list))`.
  - The bash `\047` octal-escape trick does **not** produce a `'` here (it isn't
    expanded inside single quotes in bash or fish) — avoid it entirely.
  - For anything non-trivial, prefer the `<<'EOF'` heredoc + eval pattern above;
    it sidesteps shell quoting completely. Note `(load "file")` returns `t`, not the
    file's value — to get the value, use the
    `(with-temp-buffer (insert-file-contents ...) (eval (read ...) t))` form.
- `emacsclient -e` evaluates in the daemon's context — there's no "current buffer"
  the way an interactive session has. Use `(with-current-buffer "name" ...)` to target one.
- Large return values are printed in full; redirect to a file if noisy.
- A timeout or "can't find socket" error means the daemon isn't running — start it
  with `systemctl --user start emacs` (confirm with the user first).
- Prefer **read-only inspection** when diagnosing. Only mutate state (`setq`,
  `load`, reload, restart) when the user is actively tweaking and expects it.
