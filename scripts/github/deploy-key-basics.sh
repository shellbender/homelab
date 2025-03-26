# Generate a key to apply use
ssh-keygen -t ed25519 -C "boilerplates-public deploy key" -f ~/.ssh/boilerplates-public-deploy-key
# Deploy the public key to target repo
gh repo deploy-key add ~/.ssh/boilerplates-public-deploy-key.pub -w -t "standard deploy key" --repo shellbender/boilerplates-public

# Add the private key to the GitHub actions
gh secret set REPO_PRIVATE_KEY < ~/.ssh/boilerplates-public-deploy-key
gh secret set REPO_PRIVATE_KEY < ~/.ssh/id_ed25519_shellbender_underhill



