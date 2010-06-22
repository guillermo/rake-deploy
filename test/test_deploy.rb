require 'rubygems'
require 'test/unit'
require 'rake/deploy/deploy'

# As you see this is a integration test as Net::SSH is not mocked.
# It was easy for me test in real machines.
# If you make a mock for Net::SSH fot this tests cases, please send it to me.
class TestDeployClass < Test::Unit::TestCase
  def setup
    @deploy = Deploy.new
    @deploy.host = 'esther'
    @deploy.user = 'guillermo'
  end
  
  def test_run_one_argument
    assert_equal "wadus", @deploy.run("echo wadus").strip
  end
  
  def test_with_host
    assert_equal "superwadus", @deploy.run("yolanda","echo superwadus").strip
  end
  
  def test_with_host_and_user
    assert_equal "argh", @deploy.run("esther", "sessiondeo","echo argh").strip
  end
  
  def test_with_more_than_one_host
    assert_equal ["argh\n","argh\n"], @deploy.run(["esther","yolanda"], "guillermo","echo argh")
    assert_equal ["toma\n","toma\n"], @deploy.run(["esther","yolanda"], "echo toma")
    @deploy.host = ["esther","yolanda"]
    assert_equal ["mola\n","mola\n"], @deploy.run("echo mola")
  end
end