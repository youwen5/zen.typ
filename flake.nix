{
  description = "zen.typ home manager module";

  outputs =
    { ... }:
    {
      homeManagerModules.default =
        { lib, config, ... }:
        let
          cfg = config.zenTyp;
          semVer = {
            major = 0;
            minor = 5;
            patch = 0;
          };
          generateAllVersions =
            {
              major,
              minor,
              patch,
            }:
            let
              inherit (builtins) toString;
              versionStr = "${toString major}.${toString minor}.${toString patch}";
            in
            if (minor > 1) then
              (generateAllVersions {
                inherit patch major;
                minor = minor - 1;
              })
              ++ [ versionStr ]
            else
              [ versionStr ];

          versions = generateAllVersions semVer;

          generateTypstToml =
            version:
            builtins.toFile "typst.toml-${version}" ''
              [package]
              name = "zen"
              version = "${version}"
              entrypoint = "zen.typ"
              authors = ["Youwen Wu"]
              license = "MIT"
              description = "Blingful Typst template with swag"
            '';
          installPath = ".cache/typst/packages/youwen/zen";
          installPaths = lib.attrsets.mergeAttrsList (
            builtins.map (versionStr: {
              "${installPath}/${versionStr}/zen.typ".source = ./typst/zen.typ;
              "${installPath}/${versionStr}/typst.toml".source = generateTypstToml versionStr;
              "${installPath}/${versionStr}/template/main.typ".source = ./typst/template/main.typ;
            }) versions
          );
        in
        {
          options.zenTyp.enable = lib.mkEnableOption "zen.typ Typst template";
          options.zenTyp.compat = lib.mkEnableOption "inserting a compatibility shim so all documents with same MAJOR version build";

          config = lib.mkIf cfg.enable {
            home.file = installPaths;
          };
        };
    };
}
