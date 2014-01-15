# $ ->
# 	$('#header nav').on 'click','a:not(.active)', (event) ->
# 		$('.active',event.delegateTarget).removeClass 'active'
# 		$(@).addClass 'active'

# // var url =window.location;
# // $("nav a").each(function() {
# //    if($(this).attr('href') == url){
# //       $(this).addClass('active');
# //    }
# // });

$ ->
	url = window.location.pathname
	console.log(url)
	$('nav a').each ->
		if $(@).attr('href') == url
			$(@).addClass('active')
		else
			$('#nav li').first ->
				a.addClass('active')

$ ->
	$('.popupakses').hide()
	$('.popupsyarat').hide()
	$('#mailinput').hide()
	$('#setuju').hide()
	$('#generate').hide()

	$('.cgenerate').click ->
		$('#generate').slideToggle()

	$('#req').click ->
		$('#mailinput').slideToggle()

	$('#pernyataan').click ->
		$('#setuju').slideToggle(500)

	$('.caraAkses').click ->
		$('body').css('overflow','hidden')
		$('.popupakses').fadeIn(500)
	
	$('.popupakses').click ->
		# console.log($(@))
		$(@).fadeOut(500)
		$('body').css('overflow','auto')

	$('.syaratKetentuan').click ->
		$('body').css('overflow','hidden')
		$('.popupsyarat').fadeIn(500)
	
	$('.popupsyarat').click ->
		# console.log($(@))
		$(@).fadeOut(500)
		$('body').css('overflow','auto')

	$('.exit').click ->
		$(@).parents('div').fadeOut(500)
		$('body').css('overflow','auto')



# $ ->
# 	$('.keranjang').hover ->
# 		$('.belanja').slideToggle()


# $ ->
# 	$('.respset').css('display','block')

# $ ->
# 	link = $('link')
# 	console.log(link)
# 	$('.respset button').click ->
		
# 		$this = $(@)
# 		stylesheet = $this.data('file')
# 		# console.log(stylesheet)

# 		link.attr('href', 'public/css/' + stylesheet + '.css')

# 		# if stylesheet = 'nostyle'
# 		# 	$('.bungkus').css('width','978px')
# 		# else if stylesheet = 'style'
# 		# 	$('.bungkus').removeAttribute('width')
# 		# 	location.reload()
# 		# else
# 		# 	location.reload()

# 		$this.css('display','none')

# 		$this.siblings('button').css('display','block')

# 		$this
# 			.siblings('button')
# 			.removeAttr('disabled')
# 			.end()
# 			.attr('disabled', 'disabled');
# 		$this

# $ ->
# 	$('.formKuantitas div').append('<div class="inc button">+</div><div class="dec button">-</div>')

# 	$('.formKuantitas .button').click ->
# 		$tombol = $(@)
# 		nilai = $tombol.parent().find('input').val()
# 		if $tombol.text() == '+'
# 			nilaiBaru = parseFloat(nilai) + 1
# 		else
# 			if nilai > 0
# 				nilaiBaru = parseFloat(nilai) - 1
# 			else
# 				nilaiBaru = 0

# 		$tombol.parent().find('input').val(nilaiBaru)



	