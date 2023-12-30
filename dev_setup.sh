echo "Welcome!"
echo "This script will install all the dependencies needed to run the project."
echo "This was designed for Linux (with RVM already installed)"


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

echo "You can use the following commands to run the monolith: web/bin/dev after using docker-compose to start the Postgres container"