# Cxeed

CYBER XEED ruby client

## Installation

install chrome driver

    $ brew install chromedriver


install it yourself as:

    $ gem install cxeed
    or
    $ gem install specific_install
    $ gem specific_install https://github.com/rhythm191/cxeed.git master


## Usage

認証情報のセットアップをします。
認証情報は`~/.cxeed`に保存されます。

    $ cxeed init

認証情報が正しいかどうか確認します。
エラーが出た場合はinitのいずれかのパラメータが異なります。

    $ cxeed login_test

出社を報告します。引数なしで現在の時刻を入力します。

    $ cxeed arrive
    or
    $ cxeed arrive 10:00
    or
    $ cxeed arrive 10:00 2017/09/27
    
退社を報告します。引数なしで現在の時刻を入力します。

    $ cxeed leave
    or
    $ cxeed leave 19:00
    or
    $ cxeed leave 19:00 2017/09/27

今日の勤怠を見ます。

    $ cxeed today
    
任意の日時の勤怠を見ます。

    $ cxeed attendance


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cxeed. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cxeed project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/cxeed/blob/master/CODE_OF_CONDUCT.md).
