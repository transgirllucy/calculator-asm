{
  description = "Simple x86_64 assembly calculator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          default = self.packages.${system}.calculator;
          
          calculator = pkgs.stdenv.mkDerivation {
            pname = "asm-calculator";
            version = "0.1.0";
            
            src = ./.;
            
            nativeBuildInputs = [
              pkgs.nasm
            ];
            
            buildPhase = ''
              mkdir -p $out/bin
              nasm -f elf64 -o calculator.o calculator.asm
              ${pkgs.binutils}/bin/ld calculator.o -o $out/bin/calculator
            '';
            
            installPhase = ''
              chmod +x $out/bin/calculator
            '';
            
            meta = with pkgs.lib; {
              description = "A simple calculator written in x86_64 assembly";
              platforms = [ "x86_64-linux" ];
              mainProgram = "calculator";
            };
          };
        };
        
        apps = {
          default = self.apps.${system}.calculator;
          
          calculator = {
            type = "app";
            program = "${self.packages.${system}.calculator}/bin/calculator";
          };
        };
        
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nasm
            binutils
            gdb # For debugging assembly code
          ];
          
          shellHook = ''
            echo "Assembly calculator development environment"
            echo "Use 'nasm -f elf64 -o calculator.o calculator.asm' to assemble"
            echo "Use 'ld calculator.o -o calculator' to link"
          '';
        };
      }
    );
}
