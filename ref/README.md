# User Guide

To easily extend the configs that can be automatically imported/exported do the following:
1. Make a new bash script in the `scripts/` directory with a name that matches the format used by the others - `dev-env-renew-<service-name>`
2. In that script, implement the logic to export the code from this repo into the target location on the system.
3. Make the script executable - `chmod +x scripts/dev-env-renew-<service-name>`
4. Add your configs to the repo in the appropriate location.

Do not use relative paths in your script if you want to be able to update the configs individually. There are environment variables already set for you to use:
- `PATH_DEV_ENV` - The root path of this repo.
