self: super: {
  ruby_3_2 = super.ruby_3_2.overrideAttrs (oldAttrs: rec {
    version = "3.2.4";
    src = super.fetchurl {
      url = "https://cache.ruby-lang.org/pub/ruby/3.2/ruby-${version}.tar.gz";
      sha256 = "c72b3c5c30482dca18b0f868c9075f3f47d8168eaf626d4e682ce5b59c858692";
    };
  });
}
