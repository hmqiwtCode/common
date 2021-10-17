#!/bin/bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install node
sudo yum upgrade
sudo yum install git -y
cd /home/ec2-user
git clone https://github.com/felixyu9/auto-scaling-nodejs-app
cd auto-scaling-nodejs-app
sudo chmod -R 755 .
npm install
node app.js > app.out.log 2> app.err.log < /dev/null &