{pkgs, ...}: let
  command = {
    name,
    script,
    description ? "",
    example ? "",
  }: {
    name = "${name}";
    package = pkgs.writeShellScriptBin "${name}" ''
      set -euo pipefail
      echo "> Running \"${name}\" ..."
      ${script}
      echo "✔ Done \"${name}\" !"
    '';
    description = "${description}";
    example = "${example}";
  };

  pythonCommand = {
    command,
    libraries ? [],
  }: {
    name = "${command.name}";
    package = pkgs.writers.writePython3Bin "${command.name}" {
      libraries = libraries;
    } "${command.script}";
    description = "${command.description}";
    example = "${command.example}";
  };
in [
  (command {
    name = "check";
    script = ''
      pre-commit run --files $@
    '';
    description = "check files using pre-commit";
    example = "check README.md LICENSE";
  })
  (command {
    name = "check-all";
    script = ''
      pre-commit run --all-files
    '';
    description = "check all files using pre-commit";
    example = "check-all";
  })
  (command {
    name = "reload-env";
    script = ''
      touch flake.nix
    '';
  })
]
