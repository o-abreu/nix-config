{ pkgs, ... }: {
  # Core PipeWire audio stack (keeping your working foundation, plus WirePlumber and 32-bit ALSA)
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # INFO: Lets PipeWire/PulseAudio grab realtime Linux scheduling priority (less audio stutter/latency) by default set to false. PipeWire strongly recommends it.
  security.rtkit.enable = true;

  # Bluetooth support (replacing GNOME's built-in stack)
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Essential audio and media management utilities
  environment.systemPackages = with pkgs; [
    pavucontrol # GUI volume control mixer
    pamixer # CLI volume control (great for keybinds)
    playerctl # Media player control for keyboards
  ];
}
