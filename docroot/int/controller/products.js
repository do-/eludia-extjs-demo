Ext.define('UI.controller.products', {

    extend: 'Ext.app.Controller',

    views: [
        'products.list'
        , 'products.edit'
    ],

    models: ['products'],

    init: function () {
    
        this.control ({
        
            'products_list': {
                  show: loadFirstGrid
            },

            'products_list pagingtoolbar textfield': {
                change: changeSearchFieldValue
            },

            'products_list gridpanel': {
                  containercontextmenu: showMenuOffTableBody,
                  itemcontextmenu: showMenuOnTableBody,
                  itemdblclick: openAndLoadFormForTheGridRecord
            },
            
        'products_list button[action=edit]': {
            click: showMenuOnToolbarButton
        },
        
        'products_edit button[action=save]': {
            click: saveRefreshParentGridAndCloseThisWindow
        },
        
        'products_edit button[action=close]': {
            click: closeContainingWindow
        }
                                   
        });
                
    },


    getPopupMenuItems: function (cnt) {
    
        return [
            {
                text    : 'Создать...', 
                handler : showNewObjectEditForm
            }
            , {
                xtype   : 'menuseparator',
                off     : (cnt [0] == 0 && cnt [-1] == 0)
            }
            , {
                text    : 'Удалить ' + russianNRecords (cnt [0]), 
                handler : askToKillRecords, 
                off     : (cnt [0] == 0 || cnt [-1] > 0)
            }
            , {
                text    : 'Слить ' + russianNRecords (cnt [0]), 
                handler : askToMergeRecords, 
                off     : (cnt [0] <  2 || cnt [-1] > 0)
            }
            , {
                text    : 'Восстановить ' + russianNRecords (cnt [-1]), 
                handler : askToMergeRecords, 
                off     : (cnt [0] > 0 || cnt [-1] == 0)
            }
            
        ];
    
    }
    
});