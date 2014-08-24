module JSONFixture

  def load_json_fixture(fixture)
    JSON.parse(read_fixture(fixture))
  end

  private 

    def read_fixture(fixture)
      File.read(fixture_path(fixture))
    end

    def fixture_path(fixture)
      json_fixtures_path.join("#{fixture}.json")
    end

    def json_fixtures_path
      Rails.root.join(*%w(spec support json_fixtures))
    end

end