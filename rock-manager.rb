class RockManager < Formula
  desc "Rock-Manager: Manage RockNSM deployments from MacOS"
  homepage "https://rocknsm.io/"
  url "https://github.com/rocknsm/rock/archive/rock-2.4.2-1.tar.gz"
  sha256 "e8b28ba22ffcbe2b181fbd4e87e8a158d3f4af4b8c6939fdb08d8eb417e81e8a"
  head "https://github.com/rocknsm/rock.git", :branch => "master"
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
