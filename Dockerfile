# Start from the code-server Debian base image
FROM codercom/code-server:latest 

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json
COPY deploy-container/.bashrc ./.bashrc
# COPY deploy-container/config.yaml .local/share/code-server/config.yaml

# Use zsh shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN sudo apt-get install bash-completion
RUN sudo apt-get install vim
RUN curl https://rclone.org/install.sh | sudo bash

# You can add custom software and dependencies for your environment here. Some examples:
RUN sudo find /home/coder/.local -type d -exec chmod 777 {} \;
RUN code-server --install-extension ms-dotnettools.csharp
RUN code-server --install-extension ms-vscode.cpptools
RUN code-server --install-extension mrmlnc.vscode-apache
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension equinusocio.vsc-material-theme
RUN code-server --install-extension equinusocio.vsc-material-theme-icons
RUN code-server --install-extension TabNine.tabnine-vscode
RUN code-server --install-extension aaron-bond.better-comments
RUN code-server --install-extension coenraads.bracket-pair-colorizer
RUN code-server --install-extension streetsidesoftware.code-spell-checker
RUN code-server --install-extension denoland.vscode-deno
RUN code-server --install-extension ms-azuretools.vscode-docker
RUN code-server --install-extension editorconfig.editorconfig
RUN code-server --install-extension dbaeumer.vscode-eslint
RUN code-server --install-extension mkxml.vscode-filesize
RUN code-server --install-extension eamodio.gitlens
RUN code-server --install-extension ritwickdey.liveserver
RUN code-server --install-extension yzhang.markdown-all-in-one
RUN code-server --install-extension eg2.vscode-npm-script
RUN code-server --install-extension techer.open-in-browser
RUN code-server --install-extension ionutvmi.path-autocomplete
RUN code-server --install-extension christian-kohler.path-intellisense
RUN code-server --install-extension alefragnani.project-manager
RUN code-server --install-extension ms-python.python
RUN code-server --install-extension ikuyadeu.r
RUN code-server --install-extension humao.rest-client
RUN code-server --install-extension rust-lang.rust
RUN code-server --install-extension foxundermoon.shell-format
RUN code-server --install-extension bradlc.vscode-tailwindcss
RUN code-server --install-extension ms-vscode.vscode-typescript-tslint-plugin
RUN code-server --install-extension redhat.vscode-yaml
RUN sudo apt-get install -y build-essential
# RUN COPY myTool /home/coder/myTool

RUN sudo curl -fsSL https://deb.nodesource.com/setup_15.x | sudo bash -
RUN sudo apt-get install -y nodejs

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
