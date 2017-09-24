RSpec::Matchers.define :identify do |object|
  match do |receiver|
    receiver.identify?(object)
  end
end

RSpec::Matchers.define :identify_array do |array_object|
  match do |array_receiver|
    array_receiver.all? do |receiver|
      array_object.any? do |object|
        receiver.identify?(object)
      end
    end
  end
end
