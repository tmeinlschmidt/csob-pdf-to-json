#!/bin/ruby

require 'json'

class Entry
  attr_reader :date
  attr_reader :payment
  attr_reader :payer
  attr_reader :row_no
  attr_reader :amount
  attr_reader :account
  attr_reader :vs
  attr_reader :ks
  attr_reader :ss
  attr_reader :note

  def initialize(row)
    @row = row
  end
  
  def account_details(account)
    @account_details = account
  end

  def notes(note)
    @notes = note
  end

  def parse
    parse_entry
    parse_account
    parse_notes
  end

  def to_json
    {
      date: @date,
      payment: @payment,
      payer: @payer,
      row_no: @row_no,
      amount: @amount,
      account: @account,
      vs: @vs,
      ks: @ks,
      ss: @ss,
      note: @note
    }
  end

  private

  def parse_entry
    row = preparse(@row)
    return if row == ''
    # date fix
    parsed = row.gsub(/\A([0-9]{2}\.[0-9]{2}\.)[ ]{2}([^ ])/, '\1;\2').split(/;/)
    i = 0
    @date = parsed[i]
    i += 1
    @payment = parsed[i]
    i += 1
    if parsed.count == 5
      @payer = parsed[i]
      i += 1
    end
    @row_no = parsed[i].to_i
    i += 1
    @amount = heal(parsed[i]).to_f
  end

  def parse_account
    return unless @account_details
    @account_details = preparse(@account_details).split(/;/)
    @account = @account_details[0]
    @vs = @account_details[1]
    @ks = @account_details[2]
    @ss = @account_details[3]
  end

  def parse_notes
    @note = preparse(@notes) if @notes
  end

  def preparse(row)
    row.gsub(/\A[ \t]*/, '').gsub(/[ ]{3,}/, ';').chomp
  end

  def heal(string)
    string.gsub(/[ ]*/, '').gsub(',', '.')
  end
end

pdf = ARGV[0]

STDERR.puts "Reading #{pdf}"

file = File.readlines(pdf)

data = []
data_entries = []

file.each_with_index do |line, i|
  next unless line =~ /\A[ ]*[0-9]{2}\.[0-9]{2}\.[ ]{2}/
  data << i
end

# processing data
data.each do |entry_line|
  data_entry = Entry.new(file[entry_line])
  # no additional data, skip to next
  if file[entry_line+1] != ''
    data_entry.account_details(file[entry_line+1])
    data_entry.notes(file[entry_line+2])
  end
  data_entries << data_entry
end
data_entries.map{|a| a.parse}
puts data_entries.map(&:to_json).to_json
