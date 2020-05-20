# Covid Telegram Bot

Telegram bot that provides latest statistics of COVID-19 status based on country or globally
![cover](./assets/screenshot.jpg)

## Getting Started

- Download the [telegram](https://telegram.org/) for you mobile or computer and create a new account if you don't one have already
- in the search tab search for `@bionic_covid_bot` or [click the this link](https://t.me/bionic_covid_bot) to get the bot
- start the bot
- you are now ready to use the bot to get the latest COVID-19 updates

### Usage

You can interact with the bot in two ways.

1. **You can access the bot directly and enter the queries directly inside the bot.**
   to do this follow the following flow.

- open the bot inside telegram
- while inside the bot perform the following actions to get the corresponding result
  **Enter the following to interact with the bot:**

* `Country name or country code` to get latest statistics of the country
  example: sending ethiopia or et will get you latest numbers of cases in ethiopia
* `Global` to get total global cases
* `/search` `[search term]` to search for supported countries
* `/stop` to stop the bot
* you can use this bot anywhere inside telegram by typing @bionic_covid_bot
  and searching for country you want statistics for

2. **You can interact with the bot anywhere in telegram by typing the below text inside the text field.**

`@bionic_covid_bot [search term]`

`search term` here refers to any country name you want get data of or global if you want to get the global result.

this is really useful because you can for example send the result directly to a friend in telegram without going to the bot

## Development

### Prerequisites

Since all the code is written using ruby `Ruby Runtime >= 1.9` ruby is required to interpret the code. if you don't have ruby runtime installed on your computer follow the instruction for your specific operating system on the [official installation guide](https://www.ruby-lang.org/en/documentation/installation/)

### Get source file

once you have setup all the prerequisites clone the repository on your development enviroment

`git@github.com:Mikearaya/tic-tac-toe.git`
or
`https://github.com/Mikearaya/tic-tac-toe.git`

Install all the gem dependencies for the project

`bundle install`

Install development enviroment setup packages

`npm install`

run the application

`ruby bin/main.rb`

### Clean Up

if you are done playing the game and want to clean all the artifacts created, run this command on the root directory of the project
`./reset.sh`

### Testing

For testing RSpec is used. To run test run the following command line.

`rspec`

## Troubleshooting

## Authors

👤 **Mikael Araya**

- Github: [@mikearaya](https://github.com/mikearaya)
- Twitter: [@mikearaya12](https://twitter.com/mikearaya12)
- Linkedin: [linkedin](https://linkedin.com/in/mikael-araya)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check the [issues page](issues/).

## Show your support

Give a ⭐️ if you like this project!

## 📝 License

This project is [MIT](lic.url) licensed.
