{ inputs, pkgs, ... }:
let
  unstable_pkgs = import inputs.unstable_pkgs {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
  master_pkgs = import inputs.master_pkgs {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  programs.zed-editor = {
    enable = true;
    package = unstable_pkgs.zed-editor;

    extraPackages = with pkgs; [
      nodejs
      typescript-language-server
      rust-analyzer
      ruff
      nixd
      gopls
      clang-tools
      taplo
      yaml-language-server
      bash-language-server
      vscode-langservers-extracted
      lua-language-server
      tinymist
      marksman
      helm-ls
      dockerfile-language-server
      docker-compose-language-service
      terraform-ls
    ];

    userSettings = {
      vim_mode = true;
      node = {
        path = "${pkgs.nodejs}/bin/node";
        npm_path = "${pkgs.nodejs}/bin/npm";
      };

      languages = {
        TypeScript.language_servers = [
          "typescript-language-server"
          "!vtsls"
          "..."
        ];
        JavaScript.language_servers = [
          "typescript-language-server"
          "!vtsls"
          "..."
        ];
        Rust.language_servers = [
          "rust-analyzer"
          "..."
        ];
        Python.language_servers = [
          "ruff"
          "..."
        ];
        Nix.language_servers = [
          "nixd"
          "..."
        ];
        Go.language_servers = [
          "gopls"
          "..."
        ];
        C.language_servers = [
          "clangd"
          "..."
        ];
        "C++".language_servers = [
          "clangd"
          "..."
        ];
        TOML.language_servers = [
          "taplo"
          "..."
        ];
        YAML.language_servers = [
          "yaml-language-server"
          "..."
        ];
        Bash.language_servers = [
          "bash-language-server"
          "..."
        ];
        JSON.language_servers = [
          "json-language-server"
          "..."
        ];
        HTML.language_servers = [
          "html-language-server"
          "..."
        ];
        CSS.language_servers = [
          "css-language-server"
          "..."
        ];
        Lua.language_servers = [
          "lua-language-server"
          "..."
        ];
        Typst.language_servers = [
          "tinymist"
          "..."
        ];
        Markdown.language_servers = [
          "marksman"
          "..."
        ];
        Dockerfile.language_servers = [
          "dockerfile-language-server"
          "..."
        ];
        "Docker Compose".language_servers = [
          "docker-compose-language-service"
          "..."
        ];
        Terraform.language_servers = [
          "terraform-ls"
          "..."
        ];
        Helm.language_servers = [
          "helm-ls"
          "..."
        ];
      };

      lsp = {
        typescript-language-server.binary = {
          path = "${pkgs.typescript-language-server}/bin/typescript-language-server";
          arguments = [ "--stdio" ];
        };
        rust-analyzer.binary.path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        ruff.binary = {
          path = "${pkgs.ruff}/bin/ruff";
          arguments = [ "server" ];
        };
        nixd.binary.path = "${pkgs.nixd}/bin/nixd";
        gopls.binary.path = "${pkgs.gopls}/bin/gopls";
        clangd.binary.path = "${pkgs.clang-tools}/bin/clangd";
        taplo.binary = {
          path = "${pkgs.taplo}/bin/taplo";
          arguments = [
            "lsp"
            "stdio"
          ];
        };
        yaml-language-server = {
          binary = {
            path = "${pkgs.yaml-language-server}/bin/yaml-language-server";
            arguments = [ "--stdio" ];
          };
          settings.yaml = {
            keyOrdering = false;
            schemas.kubernetes = "k8s/**/*.yaml";
          };
        };
        bash-language-server.binary = {
          path = "${pkgs.bash-language-server}/bin/bash-language-server";
          arguments = [ "start" ];
        };
        json-language-server.binary = {
          path = "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server";
          arguments = [ "--stdio" ];
        };
        html-language-server.binary = {
          path = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
          arguments = [ "--stdio" ];
        };
        css-language-server.binary = {
          path = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
          arguments = [ "--stdio" ];
        };
        lua-language-server.binary.path = "${pkgs.lua-language-server}/bin/lua-language-server";
        tinymist.binary.path = "${pkgs.tinymist}/bin/tinymist";
        marksman.binary = {
          path = "${pkgs.marksman}/bin/marksman";
          arguments = [ "server" ];
        };
        dockerfile-language-server.binary = {
          path = "${pkgs.dockerfile-language-server}/bin/docker-langserver";
          arguments = [ "--stdio" ];
        };
        docker-compose-language-service.binary = {
          path = "${pkgs.docker-compose-language-service}/bin/docker-compose-langserver";
          arguments = [ "--stdio" ];
        };
        terraform-ls.binary = {
          path = "${pkgs.terraform-ls}/bin/terraform-ls";
          arguments = [ "serve" ];
        };
        helm-ls.binary = {
          path = "${pkgs.helm-ls}/bin/helm_ls";
          arguments = [ "serve" ];
        };
      };

      agent_servers.claude-acp = {
        type = "registry";
        env.CLAUDE_CODE_EXECUTABLE = "${master_pkgs.claude-code}/bin/claude";
      };
    };
  };
}
