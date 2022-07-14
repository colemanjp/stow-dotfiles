debug_print("Application: " .. get_application_name())
debug_print("Window: " .. get_window_name());
if (get_application_name() == "KeePassXC") then
  pin_window();
end
-- Gnome settings
if (get_application_name() == "gnome-control-center") then
  pin_window();
end
