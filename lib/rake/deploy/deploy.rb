class Deploy < OpenStruct
  def initialize
    super
    @ssh_sessions = {}
    self.branch = "master"
    self.rails_env = "production"
    self.shared = %w(/tmp /log /public/system)
    self.user   = `who am i`.split(" ").first
  end
  
  def run(host,command)
    puts "    #{host}$ #{command}"
    @ssh_sessions["#{host}#{user}"] ||= Net::SSH.start(host, user)
    output = @ssh_sessions["#{host}#{user}"].exec!(command)
    puts output.split("\n").map{|l| "    #{host}> #{l}"}.join("\n") if output
    output
  end
  
end
