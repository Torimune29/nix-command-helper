<!-- markdownlint-disable -->
# Command usage

## check

### description

check files using pre-commit

### example

```bash
check README.md LICENSE
```

## check-all

### description

check all files using pre-commit

### example

```bash
check-all
```

## update-dependencies

### description

Update flake dependencies.
        If update depending flakes, run this.

### example

```bash
update-dependencies
```

## reload-env

### description

Reload flake.
        If reload not flake.nix but .nix, nix-direnv does not reload nix env.
        So run this to reload nix env force.

### example

```bash
reload-env
```

## update-project-template

### description

Update project-template using git.
        It creates branch "template", and you can delete.

### example

```bash
reload-env
```

## pythontest

### description

python test

### example

```bash
pythontest
```


