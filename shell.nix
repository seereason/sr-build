with (import <nixpkgs> { });
let
  cabalName = "sr-build";
  server =
       haskell.packages.ghc865.developPackage
        { root = ./.;
          name = cabalName;
          overrides = self: super: { shelly = super.shelly_1_9; };
          modifier = drv: haskell.lib.addBuildDepends drv
            (with haskell.packages.ghc865;
              # add extra ghc libraries here
              [cabal-install]);
        };

  in server
