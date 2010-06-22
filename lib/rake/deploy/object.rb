class Object
  def deploy
    @@deploy ||= Deploy.new
  end
end