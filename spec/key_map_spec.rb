# frozen_string_literal: true

RSpec.describe Exfuz::Key do
  describe 'input_to_name_and_char' do
    it 'return enter' do
      name = Exfuz::Key.input_to_name_and_char(10)
      expect(name).to eq(Exfuz::Key::ENTER)
    end
    it 'return f1' do
      name = Exfuz::Key.input_to_name_and_char([27, 'O', 'P'])
      expect(name).to eq(Exfuz::Key::F1)
    end
    it 'return a' do
      name, char = Exfuz::Key.input_to_name_and_char('a')
      expect(name).to eq(Exfuz::Key::CHAR)
      expect(char).to eq('a')
    end
    it 'return あ' do
      name, char = Exfuz::Key.input_to_name_and_char([227, 129, 130])
      expect(name).to eq(Exfuz::Key::CHAR)
      expect(char).to eq('あ')
    end
  end
end
