# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Item.create(name:'A', desc:'Aa', unit_price:100, qty:40, qty_sold:0 )
Item.create(name:'B', desc:'Bb', unit_price:100.23, qty:31, qty_sold:9 )
Item.create(name:'C', desc:'Cc', unit_price:200, qty:17, qty_sold:23 )
Item.create(name:'D', desc:'Dd', unit_price:50, qty:40, qty_sold:24 )
Item.create(name:'E', desc:'Ee', unit_price:150, qty:40, qty_sold:15 )
Item.create(name:'F', desc:'Ff', unit_price:510, qty:40, qty_sold:11 )
Item.create(name:'G', desc:'Gg', unit_price:520, qty:40, qty_sold:0 )
Item.create(name:'H', desc:'Hh', unit_price:350, qty:40, qty_sold:0 )
Item.create(name:'I', desc:'Ii', unit_price:590, qty:40, qty_sold:0 )
Item.create(name:'J', desc:'Jj', unit_price:80, qty:40, qty_sold:0 )
Item.create(name:'K', desc:'Kk', unit_price:90, qty:40, qty_sold:0 )
Item.create(name:'L', desc:'Ll', unit_price:9, qty:40, qty_sold:0 )
Item.create(name:'M', desc:'Mm', unit_price:40, qty:40, qty_sold:0 )
Item.create(name:'Aldnoah Zero', desc:'I use an image url for my image!! I am so special!', unit_price:400, qty:40, qty_sold:21, img_url:'http://38.media.tumblr.com/45751f009c8fe550179d1efe0ca7e054/tumblr_nik3ps7EZp1u5qkhro1_500.gif' )
Item.create(name:'April', desc:'Trying out stuff.', unit_price:500.55, qty:230, qty_sold:10, img_url:'http://33.media.tumblr.com/a1fb76eb3a1aaa0a5ac8470d4db4b884/tumblr_ndlyqqDH7F1sang2co1_500.gif' )
