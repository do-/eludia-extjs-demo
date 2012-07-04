Ext.define('Ext.ux.ludi.FileDownload', {
    extend: 'Ext.Component',
    alias: 'widget.FileDownloader',
    autoEl: {
        tag: 'iframe',
        cls: 'x-hidden',
        src: Ext.SSL_SECURE_URL
    },
    load: function(config){

        var e = this.getEl();

        e.dom.src = '/handler' + config.url + '&sid=' + Ext.Ajax.extraParams.sid;

        e.dom.onload = function() {
            if(e.dom.contentDocument.body.childNodes[0].wholeText == '404') {
                Ext.Msg.show({
                    title: 'Ошибка',
                    msg: 'Файл не найден на сервере.',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                })
            }
        }
    }
});