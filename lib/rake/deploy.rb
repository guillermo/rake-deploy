require 'rake/hooks'
require 'rake/deploy/deploy'
require 'rake/deploy/object'

desc 'Deploy the application'
task :deploy => ["deploy:symlink"]

namespace :deploy do 
  
  desc 'Generate timestamp for revision name'
  task :generate_timestamp do
    deploy.release_name ||= Time.now.utc.strftime("%Y%m%d%H%M.%S")
    deploy.release_path ||= "#{deploy.deploy_to}/releases/#{deploy.release_name}"
    deploy.current_path ||= "#{deploy.deploy_to}/current"
  end
  
  desc 'Update remote repo'
  task :update_repo do
    puts "=> update_repo"
    deploy.run("cd #{deploy.deploy_to}/shared/repo && git fetch")
  end
  
  desc 'Checkout newer version'
  task :checkout => [:generate_timestamp,:update_repo] do
    puts "=> checkout"
    deploy.run("mkdir -p #{deploy.deploy_to}/releases/")
    deploy.run("git clone -s #{deploy.deploy_to}/shared/repo #{deploy.release_path} && cd #{deploy.release_path} && git checkout #{deploy.branch}")
    deploy.shared.each do |shared_path|
      deploy.run("rm -rf #{deploy.release_path}#{shared_path}")
      deploy.run("ln -s #{deploy.deploy_to}/shared/scaffold#{shared_path} #{deploy.release_path}#{shared_path}")
    end
  end
  
  desc 'Symlink to new version'
  task :symlink => [:checkout] do
    puts "=> symlink"
    deploy.run("unlink #{deploy.deploy_to}/current")
    deploy.run("ln -s #{deploy.release_path} #{deploy.deploy_to}/current")
  end  

  desc 'Setup' 
  task :setup do
    puts "=> setup"
    %w(/releases /shared/scaffold/tmp /shared/scaffold/log).each do |path|
      deploy.run("mkdir -p #{deploy.deploy_to}#{path}")
    end
    
    deploy.run("ln -s #{deploy.deploy_to}/shared/scaffold/tmp #{deploy.deploy_to}/shared/tmp ")
    deploy.run("ln -s #{deploy.deploy_to}/shared/scaffold/log #{deploy.deploy_to}/shared/log ")
    
    deploy.run("git clone --bare #{deploy.repository} #{deploy.deploy_to}/shared/repo")
  end
  
end
