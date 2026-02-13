[group("test")]
clean-test-projects:
    rm -rf test

[group("test")]
create-test-projects: clean-test-projects
    #!/usr/bin/env bash

    set -eaux

    mkdir -p test

    # All features enabled.
    WORKSPACE="test/all-features"
    APPLICATION="$WORKSPACE/application"
    mkdir -p "$WORKSPACE"
    copier copy . "$APPLICATION" --trust \
        --data description="Tests my template" \
        --data project_name=all-features \
        --data zephyr_board="nucleo_l476rg" \
        --data use_commitizen=true \
        --data use_github_workflow=true \
        --data use_nix_flake=true \
        --data use_pre_commit=true \
        --data use_vscode=true

    # No optional features enabled.
    WORKSPACE="test/minimal-features"
    APPLICATION="$WORKSPACE/application"
    mkdir -p "$WORKSPACE"
    copier copy . "$APPLICATION" --trust \
        --data description="Tests my template" \
        --data project_name=minimal-features \
        --data zephyr_board="nucleo_l476rg" \
        --data use_commitizen=false \
        --data use_github_workflow=false \
        --data use_nix_flake=true \
        --data use_pre_commit=false \
        --data use_vscode=false

    for p in test/* ; do
        echo "+---------------------------------------"
        echo "| Initializing workspace in $p ..."
        echo "+---------------------------------------"
        pushd "$p"
        west init --local "./application"
        popd
        echo "----------------------------------------"
    done

    for p in test/*/application ; do
        echo "+---------------------------------------"
        echo "| Setting up environment in $p ..."
        echo "+---------------------------------------"
        direnv allow "$p"
        just --justfile "$p/Justfile" setup
        echo "----------------------------------------"
    done

[group("test")]
run-test-project-tests:
    #!/usr/bin/env bash

    for p in test/*/application ; do
        echo "+---------------------------------------"
        echo "| Running tests in $p ..."
        echo "+---------------------------------------"
        just --justfile "$p/Justfile" --allow-missing run-tests
        echo "----------------------------------------"
    done

[group("test")]
run-test-project-builds:
    #!/usr/bin/env bash

    for p in test/*/application ; do
        echo "+---------------------------------------"
        echo "| Building app in in $p ..."
        echo "+---------------------------------------"
        just --justfile "$p/Justfile" --allow-missing build-app
        echo "----------------------------------------"
    done

[group("test")]
run-test-project-docs:
    #!/usr/bin/env bash

    for p in test/*/application ; do
        echo "+---------------------------------------"
        echo "| Building documentation in $p ..."
        echo "+---------------------------------------"
        just --justfile "$p/Justfile" --allow-missing build-docs
        echo "----------------------------------------"
    done


[group("test")]
run-all-tests: \
        clean-test-projects \
        create-test-projects \
        run-test-project-tests \
        run-test-project-builds \
        run-test-project-docs
