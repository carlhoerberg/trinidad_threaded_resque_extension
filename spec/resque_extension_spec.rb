require './lib/trinidad_threaded_resque_extension'
Resque.inline = true

describe Trinidad::Extensions::ThreadedResque::ThreadedResqueLifecycleListener do
  subject { Trinidad::Extensions::ThreadedResque::ThreadedResqueLifecycleListener.new }

  it 'starts by default one worker' do
    workers = subject.start_workers
    workers.should have(1).things
  end

  it 'can start many workers' do
    subject.instance_variable_set(:@options, {:queues => {"q1" => 2 }})
    workers = subject.start_workers
    workers.should have(2).things
    workers[0].queues.should == ['q1']
    workers[1].queues.should == ['q1']
  end

  it 'can start many workers for different queues' do
    subject.instance_variable_set(:@options, {:queues => {"q1" => 2, "q2" => 2 }})
    workers = subject.start_workers
    workers.should have(4).things
    workers[0].queues.should == ['q1']
    workers[1].queues.should == ['q1']
    workers[2].queues.should == ['q2']
    workers[3].queues.should == ['q2']
  end

  it 'can shutdown workers' do
    subject.start_workers
    workers = subject.stop_workers
    workers[0].shutdown?.should == true
  end
end
