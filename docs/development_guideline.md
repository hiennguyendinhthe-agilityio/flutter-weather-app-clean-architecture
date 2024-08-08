# Development guideline

## Getting started (Environments - Tools)

### Puro
Puro: Puro is a powerful tool for installing and upgrading Flutter versions (https://puro.dev/)
1. The command line corresponding to the operating system.
   - Mac:
      ```
      curl -o- https://puro.dev/install.sh | PURO_VERSION="1.4.6" bash
      ```
   - Linux:
      ```
      curl -o- https://puro.dev/install.sh | PURO_VERSION="1.4.6" bash
      ```
   - Windows:
      ```
      Invoke-WebRequest -Uri "https://puro.dev/builds/1.4.6/windows-x64/puro.exe" -OutFile "$env:temp\puro.exe"; &"$env:temp\puro.exe" install-puro --promote
      ```

2. Install the package Puro
    ```
    dart pub global activate puro 1.3.1
    ```
    ```
    puro create flutter_training 3.22.3
    ```
    ```
    puro use flutter_training
    ```

### Mono repo with Melos
Melos: 3.1.1
Melos as main CLI tools for mono repo
- Refer: https://melos.invertase.dev/getting-started

```
dart pub global activate melos 3.1.1
```

### Install tools

```
melos run postbootstrap
```
