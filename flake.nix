{
  description = "zen.typ home manager module";

  outputs =
    { self }:
    {
      homeManagerModules.default =
        { lib, config, ... }:
        let
          cfg = config.zenTyp;
        in
        {
          options.zenTyp.enable = lib.mkEnableOption "zen.typ Typst template";

          config = lib.mkIf cfg.enable {
            home.file.".cache/typst/packages/youwen/zen/0.3.0" = {
              recursive = true;
              source = ./typst;
            };
            home.file.".cache/typst/packages/youwen/zen/0.2.0" = {
              recursive = true;
              source = ./typst;
            };
          };
        };
    };
}
