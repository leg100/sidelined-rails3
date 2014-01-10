sudo apt-get update
apt-get -y install curl git-core
curl https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash

cat > /root/.bash_profile <<-EOF
export RBENV_ROOT="${HOME}/.rbenv"

if [ -d "${RBENV_ROOT}" ]; then
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
fi
EOF
source .bash_profile

rbenv bootstrap-ubuntu-12-04
rbenv install 2.0.0-p247
rbenv rehash
rbenv global 2.0.0-p247

cat > /root/.gemrc <<-EOF
gem: --no-ri --no-rdoc
EOF

gem install bundler
gem install rake -f
rbenv rehash

apt-get install -y htop
echo 'alias ll="ls -altrh"' >> /root/.bash_profile

