require './lib/trinidad_threaded_resque_extension'
Resque.inline = true

describe Trinidad::Extensions::ThreadedResque::LifecycleListener do
  it 'starts by default one worker' do
    subject.start_workers
    subject.workers.should have(1).things
  end

  it 'can start many workers' do
    subject.options = { :queues => { "q1" => 2 } }
    subject.start_workers
    subject.workers.map{ |w| w.queues }.flatten.count('q1').should == 2
  end

  it 'can start many workers for different queues' do
    subject.options = { :queues => {"q1" => 2, "q2" => 2 } }
    subject.start_workers
    queues = subject.workers.map{ |w| w.queues }.flatten
    queues.count('q1').should == 2
    queues.count('q2').should == 2
  end

  it 'can shutdown workers' do
    subject.start_workers
    subject.stop_workers
    subject.workers[0].shutdown?.should == true
    subject.threads[0].stop?.should == true
  end
  
  after do
    subject.stop_workers
  end
end
