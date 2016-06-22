require 'spec_helper'

describe Lita::Handlers::OnewheelBeerWework, lita_handler: true do
  it 'sets a document' do
    send_command 'doc one http://one'
    expect(replies.last).to eq('Documented one as http://one')
  end

  it 'gets a document' do
    send_command 'doc one http://one'
    send_command 'doc one'
    expect(replies.last).to eq('one: http://one')
  end

  it 'lists documents' do
    send_command 'doc one http://one'
    send_command 'doc two http://two'
    send_command 'doc'
    expect(replies.last).to eq("one: http://one\ntwo: http://two")
  end

  it 'documents real urls' do
    send_command 'doc pachinko-endpoints https://shopigniter.atlassian.net/wiki/display/I5/Pachinko+Endpoints'
    expect(replies.last).to eq('Documented pachinko-endpoints as https://shopigniter.atlassian.net/wiki/display/I5/Pachinko+Endpoints')
  end

  it 'deletes documents' do
    send_command 'doc one http://one'
    send_command 'docdel one'
    expect(replies.last).to eq('Document deleted: one')
  end

  it 'finds by partial key' do
    send_command 'doc pacone http://one'
    send_command 'doc pactwo http://two'
    send_command 'doc pac'
    expect(replies.last).to eq("pacone: http://one\npactwo: http://two")
  end

end
