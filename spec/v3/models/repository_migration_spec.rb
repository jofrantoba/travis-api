describe Travis::API::V3::Models::RepositoryMigration do
  let(:repository) { FactoryBot.create(:repository) }

  subject { Travis::API::V3::Models::RepositoryMigration.new(repository) }

  before do
    allow(Travis::Features).to receive(:feature_active?).with(:multi_os).and_return(true)
    allow(Travis::Features).to receive(:feature_active?).with(:dist_group_expansion).and_return(true)
    allow(Travis::Features).to receive(:feature_active?).with(:education).and_return(true)
  end

  context 'when migration is enabled globally' do
    context 'when migration is enabled for owner' do
      before { Travis::Features.expects(:owner_active?).with(:allow_migration, repository.owner).returns(true) }

      it 'migrates repository' do
        request = stub_request(:post, %r{/api/repo/by_github_id/\d+/migrate}).
          with(headers: { 'Content-Type' => 'application/json' })
        subject.migrate!
        expect(request).to have_been_requested
      end
    end

    context 'when migration is disabled for owner' do
      before { Travis::Features.expects(:owner_active?).with(:allow_migration, repository.owner).returns(false) }

      it 'raises error' do
        expect { subject.migrate! }.to raise_error(Travis::API::V3::Models::RepositoryMigration::MigrationDisabledError)
      end
    end
  end

  context 'when migration is disabled globally' do
    it 'raises error' do
      expect { subject.migrate! }.to raise_error(Travis::API::V3::Models::RepositoryMigration::MigrationDisabledError)
    end
  end
end
