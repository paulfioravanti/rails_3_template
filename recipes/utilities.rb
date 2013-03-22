def colorize(text, color_code); "#{color_code}#{text}\e[0m"; end
def yellow(text); colorize(text, "\e[33m"); end
def cyan(text); colorize(text, "\e[36m"); end
def comment(text); say yellow(text); end

def heading(text)
  say "\n"
  say cyan "#######################################"
  say cyan "## #{text}"
  say cyan "#######################################"
  say "\n"
end

def secret_token
  token = StringIO.new
  IO.popen("rake secret") do |pipe|
    pipe.each do |line|
      token.print line.chomp
    end
  end
  token.string
end

def copy_from_repo(filename, erb: false)
  begin
    repo = 'https://raw.github.com/paulfioravanti/rails_template/master/files/'
    get "#{repo}#{filename}", filename
    template "#{Dir.pwd}/#{filename}", force: true if erb
  rescue OpenURI::HTTPError
    say "Unable to obtain #{filename} from the repo #{repo}"
  end
end

def change_double_to_single_quotes(filename)
  comment "# Change double to single quotes"
  gsub_file filename, /"/, "'"
end

def remove_comments(filename)
  comment "# Remove generated comments"
  gsub_file filename, /^\s{2}?\#.*\n/, ''
end

def remove_blank_lines(filename)
  comment "# Remove excess blank lines"
  gsub_file filename, /(?m)^(?<!\w\n$)\n(?!\w+)/, ''
end

def modern_hash_syntax(filename)
  comment "# Change hashes to modern syntax"
  gsub_file filename, /([^\w^:]):([\w\d_]+)\s*=>/, '\1\2:'
end