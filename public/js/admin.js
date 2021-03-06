// ======================================================================
//
//  Leo Tamer
//
//  Copyright (c) 2012 Rakuten, Inc.
//
//  This file is provided to you under the Apache License,
//  Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License.  You may obtain
//  a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.
//
// ======================================================================
(function() {
  Ext.define("LeoTamer.Admin", {
    extend: "Ext.panel.Panel",
    id: "admin",
    title: "Admin Tools",
    layout: "border",

    users: Ext.create("LeoTamer.Users"),
    buckets: Ext.create("LeoTamer.Buckets"),
    endpoints: Ext.create("LeoTamer.Endpoints"),

    admin_store: Ext.create("Ext.data.Store", {
      fields: ["name"],
      data: [
        { name: "Users" },
        { name: "Buckets" },
        { name: "Endpoints" }
      ]
    }),

    set_icon: function(value) {
      var img = undefined;
      switch(value) {
        case "Users":
          img = "<img src='images/users.png'> ";
          break;
        case "Buckets":
          img = "<img src='images/bucket.png'> ";
          break;
        case "Endpoints":
          img = "<img src='images/endpoint.png'> ";
          break;
      }
      return img + value;
    },

    initComponent: function() {
      var self = this;
      var admin_card, admin_grid;

      admin_grid = Ext.create("Ext.grid.Panel", {
        title: "Menu",
        region: "west",
        id: "admin_grid",
        width: 200,
        forceFit: true,
        hideHeaders: true,
        store: self.admin_store,
        columns: [{
          dataIndex: "name",
          renderer: self.set_icon
        }],
        listeners: {
          select: function(grid, record, index) {
            admin_card.getLayout().setActiveItem(index);
          },
          afterrender: function(grid) {
            grid.getSelectionModel().select(0);
          }
        }
      });

      admin_card = Ext.create("Ext.panel.Panel", {
        region: "center",
        layout: "card",
        activeItem: 0,
        items: [
          self.users,
          self.buckets,
          self.endpoints
        ]
      });

      Ext.apply(self, {
        items: [admin_grid, admin_card]
      });

      return self.callParent(arguments);
    }
  });
}).call(this);
