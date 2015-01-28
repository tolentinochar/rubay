# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Item.create(name:'A' desc:'Aa', unit_price:100, qty:4 )
Item.create(name:'B' desc:'Bb', unit_price:100.23, qty:31 )
Item.create(name:'C' desc:'Cc', unit_price:200, qty:17 )
Item.create(name:'D' desc:'Dd', unit_price:50, qty:40 )
