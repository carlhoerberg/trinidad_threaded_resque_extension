require './lib/trinidad_threaded_resque_extension'

describe Trinidad::Extensions::ThreadedResque::LifecycleListener do
  let(:opts) { { :require => './spec/dummy' } }
  subject { Trinidad::Extensions::ThreadedResque::LifecycleListener.new opts }

  context '#start_workers' do
    it 'starts by default one worker' do
      subject.start_workers
      subject.workers.should have(1).things
    end

    it 'can start many workers' do
      subject.options[:queues]  = { :q1 => 2 }
      subject.start_workers
      subject.workers.map{ |w| w.queues }.flatten.count('q1').should == 2
    end

    it 'can start many workers for different queues' do
      subject.options[:queues] = { :q1 => 2, :q2 => 2 }
      subject.start_workers
      queues = subject.workers.map{ |w| w.queues }.flatten
      queues.count('q1').should == 2
      queues.count('q2').should == 2
    end

    it 'requires the "require" file' do
      subject.start_workers
      defined?(Dummy).should_not be_nil
    end

    it 'raises if no "require" file is configured' do
      subject.options[:require] = nil
      lambda {
        subject.start_workers
      }.should raise_error RuntimeError
    end

    after do
      subject.stop_workers
    end
  end

  context '#stop_workers' do
    before do
      subject.start_workers
      subject.stop_workers
    end

    it 'shutdowns workers' do
      subject.workers[0].shutdown?.should be_true
    end

    it 'stops threads' do
      subject.threads[0].stop?.should be_true
    end
  end
end
