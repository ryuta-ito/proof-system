describe Imply do
  let(:imply_data) { "#{left_data}=>#{right_data}"}

  describe '#build' do
    subject { Imply.build(imply_data) }
  end
end
