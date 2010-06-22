require 'net/ssh'
require 'ostruct'

class Deploy < OpenStruct
  def initialize
    super
    @ssh_sessions = {}
    self.branch = "master"
    self.rails_env = "production"
    self.shared = %w(/tmp /log /public/system)
    self.user   = `who am i`.split(" ").first
  end
  
  # Run a command in a remote server:
  # run("ls") Run ls in current deploy.host
  # run("my_host.com", "ls") run ls in "my_host.com"
  # run("my_host.com", "guillermo", "ls") run ls in "my_shot.com" as user "guillermo"
  def run(*args)
    case args.size
    when 3
      ssh_host, ssh_user, ssh_command = args 
    when 2
      ssh_host, ssh_command = args
      ssh_user = self.user
    when 1
      ssh_host, ssh_user = self.host, self.user
      ssh_command = args.first
    else
      raise ArgumentError
    end
    return ssh_host.map{|host| run(host, ssh_user, ssh_command)} if ssh_host.is_a? Array
    
    key = "#{ssh_user}@#{ssh_host}"
    puts "    #{key}$ #{ssh_command}"
    @ssh_sessions[key] ||= Net::SSH.start(ssh_host, ssh_user)
    output = @ssh_sessions[key].exec!(ssh_command)
    puts output.split("\n").map{|l| "    #{key}> #{l}"}.join("\n") if output
    output
  end
  
end
