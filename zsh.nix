{
  lib,
  pkgs,
  ...
}:
{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      autosuggestion = {
        enable = true;
      };
      initContent =
        let
          zshConfigBefore = lib.mkOrder 550 ''
            zvm_config() {
              ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
              ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
            }
          '';
          zshConfig = lib.mkOrder 1000 ''
            unfunction zvm_config
            fastfetch
            cd(){
            builtin cd "$@" && ls
            }
          '';
        in
        lib.mkMerge [
          zshConfigBefore
          zshConfig
        ];
      plugins = [
        {
          name = "zsh-vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
      history = {
        save = 1000;
      };
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "brackets"
        ];
      };
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        format = lib.concatStrings [
          "[ ](bg:#abf0ff)"
          "$os"
          "[ ](fg:#abf0ff bg:#febbcc)"
          "$directory"
          "[](fg:#febbcc)"
          "$fill"
          "[](fg:#ffd1ff)"
          "[ ](bg:#ffd1ff)"
          "$time"
          "[ ](bg:#ffd1ff)"
          "\n"
          "$character"
        ];
        fill = {
          symbol = " ";
        };
        time = {
          disabled = false;
          time_format = "%R";
          format = "[$time]($style)";
          style = "fg:black bg:#ffd1ff";
        };
        os = {
          style = "fg:black bg:#abf0ff";
          disabled = false;
          symbols = {
            NixOS = " ";
          };
        };
        directory = {
          truncation_length = 2;
          read_only = "󰌾";
          home_symbol = " ~";
          format = "[$path]($style)[$read_only]($read_only_style)[ ]($style)";
          style = "bg:#febbcc fg:black";
        };
        character = {
          success_symbol = "[❯](bold #90ee90)";
          vimcmd_symbol = "[❮](bold #a18cd1)";
        };
      };
    };
    fastfetch = {
      enable = true;
    };
  };
}
