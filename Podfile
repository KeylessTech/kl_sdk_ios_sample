platform :ios, '13.0'

def load_env_file(filename)
  if File.exist?(filename)
    File.readlines(filename).each do |line|
      key, value = line.strip.split('=', 2)
      ENV[key] = value if key && value
    end
  else
    puts "#{filename} file not found. Please create one based on cloudsmith.template.properties"
  end
end

load_env_file('cloudsmith.properties')

unless ENV['cloudsmithTokenPartners']
  raise "Missing required environment variable: cloudsmithTokenPartners. Are you sure you created a cloudsmith.properties file based on the cloudsmith.template.properties file?"
end

source 'https://cdn.cocoapods.org/'
source 'https://dl.cloudsmith.io/' + ENV['cloudsmithTokenPartners'] +'/keyless/partners/cocoapods/index.git'


target 'ScenarioDeveloperQuickstart' do
  use_frameworks!
  pod 'KeylessSDK', '5.0.1'
end


post_install do |installer|
installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
    config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
end
end
