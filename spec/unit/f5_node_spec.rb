require 'spec_helper'

describe Puppet::Type.type(:f5_node).provider(:rest) do
  let(:resource) do
    Puppet::Type.type(:f5_node).new(
      name:                   '/Common/test',
      ensure:                 :present,
      state:                  'up',
      description:            'test node',
      logging:                'disabled',
      monitor:                ['/Common/gateway_icmp', '/Common/icmp'],
      availability:           '1',
      ratio:                  '1',
      connection_limit:       '1',
      connection_rate_limit:  '3',
      provider:               described_class.name)
  end
  let(:provider) { resource.provider }
  #let(:instance) { provider.class.instances.first }

  before :each do
    allow(Facter).to receive(:value).with(:url).and_return('https://admin:admin@bigip')
    allow(Facter).to receive(:value).with(:feature)
  end

  describe 'instances' do
    it 'gets a response from the api' do
      result = nil
      VCR.use_cassette('f5_node/instances') do
        result = provider.class.instances
      end
      expect(result.count).to eq(3)
    end
  end

  describe 'flush' do
    it 'gets a response from the api' do
      result = nil
      VCR.use_cassette('f5_node/flush') do
        provider.class.prefetch({})
        result = provider.flush
      end
      expect(result.status).to eq(200)
    end
  end


end
