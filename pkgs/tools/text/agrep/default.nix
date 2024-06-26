{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "agrep";
  version = "3.41.5";

  src = fetchFromGitHub {
    owner = "Wikinaut";
    repo = "agrep";
    # This repository has numbered versions, but not Git tags.
    rev = "eef20411d605d9d17ead07a0ade75046f2728e21";
    sha256 = "14addnwspdf2mxpqyrw8b84bb2257y43g5ccy4ipgrr91fmxq2sk";
  };

  # Related: https://github.com/Wikinaut/agrep/pull/11
  prePatch = lib.optionalString (stdenv.hostPlatform.isMusl || stdenv.isDarwin) ''
    sed -i '1i#include <sys/stat.h>' checkfil.c newmgrep.c recursiv.c
  '';
  installPhase = ''
    install -Dm 555 agrep -t "$out/bin"
    install -Dm 444 docs/* -t "$out/doc"
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = with lib; {
    description = "Approximate grep for fast fuzzy string searching";
    mainProgram = "agrep";
    homepage = "https://www.tgries.de/agrep/";
    license = licenses.isc;
    platforms = with platforms; linux ++ darwin;
  };
}
