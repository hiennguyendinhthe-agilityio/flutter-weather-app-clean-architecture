# Assets

## Design

- [Agility Design System](https://www.figma.com/file/J3sqhxKqlZP9QuW6jNGNFL/AgilityIO---Design-System-(WIP)?node-id=38%3A411&t=IFuWucErwd0cdVSp-0)
- [Agility Personal Web App](https://www.figma.com/file/JtwUfg14IezCLIqX9wpDTz/Agility-Web-App?node-id=16215%3A5099&t=tJYvmfSJ2kjQGMDl-0)

## Attaches assets (fonts, icons, images, etc)

- Developer attaches assets (fonts, icons, images, etc) from design with prefix
  - icon: `ic_`<icon_name>.png
  - image: `img_`<image_name>.png
- Developer add assets (fonts, icons, images, etc) to project's assets

  ```
  app-mobile
  ├── apps
  │   ├── banking_consumer
  |   │   ├── assets
  |   │   │   ├── fonts
  |   │   │   |   ├── my_font
  |   │   │   ├── images
  |   │   │   |   |   ├── 2.0x
  |   |   │   │   |   |   ├── img_xxx.png
  |   |   │   │   |   |   ├── ic_xxx.png
  |   │   │   |   |   ├── 3.0x
  |   |   │   │   |   |   ├── img_xxx.png
  |   |   │   │   |   |   ├── ic_xxx.png
  |   │   │   |   ├── img_xxx.png
  |   │   │   |   ├── ic_xxx.png
  └── ...
  ```

- [Resolution aware image assets](https://docs.flutter.dev/development/ui/assets-and-images#resolution-aware)

## Generates assets (fonts, icons, images, etc)

### Configuration (Do once)
- Use [FlutterGen](https://pub.dev/packages/flutter_gen)
- Add `build_runner` and `flutter_gen_runner` to package's `pubspec.yaml` file


  ```yaml
  dev_dependencies:
    build_runner:
    flutter_gen_runner:
  ```

- `FlutterGen` config default [here](https://github.com/FlutterGen/flutter_gen/blob/main/packages/core/lib/settings/config_default.dart)
  - Specifying fonts to package's `pubspec.yaml` file
  
    ```yaml
    flutter:
      fonts:
        - family: Raleway
          fonts:
            - asset: assets/fonts/Raleway-Regular.ttf
            - asset: assets/fonts/Raleway-Italic.ttf
              style: italic
        - family: RobotoMono
          fonts:
            - asset: assets/fonts/RobotoMono-Regular.ttf
            - asset: assets/fonts/RobotoMono-Bold.ttf
              weight: 700
    ```

  - Specifying images  to package's `pubspec.yaml` file

    ```yaml
    flutter:
      assets:
        - assets/images/img_xxx.png
    ```

    or all image in images directory is specified:

    ```yaml
    flutter:
      assets:
        - assets/images/
    ```

  - Config `flutter_gen` output

    ```yaml
    flutter_gen:
      output: lib/core/resources/assets_generated/ # Optional (default: lib/gen/)
      integrations:
        flutter_svg: true
    ```

### Generate Assets Dart code and usage

- Use FlutterGen, run command below, will re-gen assets, output path config at `pubspec.yaml` file.

  ```bash
  melos run build_runner
  ```

  - will re-gen assets, and has the output as the output path configured at `pubspec.yaml` file

    ```
    app-mobile
    ├── apps
    │   ├── banking_consumer
    |   │   ├── lib
    |   │   │   ├── core
    |   │   │   |   ├── resources
    |   |   │   │   |   ├── assets_generated
    |   |   │   │   |   |   ├── assets.gen.dart (default)
    |   |   │   │   |   |   ├── colors.gen.dart (default)
    |   |   │   │   |   |   ├── fonts.gen.dart (default)
    └── ...
    ```

- Then, we can use `Assets` class generated

For example with Banking Consumer app, with the image path `app-mobile/apps/banking_consumer/assets/ic_add_circle.png`, we can use `Assets.images.icAddCircle.path` with type safe support in your code.