describe 'Auth repos', auth_helpers: true, api_version: :v1, set_app: true do
  let(:user)  { FactoryBot.create(:user) }
  let(:repo)  { Repository.by_slug('svenfuchs/minimal').first }
  let(:build) { repo.builds.first }

  before(:all) { SslKey.create(repository_id: 1) }
  before { SslKey.update_all(repository_id: repo.id) }

  # TODO
  # patch '/repos/:id/settings'
  # post '/repos/:id/key' }
  # delete '/:repository_id/caches'
  # post '/:owner_name/:name/key'

  describe 'in public mode, with a public repo', mode: :public, repo: :public do
    describe 'GET /repos' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{user.login}' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{user.login}.xml?token=%{user.token}' do
      it(:with_permission)    { should auth status: 200, type: :xml, empty: false }
      it(:without_permission) { should auth status: 200, type: :xml, empty: false }
    end

    describe 'GET /repos/%{user.login}.xml' do
      it(:with_permission)    { should auth status: 200, type: :xml, empty: false }
      it(:without_permission) { should auth status: 200, type: :xml, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :xml, empty: false }
    end

    describe 'GET /repos/%{repo.id}' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.id}/cc.xml?token=%{user.token}' do
      it(:with_permission)    { should auth status: 200, type: :xml }
      it(:without_permission) { should auth status: 200, type: :xml }
    end

    describe 'GET /repos/%{repo.id}/cc.xml' do
      it(:with_permission)    { should auth status: 200, type: :xml }
      it(:without_permission) { should auth status: 200, type: :xml }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :xml }
    end

    describe 'GET /repos/%{repo.id}/settings' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.id}/key' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.id}/branches' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.id}/branches/master' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.id}/caches' do
      it(:with_permission)    { should auth status: 200, type: :json }
      it(:without_permission) { should auth status: 200, type: :json }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}/cc' do
      it(:with_permission)    { should auth status: 200, type: :json } # oddly, this returns the repo json
      it(:without_permission) { should auth status: 200, type: :json }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}/cc.xml' do
      it(:with_permission)    { should auth status: 200, type: :xml }
      it(:without_permission) { should auth status: 200, type: :xml }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :xml }
    end

    describe 'GET /repos/%{repo.slug}/cc.xml?token=%{user.token}' do
      it(:with_permission)    { should auth status: 200, type: :xml }
      it(:without_permission) { should auth status: 200, type: :xml }
    end

    describe 'GET /repos/%{repo.slug}.png' do
      it(:with_permission)    { should auth status: 200, type: :img, image: :passing }
      it(:without_permission) { should auth status: 200, type: :img, image: :passing }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :img, image: :passing }
    end

    describe 'GET /repos/%{repo.slug}.png?token=%{user.token} Accept */*' do
      let(:accept) { '*/*' }
      it(:with_permission)    { should auth status: 200, type: :img, image: :passing }
      it(:without_permission) { should auth status: 200, type: :img, image: :passing }
    end

    describe 'GET /repos/%{repo.slug}.png?token=%{user.token} Accept application/json' do
      let(:accept) { 'application/json' }
      it(:with_permission)    { should auth status: 200, type: :img, image: :passing }
      it(:without_permission) { should auth status: 200, type: :img, image: :passing }
    end

    describe 'GET /repos/%{repo.slug}.png?token=%{user.token} Accept image/png' do
      let(:accept) { 'image/png' }
      it(:with_permission)    { should auth status: 200, type: :img, image: :passing }
      it(:without_permission) { should auth status: 200, type: :img, image: :passing }
    end

    describe 'GET /repos/%{repo.slug}.png?token=%{user.token}' do
      it(:with_permission)    { should auth status: 200, type: :img, image: :passing }
      it(:without_permission) { should auth status: 200, type: :img, image: :passing }
    end

    describe 'GET /repos/%{repo.slug}?token=%{user.token} Accept */*' do
      let(:accept) { '*/*' }
      it(:with_permission)    { should auth status: 403 }
      it(:without_permission) { should auth status: 403 }
    end

    describe 'GET /repos/%{repo.slug}?token=%{user.token} Accept application/json' do
      let(:accept) { 'application/json' }
      it(:with_permission)    { should auth status: 403 }
      it(:without_permission) { should auth status: 403 }
    end

    describe 'GET /repos/%{repo.slug}?token=%{user.token} Accept image/png' do
      let(:accept) { 'image/png' }
      it(:with_permission)    { should auth status: 403 }
      it(:without_permission) { should auth status: 403 }
    end

    describe 'GET /repos/%{repo.slug}.svg?token=%{user.token}' do
      it(:with_permission)    { should auth status: 200, type: :img, image: :passing }
      it(:without_permission) { should auth status: 200, type: :img, image: :passing }
    end

    describe 'GET /repos/%{repo.slug}.svg' do
      it(:with_permission)    { should auth status: 200, type: :img, image: :passing }
      it(:without_permission) { should auth status: 200, type: :img, image: :passing }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :img, image: :passing }
    end

    describe 'GET /repos/%{repo.slug}/builds' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}/builds.atom' do
      it(:with_permission)    { should auth status: 200, type: :atom }
      it(:without_permission) { should auth status: 200, type: :atom }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :atom }
    end

    describe 'GET /repos/%{repo.slug}/builds?branches=master' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}/builds?branches=' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}/builds/%{build.id}' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}/cc.xml?token=%{user.token}' do
      it(:with_permission)    { should auth status: 200, type: :xml }
      it(:without_permission) { should auth status: 200, type: :xml }
    end

    describe 'GET /repos/%{repo.slug}/cc.xml' do
      it(:with_permission)    { should auth status: 200, type: :xml }
      it(:without_permission) { should auth status: 200, type: :xml }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :xml }
    end

    describe 'GET /repos/%{repo.slug}/key' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}/branches' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.id}/branches/master' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end
  end

  # +----------------------------------------------------+
  # |                                                    |
  # |   !!! THE ORIGINAL BEHAVIOUR ... DON'T TOUCH !!!   |
  # |                                                    |
  # +----------------------------------------------------+

  describe 'in private mode, with a private repo', mode: :private, repo: :private do
    describe 'GET /repos' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, empty: true }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{user.login}' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, empty: true }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{user.login}.xml?token=%{user.token}' do
      it(:with_permission)    { should auth status: 200, type: :xml, empty: false }
      it(:without_permission) { should auth status: 406 } # not sure what this is, an empty collection?
    end

    describe 'GET /repos/%{user.login}.xml' do
      it(:with_permission)    { should auth status: 200, type: :xml, empty: false }
      it(:without_permission) { should auth status: 406 } # not sure what this is, an empty collection?
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.id}' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.id}/cc.xml?token=%{user.token}' do
      it(:with_permission)    { should auth status: 200, type: :xml }
      it(:without_permission) { should auth status: 404 }
    end

    describe 'GET /repos/%{repo.id}/cc.xml' do
      it(:with_permission)    { should auth status: 200, type: :xml }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.id}/settings' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.id}/key' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.id}/branches' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, empty: true }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.id}/branches/master' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.id}/caches' do
      it(:with_permission)    { should auth status: 200, type: :json }
      it(:without_permission) { should auth status: 200, type: :json }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}/cc' do
      it(:with_permission)    { should auth status: 200, type: :json }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}.png?token=%{user.token}' do
      it(:with_permission)    { should auth status: 200, type: :img, image: :passing }
      it(:without_permission) { should auth status: 200, type: :img, image: :unknown }
    end

    describe 'GET /repos/%{repo.slug}.png' do
      it(:with_permission)    { should auth status: 200, type: :img, image: :passing }
      it(:without_permission) { should auth status: 200, type: :img, image: :unknown }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}.svg?token=%{user.token}' do
      it(:with_permission)    { should auth status: 200, type: :img, image: :passing }
      it(:without_permission) { should auth status: 200, type: :img, image: :unknown }
    end

    describe 'GET /repos/%{repo.slug}.svg' do
      it(:with_permission)    { should auth status: 200, type: :img, image: :passing }
      it(:without_permission) { should auth status: 200, type: :img, image: :unknown }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}/builds' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, empty: true }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}/builds.atom' do
      it(:with_permission)    { should auth status: 200, type: :atom }
      it(:without_permission) { should auth status: 406 } # not sure what this is, an empty collection?
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}/builds?branches=master' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, empty: true }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}/builds?branches=' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, empty: true }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}/builds/%{build.id}' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}/cc.xml?token=%{user.token}' do
      it(:with_permission)    { should auth status: 200, type: :xml }
      it(:without_permission) { should auth status: 404 }
    end

    describe 'GET /repos/%{repo.slug}/cc.xml' do
      it(:with_permission)    { should auth status: 200, type: :xml }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}/key' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.slug}/branches' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, empty: true }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end

    describe 'GET /repos/%{repo.id}/branches/master' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 401 }
    end
  end

  describe 'in org mode, with a public repo', mode: :org, repo: :public do
    describe 'GET /repos' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 403 }
    end

    describe 'GET /repos/%{user.login}' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :json, empty: false }
    end

    describe 'GET /repos/%{user.login}.xml?token=%{user.token}' do
      it(:with_permission)    { should auth status: 200, type: :xml, empty: false }
      it(:without_permission) { should auth status: 200, type: :xml, empty: false }
    end

    describe 'GET /repos/%{user.login}.xml' do
      it(:with_permission)    { should auth status: 200, type: :xml, empty: false }
      it(:without_permission) { should auth status: 200, type: :xml, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :xml, empty: false }
    end

    describe 'GET /repos/%{repo.id}' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :json, empty: false }
    end

    describe 'GET /repos/%{repo.id}/cc.xml?token=%{user.token}' do
      it(:with_permission)    { should auth status: 200, type: :xml }
      it(:without_permission) { should auth status: 200, type: :xml }
    end

    describe 'GET /repos/%{repo.id}/cc.xml' do
      it(:with_permission)    { should auth status: 200, type: :xml }
      it(:without_permission) { should auth status: 200, type: :xml }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :xml }
    end

    describe 'GET /repos/%{repo.id}/settings' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 404 }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 404 }
    end

    describe 'GET /repos/%{repo.id}/key' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :json, empty: false }
    end

    describe 'GET /repos/%{repo.id}/branches' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :json, empty: false }
    end

    describe 'GET /repos/%{repo.id}/branches/master' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :json, empty: false }
    end

    describe 'GET /repos/%{repo.id}/caches' do
      it(:with_permission)    { should auth status: 200, type: :json }
      it(:without_permission) { should auth status: 200, type: :json }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 404 }
    end

    describe 'GET /repos/%{repo.slug}' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :json, empty: false }
    end

    describe 'GET /repos/%{repo.slug}/cc' do
      it(:with_permission)    { should auth status: 200, type: :json }
      it(:without_permission) { should auth status: 200, type: :json }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :json }
    end

    describe 'GET /repos/%{repo.slug}.png?token=%{user.token}' do
      it(:with_permission)    { should auth status: 200, type: :img }
      it(:without_permission) { should auth status: 200, type: :img }
    end

    describe 'GET /repos/%{repo.slug}.png' do
      it(:with_permission)    { should auth status: 200, type: :img }
      it(:without_permission) { should auth status: 200, type: :img }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :img }
    end

    describe 'GET /repos/%{repo.slug}.svg?token=%{user.token}' do
      it(:with_permission)    { should auth status: 200, type: :img }
      it(:without_permission) { should auth status: 200, type: :img }
    end

    describe 'GET /repos/%{repo.slug}.svg' do
      it(:with_permission)    { should auth status: 200, type: :img }
      it(:without_permission) { should auth status: 200, type: :img }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :img }
    end

    describe 'GET /repos/%{repo.slug}/builds' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :json, empty: false }
    end

    describe 'GET /repos/%{repo.slug}/builds.atom' do
      it(:with_permission)    { should auth status: 200, type: :atom }
      it(:without_permission) { should auth status: 200, type: :atom }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :atom }
    end

    describe 'GET /repos/%{repo.slug}/builds?branches=master' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :json, empty: false }
    end

    describe 'GET /repos/%{repo.slug}/builds?branches=' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :json, empty: false }
    end

    describe 'GET /repos/%{repo.slug}/builds/%{build.id}' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :json, empty: false }
    end

    describe 'GET /repos/%{repo.slug}/cc.xml?token=%{user.token}' do
      it(:with_permission)    { should auth status: 200, type: :xml }
      it(:without_permission) { should auth status: 200, type: :xml }
    end

    describe 'GET /repos/%{repo.slug}/cc.xml' do
      it(:with_permission)    { should auth status: 200, type: :xml }
      it(:without_permission) { should auth status: 200, type: :xml }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :xml }
    end

    describe 'GET /repos/%{repo.slug}/key' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :json, empty: false }
    end

    describe 'GET /repos/%{repo.slug}/branches' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :json, empty: false }
    end

    describe 'GET /repos/%{repo.id}/branches/master' do
      it(:with_permission)    { should auth status: 200, type: :json, empty: false }
      it(:without_permission) { should auth status: 200, type: :json, empty: false }
      it(:invalid_token)      { should auth status: 403 }
      it(:unauthenticated)    { should auth status: 200, type: :json, empty: false }
    end
  end
end