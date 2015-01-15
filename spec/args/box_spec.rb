require 'squib'
require 'squib/args/base'
require 'squib/args/box'

describe Squib::Args::Box do
  it 'pulls x,y,width,height from the hash' do
    args = {x: 0, y: 1, z: 2, width: 3, height: 4}
    box = Squib::Args::Box.new.extract(args)
    expect(box.x).to eq(0)
    expect(box.y).to eq(1)
    expect(box.width).to eq(3)
    expect(box.height).to eq(4)
    expect {box.z}.to raise_error(NoMethodError)
  end
end