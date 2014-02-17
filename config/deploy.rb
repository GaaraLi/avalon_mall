require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'

set :user, 'deployer'
set :domain, ENV['on'] == 'prod' ? '112.124.35.188' : '112.124.17.207'
set :deploy_to, '/var/www/m'
set :repository, 'git@github.com:GaaraLi/avalon_mall.git'
set :term_mode, nil
set :shared_paths, ['log', 'pids', 'config/database.yml', 'public/uploads']
set :term_mode, nil
set :ruby_version, '2.0.0-p247'
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"
set :JAVA_HOME, "/usr/local/java/jdk1.7.0_51" 
#set :default_environment, 'JAVA_HOME' => "/usr/lib/jvm/java-6-openjdk-amd64"
task :provision do 
  invoke :'nginx:add_repo'
  #install local dependencies
  queue  "sudo yum install -y git gcc gcc-c++* make openssl-devel mysql-devel curl-devel nginx sendmail sendmail-cf ImageMagick" #need to run as root or add the users into sudoers

  #install rbenv
  queue  "source ~/.bash_profile"
  queue  "#{exists('rbenv')} || git clone https://github.com/sstephenson/rbenv.git ~/.rbenv"
  queue  "#{exists('rbenv')} || git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build"
  queue  "#{exists('rbenv')} || echo 'export PATH=\"$HOME/.rbenv/bin:$PATH\"' >> ~/.bash_profile && source ~/.bash_profile"

  #install ruby
  queue  "#{ruby_exists} || RUBY_CONFIGURE_OPTS=--with-openssl-dir=/usr/bin rbenv install #{ruby_version}"

  #install bundle
  queue  "#{ruby_exists} || rbenv local 2.0.0-p247"
  queue  "#{exists('gem')} || gem install bundle --no-ri --no-rdoc"

  #set up deploy to
  queue "sudo mkdir -p #{deploy_to}"
  queue "sudo chown -R #{user} #{deploy_to}"

  invoke :setup
  invoke :setup_shared

end

desc "Deploys the current version to the server."
task :deploy, [:branch] => :environment do |t, args|
  set :branch, args[:branch] ? args[:branch] : 'master'
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'setup_config'
  end
  #invoke :'rake[kindeditor:assets]'
end

%w{start stop}.each do |command|
  desc "#{command} unicorn"
  task command => :environment do
    queue! "/etc/init.d/unicorn_avalon_mall.sh #{command}"
  end
end

desc "restart smoothly"
task :restart do
  queue! "if [ -f #{unicorn_pid} ]; then kill -s USR2 `cat #{unicorn_pid}`; fi"
end

#==============================================================================================#
desc "Setup unicorn and nginx config"
task :setup_config do
  queue! "#{file_exists('/etc/nginx/nginx.conf.save')} || sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.save"

  queue! "#{file_exists('/etc/nginx/nginx.conf')} || sudo ln -nfs #{deploy_to}/current/config/nginx.conf /etc/nginx/nginx.conf"

  queue! "#{file_exists('/etc/init.d/unicorn_avalon.sh')} || sudo ln -nfs #{deploy_to}/current/scripts/unicorn.sh /etc/init.d/unicorn_avalon.sh"
end

desc "Setup shared staff"
task :setup_shared do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/pids"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/uploads"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/uploads"]


database_yml_content = <<-eos
production:
  adapter: mysql2
  database: avalon
  host: localhost
  username: root
  password:
eos

  unless File.exists? "#{deploy_to}/shared/config/database.yml"
    queue! %[touch "#{deploy_to}/shared/config/database.yml"]
    queue! %[echo "#{database_yml_content}" > "#{deploy_to}/shared/config/database.yml"]
    queue  %[echo "=====> Be sure to edit '#{deploy_to}/shared/config/database.yml'."]
  end
end

namespace :nginx do
  task :add_repo do
    nginx_repo_content = <<-EOS
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/\\$releasever/\\$basearch/
gpgcheck=0
enabled=1
EOS
    repo_path = "/etc/yum.repos.d/nginx.repo"
    queue "sudo touch #{repo_path}"
    queue "echo \"#{nginx_repo_content}\" | sudo tee /etc/yum.repos.d/nginx.repo > /dev/null"
  end
end

task :environment do
  invoke :'rbenv:load'
end

namespace :mail do
  desc "config sendmail"
  task :config do
    puts "editing /etc/mail/sendmail.mc with following detail"
    puts "DAEMON_OPTIONS(`Port=smtp,Addr=127.0.0.1, Name=MTA')dnl"
    puts "LOCAL_DOMAIN(`ixiangche.com')dnl"
    puts "editing /etc/hosts and a trailing dot to hostname, as sendmail requires a FQDN"
    puts "start send mail server with `service sendmail start`"
  end
end

def ruby_exists
    "rbenv versions | grep #{ruby_version} >/dev/null 2>&1"
end

def exists cmd
  "command -v #{cmd}>/dev/null 2>&1"
end

def file_exists file_path
  "[ -e #{file_path} ]"
end
