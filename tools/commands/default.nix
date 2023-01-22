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
    name = "update-dependencies";
    script = ''
      nix flake update --verbose
    '';
    description = ''      Update flake dependencies.
              If update depending flakes, run this.'';
    example = "update-dependencies";
  })
  (command {
    name = "reload-env";
    script = ''
      touch $(git rev-parse --show-toplevel)/flake.nix
    '';
    description = ''      Reload flake.
              If reload not flake.nix but .nix, nix-direnv does not reload nix env.
              So run this to reload nix env force.'';
    example = "reload-env";
  })
  (command {
    name = "update-project-template";
    script = ''
      git remote add template http://github.com/Torimune29/project-template
      git fetch --all
      git merge template/main --allow-unrelated-histories
    '';
    description = ''      Update project-template using git.
              It creates branch "template", and you can delete.'';
    example = "reload-env";
  })
  (pythonCommand {
    command = {
      name = "pythontest";
      script = builtins.readFile ./python/pythontest.py;
      description = "python test";
      example = "pythontest";
    };
    libraries = with pkgs.python3Packages; [pyyaml];
  })
]
