# frozen_string_literal: true
# rbs_inline: enabled

RSpec.describe DBotQuery do
  it 'has a version number' do
    expect(DBotQuery::VERSION).not_to be_nil
  end
end
