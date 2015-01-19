require 'squib'
require 'squib/args/arg_extractor'
require 'squib/args/box'

describe Squib::Args::Box do
  it 'pulls x,y,width,height from the hash' do
    args = {x: 0, y: 1, z: 2, width: 3, height: 4}
    box = Squib::Args::Box.new.extract(args)
    expect(box.x).to      eq(0)
    expect(box.y).to      eq(1)
    expect(box.width).to  eq(3)
    expect(box.height).to eq(4)
    expect {box.z}.to     raise_error(NoMethodError)
  end

  it 'handles defaults' do
    args = {x: 5}
    box = Squib::Args::Box.new.extract(args, {y: 3})
    expect(box.x).to      eq(5)
    expect(box.y).to      eq(3)
    expect(box.width).to  eq(:native)
    expect(box.height).to eq(:native)
    expect {box.z}.to     raise_error(NoMethodError)
  end

  it 'expands singletons when specified' do
    args = {x: [0,1], y: 1, z: 2, width: 3, height: 4}
    box = Squib::Args::Box.new.extract(args).expand(by: 2)
    expect(box.x).to      eq([0, 1])
    expect(box.y).to      eq([1, 1])
    expect(box.width).to  eq([3, 3])
    expect(box.height).to eq([4, 4])
    expect { box.z }.to   raise_error(NoMethodError)
  end

  it 'handles unit conversion with singletons' do
    args = {x: '1in', y: '1cm'}
    box = Squib::Args::Box.new.extract(args).convert_units(dpi: 100)
    expect(box.x).to      eq(100)
    expect(box.y).to      eq(39.3700787)
  end

  it 'handles unit conversion with expansions' do
    args = { x: %w(1in 2in) }
    box = Squib::Args::Box.new
            .extract(args)
            .expand(by: 2)
            .convert_units(dpi: 100)
    expect(box.x).to      eq([100, 200])
  end

  it 'uses array accessors' do
    args = { x: [250, 350], y: 25 }
    box = Squib::Args::Box.new.extract(args).expand(by: 2)
    expect(box[1].x).to eq(350)
    expect(box[1].y).to eq(25)
  end
end