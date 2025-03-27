platform :ios, '13.0'

def load_env_file(filename)
  if File.exist?(filename)
    File.readlines(filename).each do |line|
      key, value = line.strip.split('=', 2)
      ENV[key] = value if key && value
    end
  else
    puts "#{filename} file not found!"
  end
end

load_env_file('cloudsmith.properties')

source 'https://cdn.cocoapods.org/'
source 'https://dl.cloudsmith.io/' + ENV['cloudsmithTokenPartners'] +'/keyless/partners/cocoapods/index.git'


target 'ScenarioDeveloperQuickstart' do
  use_frameworks!
  pod 'KeylessSDK', '4.7.4'
end


post_install do |installer|
installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
    config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
end
end
