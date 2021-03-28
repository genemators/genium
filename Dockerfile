# Start from the code-server Debian base image
FROM codercom/code-server:latest 

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use zsh shell
ENV SHELL=/bin/zsh

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# You can add custom software and dependencies for your environment here. Some examples:

RUN find /home/coder/.local -type d -exec chmod 777 {} \;
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension equinusocio.vsc-material-theme
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
