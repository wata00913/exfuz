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
    body.change_all(['current'])

    it 'prev remaining lines is blank space' do
      lines = body.lines(overwrite: true)
      expect(lines).to eq({ 1 => 'current   ', 2 => '           ' })
    end
  end

  describe 'move_next' do
    texts = ['first text', 'second text', 'third text', '4th text', '5th text']

    it 'next list is (third text, 4th text)' do
      body = Exfuz::Body.new(top: 1, bottom: 2, texts: texts)
      body.move_next
      lines = body.lines(overwrite: true)
      expect(lines).to eq({ 1 => 'third text', 2 => '4th text   ' })
    end

    it 'after next list is (5th text)' do
      body = Exfuz::Body.new(top: 1, bottom: 2, texts: texts)
      body.move_next
      body.move_next
      lines = body.lines(overwrite: true)
      expect(lines).to eq({ 1 => '5th text  ', 2 => '        ' })
    end
  end

  describe 'move_prev' do
    texts = ['first text', 'second text', 'third text', '4th text']
    body = Exfuz::Body.new(top: 1, bottom: 2, texts: texts)

    it 'prev list is (first text, second text)' do
      body.move_next
      body.move_prev
      lines = body.lines(overwrite: true)
      expect(lines).to eq({ 1 => 'first text', 2 => 'second text' })
    end
  end
end
