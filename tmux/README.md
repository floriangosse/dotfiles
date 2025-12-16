# tmux Configuration

This directory contains a customized tmux configuration optimized for productivity with Vi-style keybindings and intuitive pane management.

## Features

- **Prefix Key**: Changed from default `Ctrl+b` to `Ctrl+a` for easier access
- **Vi Mode**: Navigate and select text using Vi keybindings
- **Mouse Support**: Full mouse control for panes, windows, and scrolling
- **Smart Pane Splitting**: New panes open in the current working directory
- **Activity Monitoring**: Visual notifications for activity in other windows
- **Custom Status Bar**: Shows current time and date

## Keybindings

**Note for macOS users**: `Alt` refers to the `Option` key on Mac keyboards.

### Prefix Key
The prefix key has been changed to **`Ctrl+a`** (default is `Ctrl+b`).

### Window Management

| Key | Action |
|-----|--------|
| `Ctrl+a` `c` | Create new window (in current path) |
| `Ctrl+a` `Ctrl+x` | Split window horizontally (in current path) |
| `Ctrl+a` `Ctrl+y` | Split window vertically (in current path) |

### Pane Navigation

| Key | Action |
|-----|--------|
| `Alt+h` | Move to left pane |
| `Alt+j` | Move to pane below |
| `Alt+k` | Move to pane above |
| `Alt+l` | Move to right pane |

**Note**: These work **without** the prefix key for quick navigation.

### Copy Mode

| Key | Action |
|-----|--------|
| `Ctrl+a` `Escape` | Enter copy mode |
| `v` | Begin selection (in copy mode) |
| `y` | Copy selection to clipboard (in copy mode) |

The configuration automatically detects your OS:
- **Linux**: Uses `xclip` for clipboard
- **macOS**: Uses `pbcopy` for clipboard

### Configuration

| Key | Action |
|-----|--------|
| `Ctrl+a` `r` | Reload tmux configuration |

## Settings Overview

### Terminal
- **Default Terminal**: `screen-256color` for better color support
- **Escape Time**: Set to 0ms for faster response in Vi mode

### Window Options
- **Auto Rename**: Disabled - window names won't change automatically
- **Monitor Activity**: Enabled - highlights windows with activity
- **Mouse Mode**: Enabled - full mouse support
- **Mode Keys**: Vi-style keybindings

### Status Bar
- **Background**: Dark gray (colour239)
- **Foreground**: Light gray (colour251)
- **Current Window**: Highlighted with inverted colors
- **Right Side**: Shows date and time (`YYYY-MM-DD HH:MM:SS`)
- **Update Interval**: 1 second

## Basic tmux Usage

### Starting tmux
```bash
tmux                    # Start new session
tmux new -s myname     # Start new session with name
tmux a                 # Attach to last session
tmux a -t myname       # Attach to named session
tmux ls                # List all sessions
```

### Session Management
- `Ctrl+a` `d` - Detach from current session
- `Ctrl+a` `$` - Rename current session
- `Ctrl+a` `(` - Switch to previous session
- `Ctrl+a` `)` - Switch to next session

### Window Management (tabs)
- `Ctrl+a` `w` - List windows
- `Ctrl+a` `,` - Rename window
- `Ctrl+a` `n` - Next window
- `Ctrl+a` `p` - Previous window
- `Ctrl+a` `0-9` - Switch to window by number

## Tips

1. **Quick Pane Navigation**: Use `Alt+hjkl` without any prefix for fast pane switching
2. **Current Path**: New windows and panes open in the same directory as the current pane
3. **Copy to System Clipboard**: Enter copy mode, select text with `v`, and copy with `y`
4. **Mouse Support**: Click to select panes, drag to resize, and scroll with mouse wheel
5. **No Repeat Commands**: Repeat time is set to 0, preventing accidental repeated commands

## Requirements

- tmux 2.1 or higher
- For clipboard support:
  - **Linux**: `xclip` package
  - **macOS**: `pbcopy` (included by default)

## Customization

The configuration file is located at [tmux.conf](tmux.conf). Feel free to modify it to suit your needs.

After making changes, reload the configuration with `Ctrl+a` `r`.
