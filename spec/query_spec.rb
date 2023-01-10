# frozen_string_literal: true

RSpec.describe Exfuz::Query do
  describe 'add' do
    context 'query is aあいうえお and caret is う' do
      query = Exfuz::Query.new([0, 1])
      query.add('a')
      query.add(%w[あ い う え お])
      3.times do
        query.left
      end

      it 'caret is う and query is aあいかうえお when add か' do
        query.add('か')
        expect(query.text).to eq('aあいかうえお')
        expect(query.caret[1]).to eq(8)
      end
    end
  end
  describe 'delete' do
    context 'query is aあいうえお' do
      query = Exfuz::Query.new([0, 1])
      query.add('a')
      query.add(%w[あ い う え お])

      context 'caret is right end(12)' do
        it 'deleted char is お and caret is right end(9) when one time delete' do
          query.delete
          expect(query.text).to eq('aあいうえ')
          expect(query.caret[1]).to eq(10)
        end
        it 'deleted char is all and caret is left end(0) when 6 time delete' do
          6.times do
            query.delete
          end
          expect(query.text).to eq('')
          expect(query.caret[1]).to eq(1)
        end
      end
    end
  end
  describe 'right' do
    context 'query is aあいうえお' do
      query = Exfuz::Query.new([0, 1])
      query.add('a')
      query.add(%w[あ い う え お])

      context 'caret is right end(12)' do
        it 'right position is right end(12)' do
          query.right
          expect(query.caret[1]).to eq(12)
        end
        it 'right position is right end(10) when delete and right' do
          query.delete
          query.right
          expect(query.caret[1]).to eq(10)
        end
      end
    end
  end
  describe 'left' do
    context 'query is aあいうえお' do
      query = Exfuz::Query.new([0, 1])
      query.add('a')
      query.add(%w[あ い う え お])

      context 'caret is right end(12)' do
        it 'left position is お(10)' do
          query.left
          expect(query.caret[1]).to eq(10)
        end
        it '6 time left position is a(1)' do
          query.left(6)
          expect(query.caret[1]).to eq(1)
        end
        it '7 time left position is a(1)' do
          query.left(7)
          expect(query.caret[1]).to eq(1)
        end
      end
    end
  end
end
