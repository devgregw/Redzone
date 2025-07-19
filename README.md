<img src="https://github.com/devgregw/Redzone/blob/main/redzone-web/src/app/logo.png?raw=true" width="75" height="75">

# Redzone

[![Redzone - iOS](https://github.com/devgregw/Redzone/actions/workflows/redzone-ios.yml/badge.svg)](https://github.com/devgregw/Redzone/actions/workflows/redzone-ios.yml) [![Redzone - NextJS](https://github.com/devgregw/Redzone/actions/workflows/redzone-web.yml/badge.svg)](https://github.com/devgregw/Redzone/actions/workflows/redzone-web.yml) [![Firebase Functions](https://github.com/devgregw/Redzone/actions/workflows/functions.yml/badge.svg)](https://github.com/devgregw/Redzone/actions/workflows/functions.yml) [![CodeQL Analysis](https://github.com/devgregw/Redzone/actions/workflows/codeql.yml/badge.svg)](https://github.com/devgregw/Redzone/actions/workflows/codeql.yml)

Redzone pulls publicly available severe weather outlooks from the National Weather Service's Storm Prediction Center office. The convective weather outlooks are overlayed on the map, allowing you to easily see risk forecasts relevant to you. Tap any outlook on the map to see details about what type of severe weather is forecast. Using your location (optional), Redzone will indicate which risk level currently exists at your location. Home Screen & Lock Screen widgets allow you to see a breakdown of today's or tomorrow's outlooks without the need to open the app.

## Disclaimer

Redzone displays and represents publicly available data from the National Weather Service, primarily from its Storm Prediction Center (SPC) office. The Redzone app and I, Gregory Whatley, are neither endorsed by nor affiliated with the National Weather Service or any other United States federal government organization.

By using Redzone, you assume the entire risk associated with the use of this data.

Redzone and all data provided herein by the NWS are provided “as-is,” without warranty of any kind, express or implied, including but not limited to the warranties of merchantability or fitness for a particular purpose. In no event should I be liable to you or to any third party for any direct, indirect, incidental, consequential, special, or exemplary damages or lost profit resulting from any use or misuse of this data. For more information, please see the National Weather Service's own [disclaimer](https://www.weather.gov/disclaimer).

### 17 U.S.C. § 403 Notice

© 2025 Gregory Whatley. In accordance with [17 U.S.C. § 403](https://www.law.cornell.edu/uscode/text/17/403), portions of *Redzone* incoprorate works of the United States government - namely raw risk outlook data (including geograpical coordinates, colors, names, and descriptions) and agency logos used solely to identify links to their respective websites - which are not subject to copyright protection. Copyright is claimed only in the original content authored by Gregory Whatley. *Redzone* source code is licensed under the [MIT License](LICENSE).
 
## Privacy

Redzone does not collect and store any of your personal information. You may choose to share your current location with Redzone, which is used to pinpoint your location on the map and provide information about outlooks at your location. This processing is done exclusively on your device. While Lock Screen & Home Screen widgets require location services, the core features of Redzone will remain functional if you choose to not share your location.

If you interact with an external link from Redzone, the privacy policy of that website will apply.

## Support

To report a bug, file [a new issue](https://github.com/devgregw/Redzone/issues/new) if you have a GitHub account. If you do not have a GitHub account or want to submit feedback separately, feel free to [email me](mailto:redzone@gregwhatley.dev).

## Screenshots

<details>

<summary><b>Risk Map</b></summary>

| Categorical | Categorical (zoomed) | Details |
| --- | --- | --- |
| ![Categorical risk map](https://github.com/devgregw/Redzone/blob/main/screenshots/cat_1.png?raw=true) | ![Categorical risk map (zoomed)](https://github.com/devgregw/Redzone/blob/main/screenshots/cat_2.png?raw=true) | ![Categorical risk details](https://github.com/devgregw/Redzone/blob/main/screenshots/cat_detail.png?raw=true) |

| Wind | Details |
| --- | --- |
| ![Wind risk map](https://github.com/devgregw/Redzone/blob/main/screenshots/wind_1.png?raw=true) | ![Wind risk details](https://github.com/devgregw/Redzone/blob/main/screenshots/wind_detail.png?raw=true) |

| Hail | Details |
| --- | --- |
| ![Hail risk map](https://github.com/devgregw/Redzone/blob/main/screenshots/hail_1.png?raw=true) | ![Hail risk details](https://github.com/devgregw/Redzone/blob/main/screenshots/hail_detail.png?raw=true) |

| Tornado | Details |
| --- | --- |
| ![Tornado risk map](https://github.com/devgregw/Redzone/blob/main/screenshots/torn_1.png?raw=true) | ![Tornado risk details](https://github.com/devgregw/Redzone/blob/main/screenshots/torn_detail.png?raw=true) |

| Menu | Menu (Risk) |
| --- | --- |
| ![Main menu](https://github.com/devgregw/Redzone/blob/main/screenshots/menu_1.png?raw=true) | ![Main menu 2](https://github.com/devgregw/Redzone/blob/main/screenshots/menu_2.png?raw=true) |
 
</details>

<details>

<summary><b>Widgets</b></summary>

| Home Screen | Lock Screen |
| --- | --- |
| ![Home Screen widgets](https://github.com/devgregw/Redzone/blob/main/screenshots/widgets_home.png?raw=true) | ![Lock Screen widgets](https://github.com/devgregw/Redzone/blob/main/screenshots/widgets_lockscreen.png?raw=true) |
 
</details>

<details>

<summary><b>About</b></summary>

| About | Disclaimer | Safety | Privacy |
| --- | --- | --- | --- |
| ![About](https://github.com/devgregw/Redzone/blob/main/screenshots/about_main.png?raw=true) | ![Disclaimer](https://github.com/devgregw/Redzone/blob/main/screenshots/about_disclaimer.png?raw=true) | ![Safety](https://github.com/devgregw/Redzone/blob/main/screenshots/about_safety.png?raw=true) | ![Privacy](https://github.com/devgregw/Redzone/blob/main/screenshots/about_privacy.png?raw=true) |
 
</details>

<details>

<summary><b>Risks</b></summary>

| Categorical | Wind | Hail | Tornado |
| --- | --- | --- | --- |
| ![Categorical](https://github.com/devgregw/Redzone/blob/main/screenshots/about_cat.png?raw=true) | ![Wind](https://github.com/devgregw/Redzone/blob/main/screenshots/about_wind.png?raw=true) | ![Hail](https://github.com/devgregw/Redzone/blob/main/screenshots/about_hail.png?raw=true) | ![Tornado](https://github.com/devgregw/Redzone/blob/main/screenshots/about_torn.png?raw=true) |

| Probabilistic (Day 3) | Probabilistic (Day 4-8) |
| --- | --- |
| ![Day 3](https://github.com/devgregw/Redzone/blob/main/screenshots/about_prob3.png?raw=true) | ![Lock Screen widgets](https://github.com/devgregw/Redzone/blob/main/screenshots/about_prob48.png?raw=true) |
 
</details>
