class RockManager < Formula
  desc "Rock-Manager: Manage RockNSM deployments from MacOS"
  homepage "https://rocknsm.io/"
  url "https://github.com/rocknsm/rock/archive/rock-2.3.0-1.tar.gz"
  sha256 "0509e1932ada8193e27ed3945320124346b1030af30cdcf61d30f5c97fda60a1"
  head "https://github.com/rocknsm/rock.git", :branch => "devel"
  depends_on "rocknsm/taps/ansible"
  depends_on "gnu-getopt"

  def install
    inreplace "bin/rock" do |s|
      s.gsub! "/etc/rocknsm", etc
      s.gsub! "/usr/share/rock", share
      s.gsub! "getopt", "$(brew --prefix gnu-getopt)/bin/getopt"
    end
    inreplace "playbooks/group_vars/all.yml", "/etc/rocknsm", etc
    inreplace "playbooks/generate-defaults.yml" do |s|
      s.gsub! "become: true", "become: false"
      s.gsub! "owner:", "#owner:"
      s.gsub! "group:", "#group:"
    end
    inreplace "playbooks/ansible.cfg" do |s|
      s.gsub! "/etc/rocknsm", etc
      s.gsub! "/usr/share/rock", share
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
