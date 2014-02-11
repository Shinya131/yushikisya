#!/usr/bin/env ruby
# カレントディレクトリの全ファイルを再帰的に取得して、引数に一致するファイル名を探す
# 見つかった場合は、ファイルがあるディレクトリをopenする

require 'find'
require 'active_support/core_ext'

@key_word = ARGV[0]
@exact_mach_files = []
@partial_match_files = []

def check_argument
  if @key_word.nil?
    raise ArgumentError.new("key wordを指定せよ.")
  end
end

# カレントディレクトリ以下にあるファイルを全部調べる
def search_files
  Find.find("./") do |f|
    store_when_exact_mach(f)
    store_when_partial_match(f)
  end
end

# ファイル名完全一致
def store_when_exact_mach(file)
  base = File.basename(file)

  if base == @key_word
    @exact_mach_files << file
  end
end

# ファイル名がキーワードにマッチ
def store_when_partial_match(file)
  base = File.basename(file)

  if base =~ /#{@key_word}/
    @partial_match_files << file
  end
end

# 最初にマッチしたファイルのコミット件数ランキングを表示
def show_first_mach_file_commit_count
  case
  when @exact_mach_files.present?
    print "ファイル名完全一致\n"
    show_commit_count(@exact_mach_files.first)

  when @partial_match_files.present?
    print "ファイル名一部一致\n"
    show_commit_count(@partial_match_files.first)

  else
    print "file not found.\n"
  end
end

def show_commit_count(file)
  print "#{@exact_mach_files.first}\n"
  print `git shortlog -sn --no-merges #{file} | cat -n | head -n 3`
end

check_argument
search_files
show_first_mach_file_commit_count
