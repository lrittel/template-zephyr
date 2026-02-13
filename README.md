# My Template for Zephyr projects

This repository contains the template that I am using for embedded firmware
projects using the [Zephyr RTOS](zephyrproject.org).

[copier](https://copier.readthedocs.io/en/stable/) is used to derive projects
from the template and to update projects after changes to this template.


## Usage
### Using copier directly
#### Dependencies

- [copier](https://copier.readthedocs.io/en/stable/), tested with ≥9.11.0
- [west](https://docs.zephyrproject.org/latest/develop/west/index.html#west)
- [Just](https://just.systems/)
- [direnv](https://direnv.net/)
- [Nix](https://nix.dev/) (optional)
- [commitizen](https://commitizen-tools.github.io/commitizen/) (optional)
- [pre-commit](https://pre-commit.com/) (optional)


#### Creating a New Project

```bash
# Create a workspace directory.  The project directory will be place inside the
# workspace.
WORKSPACE="/path/to/workspace"
mkdir -p "$WORKSPACE"
cd "$WORKSPACE"

# Generate the application repository in the workspace.
# The application repository will act as the manifest repository.
APPLICATION_PATH="application"
copier copy --trust https://github.com/lrittel/template-zephyr.git "$APPLICATION_PATH"
# Answer the questions and generate the project ..

# Install dependencies and initialize the west workspace.
just setup

# Create an initial commit.
git commit -am "Init"

# Follow the instructions in the generated repository
# ($APPLICATION_PATH/README.md) to set up the development environment.

# Start programming. :)
```


#### Updating an Existing Project

Update an existing project to the newest revision of this template:

1. `cd` into the application directory
2. Run copier `$ copier update --trust .`
3. Update west manifests `$ west update`


### Using Nix

This repository can be executed with `$ nix run`.


#### Dependencies

- [Nix](https://nix.dev/), tested with ≥2.28.3


#### Creating a New Project

Same as above, but replace the copier command with:
`$ nix run github:lrittel/template-zephyr copy --trust https://github.com/lrittel/template-python.git "$APPLICATION_PATH"`


#### Updating an Existing Project

Same as above, but replace the copier command with:
`$ nix run github:lrittel/template-zephyr update --trust .`
