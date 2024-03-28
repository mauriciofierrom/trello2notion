{pkgs ? import <nixpkgs> {}}:
let
  gems = pkgs.bundlerEnv {
    name = "bundle";
    gemdir = ./.;
    ruby = pkgs.ruby_3_2;
  };
in pkgs.mkShell { packages = [ gems gems.wrappedRuby ]; }
