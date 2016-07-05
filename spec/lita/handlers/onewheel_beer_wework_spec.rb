require 'spec_helper'

describe Lita::Handlers::OnewheelBeerWework, lita_handler: true do
  it { is_expected.to route_command('wework') }
  it { is_expected.to route_command('wework 2fS Breakfast Stout') }

  it 'sets a beer' do
    send_command 'wework 2fs Breakfast Stout'
    expect(replies.last).to eq('Logged Breakfast Stout at 2fs!')
  end

  it 'doesn\'t set a beer' do
    send_command 'wework 9fF Breakfast Stout'
    expect(replies.last).to eq(nil)
  end

  it 'gets a beer' do
    send_command 'wework 2fs Breakfast Stout'
    send_command 'wework 2fs'
    expect(replies.last).to eq('2fs: Breakfast Stout')
  end

  it 'lists beers' do
    send_command 'wework 2fs one'
    send_command 'wework 2fN two'
    send_command 'wework'
    expect(replies[2]).to eq('2fs: one')
    expect(replies.last).to eq('2fn: two')
  end
end
