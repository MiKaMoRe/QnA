require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { is_expected.to have_one_attached(:image) }

  it { is_expected.to belong_to(:user).optional(true) }
  it { is_expected.to belong_to :question }
end
