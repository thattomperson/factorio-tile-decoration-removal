{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, lib, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [
              "factorio-space-age"
            ];
        };

        devShells.default =  let
          factorio = pkgs.factorio-space-age-experimental.override {
            username = "thattomperson";
            # this token has been revoked
            token = "ba3f83de87674ab17995af5d2af8a5";
          };
          defaultConfig = pkgs.writeTextFile {
            name = "config.ini";
            text = ''
              ; version=11
              ; This is INI file : https://en.wikipedia.org/wiki/INI_file#Format 
              ; Semicolons (;) at the beginning of the line indicate a comment. Comment lines are ignored.
              [path]
              read-data=${factorio}/share/factorio/data/
              write-data=__PATH__system-write-data__

              [general]
              locale=auto

              [other]
              check-updates=false

              [interface]
              pick-ghost-cursor=true
              show-all-items-in-selection-lists=true
              show-parameters-in-selection-lists=true

              show-combinator-settings-when-detailed-info-is-on=true
              train-visualization-length=10

              [sound]
              master-volume=0.28

              [graphics]
              max-texture-size=8192
              full-screen=false
              v-sync=false
              video-memory-usage=high
            '';
          };
          defaultSettings = pkgs.writeTextFile {
            name = "settings.json";
            text = ''
              {
                  "factorio.workspace.library": ".vscode/lib",
                  "Lua.runtime.plugin": ".vscode/lua/plugin.lua",
                  "Lua.diagnostics.globals": [
                      "mods",
                      "table_size",
                      "log",
                      "localised_print",
                      "serpent",
                      "global",
                      "__DebugAdapter",
                      "__Profiler"
                  ],
                  "Lua.runtime.version": "Lua 5.2",
                  "factorio.versions": [
                      {
                          "name": "Local",
                          "factorioPath": "${lib.getExe factorio}",
                          "configPath": "''${workspaceFolder}/.vscode/config.ini",
                          "docsPath": "../../share/factorio/doc-html/runtime-api.json",
                          "active": true
                      }
                  ],
                  "Lua.workspace.library": [
                      "${factorio}/share/factorio/data",
                      "${factorio}/share/factorio/data/base",
                      "''${workspaceFolder}/.vscode/lua/factorio-plugin"
                  ],
                  "Lua.workspace.userThirdParty": [
                      "/home/tom/.config/Code/User/workspaceStorage/e623b9dde400e419f8810c090fa705d2/justarandomgeek.factoriomod-debug/sumneko-3rd"
                  ],
                  "Lua.workspace.checkThirdParty": "ApplyInMemory",
              }
            '';
          };

        in pkgs.mkShell {
          buildInputs = [ factorio ];
          shellHook = ''
            rm ./.vscode/config.ini || true;
            ln -s ${builtins.toString defaultConfig} ./.vscode/config.ini
            rm ./.vscode/settings.json || true;
            cp ${builtins.toString defaultSettings} ./.vscode/settings.json
          '';
        };
      };
    };
}
