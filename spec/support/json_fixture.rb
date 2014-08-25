module JSONFixture

  def load_json_fixture(fixture)
    JSON.parse(read_fixture(fixture))
  end

  private 

    def read_fixture(fixture)
      File.read(json_fixture_path(fixture))
    end

    def json_fixture_path(fixture)
      base_json_fixture_path.join("#{fixture}.json")
    end

    def base_json_fixture_path
      Rails.root.join(*%w(spec support json_fixtures))
    end

end