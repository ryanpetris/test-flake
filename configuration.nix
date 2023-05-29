# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, petrisnix, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Phoenix";
  virtualisation.vmware.guest.enable = true;

  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
      efiSysMountPoint = "/boot/efi";
    };

    grub = {
      enable = true;
      device = "nodev";
      efiInstallAsRemovable = true;
      efiSupport = true;
    };
  };

  users = {
    defaultUserShell = pkgs.zsh;

    users = {
      petris = {
        isNormalUser = true;
        uid = 1000;
        name = "petris";
        group = "petris";
        description = "Ryan Petris";
        extraGroups = [ "wheel" ];
      };
    };

    groups = {
      petris = {
        gid = 1000;
        name = "petris";
      };
    };
  };

  networking = {
    firewall.enable = false;
    hostName = "petris-dev";
  };

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      modules = (with pkgs.xorg; [
        xf86videovmware
      ]);
    };

    udev.packages = (with pkgs.gnome; [
      gnome-settings-daemon
    ]);
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      interactiveShellInit = ''
        source ${pkgs.grml-zsh-config}/etc/zsh/zshrc

        export SAVEHIST=0
        export DIRSTACKSIZE=0
        export EDITOR=nano
      '';

     promptInit = "";
    };
  };

  environment.systemPackages = (with pkgs; [
    firefox
    git
    gnupg
    iptables
    nftables
    remmina
    (vscode-with-extensions.override {
      vscodeExtensions = (with vscode-extensions; [
        bbenoist.nix
      ]);
    })
  ]) ++ (with pkgs.gnome; [
    adwaita-icon-theme
    gnome-terminal
    gnome-tweaks
  ]) ++ (with pkgs.gnomeExtensions; [
    appindicator
  ]);

  system.stateVersion = "22.11";
}
