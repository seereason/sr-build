with (import <nixpkgs> { });
let
  cabalName = "sr-build";
  client =
       haskell.packages.ghcjs86.developPackage
        { root = ./.;
          name = cabalName;
        };
  server =
       haskell.packages.ghc865.developPackage
        { root = ./.;
          name = cabalName;
          modifier = drv: haskell.lib.addBuildDepends drv
            (with haskell.packages.ghc865;
              # add extra ghc libraries here
              [cabal-install]);
        };
  merge = { mk ? stdenv.mkDerivation, client, server}:
      mk
       { name = client.name + "-and-" + server.name;
         buildInputs = [ client.buildInputs server.buildInputs ];
         nativeBuildInputs = [ client.nativeBuildInputs server.nativeBuildInputs ];
       };
  in merge {client=client; server=server; }
