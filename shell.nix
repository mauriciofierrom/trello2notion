{pkgs ? import <nixpkgs> { overlays = [ (import ./overlay.nix) ]; }}:
let
  gems = pkgs.bundlerEnv {
    name = "bundle";
    gemdir = ./.;
    ruby = pkgs.ruby_3_2;
  };
in pkgs.mkShell { packages = [ gems gems.wrappedRuby pkgs.terraform pkgs.google-cloud-sdk-gce]; }
