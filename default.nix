{ jb55pkgs ? import <jb55pkgs> {}
, nixpkgs ? import <nixpkgs> {}
, stdenv ? nixpkgs.stdenv
, sharefile ? jb55pkgs.sharefile
, maim ? nixpkgs.maim
, libnotify ? nixpkgs.libnotify
, makeWrapper ? nixpkgs.makeWrapper
, lib
}:

let inputs = [ sharefile maim libnotify ];
    buildPaths = sep: fmt:
      "${stdenv.lib.concatStringsSep sep (map fmt inputs)}";
in stdenv.mkDerivation rec {
  pname = "snap";
  version = "1.3";

  src = ./.;

  buildInputs = [ makeWrapper ] ++ inputs;

  installPhase = ''
    mkdir -p $out/bin
    cp snap $out/bin

    wrapProgram "$out/bin/snap" \
      --prefix PATH : "${buildPaths ":" (f: "${f}/bin")}"
  '';

  meta = with lib; {
    description = "quick upload via sharefile";
    homepage = "https://github.com/jb55/snap";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.mit;
  };
}
