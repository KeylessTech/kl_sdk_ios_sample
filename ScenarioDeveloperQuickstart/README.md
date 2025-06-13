# Keyless SDK - Scenario Developer Quickstart

Welcome to the developer quickstart

## Setup Dependencies
We distribute the Keyless SDK through cloudsmith packages. 

We already added for you in the `Podfile` the following:

```Ruby
source 'https://dl.cloudsmith.io/' + ENV['cloudsmithTokenPartners'] +'/keyless/partners/cocoapods/index.git'
```

Cloudsmith needs a "token" to authorize our SDK download from `CocoaPods` repository. You can read the `cloudsmithTokenPartners` environment variable from the a file in the target root folder. Create a `cloudsmith.properties` file next to the `cloudsmith.template.properties`. 

> [!CAUTION]
> You should not commit the `cloudsmith.properties` file containing the token in your git repository. We added it in the .gitignore file for you.

```markdown
# cloudsmith.properties content
cloudsmithTokenPartners=YOUR_CLOUDSMITH_TOKEN
```
You can now run `pod install` to use the Keyless SDK in the project workspace.

> [!NOTE]
> The Keyless SDK version installed does not run on IOS Simulator. Please use a physical device to test.

## Setup Keyless API key and host

Open the project workspace `ScenarioDeveloperQuickstart.xcworkspace`.

In order to avoid committing API keys we created a template xcconfig file under `kl_sdk_ios_sample/ScenarioDeveloperQuickstart/keys.template.xcconfig` copy the content of the template into a `kl_sdk_ios_sample/ScenarioDeveloperQuickstart/keys.xcconfig` file and add it as [build configuration file to your project](https://developer.apple.com/documentation/xcode/adding-a-build-configuration-file-to-your-project). In a nutshell:
- Select the `ScenarioDeveloperQuickstart` folder from the project editor.
- Create a new file from template: File -> New -> File from Template...
- Chose Configuration Settings File
- Enter a name for the file (for example `keys.xcconfig`)
- Where should already be the `ScenarioDeveloperQuickstart` folder
- Deselect all targets to prevent Xcode from embedding the file as a resource in the target’s bundle.

The template looks like
```markdown
API_KEY=enter_keyless_api_key_here
HOST=enter_keyless_host_here
```

Make sure to remove any trialing slash from the Keyless host
- OK     ->  `https://host.keyless.technology`
- NOT OK ->  `https://host.keyless.technology/`

Now add the keys.xcconfig as configuration for debug and release under `Project -> ScenarioDeveloperQuickstart -> Info -> Configurations`. 

We already prepared the code to retrieve the `API_KEY` and `HOST` from the `keys.xcconfig` you just created, double check that your `Info.plist` contains the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>API_KEY</key>
	<string>$(API_KEY)</string>
	<key>HOST</key>
	<string>$(HOST)</string>
</dict>
</plist>
```

We already prepared the code fo you to look for the apiKey and host in the `KeylessWrapper` class. You should see your api key and host if you followed the steps above.

```Swift
// Make sure you followed the README.md to add your API Key and Host into the Info.plist
static let apikey :String = Configuration.apiKey
static let hosts = [Configuration.host]
```

To troubleshoot issues make sure you did not miss any step, this [walkthrough](https://moinulhassan.medium.com/read-variables-from-env-file-to-xcconfig-files-for-different-schemes-in-xcode-3ef977a0eef8) is a good reference for the setup.


## Next steps
Setup of the project is done, you should be able to build the project and launch it on a device.
We advise to use a real device since the camera won't work on an emulator.

The app shows buttons to perform the main actions with the Keyless SDK:
- Setup: configures the SDK. Mandatory for the SDK to work as expected.
- Enroll: "register" the user biometric with Keyless privacy preserving technology.
- Authenticate: check a face in front of the device with the face initially registered during enrollment.
- DeEnroll: "delete" the user from Keyless.
- Reset: clears the SDK state. Start from scratch after reset is successful.
