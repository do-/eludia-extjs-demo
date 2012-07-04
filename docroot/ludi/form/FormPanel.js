Ext.define ('Ext.ux.ludi.form.FormPanel', {

    extend: 'Ext.form.Panel',

    alias: 'widget.formpanel',

	initComponent: function () {

		if (!Ext.isObject (this.layout)) {
			this.layout = {
				type : this.layout
			};
		}

		if (this.layout.type == 'eludia') {

			this.layout.type = 'table';
			this.layout.tableAttrs = this.layout.tableAttrs || {
				style: {
					width: '100%'
				}
			};

			var items = [];
			for (var i in this.items) {
				var field = this.items [i];
				var row = [];

				if (field instanceof Array) {

					for (var j in field) {
						var row_field = field [j];

						if (row_field.off)
							continue;

						row.push  (row_field);
					}

					if (row.length == 0)
						continue;

					items.push (row);

				} else {

					items.push ([field]);

				}

			}

			var max_colspan = 1;

			for (var i in items) {
				var row = items [i];
				var sum_colspan = 0;

				for (var j = 0; j < row.length; j ++) {

					row [j].colspan = row [j].colspan || 1;

					sum_colspan += row [j].colspan;

//					sum_colspan ++;

					if (j < row.length - 1)
						continue;

					row [j].sum_colspan = sum_colspan;

				}

				if (max_colspan < sum_colspan)
					max_colspan = sum_colspan;

			}

			this.items = [];
			for (var i in items) {
				var row = items [i];
				row [row.length - 1].colspan += (max_colspan - row [row.length - 1].sum_colspan);
				for (var j in row)
					this.items.push (row [j]);
			}

			this.layout.columns = max_colspan;



		}


		this.callParent (arguments);

	}


});