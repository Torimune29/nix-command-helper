{
  system,
  pre-commit-hooks,
  ...
}: let
  excludes = ["LICENSE" "CHANGELOG.md"];
in
  pre-commit-hooks.lib."${system}".run {
    src = ./.;
    hooks = {
      # common
      commitizen.enable = true;
      typos.enable = true;
      yamllint.enable = true;
      markdownlint = {
        enable = true;
        excludes = excludes;
      };
      editorconfig-checker = {
        enable = true;
        excludes = excludes;
      };
      mdsh.enable = true;
      # language
      black.enable = true;
      flake8.enable = true;
      hadolint.enable = true;
      shellcheck.enable = true;
      shfmt.enable = true;
      actionlint.enable = true;
      alejandra.enable = true;
    };

    settings = {
      yamllint.relaxed = true;
      markdownlint.config = {
        # check editorconfig instead
        MD007 = false;
        MD013 = false;
        # for mdsh
        MD031 = false;
      };
    };
  }
