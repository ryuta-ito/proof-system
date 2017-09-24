RSpec::Matchers.define :identify do |object|
  match do |receiver|
    receiver.identify?(object)
  end
end
