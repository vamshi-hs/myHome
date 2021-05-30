{ dmenu,pkgs, ... }:
let dmenu = pkgs.dmenu.override( { patches = [./dmenu-patches/solarized-dark.diff
                                              ./dmenu-patches/grid.diff
                                              ./dmenu-patches/gridnav.diff
                                              ./dmenu-patches/instant.diff
                                              # ./dmenu-patches/lineheight.diff
                                              ./dmenu-patches/mouseSupport.diff
                                              # ./dmenu-patches/noSort.diff
                                              ./dmenu-patches/dynamicdmenu.diff
                                              # ./dmenu-patches/morecolor.diff
                                              ./dmenu-patches/withflagc.diff
                                              # ./dmenu-patches/xyw.diff
                                              # ./dmenu-patches/border.diff
                                                ]; } );
in { home-manager.users.vamshi.home.packages = [ dmenu ]; }

