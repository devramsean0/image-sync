echo "Welcome!"
echo "This script will install all the dependencies needed to run the project."
echo "This was designed for Linux (with RVM already installed)"

#              #
# Runtime Deps #
#              #

# RVM
echo "Checking if RVM is installed"
if ! command -v rvm &> /dev/null
then
    echo "RVM not installed, installing."
    \curl -sSL https://get.rvm.io | bash -s stable --ruby
    echo "RVM is now installed"
fi

# Node.js
echo "Checking if Node is installed"
if ! command -v node &> /dev/null
then
    echo "Node not installed, installing volta."
    curl https://get.volta.sh | bash
    volta setup
    volta install yarn@latest
    echo "Volta installed"
fi

# Yarn
echo "Checking if Yarn is installed"
if ! command -v yarn &> /dev/null
then
    echo "Yarn not installed, installing yarn via npm"
    npm i -g yarn
    echo "Yarn installed"
fi

#     #
# Web #
#     #

# Install Ruby version
echo "Installing Ruby version..."
RUBY_VERSION=$(cat .ruby-version)
rvm fetch $RUBY_VERSION
rvm install $RUBY_VERSION
echo "Finished installing Ruby version!"

# Install Ruby gems
echo "Installing Ruby gems..."
cd web
gem install foreman
bundle install
echo "Finished installing Ruby gems!"

# Configure database
echo "Configuring database..."
docker compose up -d
bin/rails db:prepare
bin/rails db:migrate
docker compose down
echo "Finished configuring database!"

# Configure environment variables
echo "Configuring environment variables..."
cp .env.example .env
echo "Finished configuring environment variables!, you may want to edit the web/.env file"

#        #
# Mobile #
#        #

cd ../mobile

# Installing Node deps
echo "Installing NPM packages"
yarn install
echo "Finished installing NPM packages"

# Prebuild
echo "Prebuilding Native projects"
yarn expo prebuild
echo "Finished prebuilding"

echo "You can use the following commands to run the monolith: web/bin/dev after using docker-compose to start the Postgres container"