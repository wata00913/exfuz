# frozen_string_literal: true

RSpec.describe Exfuz::Body do
  describe 'change_some and lines' do
    texts = ['first text', 'second text']
    context 'prev text is longer than current text' do
      body = Exfuz::Body.new(top: 1, bottom: 2, texts: texts)
      body.change_some({ 0 => 'current' })

      it 'overwrite line has blank space' do
        lines = body.lines(overwrite: true)
        expect(lines).to eq({ 1 => 'current   ', 2 => 'second text' })
      end

      it 'line has no blank space without overwrite' do
        lines = body.lines
        expect(lines).to eq({ 1 => 'current', 2 => 'second text' })
      end
    end

    context 'prev text is shorter than current text' do
      body = Exfuz::Body.new(top: 1, bottom: 2, texts: texts)
      body.change_some({ 0 => 'current text is longer' })

      it 'line has no blank space without overwrite' do
        lines = body.lines(overwrite: true)
        expect(lines).to eq({ 1 => 'current text is longer', 2 => 'second text' })
      end
    end
  end

  describe 'change_all and lines' do
    texts = ['first text', 'second text']
    body = Exfuz::Body.new(top: 1, bottom: 2, texts: texts)
    body.change_all({ 0 => 'current' })

    it 'prev remaining lines is blank space' do
      lines = body.lines(overwrite: true)
      expect(lines).to eq({ 1 => 'current   ', 2 => '           ' })
    end
  end
end
