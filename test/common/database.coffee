orm   = require 'orm'
redis = require '../../src/redis_adapter.coffee'

class Database
  @open: (callback) ->
    orm.addAdapter 'redis', redis

    orm.connect 'redis://localhost:6380', (err, db)->
      return callback(err) if err?
      
      order = db.define "orders",
                      shipping_address: String
                      total: Number
                      order_date: Date
                      sent_to_fullment: Boolean

      lineItem = db.define "line_items",
                      order_id: String
                      quantity: Number
                      product_description: String

      models =
        Order: order
        LineItem: lineItem

      callback null, models, ->
        db.close()


module.exports = Database
