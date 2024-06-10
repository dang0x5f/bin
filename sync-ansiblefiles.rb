#!/usr/bin/env ruby

require 'socket'
require 'etc'

$HOME = "/home/" + Etc.getlogin + "/"
$REPO = $HOME + "code/repo/ansible_pull/tasks/files/"

# $TEST_DIR = "/tmp/test_dir/"

paths_hash = []
paths_hash << { ".Xresources"                     => "xresources"         }
paths_hash << { ".xmonad/config.hs"               => "xmonad"             }
paths_hash << { ".xmonad/xmonadctl.hs"            => "xmonadctl"          }
paths_hash << { ".config/picom.conf"              => "picom"              }
paths_hash << { ".shrc"                           => "shrc"               }
paths_hash << { ".vimrc"                          => "vimrc"              }
paths_hash << { ".gitconfig"                      => "gitconfig"          }
paths_hash << { ".vim/after/syntax/c.vim"         => "c.vim"              }
paths_hash << { ".vim/after/ftplugin/vimwiki.vim" => "vimwiki.vim"        }
paths_hash << { ".vim/colors/solarized.vim"       => "solarized.vim"      }
paths_hash << { ".vim/colors/seoul256.vim"        => "seoul256.vim"       }
paths_hash << { ".vim/colors/seoul256-light.vim"  => "seoul256-light.vim" }

if __FILE__ == $0
  paths_hash.each do |path_values|
    path_values.each do |key, value|

      from = $HOME + key
      to   = $REPO + value

      file = File.open(from)
      data = file.read
      file.close

      File.write(to, data)

      puts "From: #{from}"
      puts "  To: #{to}"

    end
  end
end
