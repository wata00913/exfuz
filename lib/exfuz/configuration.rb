# frozen_string_literal: true

require 'singleton'
require 'pathname'
require 'json'

module Exfuz
  class Configuration
    include Singleton

    GLOBAL_DIRS = [File.join(Dir.home, '.config/exfuz')].freeze
    FILE_NAME = '.exfuz.json'

    attr_reader :dirname

    private_constant :FILE_NAME, :GLOBAL_DIRS

    def initialize
      @dirname = Pathname.new(Dir.pwd)
      set_data
    end

    def book_name_path_type
      @data[:book_name_path_type]
    end

    def cell_position_format
      @data[:cell_position_format]
    end

    def line_sep
      @data[:line_sep]
    end

    def split_new_line
      @data[:split_new_line]
    end

    def jump_positions?
      @data[:jump_positions]
    end

    def fuzzy_finder_command_type
      @data[:fuzzy_finder_command_type].to_sym
    end

    private

    def set_data
      @data = default.clone
      @data.merge!(read_from_global || {})
           .merge!(read_from_local(@dirname) || {})
    end

    def read_from_local(dirname)
      fpath = File.join(dirname.to_s, FILE_NAME)
      return nil unless File.exist?(fpath)

      read(fpath)
    end

    def read_from_global
      fpath = GLOBAL_DIRS.map { |d| File.join(d, FILE_NAME) }
                         .find { |f| File.exist?(f) }
      return nil unless fpath

      read(fpath)
    end

    def read(path)
      data = JSON.parse(File.read(path), symbolize_names: true)
      data.transform_values { |v| v.instance_of?(String) ? v.to_sym : v }
    end

    def default
      {
        book_name_path_type: :relative,
        cell_position_format: :index,
        line_sep: ':',
        split_new_line: false,
        jump_positions: false,
        fuzzy_finder_command_type: 'fzf'
      }
    end
  end
end
