class RockManager < Formula
  desc "Rock-Manager: Manage RockNSM deployments from MacOS"
  homepage "https://rocknsm.io/"
  url "https://github.com/rocknsm/rock/archive/rock-2.3.0-1.tar.gz"
  sha256 "0509e1932ada8193e27ed3945320124346b1030af30cdcf61d30f5c97fda60a1"
  head "https://github.com/rocknsm/rock.git", :branch => "devel"
  depends_on "ansible"
  depends_on "gnu-getopt"

  def install
    inreplace "bin/rock" do |s|
      s.gsub! "/etc/rocknsm", etc
      s.gsub! "/usr/share/rock", share
      s.gsub! "getopt", "$(brew --prefix gnu-getopt)/bin/getopt"
    end
    inreplace ["playbooks/auth-mgmt.yml", "playbooks/deploy-rock.yml", "playbooks/generate-defaults.yml", "playbooks/manage-services.yml", "playbooks/delete-data.yml"] do |s|
      s.gsub! "/etc/rocknsm", etc
    end
    inreplace "playbooks/generate-defaults.yml" do |s|
      s.gsub! "localhost", "localhost\n  become: false"
      s.gsub! "owner:", "#owner:"
      s.gsub! "group:", "#group:"
    end

    bin.install "bin/rock"
    etc.install "etc/hosts.ini"
    share.install Dir["playbooks/"]
    share.install Dir["roles/"]

  end

  test do
    system "rock", "help"
    system "rock", "genconfig"
  end
end
