{ ... }:
{
  programs.git.settings = {
    commit.gpgsign = true;
    gpg.format = "ssh";
    user = {
      signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID3ETWWGQPgH2cNSFvdyo6/kA9Xni/cebIEz8mXqqzYD";
      email = "riley.mclain@watts.ai";
      name = "riley.mclain";
    };

    credential.gpgEncryptionKey = "7D8490DACBD93D7F15B808EA3E3DB6CA7E43CF7E";
  };
}
