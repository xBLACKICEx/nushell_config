# Nushell Config File
#
# version = "0.102.1"
$env.config.color_config = {
    separator: white
    leading_trailing_space_bg: { attr: n }
    header: green_bold
    empty: blue
    bool: light_cyan
    int: white
    filesize: cyan
    duration: white
    date: purple
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cell-path: white
    row_index: green_bold
    record: white
    list: white
    closure: green_bold
    glob:cyan_bold
    block: white
    hints: dark_gray
    search_result: { bg: red fg: white }
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_external_resolved: light_yellow_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    shape_glob_interpolation: cyan_bold
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_keyword: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
    shape_raw_string: light_purple
    shape_garbage: {
        fg: white
        bg: red
        attr: b
    }
}

$env.config.keybindings = [
    {
        name: fuzzy_history
        modifier: control
        keycode: char_r
        mode: [emacs, vi_normal, vi_insert]
        event: [
          {
            send: ExecuteHostCommand
            cmd: "commandline edit (
              history
                | get command
                | uniq
                | reverse
                | str join (char -i 0)
                | fzf --scheme=history --read0 --layout=reverse --height=40% -q (commandline)
                | decode utf-8
                | str trim
            )"
          }
        ]
      }
      {
        name: fuzzy_filefind
        modifier: control
        keycode: char_t
        mode: [emacs, vi_normal, vi_insert]
        event: [
            {
                send: ExecuteHostCommand
                cmd: "
                        if ((commandline | str trim | str length) == 0) {

                        # if empty, search and use result
                        (fzf --preview 'bat -n --color=always {}' --layout=reverse | decode utf-8 | str trim)

                        } else if (commandline | str ends-with ' ') {

                        # if trailing space, search and append result
                        [
                            (commandline)
                            (fzf --preview 'bat -n --color=always {}' --layout=reverse | decode utf-8 | str trim)
                        ] | str join

                        } else {
                        # otherwise search for last token

                        [
                            (commandline | split words | reverse | skip 1 | reverse | str join ' ') 
                            (fzf
                                --layout=reverse
                                --preview 'bat -n --color=always {}'
                                -q (commandline | split words | last)
                            | decode utf-8 | str trim)
                        ] | str join ' '

                        }
                    "
            }
        ]
    }
    {
        name: change_dir_with_fzf
        modifier: control
        keycode: char_y
        mode: [emacs, vi_normal, vi_insert]
        event: {
          send: ExecuteHostCommand,
          cmd: "zi"
        }
    }
]

source ~/.zoxide.nu
use ~/.cache/starship/init.nu

# Custom completions
# source ( $nu.default-config-dir + "/scripts/custom-completions/git/git-completions.nu" )
source ( $nu.default-config-dir + "/scripts/custom-completions/cargo/cargo-completions.nu" )
source ( $nu.default-config-dir + "/scripts/custom-completions/rustup/rustup-completions.nu" )
source ( $nu.default-config-dir + "/scripts/custom-completions/scoop/scoop-completions.nu" )
source ( $nu.default-config-dir + "/scripts/custom-completions/vscode/vscode-completions.nu" )
source ( $nu.default-config-dir + "/scripts/custom-completions/winget/winget-completions.nu" )

# Custom modules
# source ( $nu.default-config-dir + "/scripts/modules/docker/docker.nu" )

# Theme
use  ( $nu.default-config-dir + /scripts/themes/nu-themes/fishtank.nu )
$env.config = ($env.config | merge {color_config: (fishtank)})

# Aliases
use ( $nu.default-config-dir + "/scripts/aliases/git/git-aliases.nu" ) *
