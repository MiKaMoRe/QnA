RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :author }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
