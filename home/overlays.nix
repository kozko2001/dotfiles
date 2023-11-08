self: super: {
  myollama = super.ollama.overrideAttrs
    (old: rec {
      name = "ollama kzk version ${version}";
      version = "0.1.8";
      sha256 = "new_hash";
      src = super.fetchFromGitHub {
        owner = "jmorganca";
        repo = "ollama";
        rev = "v${version}";
        hash = "sha256-cHkuCRdxHxNGlgPWnUeVPeW/75C0dHEbVQ3sb1uq6xo=";
      };
    });
}

