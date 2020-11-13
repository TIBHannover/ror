<script>

	$(document).ready(function () {ldelim}
		var primaryLocale = "{$primaryLocale}";
		var results = null;

		//$('input[id^="affiliation-'+ lang+'"]').hide();
		$('input[id^="affiliation-' + primaryLocale + '"]').tagit({ldelim}
			fieldName: 'affiliation-ROR[]',
			allowSpaces: true,
			tagLimit: 1,
			tagSource: function (search, r) {ldelim}
				$.ajax({ldelim}
					url: 'https://api.ror.org/organizations',
					dataType: 'json',
					cache: true,
					data: {ldelim}
						affiliation: search.term + '*'
						{rdelim},
					success:
							function (data) {ldelim}
								results = data.items;

								r($.map(data.items, function (item) {ldelim}
									return {ldelim}
										label: item.organization.name,
										value: item.organization.name + ' [' + item.organization.id + ']'
										{rdelim}
									{rdelim}));

								{rdelim}
					{rdelim});
				{rdelim},
			afterTagAdded: function (event, ui) {ldelim}
				console.log("afterTagAdded ", ui);


				if (ui.duringInitialization === true) {
					$('input[id^="affiliation-' + primaryLocale + '"]').after('<div id = "rorIdField" style="float:right; background:#eaedee;"><a href="{$rorId}" target="_blank">{$rorId}</a></div>');
				} else {
					const regex = /https:\/\/ror\.org\/(\d|\w)+/g;
					const found = ui.tagLabel.match(regex);
					if (found !== null) {
						const rorId = found[0];
						$.each(results, function (key,value){
							//console.log(value);
							if (value.organization.id == rorId){
								var supportedLocales = {$supportedLocales|json_encode};

								$.each(supportedLocales, function( k, val ) {
									var locale = k.slice(0,2);
									if (locale.length == 2) {
										value.organization.labels.forEach(function (v) {
											if (locale == v["iso639"]) {
												if (locale !== primaryLocale) {
													$('input[id^="affiliation-' + locale + '"]').val(v.label);
													console.log(locale, labels, v["iso639"]);
												}
											}
										});

									}
								});

							}
						});


					}




				}
				{rdelim},
			afterTagRemoved: function (event, ui) {ldelim}
				console.log("afterTagRemoved ", ui);
				$('#rorIdField').remove("");
				{rdelim},
			onTagClicked: function (event, ui) {ldelim}
				console.log("onTagClicked ", ui);
				{rdelim},
			onTagRemoved: function (event, ui) {ldelim}
				console.log("onTagClicked ", ui);
				$('#rorIdField').remove("");
				{rdelim}
			{rdelim});
		{rdelim});
</script>
