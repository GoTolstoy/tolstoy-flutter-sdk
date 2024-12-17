# Tolstoy Flutter SDK

## Installation

To install the Tolstoy Flutter SDK, you need to have access to the Tolstoy GitHub repository. Please follow these steps:

1. Contact the Tolstoy support or development team to get collaboration access to the GitHub repository.

2. Once you have access, add the following to your `pubspec.yaml` dependencies:

    ```yaml
      tolstoy_flutter_sdk:
        git:
          url: git@github.com:GoTolstoy/tolstoy-flutter-sdk.git
          ref: master
    ```

3. Run `flutter pub get` to fetch the package.

## Update package

To update the Tolstoy Flutter SDK package, run the following command:

```bash
dart run tolstoy_flutter_sdk:update
```

This will ensure you have the latest version of the SDK.

## Examples

Basic usage example are available here: [Tolstoy Flutter SDK Examples](https://github.com/GoTolstoy/tolstoy-flutter-sdk/tree/master/examples)

## Content

The Tolstoy Flutter SDK provides the following exportable components:

### Feed

- [`FeedView`](https://github.com/GoTolstoy/tolstoy-flutter-sdk/blob/master/lib/modules/feed/widgets/feed_view.dart): Widget for displaying a feed of content. More controllable than `FeedScreen`.
- [`FeedScreen`](https://github.com/GoTolstoy/tolstoy-flutter-sdk/blob/master/lib/modules/feed/screens/feed_screen.dart): Pre-built screen for displaying a feed.

### Rail

- [`Rail`](https://github.com/GoTolstoy/tolstoy-flutter-sdk/blob/master/lib/modules/rail/widgets/rail.dart): Widget for displaying a rail of content. More controllable than `RailWithFeed`.
- [`RailWithFeed`](https://github.com/GoTolstoy/tolstoy-flutter-sdk/blob/master/lib/modules/rail/widgets/rail_with_feed.dart): Combined widget for displaying a rail with a feed.

### Other

- [`RailOptions`](https://github.com/GoTolstoy/tolstoy-flutter-sdk/blob/master/lib/modules/rail/models/rail_options.dart): Options for customizing the rail.
- [`TvPageConfig`](https://github.com/GoTolstoy/tolstoy-flutter-sdk/blob/master/lib/modules/api/models/tv_page_config.dart): Configuration model for Feed pages.
- [`TvConfigProvider`](https://github.com/GoTolstoy/tolstoy-flutter-sdk/blob/master/lib/modules/api/widgets/tv_config_provider.dart): Widget for providing Feed configuration.
- [`AssetViewOptions`](https://github.com/GoTolstoy/tolstoy-flutter-sdk/blob/master/lib/modules/assets/models/asset_view_options.dart): Options for customizing asset views.
- [`Product`](https://github.com/GoTolstoy/tolstoy-flutter-sdk/blob/master/lib/modules/products/models/product.dart): Model representing a product.
- [`getTvPageConfig`](https://github.com/GoTolstoy/tolstoy-flutter-sdk/blob/master/lib/modules/api/services/api.dart): Function for fetching Feed configuration.

## Useful commands

- `dart analyze` - analyze the code for potential issues.
- `dart fix --apply` - fix the code for potential issues.
- `dart format bin` - format the code in the `bin` directory.
- `dart format lib` - format the code in the `lib` directory.
