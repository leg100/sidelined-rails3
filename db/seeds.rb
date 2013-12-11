# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(username: 'leg100', email: 'louisgarman@gmail.com', roles: ['admin'], password: 'j843874q', password_confirmation: 'j843874q').save(validate: false)
User.create(username: 'wikipedia', email: 'louisgarman+wikipedia@gmail.com', roles: ['admin'], password: 'j843874q', password_confirmation: 'j843874q').save(validate: false)
Club.create(long_name: "Arsenal F.C.", short_name: "ARS")
Club.create(long_name: "Aston Villa F.C.", short_name: "AST")
Club.create(long_name: "Cardiff City F.C.", short_name: "CAR")
Club.create(long_name: "Chelsea F.C.", short_name: "CHE")
Club.create(long_name: "Crystal Palace F.C.", short_name: "CRY")
Club.create(long_name: "Everton F.C.", short_name: "EVE")
Club.create(long_name: "Fulham F.C.", short_name: "FUL")
Club.create(long_name: "Hull City A.F.C.", short_name: "HUL")
Club.create(long_name: "Liverpool F.C.", short_name: "LIV")
Club.create(long_name: "Manchester City F.C.", short_name: "MCY")
Club.create(long_name: "Manchester United F.C.", short_name: "MAN")
Club.create(long_name: "Newcastle United F.C.", short_name: "NEW")
Club.create(long_name: "Norwich City F.C.", short_name: "NOR")
Club.create(long_name: "Southampton F.C.", short_name: "SOU")
Club.create(long_name: "Stoke City F.C.", short_name: "STO")
Club.create(long_name: "Sunderland A.F.C.", short_name: "SUN")
Club.create(long_name: "Swansea City A.F.C.", short_name: "SWA")
Club.create(long_name: "Tottenham Hotspur F.C.", short_name: "TOT")
Club.create(long_name: "West Bromwich Albion F.C.", short_name: "WBA")
Club.create(long_name: "West Ham United F.C.", short_name: "WHU")
