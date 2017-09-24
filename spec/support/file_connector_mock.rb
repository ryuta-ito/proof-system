shared_context 'use File.read mock' do
  before do
    allow(File).to receive(:read).and_return(file_connector_read_text)
  end
end
