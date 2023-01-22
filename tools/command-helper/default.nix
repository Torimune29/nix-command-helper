{
  pkgs,
  commands,
  shell ? "mkShellNoCC",
  shellHook ? "",
  nativeBuildInputs ? [],
  ...
}: let
  descriptionDefaultText = "(No description.)";
  exampleDefaultText = "(No example.)";
  # generate help
  usage = pkgs.lib.concatStrings (
    pkgs.lib.forEach commands (command: ''
      ${builtins.toString command.name}
          description:
              ${
        if command.description == ""
        then descriptionDefaultText
        else builtins.toString command.description
      }
          example:
              ''$ ${
        if command.example == ""
        then exampleDefaultText
        else builtins.toString command.example
      }
    '')
  );
  help = pkgs.writeShellScriptBin "help-commands" ''
    set -euo pipefail
    cat <<EOF
    ${usage}
    EOF
  '';

  # for check command examples validation
  examples = pkgs.lib.concatStrings (
    pkgs.lib.forEach commands (command:
      pkgs.lib.optionalString
      (command.example != exampleDefaultText)
      (builtins.toString command.example + "\n"))
  );
  testExamples = pkgs.writeShellScriptBin "test-command-examples" ''
    set -euo pipefail
    ${examples}
  '';

  # generate usage markdown
  usageMarkdown =
    ''
      <!-- markdownlint-disable -->
      # Command usage

    ''
    + pkgs.lib.concatStrings (
      pkgs.lib.forEach commands (
        command: ''
          ## ${builtins.toString command.name}

          ### description

          ${
            if command.description == ""
            then descriptionDefaultText
            else builtins.toString command.description
          }

          ### example

          \`\`\`bash
          ${
            if command.example == ""
            then exampleDefaultText
            else builtins.toString command.example
          }
          \`\`\`

        ''
      )
    );
  generateDocument = pkgs.writeShellScriptBin "generate-document" ''
    set -euo pipefail
    cat <<EOF
    ${usageMarkdown}
    EOF
  '';

  # for passing to devShells
  derivations = pkgs.lib.forEach commands (command: command.package);
in
  pkgs."${shell}" {
    shellHook = shellHook;
    nativeBuildInputs =
      nativeBuildInputs
      ++ derivations
      ++ [help testExamples generateDocument]
      # ++ [
      #   clang
      # ]
      ;
  }
