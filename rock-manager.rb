# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class RockManager < Formula
  desc "Rock-Manager: Manage RockNSM deployments from MacOS"
  homepage "https://rocknsm.io/"
  head "https://github.com/rocknsm/rock.git", :tag => "rock-2.3.0-1", :release => "0c3511f40a5e4b62ee7d9855edc9e13e197a4a5d"
  depends_on "ansible"


  devel do
    head "https://github.com/rocknsm/rock.git", :branch => "devel"
  end

  def install
    bin.install "bin/rock"
    share.install Dir["playbooks/"]
    share.install Dir["roles/"]
    etc.install "hosts.ini"

    inreplace "bin/rock" do |s|
      s.gsub "/etc/rocknsm", etc
      s.gsub "/usr/share/rock", share
    end
    inreplace ["playbooks/deploy-rock.yml", "playbooks/generate-defaults.yml"] do |s|
      s.gsub "/etc/rocknsm", etc
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test rock-manager`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    head "https://github.com/rocknsm/rock.git", :branch => "devel"

    cmd = "rock help"
    assert_match "Usage: /usr/local/Cellar/rock-manager/0.1/rock", shell_output(cmd)
  end
end
